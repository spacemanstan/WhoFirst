/***
 Gobal values
 ***/

final int FPS = 30;

float tokenSize, noiseVal;

String STATE = "waiting";

// color scheme
color colorText, colorLight, colorDark;

Button[] buttons;
ArrayList<PVector> results = new ArrayList<PVector>();

int countDown = -1;
final int cdInterval = FPS*4;
int selected = -1;


ArrayList<Particle> particles = new ArrayList<Particle>();

RingEffect winAnim = null;


/***
 Setup & Draw
 ***/

void setup() {
  fullScreen(); // best for android
  orientation(PORTRAIT); // lock rotation
  frameRate(FPS); // 30 fps, FPS is global final int

  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  // color scheme
  colorText = color(120, 0, 95); /* white */
  colorLight = color(160, 10, 50); /* gray (slate kinda) */
  colorDark = color(160, 10, 25); /* dark gray */

  tokenSize = width/4;

  noiseVal = 0.0;

  Button top = new Button(width/2, height * 0.04, width * 0.85, height * 0.06, 0);
  Button bot = new Button(width/2, height * (1.0- 0.04), width * 0.85, height * 0.06, PI);

  buttons = new Button[]{ top, bot };
}

void draw() {
  background(69); // nice

  if (STATE == "waiting") {
    for (Button button : buttons) button._draw();

    drawTokens();
  }

  if (STATE == "selecting" || STATE == "decided") {
    
    if(winAnim != null) winAnim._draw();

    // draw particles
    for (int p_ = particles.size() - 1; p_ > 0; --p_) {
      Particle ptcl = particles.get(p_);

      ptcl._draw();

      if (ptcl.lifespan < 0)
        particles.remove(p_);
    }

    // draw highlight
    pushMatrix(); // prepare translation
    pushStyle(); // prepare for drawing
    translate(results.get(selected).x, results.get(selected).y);
    noStroke();
    if ( results.size() > 1 )
      fill(0, 81, 65);
    else
      fill(124, 81, 65);
    circle(0, 0, tokenSize*1.15);
    popStyle(); // restore after drawing
    popMatrix(); // restore matrix manipulations


    for (int res = results.size() - 1; res >= 0; --res) {
      pushMatrix(); // prepare translation
      translate(results.get(res).x, results.get(res).y);

      pushStyle(); // prepare for drawing
      // circle
      fill(colorLight);
      stroke(colorDark);
      strokeWeight(tokenSize * 0.08);
      circle(0, 0, tokenSize);

      // text
      /***  random greek letter + which token this is  ***/
      //char randomGreek = (char) (noise(noiseVal + results.get(res).x + results.get(res).y) * 17 + 931);
      //int randomInt = (int) (noise(noiseVal + results.get(res).x + results.get(res).y) * 9 + 1);
      //String tag = Character.toString(randomGreek) + "[" + randomInt + "]";

      //noStroke();
      //fill(colorText);
      //textSize(tokenSize * 0.5);
      //text(tag, 0, 0);

      popStyle(); // restore after drawing
      popMatrix(); // restore matrix manipulations


      --countDown;

      if (countDown == 0) {
        if (results.size() > 1) {
          countDown = cdInterval;

          // before removing selected spawn some particles at its pos
          PVector selpos = results.get(selected).copy();

          for (int rp = 0; rp < (int)random(5, 17); ++rp)
            particles.add( new Particle(selpos.x, selpos.y) );

          results.remove(selected);

          selected = (int)(random(0, results.size()));
        }

        if (results.size() == 1) {
          if (STATE == "decided") {
            countDown = -1;
            selected = -1;
            results.clear();
            STATE = "waiting";
            winAnim = null;
            break;
          }

          countDown = (int)(cdInterval*1.25);
          winAnim = new RingEffect(results.get(selected).x, results.get(selected).y);
          STATE = "decided";
        }
      } else {
        if (countDown % (FPS/2) == 0)
          selected = (int)(random(0, results.size()));
      }
    }
  }
}



/***
 Functions
 ***/
