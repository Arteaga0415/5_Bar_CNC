clc 
clear all
 r1 = 13;
 r2 = 11;
 r3 = 11;
 r4 = 12;
 r5 = 13;
 r6 = 10;
 r7 = 10;
 A2=[5;5];

 %GDL1
 theta1 = 0.35;
 theta20 = 0;
 omega20 = 0;
 alpha20 = 1;
 %GDL2
 theta50=0;
 omega50=0;
 alpha50=1;

 q= [1;2;0.5;2;1;0.5;7;7];

 counter_t=0;
 for t=0:0.1:1.2
     stop=100;
     i=0;
     counter_t=counter_t+1;
 while stop>1e-9 && i<100
     i=i+1;
    phi=[-r1*cos(theta1)+r2*cos(q(1))+r3*cos(q(2))-r4*cos(q(3))-r5*cos(q(4));
             -r1*sin(theta1)+r2*sin(q(1))+r3*sin(q(2))-r4*sin(q(3))-r5*sin(q(4));
              r4*cos(q(3))+r6*cos(q(5))-r7*cos(q(6));
              r4*sin(q(3))+r6*sin(q(5))-r7*sin(q(6));
              A2(1)+r2*cos(q(1))+r3*cos(q(2))+r6*cos(q(5))-q(7);
              A2(2)+r2*sin(q(1))+r3*sin(q(2))+r6*sin(q(5))-q(8);
              q(1)-theta20-(omega20*t)-(0.5*alpha20*t^2);
              q(4)-theta50-(omega50*t)-(0.5*alpha50*t^2)];
      
      J=[-r2*sin(q(1))  -r3*sin(q(2))   r4*sin(q(3))   r5*sin(q(4))   0              0             0   0;
              r2*cos(q(1))   r3*cos(q(2))  -r4*cos(q(3))  -r5*cos(q(4))   0              0             0   0;
              0              0             -r4*sin(q(3))   0             -r6*sin(q(5))   r7*sin(q(6))  0   0;
              0              0              r4*cos(q(3))   0              r6*cos(q(5))  -r7*cos(q(6))  0   0;
             -r2*sin(q(1))  -r3*sin(q(2))   0              0             -r6*sin(q(5))   0            -1   0;
              r2*cos(q(1))   r3*cos(q(2))   0              0              r6*cos(q(5))   0             0  -1;
              1              0              0              0              0              0             0   0;
              0              0              0              1              0              0             0   0];
      
      q_i=-J\phi+q;
      q=q_i;
      stop=norm(phi);
 end

 if i>99
        disp('no hubo convergencia')
        break
 end
 %historico de posicion
 Q(:,counter_t)=q;

 phi_tp=[0; 0; 0; 0; 0; 0; -omega20-alpha20*t; -omega50-alpha50*t];
 v=-J\phi_tp;
 V(:,counter_t)=v;
 
 %calcular acceleracion
 phi_tpp=[0; 0; 0; 0; 0; 0; -alpha20; -alpha50];
 Jp=[-r2*v(1)*cos(q(1))  -r3*v(2)*cos(q(2))   r4*v(3)*cos(q(3))   r5*v(4)*cos(q(4))  0                   0                  0  0;
        -r2*v(1)*sin(q(1))  -r3*v(2)*sin(q(2))   r4*v(3)*sin(q(3))   r5*v(4)*sin(q(4))  0                   0                  0  0;
         0                   0                  -r4*v(3)*cos(q(3))   0                 -r6*v(5)*cos(q(5))   r7*v(6)*cos(q(6))  0  0;
         0                   0                  -r4*v(3)*sin(q(3))   0                 -r6*v(5)*sin(q(5))   r7*v(6)*sin(q(6))  0  0;
         -r2*v(1)*cos(q(1))  -r3*v(2)*cos(q(2))  0                   0                 -r6*v(5)*cos(q(5))   0                  0  0;
         -r2*v(1)*sin(q(1))  -r3*v(2)*sin(q(2))  0                   0                 -r6*v(5)*sin(q(5))   0                  0  0;
         0                   0                   0                   0                  0                   0                  0  0;
         0                   0                   0                   0                  0                   0                  0  0];

 a=-J\(Jp*v+phi_tpp);
 A(:,counter_t)=a;
 
 end
 [m n] =size(Q);
 figure()
 for t=1:2:n
     O1=[0, 0];
     O2=[A2(1), A2(2)];
     O3=[A2(1)+r2*cos(Q(2,t)), A2(2)+r2*sin(Q(2,t))];
     O4=[A2(1)+r2*cos(Q(2,t))+r3*cos(Q(3,t)), A2(2)+r2*sin(Q(2,t))+r3*cos(Q(3,t))];
     O5=[A2(1)+r2*cos(Q(2,t))+r3*cos(Q(3,t))+r6*cos(Q(6,t)), A2(2)+r2*sin(Q(2,t))+r3*cos(Q(3,t))+r6*cos(Q(6,t))];
     O6=[A2(1)+r1*cos(Q(1,t))+r5*cos(Q(5,t)) A2(2)+r1*sin(Q(1,t))+r5*cos(Q(5,t))];
     O7=[A2(1)+r1*cos(Q(1,t)), A2(2)+r1*sin(Q(1,t))];
     
     line([O1(1) O2(1)],[O1(2) O2(2)])
     hold on
     line([O2(1) O3(1)],[O2(2) O3(2)])
     line([O3(1) O4(1)],[O3(2) O4(2)])
     line([O4(1) O5(1)],[O4(2) O5(2)])
     line([O4(1) O6(1)],[O4(2) O6(2)])
     line([O5(1) O6(1)],[O5(2) O6(2)])
     line([O2(1) O7(1)],[O2(2) O7(2)])
     line([O7(1) O6(1)],[O7(2) O6(2)])
 end
   


