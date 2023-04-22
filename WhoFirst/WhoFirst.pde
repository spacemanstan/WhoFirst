/***
 Gobal values
 ***/

final int FPS = 30;

ArrayList<TouchTracker> TOKENS = new ArrayList<TouchTracker>();

// used to track when all players take their fingers off simultaneously
int lastTouchCount = 0;
final int timeLimit = 15; // half a second, time frame for all players to remove finger to trigger selection



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
}

void draw() {
  background(69); // nice

  // offwhite
  color colorText = color(120, 0, 95);
  // kinda slate gray (blue-ish tone to it)
  color colorLight = color(160, 10, 50);
  // darker gray for borders and what not
  color colorDark = color(160, 10, 50);
  
  float tokenSize = width/4;

  for (int i = 0; i < touches.length; i++) {
    pushMatrix(); // prepare translation

    translate(touches[i].x, touches[i].y);
    // roation in the future maybe?
    // but that would need more matrix push pops to not rotate text

    pushStyle(); // prepare for drawing

    fill(colorLight);
    stroke(colorDark);
    strokeWeight(tokenSize * 0.25);
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
  for (int i = 0; i < touches.length; i++) {
    int id = event.getPointerId(i);
    println("Touch started with ID: " + id);
  }
  println("\n\n");
}

void touchEnded(TouchEvent event) {
  for (int i = 0; i < touches.length; i++) {
    int id = event.getPointerId(i);
    //println("Touch ended with ID: " + id);
  }

  printArray(touches);
  println("\n\n");
}




/***
 Interfaces
 ***/

public interface Drawable {
  void _draw();
}



/***
 Classes
 ***/

/*
  Class to track the touch tokens on screen
 used to select the winner
 */
class TouchTracker implements Drawable {
  PVector pos;
  final float tokenSize;
  final String tag;
  int activeID = -1; // -1 if no touch, otherwise assign touch id
  int lifespan;

  // track which token this is
  final int instance;

  /*** color scheme ***/
  final color colorText; // text color value
  final color colorLight; // fill color value
  final color colorDark; // stroke color value

  TouchTracker(float px_, float py_, int id_) {
    /***  color scheme  ***/
    // offwhite
    colorText = color(120, 0, 95);
    // kinda slate gray (blue-ish tone to it)
    colorLight = color(160, 10, 50);
    // darker gray for borders and what not
    colorDark = color(160, 10, 50);

    /***  position  ***/
    pos = new PVector(px_, py_);

    /*** tracking ***/
    instance = TOKENS.size();
    activeID = id_;

    /***  random greek letter + which token this is  ***/
    char randomLetter = (char) (random(24) + 945);
    String textToShow = Character.toString(randomLetter).toUpperCase() + " [" + (instance) + "]";
    tag = textToShow;

    /*** size ***/
    tokenSize = width / 5; // needs to allow for many tokens on screen with space between

    /*** timers ***/
    lifespan = (int)(FPS * 1.5); // second and a half
  }

  // draw token on screen as circle
  void _draw() {
    pushMatrix(); // prepare translation

    translate(pos.x, pos.y);
    // roation in the future maybe?
    // but that would need more matrix push pops to not rotate text

    pushStyle(); // prepare for drawing

    fill(colorLight);
    stroke(colorDark);
    strokeWeight(tokenSize * 0.05);
    circle(0, 0, tokenSize);

    fill(colorText);
    textSize(tokenSize * 0.4);

    popStyle(); // restore after drawing

    popMatrix(); // restore matrix manipulations
  }
}
