
//globals
int geoPinX = A0;
int geoPinY = A1;
int geoPinZ = A2;
int value = 0;
unsigned long target = 0L ;

int data1; 
int data2; 
int data3; //store data from all 3 sensors
int freq = 2000 ; //data collection frequency ~x milliseconds

void setup() {
  Serial.begin(115200);         //Baud rate for Serial Monitor
  pinMode(geoPinX, INPUT);
  pinMode(geoPinY, INPUT);
  pinMode(geoPinZ, INPUT);
}

void loop(){
  analogReadResolution(12);
  if (micros() - target >= 2000) // sample when time comes -- Sets SAMPLE RATE to 500Hz
  {
    data1 = analogRead(geoPinX);
    data2 = analogRead(geoPinY);
    data3 = analogRead(geoPinZ);
  //Display Data to Serial Monitor
    Serial.print(data1);
    Serial.print(",");
    Serial.print(data2);
    Serial.print(",");
    Serial.println(data3);
    target += 2000 ; // prepare for next sample
  }
}
