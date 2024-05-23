clear
clc
clf
close all

r1=42;
r3=33;
r4=33;
r7=6;
r8=34;

theta1=0.0;
theta2=deg2rad(67.5);
theta5=deg2rad(112.5);
o2=[0;0];
coordenadas=Gen_coordenadas();
tiempo = length(coordenadas);

%semilla
q=[1; 5; 52; 8; 6; -10];
contador=0;
for t=1:1:tiempo
    contador=contador+1;
    tol=100;
    iter=0;
    

    r6=coordenadas(1,contador)/(cos(atan(coordenadas(2,contador)/coordenadas(1,contador))));
    theta6=atan(coordenadas(2,contador)/coordenadas(1,contador));

    %r6=coordenadas_2(1,contador)/(cos(atan(coordenadas_2(2,contador)/coordenadas_2(1,contador))));
    %theta6=atan(coordenadas_2(2,contador)/coordenadas_2(1,contador));

while tol>1e-10 && iter<100
    iter=iter+1;
    Phi=[-r1*cos(theta1)+q(1)*cos(theta2)+r3*cos(q(3))-r4*cos(q(4))-q(2)*cos(theta5);
        -r1*sin(theta1)+q(1)*sin(theta2)+r3*sin(q(3))-r4*sin(q(4))-q(2)*sin(theta5);
        -r1*cos(theta1)+q(1)*cos(theta2)+r3*cos(q(3))+r7*cos(q(5))-r8*cos(q(6))-q(2)*cos(theta5);
        -r1*sin(theta1)+q(1)*sin(theta2)+r3*sin(q(3))+r7*sin(q(5))-r8*sin(q(6))-q(2)*sin(theta5);
        q(1)*cos(theta2)+r3*cos(q(3))+r7*cos(q(5))-r6*cos(theta6);
        q(1)*sin(theta2)+r3*sin(q(3))+r7*sin(q(5))-r6*sin(theta6)];

    J=[cos(theta2), -cos(theta5),  -r3*sin(q(3)),    r4*sin(q(4)),          0,            0;
        sin(theta2), -sin(theta5),   r3*cos(q(3)),  -r4*cos(q(4)),          0,            0;
        cos(theta2), -cos(theta5),  -r3*sin(q(3)),       0,          -r7*sin(q(5)),   r8*sin(q(6));
        sin(theta2), -sin(theta5),   r3*cos(q(3)),       0,           r7*cos(q(5)),  -r8*cos(q(6));
        cos(theta2),       0,       -r3*sin(q(3)),       0,          -r7*sin(q(5)),       0;
        sin(theta2),       0,        r3*cos(q(3)),       0,           r7*cos(q(5)),       0];

    qf=-J\Phi+q;
    q=qf;
    tol=norm(Phi);
end
if iter>99
    disp('no hubo convergencia')
end
%historico de posicion
Q(:,contador)=q;


P1(:,contador)=q(1);
P2(:,contador)=q(2);
if (contador == 1)
    Pasos1(:,contador)=1000*(Q(1,contador)-q(1));
    Pasos2(:,contador)=1000*(Q(2,contador)-q(2));
end
if (contador > 1)
    Pasos1(:,contador)=1000*(Q(1,contador)-Q(1,contador-1));
    Pasos2(:,contador)=1000*(Q(2,contador)-Q(2,contador-1));
end
Pasos1(:,contador)=round(Pasos1(:,contador));
Pasos2(:,contador)=round(Pasos2(:,contador));

end
u=length(Pasos1)
Vel=500;
for t=1:1:u
    if (t==1)
        V2(1,t)=0;
        V1(1,t)=0;
    end
    if (t~=1)
        V2(1,t)=sqrt((Vel^2)/(abs(Pasos1(t)^2/Pasos2(t)^2) + 1));
        V1(1,t)=(abs(Pasos1(t))/abs(Pasos2(t)))*V2(1,t);
    end
end
%Poner los pasos y velocidades en metrices con separaciones con comas 
Pasos(1,:)=Pasos1;
Pasos(2,:)=Pasos2;
Velocidad(1,:)=V1;
Velocidad(2,:)=V2;
csvwrite('Pasos.txt',Pasos);
csvwrite('Velocidad.txt',Velocidad);
type('Pasos.txt')
type('Velocidad.txt')

hold on
O1=[0, 0];
O2=[q(1)*cos(theta2), q(1)*sin(theta2)];
O3=[q(1)*cos(theta2)+ r3*cos(q(3)), q(1)*sin(theta2)+r3*sin(q(3))];
O4=[r1*cos(theta1)+ q(2)*cos(theta5),r1*sin(theta1)+ q(2)*sin(theta5)];
O5=[r1*cos(theta1), r1*sin(theta1)];
O6=[r6*cos(theta6), r6*sin(theta6)];
O7=[q(1)*cos(theta2)+ r3*cos(q(3))+ r7*cos(q(5)), q(1)*sin(theta2)+r3*sin(q(3))+ r7*sin(q(5))];

line([O1(1) O2(1)],[O1(2) O2(2)],'Color','k')
hold on
line([O2(1) O3(1)],[O2(2) O3(2)])
line([O3(1) O4(1)],[O3(2) O4(2)])
line([O5(1) O4(1)],[O5(2) O4(2)])
line([O1(1) O5(1)],[O1(2) O5(2)])
line([O3(1) O7(1)],[O3(2) O7(2)],'Color','g')
line([O4(1) O7(1)],[O4(2) O7(2)],'Color','g')
%Esta seran las coordenadas del motortool desde el origen
line([O1(1) O6(1)],[O1(2) O6(2)],'Color','r')
hold off

[m n] =size(Q);
figure
paso=1; %cada cuantas iteraciones se genera una grafica
for t=1:paso:n
    O1=[0, 0];
    O2=[Q(1,t)*cos(theta2), Q(1,t)*sin(theta2)];
    O3=[Q(1,t)*cos(theta2)+ r3*cos(Q(3,t)), Q(1,t)*sin(theta2)+r3*sin(Q(3,t))];
    O4=[r1*cos(theta1)+ Q(2,t)*cos(theta5),r1*sin(theta1)+ Q(2,t)*sin(theta5)];
    O5=[r1*cos(theta1), r1*sin(theta1)];
    O6=[r6*cos(theta6), r6*sin(theta6)];
    O7=[Q(1,t)*cos(theta2)+ r3*cos(Q(3,t))+ r7*cos(Q(5,t)), Q(1,t)*sin(theta2)+r3*sin(Q(3,t))+ r7*sin(Q(5,t))];

    line([O1(1) O2(1)],[O1(2) O2(2)])
    hold on
    line([O2(1) O3(1)],[O2(2) O3(2)])
    line([O3(1) O4(1)],[O3(2) O4(2)])
    line([O5(1) O4(1)],[O5(2) O4(2)])
    line([O1(1) O5(1)],[O1(2) O5(2)],'Color','k')
    line([O3(1) O7(1)],[O3(2) O7(2)],'Color','r')
    line([O4(1) O7(1)],[O4(2) O7(2)],'Color','r')
    %Esta seran las coordenadas del motortool desde el origen
    line([O1(1) O6(1)],[O1(2) O6(2)],'Color','g')
    hold off
end
