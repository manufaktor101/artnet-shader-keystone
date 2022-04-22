//OSC

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

//shader

PShader shader;

//keystone

import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;

//LED stripes und artnet zuweisung

import ch.bildspur.artnet.*;

ArtNetClient artnet;
byte[] dmxData = new byte[512];

int startAddrDMX=200;

color[] led = new color[100];
color[] led1 = new color[100];

int CVx = 0;
int CVy = 0;
//int CVyi = int(CVy);

//array CV

int[] CVxxx;
int[] CVyyy;

void setup(){
  
  //must be P3D renderer to work with the keystone
  fullScreen(P3D);
  
  //array CV
  
  CVyyy = new int[5];
  CVxxx = new int[5];
  
  //OSC
  
    oscP5 = new OscP5(this, 12000);   //listening
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
   
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();
  
  //keystone setup
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(1000, 750, 20);
  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(1000, 750, P3D);
  
  //shader
  
  shader = loadShader("interfogg.frag");
  
}

//for keystone mapping setting

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;
  case 'l':
    // loads the saved layout
    ks.load();
    break;
  case 's':
    // saves the layout
    ks.save();
    break;
  }
}


void draw() {
  
   //color c = color(255, 0, 0);

// keystone
    
   PVector surfaceMouse = surface.getTransformedMouse();
  // Draw the scene, offscreen
  offscreen.beginDraw();
  //da was wir sehen wollen
  
  //offscreen.background(c);


    //smoothness of CV values
  // int CVxx = 0;
  // int CVyy = 0;
  // int Y = 0;
  // int X = 0;

  
  //for (int i=0;i<CVyyy.length-1;i++){
  //   Y += CVyyy[i];
  //     }
  
  //       CVyy = (Y/CVyyy.length)*3;
  
  //for (int i=0;i<CVxxx.length-1;i++){
  //   X += CVxxx[i];
  //      }
        
  //      CVxx = X/CVxxx.length;
        
        //
  
  //shader
  
  shader.set("u_resolution", float(1000), float(750));
  //map(X, 640, 2600, 0, 192.0);
  //map(Y, 500, 1300, 0, 120.0);
  shader.set("u_mouse", float(CVx), float(3*CVy));//mouseX mouseY
  println("Shader: " + CVx + "-" + CVy);
  shader.set("u_time", millis() / 1000.0);
  shader(shader);
  rect(0,0,1000,750);
  
  //offscreen.background(255);
  offscreen.fill(255, 255, 255);
  offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);

//jardin
  
  //float pixel_ratio = height / 35;
  int height_ratio = height/35;
  int width_ratio = width/10;
  int heightfix = height-90;
  
  for (int i=0;i<33;i++) {
    led[i] = get(width_ratio, heightfix-height_ratio*i);
  }
  
  for (int i=0;i<26;i++) {
     led[i+33] = get(width_ratio*2, 5*height_ratio+height_ratio*i);
  }
  
  for (int i=0;i<22;i++) {
     led[i+59] = get(width_ratio*3, (heightfix-7*height_ratio)-(height_ratio*i));
  }
  
  for (int i=0;i<19;i++) {
     led[i+81] = get(width_ratio*4, 9*height_ratio+height_ratio*i);
  }
  
  // LED send DMX

  for (int p=0;p<led.length;p++)  {
      float redd = map(red(led[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      float greend = map(green(led[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      float blued = map(blue(led[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      dmxData[startAddrDMX+(p*3)] = (byte) redd; 
      dmxData[startAddrDMX+(p*3)+1] = (byte) greend; 
      dmxData[startAddrDMX+(p*3)+2] = (byte) blued; 
  }
      
  // send dmx to DMXkeeng
  artnet.unicastDmx("192.168.0.112", 0, 0, dmxData);

//cour
  
   for (int i=0;i<33;i++) {
    led1[i] = get(width_ratio*9, heightfix-height_ratio*i);
  }
  
  for (int i=0;i<26;i++) {
     led1[i+33] = get(width_ratio*8, 5*height_ratio+height_ratio*i);
  }
  
  for (int i=0;i<22;i++) {
     led1[i+59] = get(width_ratio*7, (heightfix-7*height_ratio)-(height_ratio*i));
  }
  
   for (int i=0;i<19;i++) {
     led1[i+81] = get(width_ratio*6, 9*height_ratio+height_ratio*i);
  }

  // LED send DMX 

  for (int p=0;p<led1.length;p++)  {
      float redd = map(red(led1[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      float greend = map(green(led1[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      float blued = map(blue(led1[p]), 5, 255, 0, 50);//letze zahl ist dimmer der LED
      dmxData[startAddrDMX+(p*3)] = (byte) redd; 
      dmxData[startAddrDMX+(p*3)+1] = (byte) greend; 
      dmxData[startAddrDMX+(p*3)+2] = (byte) blued; 
  }
      
  // send dmx to DMXkeeng
  
  artnet.unicastDmx("192.168.0.112", 0, 1, dmxData);
  
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if(theOscMessage.checkAddrPattern("/test")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("ii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      
      CVx = theOscMessage.get(0).intValue();
      CVy = theOscMessage.get(1).intValue();
      
            //smoothness of the cv values
      
      //for (int i = CVyyy.length-1; i > 0; i--) {
      //  CVyyy[i] = CVyyy[i-1];
      //}
      //// Add new values to the beginning
      //CVyyy[0] = CVy;
      //// Display each pair of values as a line
      //for (int i = 1; i < CVyyy.length; i++) {
      //  line(i, CVyyy[i], i-1, CVyyy[i-1]);
      //}
      //for (int i = CVxxx.length-1; i > 0; i--) {
      //  CVxxx[i] = CVxxx[i-1];
      //}
      //// Add new values to the beginning
      //CVxxx[0] = CVx;
      //// Display each pair of values as a line
      //for (int i = 1; i < CVxxx.length; i++) {
      //  line(i, CVxxx[i], i-1, CVxxx[i-1]);
      //}
      
      //
     
      //int firstValue = theOscMessage.get(0).intValue();  
      //float secondValue = theOscMessage.get(1).floatValue();
      //String thirdValue = theOscMessage.get(2).stringValue();
      //print("### received an SATANNNN osc message /test with typetag if.");
      println(" values: " + CVx + "-" + CVy);
      return;
    }  
  } 
  //println("### received an  GOOODD osc message. with address pattern "+theOscMessage.addrPattern());
}
