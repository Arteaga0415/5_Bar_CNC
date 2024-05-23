%Generador de coordenadas 
function [coordenadas] = Gen_cordenadas()
    clc
    clf
    L = 20; 
    %r=4.5;
    X_inicial=39.9035674*cos(-30.53438095);
    Y_inicial=39.9035674*sin(-30.53438095);
    contador=0;
    for t=0:1:(L)
        contador=contador+1;
        theta=(360/L)*t;
        theta=deg2rad(theta);
        %Para obtener flores
        r=4.5*sin(3*theta); %18, %20, %22, %17, %24
        %r=4+cos(3.5*pi*theta); %33
        coordenadas(1,contador)=r*cos(theta);
        coordenadas(2,contador)=r*sin(theta);
    end
    X=coordenadas(1,:)+X_inicial;
    Y=coordenadas(2,:)+Y_inicial;
    figure
    plot(X,Y,"r")
    figure
    plot(X,Y,"r")
    coordenadas(1,:)=X;
    coordenadas(2,:)=Y;
end
