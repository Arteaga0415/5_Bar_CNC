// Include the AccelStepper Library
#include <AccelStepper.h>

//definir pines de entrada
#define motorPin1  11     // IN1 on ULN2003 ==> Blue   on 28BYJ-48
#define motorPin2  10     // IN2 on ULN2004 ==> Pink   on 28BYJ-48
#define motorPin3  9    // IN3 on ULN2003 ==> Yellow on 28BYJ-48
#define motorPin4  8    // IN4 on ULN2003 ==> Orange on 28BYJ-48

#define motor2Pin1  7     // IN1 on ULN2003 ==> Blue   on 28BYJ-48
#define motor2Pin2  6     // IN2 on ULN2004 ==> Pink   on 28BYJ-48
#define motor2Pin3  5    // IN3 on ULN2003 ==> Yellow on 28BYJ-48
#define motor2Pin4  4    // IN4 on ULN2003 ==> Orange on 28BYJ-48

//definir variables
#define potenciometro  A3
#define FULLSTEP 4

int velocidad = 0;
int valor = 0;
int arriba_1 = 33;
int arriba_2 = 35;
int abajo_1 = 37;
int abajo_2 = 39;

AccelStepper myStepper1(FULLSTEP, motorPin1, motorPin3, motorPin2, motorPin4);
AccelStepper myStepper2(FULLSTEP, motor2Pin1, motor2Pin3, motor2Pin2, motor2Pin4);

void setup() {
  // establecer datos iniciales:
  myStepper1.setMaxSpeed(1000.0);
  myStepper1.setAcceleration(150.0);
  myStepper1.setSpeed(400);
  myStepper1.setCurrentPosition(0);
  
  myStepper2.setMaxSpeed(1000.0);
  myStepper2.setAcceleration(150.0);
  myStepper2.setSpeed(400);
  myStepper2.setCurrentPosition(0);

  pinMode(arriba_1, INPUT);
  pinMode(arriba_2, INPUT);
  pinMode(abajo_1, INPUT);
  pinMode(abajo_2, INPUT);
  Serial.begin(9660);
}

void loop() {
  // correr motor de paso con potenciometro:
//  valor = analogRead(potenciometro);
//  velocidad = map(valor, 0, 1023, 50, 300);
  myStepper1.setSpeed(300);
  if (digitalRead(arriba_1) == HIGH)
  {
    myStepper1.runSpeed();
  }
}
