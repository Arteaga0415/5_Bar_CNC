clear
clc
clf
close all

r1=6;
r3=4;
r4=4;
r7=1.1;
r8=4.9;
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
              q(1)*cos(theta2)+r3*cos(q(3))-q(5)*cos(q(6));
              q(1)*sin(theta2)+r3*sin(q(3))-q(5)*sin(q(6));
              q(1)-r20-(v20*t)-(0.5*a20*t^2);
              q(2)-r50-(v50*t)-(0.5*a50*t^2)];

          J=[cos(theta2), -cos(theta5),  -r3*sin(q(3)),   r4*sin(q(4)),     0,             0,               0,             0;
             sin(theta2), -sin(theta5),   r3*cos(q(3)),  -r4*cos(q(4)),     0,             0,               0,             0;
             cos(theta2), -cos(theta5),  -r3*sin(q(3)),       0,            0,             0,       -r7*sin(q(7)),     r8*sin(q(8));
             sin(theta2), -sin(theta5),   r3*cos(q(3)),       0,            0,             0,          r7*cos(q(7)),  -r8*cos(q(8));
             cos(theta2),       0,       -r3*sin(q(3)),       0,        -cos(q(6)),    q(5)*sin(q(6))       0,             0;
             sin(theta2),       0,        r3*cos(q(3)),       0,        -sin(q(6)),   -q(5)*cos(q(6))       0,             0;
                 1,             0,             0,             0,            0,             0,               0,             0;
                 0,             1,             0,             0,            0,             0,               0,             0];
        
        qf=-J\Phi+q;
        q=qf;
        tol=norm(Phi);
    end
    if iter>99
        disp('no hubo convergencia')
        break
    end
    %historico de posicion
    P(:,contador)=q;
    %calcular la velocidad
    phi_tp=[0; 0; 0; 0; 0; 0; -v20-a20*t; -v50-a50*t];
    v=-J\phi_tp;
    V(:,contador)=v;
    %calcular aceleración
%     phi_tpp=[0; 0; -a20; -a50];
%     Jp=[0, 0,  -r3*v(3)*cos(q(3)),   r4*v(4)*cos(q(4));
%         0, 0,  -r3*v(3)*sin(q(3)),   r4*v(4)*sin(q(4));
%         0, 0,   0, 0;
%         0, 0,   0, 0];
%     a=-inv(J)*(Jp*v+phi_tpp);
%     A(:,contador)=a;
end

%plot de posición
figure
t=[0:0.1:tiempo];
plot(t,P(1,:),'r')
hold on
plot(t,P(2,:),'g')
plot(t,P(3,:),'b')
plot(t,P(4,:),'k')
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
hold off
axis([0 3 -1 4])

%plot de aceleración
% figure
% t=[0:0.1:tiempo];
% plot(t,A(1,:),'r')
% hold on
% plot(t,A(2,:),'g')
% plot(t,A(3,:),'b')
% plot(t,A(4,:),'k')
% hold off
% axis([0 3 -1 3])

figure 
O1=[0, 0];
O2=[q(1)*cos(theta2), q(1)*sin(theta2)];
O3=[q(1)*cos(theta2)+ r3*cos(q(3)), q(1)*sin(theta2)+r3*sin(q(3))];
O4=[r1*cos(theta1)+ q(2)*cos(theta5),r1*sin(theta1)+ q(2)*sin(theta5)];
O5=[r1*cos(theta1), r1*sin(theta1)];
O7=[q(1)*cos(theta2)+ r3*cos(q(3))+ r7*cos(q(7)), q(1)*sin(theta2)+r3*sin(q(3))+ r7*sin(q(7))];

line([O1(1) O2(1)],[O1(2) O2(2)])
hold on
line([O2(1) O3(1)],[O2(2) O3(2)])
line([O3(1) O4(1)],[O3(2) O4(2)])
line([O5(1) O4(1)],[O5(2) O4(2)])
line([O1(1) O5(1)],[O1(2) O5(2)])
line([O3(1) O7(1)],[O3(2) O7(2)])
line([O4(1) O7(1)],[O4(2) O7(2)])

hold off




