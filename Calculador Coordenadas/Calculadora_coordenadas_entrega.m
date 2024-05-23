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

%GDL1
r20=1;
v20=0;
a20=1;
%GDL2
r50=1;
v50=0;
a50=1;
tiempo = 2.3;

%semilla
q=[3.6; 4.7; 1.7; 2.3; 1.5; 2; 3; 1];
contador=0;
for t=0:0.1:tiempo
    contador=contador+1;
    tol=100;
    iter=0;

    while tol>1e-10 && iter<100
        iter=iter+1;
        Phi=[-r1*cos(theta1)+q(1)*cos(theta2)+r3*cos(q(3))-r4*cos(q(4))-q(2)*cos(theta5);
             -r1*sin(theta1)+q(1)*sin(theta2)+r3*sin(q(3))-r4*sin(q(4))-q(2)*sin(theta5);
             -r1*cos(theta1)+q(1)*cos(theta2)+r3*cos(q(3))+r7*cos(q(7))-r8*cos(q(8))-q(2)*cos(theta5);
             -r1*sin(theta1)+q(1)*sin(theta2)+r3*sin(q(3))+r7*sin(q(7))-r8*sin(q(8))-q(2)*sin(theta5);
              q(1)*cos(theta2)+r3*cos(q(3))+r7*cos(q(7))-q(5)*cos(q(6));
              q(1)*sin(theta2)+r3*sin(q(3))+r7*sin(q(7))-q(5)*sin(q(6));
              q(1)-r20-(v20*t)-(0.5*a20*t^2);
              q(2)-r50-(v50*t)-(0.5*a50*t^2)];
 
          J=[cos(theta2), -cos(theta5),  -r3*sin(q(3)),   r4*sin(q(4)),   0,           0,                0,             0;
             sin(theta2), -sin(theta5),   r3*cos(q(3)),  -r4*cos(q(4)),   0,           0,                0,             0;
             cos(theta2), -cos(theta5),  -r3*sin(q(3)),       0,          0,           0,          -r7*sin(q(7)),   r8*sin(q(8));
             sin(theta2), -sin(theta5),   r3*cos(q(3)),       0,          0,           0,           r7*cos(q(7)),  -r8*cos(q(8));
             cos(theta2),       0,       -r3*sin(q(3)),       0,      -cos(q(6)),  q(5)*sin(q(6))  -r7*sin(q(7)),       0;
             sin(theta2),       0,        r3*cos(q(3)),       0,      -sin(q(6)), -q(5)*cos(q(6))   r7*cos(q(7)),       0;
                 1,             0,             0,             0,          0,           0,                0,             0;
                 0,             1,             0,             0,          0,           0,                0,             0];
        
        qf=-J\Phi+q;
        q=qf;
        tol=norm(Phi);
    end
    if iter>99
        disp('no hubo convergencia')
        break
    end
    %historico de posicion
    Q(:,contador)=q;
    coordenadas(:,contador)=[q(5),q(6)];

    %calcular la velocidad
    phi_tp=[0; 0; 0; 0; 0; 0; -v20-a20*t; -v50-a50*t];
    v=-J\phi_tp;
    V(:,contador)=v;
    %calcular aceleración
    phi_tpp=[0; 0; 0; 0; 0; 0; -a20; -a50];
    Jp=[0, 0,  -r3*v(3)*cos(q(3)),   r4*v(4)*cos(q(4)), 0, 0, 0, 0;
        0, 0,  -r3*v(3)*sin(q(3)),   r4*v(4)*sin(q(4)), 0, 0, 0, 0;
        0, 0,  -r3*v(3)*cos(q(3)),  0, 0, 0, -r7*v(7)*cos(q(7)), r8*v(8)*cos(q(8));
        0, 0,  -r3*v(3)*sin(q(3)),  0, 0, 0, -r7*v(7)*sin(q(7)), r8*v(8)*sin(q(8));
        0, 0,  -r3*v(3)*cos(q(3)),  0, v(6)*sin(q(6)), q(5)*v(6)*cos(q(6)), -r7*v(7)*cos(q(7)), 0;
        0, 0,  -r3*v(3)*sin(q(3)),  0, v(6)*cos(q(6)), q(5)*v(6)*sin(q(6)), -r7*v(7)*sin(q(7)), 0;
        0, 0,  0,  0, 0, 0, 0, 0;
        0, 0,  0,  0, 0, 0, 0, 0;
        ];
    a=-inv(J)*(Jp*v+phi_tpp);
    A(:,contador)=a;
end

%plot de posición
figure
t=[0:0.1:tiempo];
plot(t,Q(1,:),'r')
hold on
plot(t,Q(2,:),'g')
plot(t,Q(3,:),'b')
plot(t,Q(4,:),'k')
plot(t,Q(5,:),'r')
plot(t,Q(6,:),'g')
plot(t,Q(7,:),'b')
plot(t,Q(8,:),'k')
hold off
axis([0 3 0 5])

%plot de velocidad
figure
t=[0:0.1:tiempo];
plot(t,V(1,:),'r')
hold on
plot(t,V(2,:),'g')
plot(t,V(3,:),'b')
plot(t,V(4,:),'k')
plot(t,V(5,:),'r')
plot(t,V(6,:),'g')
plot(t,V(7,:),'b')
plot(t,V(8,:),'k')
hold off
axis([0 3 -1 4])

%plot de aceleración
figure
t=[0:0.1:tiempo];
plot(t,A(1,:),'r')
hold on
plot(t,A(2,:),'g')
plot(t,A(3,:),'b')
plot(t,A(4,:),'k')
plot(t,A(5,:),'r')
plot(t,A(6,:),'g')
plot(t,A(7,:),'b')
plot(t,A(8,:),'k')
hold off
axis([0 3 -1 3])

figure 
O1=[0, 0];
O2=[q(1)*cos(theta2), q(1)*sin(theta2)];
O3=[q(1)*cos(theta2)+ r3*cos(q(3)), q(1)*sin(theta2)+r3*sin(q(3))];
O4=[r1*cos(theta1)+ q(2)*cos(theta5),r1*sin(theta1)+ q(2)*sin(theta5)];
O5=[r1*cos(theta1), r1*sin(theta1)];
O6=[q(5)*cos(q(6)), q(5)*sin(q(6))];
O7=[q(1)*cos(theta2)+ r3*cos(q(3))+ r7*cos(q(7)), q(1)*sin(theta2)+r3*sin(q(3))+ r7*sin(q(7))];

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
figure()
paso=5; %cada cuantas iteraciones se genera una grafica
for t=1:paso:n
    O1=[0, 0];
    O2=[Q(1,t)*cos(theta2), Q(1,t)*sin(theta2)];
    O3=[Q(1,t)*cos(theta2)+ r3*cos(Q(3,t)), Q(1,t)*sin(theta2)+r3*sin(Q(3,t))];
    O4=[r1*cos(theta1)+ Q(2,t)*cos(theta5),r1*sin(theta1)+ Q(2,t)*sin(theta5)];
    O5=[r1*cos(theta1), r1*sin(theta1)];
    O6=[Q(5,t)*cos(Q(6,t)), Q(5,t)*sin(Q(6,t))];
    O7=[Q(1,t)*cos(theta2)+ r3*cos(Q(3,t))+ r7*cos(Q(7,t)), Q(1,t)*sin(theta2)+r3*sin(Q(3,t))+ r7*sin(Q(7,t))];

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




