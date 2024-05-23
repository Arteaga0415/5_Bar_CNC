## This repository consists of Arduino and MATLAB codes for controlling a 5-bar mechanism CNC machine, and some MATLAB codes to calculate forces and stress on the joints and bars.

* Note: "Control_para_inventiva" is the most updated code that controls the CNC machine using four arrays: two for motor steps and two for the speeds to maintain a constant total speed in the X and Y planes.

* The MATLAB codes that calculate coordinates are "Calculadora-coordenadas...". "Calculadora-coordenadas_r6_theta6.m" is the one that generates the four arrays needed for the Arduino code.

* "Calculadora-coordenadas_r6_theta6.m" uses "Gen_coordenadas.m" to generate coordinates based on polar calculus functions, and the other two codes generate positions for the machine mechanism based on a seed "q=[]" (Keep in mind "q=[]" is the array of results).

### The coordinates of the mechanism are calculated using the Jacobian Matrix since it is a system of nonlinear equations. The Jacobian matrix is a matrix of partial derivatives, and the Newton-Raphson method is a powerful technique for solving equations numerically.

* A presentation on the Jacobian method for mechanisms can be found here: [Presentation Here](https://www.slideserve.com/kendis/properties-of-the-jacobian-powerpoint-ppt-presentation)

* Newton-Raphson:
  ![Newton-Raphson Method Formula](https://en.neurochispas.com/wp-content/uploads/2023/01/Formula-for-the-Newton-Raphson-method.png)

* Resulting formula: 
  ![Resulting Formula](image.png)
