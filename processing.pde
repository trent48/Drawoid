import processing.serial.*;

float leftDist;
float rightDist;
String val;
int curX;
int curY;
  Serial myPort;

void setup(){
size(600,300);
  println(Serial.list());
  curX = 0;
  curY = 0;
  myPort = new Serial(this, Serial.list()[3], 9600);
  println("print to serial");
  myPort.write(49+"\n");

textSize(16);
}


void draw(){
    if ( myPort.available() > 0){  // If data is available,
      val = myPort.readStringUntil('\n');         // read it and store it in val
      println(val);
    } 

  background(255);
  fill(0);
  leftDist = dist(0,0,mouseX, mouseY);
  rightDist = dist(width,0,mouseX, mouseY);
  line(0,0,mouseX, mouseY);
  line(width,0, mouseX, mouseY);
  text("left side: " + leftDist, 20,20);
  text("right side: "+ rightDist, 20, 34);
  ellipse(mouseX, mouseY, 10,10);
  fill(255,0,0);
  ellipse(curX, curY, 10, 10);
  //float x1 = map(mouseX, 0, width, 0,100);
  //float y1 = map(mouseY, 0,height, 0,100);
  //ellipse(int(x1),int(y1), 10,10);
  //text("steps: " + int(x1), 20,48);
  
  
}

void mousePressed(){


float moveX;
int a = int(leftDist);
if (a == curX){

}else{
  if (a > curX){
    moveX = a - curX;
    curX = a; 
    myPort.write(str(curX));
    myPort.write('\n'); 
  }else{
    moveX = a - curX;
    curX = a; 
  }
 println("moving :" + int(moveX));
 
}

}
