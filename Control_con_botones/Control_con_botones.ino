// Include the AccelStepper Library
#include <AccelStepper.h>

//definir variables
// Para Crear un Circulo
//int Pasos_1[] = {0, 1445,  50,  -1329, -2312, -2523, -1733, -141,  1561,  2547,  2435};
//int Pasos_2[] = {0, 2773,  2390,  1230,  -289,  -1766, -2724, -2668, -1450, 430, 2074};
//int Velocidad_1[] = {0, 231.058920414758,  10.4579627416549,  366.956799733017,  496.138938356834,  409.623587566498,  268.387639589481,  26.3874638270501,  366.338230695492,  493.023230436195,  380.641620623765};
//int Velocidad_2[] = {0, 443.409263882439,  499.890619051102,  339.621417360129,  62.0173672946042,  286.720275720347,  421.862625644400,  499.303216245175,  340.288555098311,  83.2351743571118,  324.209741755108};
//int steps = 11;
// Para crear la flor 1
int Pasos_1[] = {0, 2850,  1757,  -1204, -3403, -3066, -560,  1722,  1903,  463, -955,  -762,  1254,  2850,  1757,  -1204, -3403, -3066, -560,  1722,  1903,  463, -955,  -762,  1254};
int Pasos_2[] = {0, -601,  1012,  625, -1035, -2263, -1668, 823, 3108,  3091,  882, -1673, -2300, -601,  1012,  625, -1035, -2263, -1668, 823, 3108,  3091,  882, -1673, -2300};
int Velocidad_1[] = {0, 489.240259027154,  433.269215937566,  443.771226786053,  478.364170573154,  402.287039792884,  159.136535868106,  451.124729702728,  261.091185815548,  74.0685291544381,  367.313234649792,  207.249771203286,  239.345824724548,  489.240259027154,  433.269215937566,  443.771226786053,  478.364170573154,  402.287039792884,  159.136535868106,  451.124729702728,  261.091185815548,  74.0685291544381,  367.313234649792,  207.249771203286,  239.345824724548};
int Velocidad_2[] = {0, 103.169612517656,  249.555177307238,  230.362970715351,  145.491306653898,  296.926148418557,  473.999538978572,  215.607231443290,  426.416923549513,  494.483420337728,  339.235887917400,  455.024760135298,  438.991544550605,  103.169612517656,  249.555177307238,  230.362970715351,  145.491306653898,  296.926148418557,  473.999538978572,  215.607231443290,  426.416923549513,  494.483420337728,  339.235887917400,  455.024760135298,  438.991544550605};
int steps = 25;


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
  if (recorrido != steps)
  {
    myStepper1.setSpeed(Velocidad_1[i]);
    myStepper2.setSpeed(Velocidad_2[i]);
    myStepper1.move(destino_1);
    myStepper2.move(destino_2);
    myStepper1.run();
    myStepper2.run();
  }
  if ((i == steps))
  {
    i=i;
    myStepper1.setCurrentPosition(0);
    myStepper2.setCurrentPosition(0);
    destino_1=0;
    destino_2=0;
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
      Funcion_Recorrido();
    }
  }
}
