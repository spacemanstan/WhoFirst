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
    dimX = (int)(width / diaLength) + 3;
    dimY = (int)(height / diaLength) + 3;

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

    // Map Perlin noise to the hue range -360 to 740
    //float hue = map(noise(hueNoise += 0.001), 0, 1, -360, 740);

    for (int y_ = 0; y_ < dimY; ++y_) {
      for (int x_ = 0; x_ < dimX; ++x_) {
        pushMatrix();

        translate(x_ * diaLength - diaLength*2, y_ * diaLength - diaLength*2);
        rotate(ang);


        noStroke();
        float hue = map(noise((float)hueNoise)*1000, 0, 1000, 0, 360);
        fill(hue, 30, 60);
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

  bgPattern = new diamondGridBG(10);
}

void draw() {
  background(69); // nice
  bgPattern._draw();
}
