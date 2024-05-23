clc 

clear all
 r1 = 5;
 r2 = 3;
 r3 = 6;
 r4 = 7;
 theta1 = 0.3;
 theta2 = 0;
 omega2 = 0;
 alpha2 = 1;
 q= [0.2;1;2.2;2.5];
 counter_t=0;
 for t=0:0.1:3.6
     stop=100;
     i=0;
     counter_t=counter_t+1;
 while stop>1e-9 && i<100
     i=i+1;
     phi=[-r1*cos(q(1))+r2*cos(q(2))+r3*cos(q(3))-r4*cos(q(4));
          -r1*sin(q(1))+r2*sin(q(2))+r3*sin(q(3))-r4*sin(q(4));
          q(2)-theta2-(omega2*t)-(0.5*alpha2*(t)^2);
          q(1)-theta1];
      
      J=[r1*sin(q(1)), -r2*sin(q(2)), -r3*sin(q(3)),  r4*sin(q(4));
        -r1*cos(q(1)),  r2*cos(q(2)),  r3*cos(q(3)), -r4*cos(q(4));
         0, 1, 0, 0;
         1, 0, 0, 0];
      
      q_i=-J\phi+q;
      q=q_i;
      stop=norm(phi);
 end
 phi_tp=[0;0;-omega2-alpha2*t;0];
 v=-J\phi_tp;
 %calcular acceleracion
 phi_tpp=[0;0;-alpha2;0];
 Jp=[v(1)*r1*cos(q(1)), -v(2)*r2*cos(q(2)), -v(3)*r3*cos(q(3)), v(4)*r4*cos(q(4));
     v(1)*r1*sin(q(1)), -v(2)*r2*sin(q(2)), -v(3)*r3*sin(q(3)), v(4)*r4*sin(q(4));
         0, 0, 0, 0;
         0, 0, 0, 0];
 a=-J\(Jp*v+phi_tpp);
 
 Q(:,counter_t)=q;
 V(:,counter_t)=v;
 A(:,counter_t)=a;


 
 end
 [m n] =size(Q);
 figure()
 for t=1:2:n
     O1=[0, 0];
     O2=[r2*cos(Q(2,t)), r2*sin(Q(2,t))];
     O3=[r2*cos(Q(2,t))+r3*cos(Q(3,t)), r2*sin(Q(2,t))+r3*sin(Q(3,t))];
     O4=[r1*cos(Q(1,t)), r1*sin(Q(1,t))];
     
     line([O1(1) O2(1)],[O1(2) O2(2)])
     hold on
     line([O2(1) O3(1)],[O2(2) O3(2)])
     line([O3(1) O4(1)],[O3(2) O4(2)])
     line([O1(1) O4(1)],[O1(2) O4(2)])

 end
   


 