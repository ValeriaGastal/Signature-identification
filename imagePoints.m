function cXY=imagePoints(dirImagen)
    %clc;clear;
    %directorio='C:\Users\Juan Andres\Desktop\1.bmp';
    imagen= imread(dirImagen); %lee direccion de imagen
    [u,v]=size(imagen);        %u fila, v columna
    cX=[];      %inicializa vector para coordenadas x
    cY=[];      %inicializa vector para coordenadas y
    cXY=[];     %inicializa vector para guardar ambos puntos
    ind=0;      %indice del vector
    for i=1:u
        for j=1:v % va /3 si la imagen es png, si es bmp, solo v
            if(imagen(i,j)==0)
                ind=1+ ind;     %suma una posicion nueva
                cX(ind)=i;      %asigna la coordenada x
                cY(ind)=j;      %asigna la coordenada y
            end
        end
    end
    cXY=[cX;cY];    % concatenacion de ambos vectores en una matriz
    cXY=cXY';       %transpone matriz
end