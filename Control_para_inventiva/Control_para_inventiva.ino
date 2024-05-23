// Include the AccelStepper Library
#include <AccelStepper.h>

//definir variables
// Para Crear un Circulo
int Pasos_1[] = {0,3099,1522,-2017,-3906,-2382,834,2271,1090,-779,-981,1250,3099,1522,-2017,-3906,-2382,834,2271,1090,-779,-981,1250};
int Pasos_2[] = {0,-551,1164,317,-1682,-2481,-610,2572,3670,1626,-1505,-2520,-551,1164,317,-1682,-2481,-610,2572,3670,1626,-1505,-2520};
int Velocidad_1[] = {0,492.28,397.16,493.94,459.23,346.28,403.57,330.94,142.36,216.03,273.03,222.18,492.28,397.16,493.94,459.23,346.28,403.57,330.94,142.36,216.03,273.03,222.18};
int Velocidad_2[] = {0,87.527,303.74,77.629,197.75,360.68,295.18,374.8,479.31,450.92,418.87,447.92,87.527,303.74,77.629,197.75,360.68,295.18,374.8,479.31,450.92,418.87,447.92};
int steps = 23;
// Para crear la flor 1
//int Pasos_1[] = {0, 2850,  1757,  -1204, -3403, -3066, -560,  1722,  1903,  463, -955,  -762,  1254,  2850,  1757,  -1204, -3403, -3066, -560,  1722,  1903,  463, -955,  -762,  1254};
//int Pasos_2[] = {0, -601,  1012,  625, -1035, -2263, -1668, 823, 3108,  3091,  882, -1673, -2300, -601,  1012,  625, -1035, -2263, -1668, 823, 3108,  3091,  882, -1673, -2300};
//int Velocidad_1[] = {0, 489.240259027154,  433.269215937566,  443.771226786053,  478.364170573154,  402.287039792884,  159.136535868106,  451.124729702728,  261.091185815548,  74.0685291544381,  367.313234649792,  207.249771203286,  239.345824724548,  489.240259027154,  433.269215937566,  443.771226786053,  478.364170573154,  402.287039792884,  159.136535868106,  451.124729702728,  261.091185815548,  74.0685291544381,  367.313234649792,  207.249771203286,  239.345824724548};
//int Velocidad_2[] = {0, 103.169612517656,  249.555177307238,  230.362970715351,  145.491306653898,  296.926148418557,  473.999538978572,  215.607231443290,  426.416923549513,  494.483420337728,  339.235887917400,  455.024760135298,  438.991544550605,  103.169612517656,  249.555177307238,  230.362970715351,  145.491306653898,  296.926148418557,  473.999538978572,  215.607231443290,  426.416923549513,  494.483420337728,  339.235887917400,  455.024760135298,  438.991544550605};
//int steps = 25;


int Start = 2;
int Recorrido = 3;
int boton_1 = 6;
int boton_2 = 7;
int boton_3 = 8;
int boton_4 = 9;
int potenciometro = A2;

// variables del codigo
int vel = 0;
int valor = 0; 
int destino_1 = 0;
int destino_2 = 0;
int i = 0;
int recorrido=0;

AccelStepper myStepper1(1,12,13); //use pin 11 and 12 for dir and step, 1 is the “external driver”
AccelStepper myStepper2(1,11,10); //use pin 10 and 9 for dir and step, 1 is the “external driver”

void setup() {
  // establecer datos iniciales:
  pinMode(Start, INPUT);
  pinMode(Recorrido, INPUT);
  pinMode(boton_1, INPUT);
  pinMode(boton_2, INPUT);
  pinMode(boton_3, INPUT);
  pinMode(boton_4, INPUT);
  //Iniciar datos del motor 1
  myStepper1.setMaxSpeed(1000.0);
  myStepper1.setSpeed(400);
  //Iniciar datos del motor 2
  myStepper2.setMaxSpeed(1000.0);
  myStepper2.setSpeed(400);
  Serial.begin(115200);
}

void Funcion_Recorrido()
{
 
  if ((i == 0))
  {
    myStepper1.setCurrentPosition(0);
    myStepper2.setCurrentPosition(0);
    Serial.println(i);
  }
  
  if ((i<=steps)&&((myStepper1.currentPosition() == Pasos_1[i])||(myStepper2.currentPosition() == Pasos_2[i])))
  {
    i = i + 1;
    destino_1 = Pasos_1[i];
    destino_2 = Pasos_2[i];

    myStepper1.setCurrentPosition(0);
    myStepper2.setCurrentPosition(0);
    Serial.println(i);    
    if ((Pasos_1[i]<0)&&(Velocidad_1[i]>0))
    {
      Velocidad_1[i]=-Velocidad_1[i];
    }
    if ((Pasos_2[i]<0)&&(Velocidad_2[i]>0))
    {
      Velocidad_2[i]=-Velocidad_2[i];
    }


  }
  if (i != steps)
  {
    myStepper1.setSpeed(Velocidad_1[i]);
    myStepper2.setSpeed(Velocidad_2[i]);
    myStepper1.move(destino_1);
    myStepper2.move(destino_2);
    myStepper1.run();
    myStepper2.run();
  }
  if (i == steps)
  {
    myStepper1.setCurrentPosition(0);
    myStepper2.setCurrentPosition(0);
    destino_1=0;
    destino_2=0;
    recorrido=0;
    i=0;
  }
}

void loop() {
  if (digitalRead(Start) == HIGH)
  {
    // correr motores de paso con potenciometro:
    valor = analogRead(potenciometro);
    vel = map(valor, 0, 1023, 100, 1000);
    
    //correr motores de paso con velocidad fija
    //vel = 300; 
    
    //arriba motor 1
    if ((digitalRead(boton_1) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper1.setSpeed(vel);
      myStepper1.runSpeed();
    }
    //abajo motor 1
    if ((digitalRead(boton_2) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper1.setSpeed(-vel);
      myStepper1.runSpeed();
    }
    
    //arriba motor 2
    if ((digitalRead(boton_3) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper2.setSpeed(vel);
      myStepper2.runSpeed();
    }
    //abajo motor 2
    if ((digitalRead(boton_4) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper2.setSpeed(-vel);
      myStepper2.runSpeed();
    }
    //Iniciar recorrido 
    if (digitalRead(Recorrido) == HIGH)
    {
      recorrido=1;
    }
    if (recorrido==1)
    {
      Funcion_Recorrido();
    }
  }
}