void drawTokens() {
  for (int tid = 0; tid < touches.length; ++tid) {
    // dont draw token when player clicks start button
    float thres = 0.75;
    for (Button btn : buttons)
      if ( touches[tid].y >= btn.pos.y - btn.dim.y*thres && touches[tid].y <= btn.pos.y + btn.dim.y*thres)
        if ( touches[tid].x >= btn.pos.x - btn.dim.x*thres && touches[tid].x <= btn.pos.x + btn.dim.x*thres)
          return;

    pushMatrix(); // prepare translation

    translate(touches[tid].x, touches[tid].y);
    // roation in the future maybe?
    // but that would need more matrix push pops to not rotate text

    pushStyle(); // prepare for drawing

    // circle
    fill(colorLight);
    stroke(colorDark);
    strokeWeight(tokenSize * 0.08);
    circle(0, 0, tokenSize);

    popStyle(); // restore after drawing

    popMatrix(); // restore matrix manipulations
  }
}



/***
 Touch Event Listeners
 ***/

// create a new token if touch didnt start on another token
void touchStarted(TouchEvent event) {
  // get the id that started this event
  int started = -1;

  if (touches.length > 0) started = touches.length - 1;
  if (started < -1) return;

  // check if the start button was clicked and save the touches array for future processing
  float thres = 0.75;
  if (STATE == "waiting" && touches.length > 1) {
    for (Button btn : buttons)
      if ( touches[started].y >= btn.pos.y - btn.dim.y*thres && touches[started].y <= btn.pos.y + btn.dim.y*thres)
        if ( touches[started].x >= btn.pos.x - btn.dim.x*thres && touches[started].x <= btn.pos.x + btn.dim.x*thres) {
          // start the selection

          STATE = "selecting";

          for (int i = 0; i < touches.length - 1; ++i)
            results.add( new PVector( touches[i].x, touches[i].y ) );

          countDown = cdInterval;
          selected = (int)(random(0, results.size()));
        }
  }
}



class Button {
  final PVector pos, dim;
  final String text;
  final float ang;
  final color colorText, colorLight, colorDark;

  Button(float px_, float py_, float dx_, float dy_, float ang_) {
    // color scheme
    colorText = color(120, 0, 95); /* white */
    colorLight = color(120, 40, 50); /* gray (slate kinda) */
    colorDark = color(120, 40, 25); /* dark gray */

    pos = new PVector(px_, py_);
    dim = new PVector(dx_, dy_);

    ang = ang_;

    text = "Start";
  }

  void _draw() {
    pushMatrix();

    translate(pos.x, pos.y);
    rotate(ang);

    pushStyle();

    fill(colorLight);
    stroke(colorDark);
    strokeWeight(dim.y*0.08);
    rect(0, 0, dim.x, dim.y);

    noStroke();
    fill(colorText);
    textSize(dim.y * 0.8);

    text(text, 0, 0);

    popStyle();

    popMatrix();
  }
}


class Particle {
  PVector pos, vel, acc;
  int lifespan;

  Particle(float px_, float py_) {
    pos = new PVector(px_, py_);

    float accx = (int)random(0, 2) == 0 ? -1 : 1;
    float accy = (int)random(0, 2) == 0 ? -1 : 1;
    float velx = accx * -5;
    float vely = accy * -5;

    vel = new PVector( velx*(int)random(1, 3), vely*(int)random(1, 3) );
    acc = new PVector( random(-0.15, 0.15), random(-0.15, 0.15) );

    lifespan = (int)(1.75 * FPS);
  }

  void _draw() {
    pos.x += vel.x;
    pos.y += vel.y;
    vel.x += acc.x;
    vel.y += acc.y;

    --lifespan;

    pushMatrix();

    translate(pos.x, pos.y);

    noStroke();
    fill(0, 81, 65);
    circle(0, 0, map(lifespan, 0, (int)(1.75 * FPS), 0, tokenSize/5));

    popMatrix();
  }
}


class RingEffect {
  PVector pos;
  int lifespan;

  RingEffect(float px_, float py_) {
    pos = new PVector(px_, py_);

    lifespan = (int)(1.75 * FPS);
  }

  void _draw() {

    --lifespan;

    pushMatrix();

    translate(pos.x, pos.y);

    stroke(124, 81, 65, 75);
    strokeWeight(tokenSize * 0.1);
    noFill();
    circle(0, 0, map(lifespan, 0, (int)(1.75 * FPS), tokenSize*2, tokenSize));

    popMatrix();
  }
}
