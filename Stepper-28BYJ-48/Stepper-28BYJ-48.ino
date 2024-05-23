int i;
int k;
int vuelta1;
int vuelta2;

char AsciiCod= 0; // Dato  que es enviado por monitor serial
#define A 11
#define B 10
#define C 9
#define D 8
 

void setup(){
pinMode(A,OUTPUT);
pinMode(B,OUTPUT);
pinMode(C,OUTPUT);
pinMode(D,OUTPUT);
i=0;
k=10000;

Serial.begin(9600);
Serial.println("Indique la cantidad de vueltas ---");
Serial.println(k);

}

void write(int a,int b,int c,int d){
digitalWrite(A,a);
digitalWrite(B,b);
digitalWrite(C,c);
digitalWrite(D,d);
}

void onestep(){
write(1,0,0,0);
delay(2);
write(1,1,0,0);
delay(2);
write(0,1,0,0);
delay(2);
write(0,1,1,0);
delay(2);
write(0,0,1,0);
delay(2);
write(0,0,1,1);
delay(2);
write(0,0,0,1);
delay(2);
write(1,0,0,1);
delay(2);
}

void onestep_2(){
write(1,0,0,1);
delay(2);
write(0,0,0,1);
delay(2);
write(0,0,1,1);
delay(2);
write(0,0,1,0);
delay(2);
write(0,1,1,0);
delay(2);
write(0,1,0,0);
delay(2);
write(1,1,0,0);
delay(2);
write(1,0,0,0);
delay(2);
}

void ingreso_datos()
{
  while (Serial.available() > 0)
  {
     vuelta1 = Serial.parseFloat();  
  }
  Serial.println("Ingrese la cantidad de pasos a la derecha siendo 512 una vuelta");
  while (Serial.available() == 0)
  {
  }
  vuelta1 = Serial.parseFloat();  

  
  while (Serial.available() > 0)
  {
     vuelta2 = Serial.parseFloat();  
  }
  Serial.println("Ingrese la cantidad de pasos a la izquierda siendo 512 una vuelta");
  while (Serial.available() == 0)
  {
  }
  vuelta2 = Serial.parseFloat();
  #define NUMBER_OF_STEPS_PER_REV (vuelta1)
  #define NUMBER_OF_STEPS_PER_REV_2 (vuelta2)
  Serial.println(NUMBER_OF_STEPS_PER_REV);
  Serial.println(NUMBER_OF_STEPS_PER_REV_2);
  delay(20);
}

void loop(){
ingreso_datos();
//while (i<=NUMBER_OF_STEPS_PER_REV){
//onestep();
//i++;
//Serial.println("Se mueve a la izquierda");
//if (i==NUMBER_OF_STEPS_PER_REV)
//{
//  k=0;
//  Serial.println(k);
//}
//}
//while (k<=NUMBER_OF_STEPS_PER_REV_2){
//onestep_2();
//Serial.println(NUMBER_OF_STEPS_PER_REV_2);
//Serial.println("Se mueve a la derecha");
//k++;
for (int x = 0; x < 400; x++)
{
  onestep();
}
}
