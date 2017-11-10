
import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
import processing.sound.*;

SoundFile file;
OpenCV opencv;
Capture cam;

// Scaled down image
PImage smaller;
PImage text;
PImage trig;
Rectangle[] faces;

int scale = 3;

void setup() {
  
  
  
  // Start capturing
  cam = new Capture(this, 640, 480);
  printArray(cam.list());
  cam.start();
  size(640,480);

  // Create the OpenCV object
  opencv = new OpenCV(this, cam.width/scale, cam.height/scale);
  
  // Which "cascade" are we going to use?
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
 
  // Make scaled down image
  
  smaller = createImage(opencv.width,opencv.height,RGB);
  trig = createImage(cam.width, cam.height, RGB);
  text = loadImage("Triggered.jpg");
   // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "Sound.mp3");
  
}

void captureEvent(Capture cam) {
  cam.read();  
  smaller.copy(cam,0,0,cam.width,cam.height,0,0,smaller.width,smaller.height);
  smaller.updatePixels();
}
boolean oneTime = true;
void draw() {
  
  opencv.loadImage(smaller); 
  faces = opencv.detect();
 
  if (faces != null && faces.length > 0) {
    
      int limiteE = faces[0].x*scale;
      int limiteD = faces[0].width*scale;
      int limiteA = faces[0].y*scale;
      int limiteB = faces[0].height*scale;
      trig.copy(cam,limiteE+35/2,limiteA+35,limiteD-35,limiteB-35,0,0,cam.width, cam.height);
      image(trig, 0,0);
      image(text, width / 2 - text.width/2 + random(15)  , height - text.height + random(15));
      if(oneTime){
         oneTime = false; 
        file.play();
      }
  }else{
    image(cam, 0,0);
    if(oneTime == false){
      oneTime = true;
      file.stop(); 
    }
  }
}