clc 
clf
clear all
L1 = 6;
L3 = 4;
L4 = 4;


L20 = 1;
V20 = 0;
a20 = 1;
L50 = 1;
V50 = 0;
a50 = 1;
theta_1 = 0;
theta_2 = deg2rad(112.5);
theta_5 = deg2rad(67.5);

%O=[0;0];
%D=[0.18;0.445];
%q = [L2; L5; theta_3; theta_4; L6; thetha_6]
q=[3.6; 4.7; 1.7; 2.3;1;1];
stop=100;
i=0;
counter_t=0;
limite = 1000;
tiempo = 1.0;

for t=0:0.1:tiempo
    stop=100;
    i=0;
    counter_t=counter_t+1;
while stop>1e-9 && i<limite
    i=i+1;
    phi=[L1*cos(theta_1)+q(1)*cos(theta_2)-L4*cos(q(4))+L3*cos(q(3))-q(2)*cos(theta_5);
         L1*sin(theta_1)+q(1)*sin(theta_2)-L4*sin(q(4))+L3*sin(q(3))-q(2)*sin(theta_5);
         q(2)*cos(theta_5)+L4*cos(q(4))-q(5)*cos(q(6));
         q(2)*sin(theta_5)+L4*sin(q(4))-q(5)*sin(q(6));
         q(1)-L20-(L20*t)-(0.5*a20*t^2);
         q(2)-L50-(L50*t)-(0.5*a50*t^2)];

          J=[cos(theta_2), -cos(theta_5),  -L3*sin(q(3)),   L4*sin(q(4)), 0, 0;
             sin(theta_2), -sin(theta_5),   L3*cos(q(3)),  -L4*cos(q(4)), 0, 0;
              0, -cos(theta_5), 0,  L4*sin(q(4)), -cos(q(6)), q(5)*sin(q(6));
              0, -sin(theta_5), 0, -L4*cos(q(4)), -sin(q(6)),-q(5)*cos(q(6))
              1, 0, 0, 0, 0, 0;
              0, 1, 0, 0, 0, 0];
    
    q_i=-J\phi+q;
    q=q_i;
    stop=norm(phi);
end
if i>limite
        disp('no hubo convergencia')
        break
 end
 %historico de posicion
 Q(:,counter_t)=q;

 phi_tp=[0; 0; 0; 0; -V20-a20*t; -V50-a50*t];
 v=-J\phi_tp;
 %historico de Velocidad
 V(:,counter_t)=v;
 
 %calcular acceleracion
%  phi_tpp=[0; 0; 0; 0; 0; 0; -a20; -a50];
%  Jp=[-r2*v(1)*cos(q(1))  -r3*v(2)*cos(q(2))   r4*v(3)*cos(q(3))   r5*v(4)*cos(q(4))  0                   0                  0  0;
%         -r2*v(1)*sin(q(1))  -r3*v(2)*sin(q(2))   r4*v(3)*sin(q(3))   r5*v(4)*sin(q(4))  0                   0                  0  0;
%          0                   0                  -r4*v(3)*cos(q(3))   0                 -r6*v(5)*cos(q(5))   r7*v(6)*cos(q(6))  0  0;
%          0                   0                  -r4*v(3)*sin(q(3))   0                 -r6*v(5)*sin(q(5))   r7*v(6)*sin(q(6))  0  0;
%          -r2*v(1)*cos(q(1))  -r3*v(2)*cos(q(2))  0                   0                 -r6*v(5)*cos(q(5))   0                  0  0;
%          -r2*v(1)*sin(q(1))  -r3*v(2)*sin(q(2))  0                   0                 -r6*v(5)*sin(q(5))   0                  0  0;
%          0                   0                   0                   0                  0                   0                  0  0;
%          0                   0                   0                   0                  0                   0                  0  0];
%  a=-J\(Jp*v+phi_tpp);
%  %historico de aceleracion
%  A(:,counter_t)=a;
end

%plot de posición
t=[0:0.1:tiempo];
plot(t,Q(1,:),'r')
hold on
plot(t,Q(2,:),'g')
plot(t,Q(3,:),'b')
plot(t,Q(4,:),'k')
% plot(t,Q(5,:),'k')
% plot(t,Q(6,:),'k')
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
% plot(t,V(5,:),'k')
% plot(t,V(6,:),'k')
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


%Graficadora
figure
O1=[0, 0];
O2=[L1*cos(theta_1), L1*sin(theta_1)];
O3=[q(1)*cos(theta_2)+ L1*cos(theta_1), q(1)*sin(theta_2)+L1*sin(theta_1)];
O4=[L1*cos(theta_1)+ q(1)*cos(theta_2)+ L3*cos(q(3)),L1*sin(theta_1)+ q(1)*sin(theta_2)+L3*sin(q(3))];
O5=[q(2)*cos(theta_5),q(2)*sin(theta_5)];
O6=[L1*cos(theta_1)+ q(5)*cos(q(6)), L1*sin(theta_1)+ q(5)*sin(q(6))];
line([O1(1) O2(1)],[O1(2) O2(2)])
hold on
line([O2(1) O3(1)],[O2(2) O3(2)])
line([O3(1) O4(1)],[O3(2) O4(2)])
line([O5(1) O4(1)],[O5(2) O4(2)])
line([O1(1) O5(1)],[O1(2) O5(2)])
line([O1(1) O6(1)],[O1(2) O6(2)])

%graficadora de todas las posiciones
% [m n] =size(Q);
% figure()
% for t=1:2:n
%     O1=[0, 0];
%     O2=[A2(1), A2(2)];
%     O3=[A2(1)+r2*cos(Q(2,t)), A2(2)+r2*sin(Q(2,t))];
%     O4=[A2(1)+r2*cos(Q(2,t))+r3*cos(Q(3,t)), A2(2)+r2*sin(Q(2,t))+r3*cos(Q(3,t))];
%     O5=[A2(1)+r2*cos(Q(2,t))+r3*cos(Q(3,t))+r6*cos(Q(6,t)), A2(2)+r2*sin(Q(2,t))+r3*cos(Q(3,t))+r6*cos(Q(6,t))];
%     O6=[A2(1)+r1*cos(Q(1,t))+r5*cos(Q(5,t)) A2(2)+r1*sin(Q(1,t))+r5*cos(Q(5,t))];
%     O7=[A2(1)+r1*cos(Q(1,t)), A2(2)+r1*sin(Q(1,t))];
% 
%     line([O1(1) O2(1)],[O1(2) O2(2)])
%     hold on
%     line([O2(1) O3(1)],[O2(2) O3(2)])
%     line([O3(1) O4(1)],[O3(2) O4(2)])
%     line([O4(1) O5(1)],[O4(2) O5(2)])
%     line([O4(1) O6(1)],[O4(2) O6(2)])
%     line([O5(1) O6(1)],[O5(2) O6(2)])
%     line([O2(1) O7(1)],[O2(2) O7(2)])
%     line([O7(1) O6(1)],[O7(2) O6(2)])
% end