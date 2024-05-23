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
        q_tabla = [q(3), q(4)]
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

    fuerzas = A\b
  
    Q(:,contador)= fuerzas;
    
    % % ESFUERZOS
    Area_aplastamiento = ((12.7/1000) * (12.7/1000));
    Area_cortante = pi*((0.0127/2)^2);
    Par = [fuerzas(1), fuerzas(2)];
    Par_resultante = ((fuerzas(1))^(2) + (fuerzas(2))^(2))^(1/2);
    Par_F2 = ((fuerzas(3))^(2) + (fuerzas(5))^(2))^(1/2);
    Par_F5 = ((fuerzas(4))^(2) + (fuerzas(6))^(2))^(1/2);
    
    esfuerzo_aplastamiento = Par_resultante / Area_aplastamiento;
    esfuerzo_cortante = Par_resultante / Area_cortante;
    
    esfuerzo_aplastamiento_F2 = Par_F2 / Area_aplastamiento;
    esfuerzo_cortante_F2 = Par_F2 / Area_cortante;
    
    esfuerzo_aplastamiento_F5 = Par_F5 / Area_aplastamiento;
    esfuerzo_cortante_F5 = Par_F5 / Area_cortante;
    
    E(:, contador) = esfuerzo_aplastamiento;
    C(:, contador) = esfuerzo_cortante;
    
    R(:, contador) = esfuerzo_aplastamiento_F2;
    T(:, contador) = esfuerzo_cortante_F2;
    
    G(:, contador) = esfuerzo_aplastamiento_F5;
    H(:, contador) = esfuerzo_cortante_F5;

    % T O R N I L L O
    L = 500/ 1000;
    Torque_F2 = fuerzas(5)*L / 2*pi;
    Torque_F5 = fuerzas(6)*L / 2*pi;
    d_p = 11/1000;
    d_r = 10/1000;
    sigma_F2 = (16*fuerzas(5)) / (pi*((d_p + d_r)^(2)));
    tao_F2 = (16*Torque_F2) / (pi*(d_r^3));
    sigma_F5 = (16*fuerzas(6)) / (pi*((d_p + d_r)^(2)));
    tao_F5 = (16*Torque_F5) / (pi*(d_r^3));
    
    O(:, contador) = sigma_F2;
    OO(:, contador) = sigma_F5;
    TAO2(:, contador) = tao_F2;
    TAO5(:, contador) = tao_F5;
    
    
    
    sigprom_presult= (Par_resultante /((0.0254-0.0127)*0.0127));
    sigprom_f2=( Par_F2 /((0.0254-0.0127)*0.0127));
    sigprom_f5=( Par_F5 /((0.0254-0.0127)*0.0127));

    k=2.1;
    sigma_res_max=k*sigprom_presult;
    sigma_f2_max=k*sigprom_f2;
    sigma_f5_max=k* sigprom_f5;
    
    SR(:, contador) = sigma_res_max;
    SF(:, contador) = sigma_f2_max;
    SFF(:,contador) = sigma_f5_max;

    
    %%%%%%%% CARGA CRITICA %%%%%%%%%%%%
    E_tornillo = 210*10^9;      % aleacion 304: 210 GPa
    I_tornillo = (1/4)*pi*((d_r/2)^2);
    P_cri = ((pi^2)*E_tornillo*I_tornillo) / (L);
    
    %factor de seguridad

    Eultimo1020=200*10^9;

    Fs_res=(Eultimo1020/sigma_res_max);
    Fs_f2=(Eultimo1020/sigma_f2_max);
    Fs_f5=(Eultimo1020/sigma_f5_max);
    
    TR(:, contador) = Fs_res;
    TF(:, contador) = Fs_f2;
    TFF(:,contador) = Fs_f5;


 
  
