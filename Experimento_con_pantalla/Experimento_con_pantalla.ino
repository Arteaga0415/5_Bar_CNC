// Include the AccelStepper Library
#include <AccelStepper.h>

int Pasos1[24];
int Pasos2[24];
int Pasos_1[] = {0, 5, 15,  25,  35,  45,  55,  65,  75,  85,  95,  105, 115, 125, 135, 145, 155, 165, 175, 185, 195, 205, 215, 225};
int Pasos_2[] = {0, 5, 15,  25,  35,  45,  55,  65,  75,  85,  95,  105, 115, 125, 135, 145, 155, 165, 175, 185, 195, 205, 215, 225};
//definir variables
// definir entradas 
int Start = 2;
int Recorrido = 3;
int boton_1 = 6;
int boton_2 = 7;
int boton_3 = 8;
int boton_4 = 9;
int potenciometro = A2;

// recorridos
int recorrido_1;
int recorrido_2;
int recorrido_3;
int recorrido_4;
int recorrido_5;
int recorrido_6;
int recorrido_7;

// variables del codigo
int velocidad = 0;
int valor[7]; 
int posicion = 0;
int destino_1 = 0;
int destino_2 = 0;
int i;
int k = 0;
int l = 0;

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
  Serial3.begin(115200);
}
void ff()
{ //me envia por el serial3 los FF  "todos los comando que se envian o reciben"
  Serial3.write(0xff);
  Serial3.write(0xff);
  Serial3.write(0xff);
}

void detectar_pantalla()
{
  i = 0;
  if ((Serial3.available() > 0)) // 
  {
    delay(20);

    while (Serial3.available() > 0)
    {
      valor[i] = Serial3.read(); /*leo la info que me manda */
      i++; /* la almacena en i */
    }

    if ((valor[0] == 0x65) && (valor[6] == 0xFF))  // si el valor en la posicion 0 es 6
    {
      if (valor[1] == 0 && valor[2] == 1)   //pulsador nueva medida de la pagina 2
      {
        recorrido_1 = 1;
        Serial.println("Start");
      }
      if (valor[1] == 0 && valor[2] == 5)   //pulsador nueva medida de la pagina 2
      {
        recorrido_2 = 1;
        Serial.println("Stop");
      }
      if (valor[1] == 0 && valor[2] == 6)   //pulsador nueva medida de la pagina 2
      {
        recorrido_3 = 1;
        Serial.println("El motor 1 se mueve hacia arriba");
      }
      if (valor[1] == 0 && valor[2] == 7)   //pulsador nueva medida de la pagina 2
      {
        recorrido_4 = 1;
        Serial.println("El motor 1 se mueve hacia abajo");
      }
      if (valor[1] == 0 && valor[2] == 8)   //pulsador nueva medida de la pagina 2
      {
        recorrido_5 = 1;
        Serial.println("El motor 2 se mueve hacia arriba");
      }
      if (valor[1] == 0 && valor[2] == 9)   //pulsador nueva medida de la pagina 2
      {
        recorrido_6 = 1;
        Serial.println("El motor 2 se mueve hacia abajo");
      }
      if (valor[1] == 0 && valor[2] == 0xA)   //pulsador nueva medida de la pagina 2
      {
        recorrido_7 = 1;
        Serial.println("La maquina hace el recorrido");
      }
    }
  }
}

void Funcion_Recorrido()
{
  myStepper1.setSpeed(velocidad);
  myStepper2.setSpeed(velocidad);
  if (myStepper1.distanceToGo() == 0)
  {
    k = k + 1;
    destino_1 = Pasos_1[k];
  }
  if (myStepper2.distanceToGo() == 0)
  {
    l = l + 1;
    destino_2 = Pasos_2[l];
  }
  myStepper1.moveTo(destino_1);
  myStepper2.moveTo(destino_2);
  myStepper1.run();
  myStepper2.run();
}


void loop() {
  if (digitalRead(Start) == HIGH)
  {
    // correr motores de paso con potenciometro:
    posicion = analogRead(potenciometro);
    velocidad = map(posicion, 0, 1023, 50, 750);
    //detecta señal en la pantalla 
    detectar_pantalla();
    // correr motores de paso con velocidad fija
    //velocidad = 300; 
    
    //arriba motor 1
    if ((digitalRead(boton_1) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper1.setSpeed(velocidad);
      myStepper1.runSpeed();
    }
    //abajo motor 1
    if ((digitalRead(boton_2) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper1.setSpeed(-velocidad);
      myStepper1.runSpeed();
    }
    
    //arriba motor 2
    if ((digitalRead(boton_3) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper2.setSpeed(velocidad);
      myStepper2.runSpeed();
    }
    //abajo motor 2
    if ((digitalRead(boton_4) == HIGH)&&(digitalRead(Recorrido) == LOW))
    {
      myStepper2.setSpeed(-velocidad);
      myStepper2.runSpeed();
    }
    //Iniciar recorrido 
    if (digitalRead(Recorrido) == HIGH)
    {
      Funcion_Recorrido();
    }
    
    if (recorrido_1 == 1)
    {
      Funcion_Recorrido_1();
    }
    if (recorrido_2 == 1)
    {
      Funcion_Recorrido_2();
    }
    if (recorrido_3 == 1)
    {
      Funcion_Recorrido_3();
    }
    if (recorrido_4 == 1)
    {
      Funcion_Recorrido_4();
    }
    if (recorrido_5 == 1)
    {
      Funcion_Recorrido_5();
    }
    if (recorrido_6 == 1)
    {
      Funcion_Recorrido_6();
    }
    if (recorrido_7 == 1)
    {
      Funcion_Recorrido_7();
    }
  }
}

void Funcion_Recorrido_1()
{
  myStepper1.setSpeed(velocidad);
  myStepper1.runSpeed();
  
  myStepper2.setSpeed(velocidad);
  myStepper2.runSpeed();
}

void Funcion_Recorrido_2()
{
  myStepper1.setSpeed(0);
  myStepper1.runSpeed();
  
  myStepper2.setSpeed(0);
  myStepper2.runSpeed();
}

void Funcion_Recorrido_3()
{
  myStepper1.setSpeed(velocidad);
  myStepper1.runSpeed();
}

void Funcion_Recorrido_4()
{
  myStepper1.setSpeed(-velocidad);
  myStepper1.runSpeed();
}

void Funcion_Recorrido_5()
{
  myStepper2.setSpeed(velocidad);
  myStepper2.runSpeed();
}

void Funcion_Recorrido_6()
{
  myStepper2.setSpeed(-velocidad);
  myStepper2.runSpeed();
}

void Funcion_Recorrido_7()
{
  while (digitalRead(Recorrido) == HIGH)
    {
      Funcion_Recorrido();
    }
}
