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
q=[0.2; 0.2; 1.7; 2.3; 1.5; 2; 3; 1];
contador=0;
for t=0:0.01:tiempo
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
        %disp(q)
        q_prima = [q(3); q(4); q(7)];
        %disp(q_prima)

    end
    if iter>99
        disp('no hubo convergencia')
        break
    end
    

    posiciones = [rad2deg(q_prima(1)), rad2deg(q_prima(2)), rad2deg(q_prima(3))];

    r7 = 6;
    r3 = 33;
    r4 = 33;
    F_ext = 800;

    A = [0, 1, -cos(90 - posiciones(1)), 0, cos(posiciones(1)), 0;
     1, 0, sin(90 - posiciones(1)), 0, sin(posiciones(1)), 0;
     r3*cos(posiciones(1)), -r3*sin(posiciones(1)), 0, 0, 0, 0;
     0, -1, 0, cos(posiciones(2) - 90), 0, -cos(posiciones(2));
     -1, 0, 0, sin(posiciones(2) - 90), 0, sin(posiciones(2));
     0, 0, 0, r4, 0, 0;
     ];
    b = [0; 0; 0; F_ext; 0; -F_ext*(r7*sin(posiciones(3)))];

    fuerzas = A\b;
    Q(:,contador)= fuerzas;
    
    % % ESFUERZOS
    Area_aplastamiento = ((12.7/1000) * (12.7/1000));
    Area_cortante = pi*((0.0127/2)^2);
    Par = [fuerzas(1), fuerzas(2)];
    Par_resultante = ((fuerzas(1))^(2) + (fuerzas(2))^(2))^(1/2);
    esfuerzo_aplastamiento = Par_resultante / Area_aplastamiento;
    esfuerzo_cortante = Par_resultante / Area_cortante;
    E(:, contador) = esfuerzo_aplastamiento;
    C(:, contador) = esfuerzo_cortante;

   

 
  
end    

 %plot de ESFUERZOS aplastamiento
 figure
 t=[0:0.01:tiempo];
 plot(t,E(1,:),'r')
 axis([0 2.5 -10000 8000000])
 title('Esfuerzo de aplastamiento pasador barra 3-4')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
  %plot de ESFUERZOS cortante
 figure
 t=[0:0.01:tiempo];
 plot(t,C(1,:),'b')
 axis([0 2.5 -10000 9500000])
 title('Esfuerzo cortante pasador barra 3-4')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on


 %plot de R_34y
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(1,:),'r')
 axis([0 2.5 -600 1200])
 title('Reacciones barra 3 Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Reacción vertical[N]')
 legend({'R-34y'},'Location','southwest')
 grid on
 
 % plot de R_34x
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(2,:),'g')
 axis([0 2.5 -1100 150])
 title('Reacciones barra 3 Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Reacción horizontal[N]')
 legend({'R-34x'},'Location','northwest')
 grid on
 
%   % plot de R_p2
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(3,:),'b')
 axis([0 2.5 -1.5*10^(-13) 1.5*10^(-13)])
 title('Reacciones par prismático Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Reacción perpendicular par P-2[N]')
 legend({'R-p2'},'Location','southwest')
 grid on
%  
  % plot de R_p5
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(4,:),'g')
 axis([0 2.5 -300 300])
 title('Reacciones par prismático Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Reacción perpendicular par P-5[N]')
 legend({'R-p5'},'Location','southwest')
 grid on
%  

% plot de F_2
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(5,:),'g')
 axis([0 2.5 -1500 500])
 title('Reacciones par prismático Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Grado de libertad F-2[N]')
 legend({'F-2'},'Location','southwest')
 grid on
%   
  % plot de F_5
 figure
 t=[0:0.01:tiempo];
 plot(t,Q(6,:),'r')
 axis([0 2.5 -500 1500])
 title('Reacciones par prismático F-5 Vs tiempo')
 xlabel('tiempo[s]')
 ylabel('Grado de libertad F-5[N]')
 legend({'F-5'},'Location','southwest')
 grid on
%  
 
 