end    

 %%%plot de ESFUERZOS aplastamiento
 figure
 t=(0:0.01:tiempo);
 plot(t,E(1,:),'r')
 axis([0 2.5 -10000 8000000])
 title('Esfuerzo de aplastamiento pasador barra C')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
  %%%plot de ESFUERZOS cortante
 figure
 t=(0:0.01:tiempo);
 plot(t,C(1,:),'b')
 axis([0 2.5 -10000 9500000])
 title('Esfuerzo cortante pasador barra C')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
 %%%par F2
  figure
 t=(0:0.01:tiempo);
 plot(t,R(1,:),'r')
 axis([0 2.5 -10000 8000000])
 title('Esfuerzo de aplastamiento pasador barra B')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
  %plot de ESFUERZOS cortante
 figure
 t=(0:0.01:tiempo);
 plot(t,T(1,:),'b')
 axis([0 2.5 -10000 9500000])
 title('Esfuerzo cortante pasador barra B')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
 
%%%Par F5
   figure
 t=(0:0.01:tiempo);
 plot(t,G(1,:),'r')
 axis([0 2.5 -10000 8000000])
 title('Esfuerzo de aplastamiento pasador barra E')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
  %plot de ESFUERZOS cortante
 figure
 t=(0:0.01:tiempo);
 plot(t,H(1,:),'b')
 axis([0 2.5 -10000 9500000])
 title('Esfuerzo cortante pasador barra E')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on


%%%%%% T O R N I L L O %%%%%%%%%%%%%%%%%%%

%%%%%%%%%% AXIAL

 figure
 t=(0:0.01:tiempo);
 plot(t,O(1,:),'r')
 axis([0 2.5 -1.5*10^7 0])
 title('Esfuerzo axial tornillo r2')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
 
 figure
 t=(0:0.01:tiempo);
 plot(t,OO(1,:),'b')
 axis([0 2.5 -10000000 20000000])
 title('Esfuerzo axial tornillo r5')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on

%%%%%%%%%%%CORTANTE

 figure
 t=(0:0.01:tiempo);
 plot(t,TAO2(1,:),'r')
 axis([0 2.5 -5*10^9 0])
 title('Esfuerzo cortante de torsión tornillo r3')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on
 
 figure
 t=(0:0.01:tiempo);
 plot(t,TAO5(1,:),'b')
 axis([0 2.5 -1*10^9 4.5*10^9])
 title('Esfuerzo cortante de torsión tornillo r5')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on


%%%%%%%%%%% ESFUERZO CONCENTRADOR DE ESFUERZOS EN BARRAS (AGUJERO)
%%%%%%%%%%% %%%%%%%%%%
% 
%  figure
%  t=(0:0.01:tiempo);
%  plot(t,SR(1,:),'r')
%  axis([0 2.5 0 2*10^7])
%  title('Esfuerzo axial máximo barra 4 debido a par R')
%  xlabel('tiempo[s]')
%  ylabel('Esfuerzo [N/m^2]')
%  legend({'Esfuerzo'},'Location','southwest')
%  grid on
 
 figure
 t=(0:0.01:tiempo);
 plot(t,SF(1,:),'b')
 axis([0 2.5 0 2*10^7])
 title('Esfuerzo axial máximo barra 3 debido a par prismático')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on

 figure
 t=(0:0.01:tiempo);
 plot(t,SFF(1,:),'b')
 axis([0 2.5 0 2*10^7])
 title('Esfuerzo axial máximo barra 4 debido a par prismático')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Esfuerzo'},'Location','southwest')
 grid on

% facot de seguridad

 figure
 t=(0:0.01:tiempo);
 plot(t,TR(1,:),'b')
 axis([0 2.5 10000 55000])
 title('Factor de seguridad pasador C')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Factor de seguridad'},'Location','southwest')
 grid on

 figure
 t=(0:0.01:tiempo);
 plot(t,TF(1,:),'b')
 axis([0 2.5 0 55000])
 title('Factor de seguridad barra 3')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Factor de seguridad'},'Location','southwest')
 grid on

 figure
 t=(0:0.01:tiempo);
 plot(t,TFF(1,:),'b')
 axis([0 2.5 0 505000])
 title('Factor de seguridad barra 4')
 xlabel('tiempo[s]')
 ylabel('Esfuerzo [N/m^2]')
 legend({'Factor de seguridad'},'Location','southwest')
 grid on





