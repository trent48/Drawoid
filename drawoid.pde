int X_STEP_PIN  = 54;
int X_DIR_PIN  = 55;
int X_ENABLE_PIN = 38;
const int stepsInFullRound = 200;
int a = 0;
int location;
String inputString = "";
boolean stringComplete = false;

void setup(){
  Serial.begin(9600);
  inputString.reserve(200);
  Serial.println("Connnected!");
  pinMode(X_STEP_PIN, OUTPUT);
  pinMode(X_DIR_PIN, OUTPUT); 
  pinMode(X_ENABLE_PIN, OUTPUT); 
  digitalWrite(X_ENABLE_PIN, LOW);
  location = 0;
}

void loop(){
  
  if (stringComplete){
    Serial.println("Recived: " + inputString);
    
    run(true, 1, inputString.toInt());
    
    inputString = "";
    Serial.println("Current location: " + location);
    stringComplete = false;
   }
  
  
 
}

void serialEvent(){
  while (Serial.available()){
    char inChar = (char)Serial.read();
    inputString += inChar;

    if (inChar == '\n'){
      stringComplete = true;
    }
  }
}

// Runs the motor according to a chosen direction, speed (rounds per seconds) and the number of steps
void run(boolean runForward, double speedRPS, int stepCount) {
  digitalWrite(X_DIR_PIN, runForward);
  for (int i = 0; i < stepCount; i++) {
    digitalWrite(X_STEP_PIN, HIGH);
    holdHalfCylce(speedRPS);
    digitalWrite(X_STEP_PIN, LOW);
    holdHalfCylce(speedRPS);
  }
  distanceCount(runForward, stepCount);
}

void distanceCount(boolean addition, int stepCount){
  if (addition){
   location = location + stepCount; 
  }else{
   location = location - stepCount;
  }
  
}

// A custom delay function used in the run()-method
void holdHalfCylce(double speedRPS) {
  long holdTime_us = (long)(1.0 / (double) stepsInFullRound / speedRPS / 2.0 * 1E6);
  int overflowCount = holdTime_us / 65535;
  for (int i = 0; i < overflowCount; i++) {
    delayMicroseconds(65535);
  }
  delayMicroseconds((unsigned int) holdTime_us);
}

// Runs the motor once in forward direction and once to the opposite direction. 
// Holds the motor still for 1 sec after both movements. 
void runBackAndForth(double speedRPS, int rounds) {
  run(true, speedRPS, stepsInFullRound * rounds);
  delay(1000);
  run(false, speedRPS, stepsInFullRound * rounds);
  delay(1000);
}
