// Include the AccelStepper Library
#include <AccelStepper.h>

// Define step constant para motores pequeños
#define FULLSTEP 4
#define HALFSTEP 8

#define motorPin1  11     // IN1 on ULN2003 ==> Blue   on 28BYJ-48  
#define motorPin2  10     // IN2 on ULN2004 ==> Pink   on 28BYJ-48  
#define motorPin3  9    // IN3 on ULN2003 ==> Yellow on 28BYJ-48  
#define motorPin4  8    // IN4 on ULN2003 ==> Orange on 28BYJ-48  

#define B_motorPin1  7     // IN1 on ULN2003 ==> Blue   on 28BYJ-48  
#define B_motorPin2  6     // IN2 on ULN2004 ==> Pink   on 28BYJ-48  
#define B_motorPin3  5    // IN3 on ULN2003 ==> Yellow on 28BYJ-48  
#define B_motorPin4  4    // IN4 on ULN2003 ==> Orange on 28BYJ-48  

  
// NOTE: The sequence 1-3-2-4 is required for proper sequencing of 28BYJ-48  
AccelStepper myStepper1(FULLSTEP, motorPin1, motorPin3, motorPin2, motorPin4);
AccelStepper myStepper2(FULLSTEP, B_motorPin1, B_motorPin3, B_motorPin2, B_motorPin4);

// define para mototres nema 37
// Pins entered in sequence IN1-IN3-IN2-IN4 for proper step sequence
//AccelStepper myStepper1(1, 11, 10);
//AccelStepper myStepper2(1, 8, 9);


const int ledPin =  10; //Salida direccion de giro
int mover1=0;
int mover2=0;
int vueltas=1024;
int buttonState = 0;//Variable para almacenar los estados de la entrada digital

void setup() 
{
  Serial.begin(9600);  
  pinMode(11, OUTPUT);
  //pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  // set the maximum speed, acceleration factor,
  // initial speed and the target position
  myStepper1.setMaxSpeed(250.0);
  myStepper1.setAcceleration(50.0);
  myStepper1.setSpeed(250);
  myStepper1.moveTo(vueltas);

  myStepper2.setMaxSpeed(250.0);
  myStepper2.setAcceleration(50.0);
  myStepper2.setSpeed(250);
  myStepper2.moveTo(vueltas);
}

void ingreso_datos()
{
  while (Serial.available() > 0)
  {
     mover1 = Serial.parseInt();  
  }
  Serial.println("Ingrese 1 para mover el motor de la derecha");
  while (Serial.available() == 0)
  {
  }
  mover1 = Serial.parseInt();  
  
  while (Serial.available() > 0)
  {
     mover2 = Serial.parseInt();  
  }
  Serial.println("Ingrese 1 para mover el motor de la izquierda");
  while (Serial.available() == 0)
  {
  }
  mover2 = Serial.parseInt();

  while (Serial.available() > 0)
  {
     vueltas = Serial.parseInt();  
  }
  Serial.println("Ingrese la cantidad de vueltas en pulsaciones");
  while (Serial.available() == 0)
  {
  }
  vueltas = Serial.parseInt();
  delay(20);
}

// the loop function runs over and over again forever
void loop() 
{  
  while ((mover1==0) && (mover2==0))
  {
  ingreso_datos();
  }
  Serial.print("mover 1: ");
  Serial.println(mover1);
  Serial.print("mover 2: ");
  Serial.println(mover2);
  //Change direction at the limits 
  // Change direction once the motor reaches target position
     if (myStepper1.distanceToGo() == 0) 
     {
       //myStepper1.moveTo(-myStepper1.currentPosition());
       myStepper1.stop();
     } 
     
     if (myStepper2.distanceToGo() == 0) 
     {
       myStepper2.moveTo(-myStepper2.currentPosition());
     } 
    if (mover1 == 1)  
    {
      myStepper1.run();
    }
   
   if (mover2 == 1)
    {
      myStepper2.run();
    }
   else
   {
    
   }
} 
