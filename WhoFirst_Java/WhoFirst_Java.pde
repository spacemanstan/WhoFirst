public interface Drawable {
  void _draw();
}

/*
  Creates a drawable diamond grid scaled to background
 */
class diamondGridBG implements Drawable {
  int dimX, dimY;
  float diaLength, ang;
  double hueNoise;
  color colorBG, colorDiamond;

  diamondGridBG(int countX) {
    // initialize colors
    colorBG = color( 0, 0, 33);
    colorDiamond = color(120, 40, 40);

    // calculate length, then the number of them that fit
    diaLength = width / ((float)countX + 1.0);
    // get dimensions based on length, extra 3 needed for padding
    dimX = (int)(width / diaLength) + 1;
    dimY = (int)(height / diaLength) + 1;

    // spinny thing
    ang = HALF_PI / 2.0;

    // color thing
    hueNoise = 0;
  }

  void _draw() {
    pushStyle();

    noStroke();
    fill(colorBG);
    rect(width/2, height/2, width, height);

    // update angle for spinny animation
    ang += 0.01;

    for (int x_val = 0; x_val < dimX; ++x_val) {
      // print from outter values to mid value
      // this makes center column draw last and overlap edges
      int x_ = x_val % 2 == 0 ? x_val / 2 : dimX - x_val / 2 - 1;
      
      for (int y_ = 0; y_ < dimY; ++y_) {
        pushMatrix();

        translate(x_ * diaLength, y_ * diaLength);
        rotate(ang);


        noStroke();
        float hue = map(noise((float)hueNoise)*1000, 0, 1000, 0, 360);
        float brt = map(abs(x_ - dimX/2), 0, dimX/2, 69, 0);
        fill(hue, 30, brt);
        float mult = 0.9;
        rect(0, 0, diaLength * mult, diaLength * mult);

        popMatrix();
      }
      
      hueNoise += 0.0001;
    }

    popStyle();
  }
}

diamondGridBG bgPattern;

void setup() {
  size(450, 900); // close enough to mobile

  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);

  bgPattern = new diamondGridBG(11);
}

void draw() {
  background(69); // nice
  bgPattern._draw();
}
