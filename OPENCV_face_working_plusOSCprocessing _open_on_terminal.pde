import processing.javafx.*;

import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;

//OSC

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

//

Capture cam;

DeepVision vision;
ULFGFaceDetectionNetwork network;
ResultList<ObjectDetectionResult> detections;

public void setup() {
  size(640, 480, FX2D);
  colorMode(HSB, 360, 100, 100);
  
  ////OSC
  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);  //  speak to
  
  //oscP5.plug(this, "varName", "keyword");
  ////
  
  //OSC
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  //

  println("creating network...");
  vision = new DeepVision(this);
  network = vision.createULFGFaceDetectorRFB320();

  println("loading model...");
  network.setup();

  println("setup camera...");
  cam = new Capture(this, 640, 480, "C922 Pro Stream Webcam", 30);
  cam.start();
}

public void draw() {
  background(55);

  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0);

  if (cam.width == 0) {
    return;
  }

  detections = network.run(cam);

  noFill();
  //strokeWeight(2f);

  //stroke(200, 80, 100);
  for (ObjectDetectionResult detection : detections) {
    rect(detection.getX(), detection.getY(), detection.getWidth(), detection.getHeight());
    
 
     /* create a new osc message object */
  OscMessage myMessage = new OscMessage("/test");
  
  myMessage.add(detection.getX()); /* add an int to the osc message */
  myMessage.add(detection.getY()); /* add a float to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
    
  // //OSC
   
  // OscMessage newMessage = new OscMessage("detection.getX()");  
  //newMessage.add(detection.getX()); 
  //oscP5.send(newMessage, myRemoteLocation);

}

  surface.setTitle("Face Detector Test - FPS: " + Math.round(frameRate));


 
}





////OSC

//void mousePressed() {
//  /* create a new osc message object */
//  OscMessage myMessage = new OscMessage("/test");
  
//  myMessage.add(123); /* add an int to the osc message */
//  myMessage.add(12.34); /* add a float to the osc message */
//  myMessage.add("some text"); /* add a string to the osc message */

//  /* send the message */
//  oscP5.send(myMessage, myRemoteLocation); 
//}


//void oscEvent(OscMessage theOscMessage) {
//  /* check if theOscMessage has the address pattern we are looking for. */
  
//  if(theOscMessage.checkAddrPattern("/test")==true) {
//    /* check if the typetag is the right one. */
//    if(theOscMessage.checkTypetag("ifs")) {
//      /* parse theOscMessage and extract the values from the osc message arguments. */
//      int firstValue = theOscMessage.get(0).intValue();  
//      float secondValue = theOscMessage.get(1).floatValue(detection.getX());
//      String thirdValue = theOscMessage.get(2).stringValue();
//      print("### received an osc message /test with typetag ifs.");
//      println(" values: "+firstValue+", "+secondValue+", "+thirdValue);
//      return;
//    }  
//  } 
//  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
//}
