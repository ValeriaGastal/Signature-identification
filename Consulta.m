function Consulta(d)
%con la imagen ya habiendo pasado por esquel y pasarBMP


%CONSTANTES
angulos= [18 36 54 72 90 108 126 144 162 180]; 
proporciones = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
conn=database('histogramas','','');
direccion= 'D:\Escritorio\Imagenes esqueletizadas en BMP\';

%HISTOGRAMA DE LA IMAGEN
    imagen=imread(char(d));
    P=imagePoints(char(d));
    pTam=size(P);
    centroide=centroidOf(char(d));
    histograma = zeros(10, 10);
    for j= 1: pTam
        for k= 1: pTam  
            if (j<k)
                angulo= anglesBetween(centroide, P(j,:),P(k,:));
                propor= proporcion(centroide, P(j,:), P(k,:));
                
                if angulo>162 && angulo <=180
                    angleRangeInterval=10;
                else
                        if angulo>144
                            angleRangeInterval=9;
                        else
                            if angulo> 126 %Luego de calcular el angulo entre dos dos puntos y el centroide y su proporcion, encuentra los angulos inferiores a este y proporciones inferiores a este, y se queda con el más alto de estos 
                                angleRangeInterval=8;
                            else
                                if angulo>108
                                    angleRangeInterval=7;
                                else
                                    if angulo>90
                                        angleRangeInterval=6;
                                    else
                                        if angulo>72
                                            angleRangeInterval=5;
                                        else
                                            if angulo>54
                                                angleRangeInterval=4;
                                            else
                                                if angulo>36
                                                    angleRangeInterval=3;
                                                else
                                                    if angulo>18
                                                        angleRangeInterval=2;
                                                    else
                                                        angleRangeInterval=1;
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                end
                
                if propor>0.9 && propor<=1
                    proportionRangeInterval=10;
                else
                    if propor>0.8
                        proportionRangeInterval=9;
                    else
                        if propor>0.7
                            proportionRangeInterval=8;
                        else
                            if propor>0.6
                                proportionRangeInterval=7;
                            else
                                if propor>0.5
                                    proportionRangeInterval=6;
                                else
                                    if propor>0.4
                                        proportionRangeInterval=5;
                                    else
                                        if propor>0.3
                                            proportionRangeInterval=4;
                                        else
                                            if propor>0.2
                                                proportionRangeInterval=3;
                                            else
                                                if propor>0.1
                                                    proportionRangeInterval=2;
                                                else
                                                    proportionRangeInterval=1;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                histograma(angleRangeInterval, proportionRangeInterval) = 1 + histograma(angleRangeInterval, proportionRangeInterval);    
                
            end
        end
       
            
    
    end
     %normalización
     histogramaNorma = norm(histograma);        
        if(histogramaNorma > 0)
                histograma = histograma/histogramaNorma;
        end   
        
%COMPARAR HISTOGRAMAS
vectorMinimos=[50000,50000,50000,50000,50000];
vectorNombresMinimos=[0,0,0,0,0];
for i=1:5256
    consulta=strcat('Select * from histograma where idhistograma=',int2str(i));
    curs= exec(conn,consulta);
    curs= fetch(curs);
    datos=curs.data;
    histogramaAux = zeros(10, 10);
    for j=1:10
        for k= 1:10
            %for l=3:102
                histogramaAux(j,k)= cell2mat(datos((j-1)*10+k+2)); %l
            %end
        end
    end    
    distancia= norm(histogramaAux-histograma);
    if distancia<vectorMinimos(5)
        if distancia<vectorMinimos(4)
            if distancia<vectorMinimos(3)
                if distancia<vectorMinimos(2)
                    if distancia<vectorMinimos(1)
                        vectorMinimos(1)=distancia;
                        vectorNombresMinimos(1)= cell2mat(datos(2));
                    else
                        vectorMinimos(2)=distancia;
                        vectorNombresMinimos(2)= cell2mat(datos(2));
                    end
                else 
                    vectorMinimos(3)=distancia;
                    vectorNombresMinimos(3)= cell2mat(datos(2));
                end
            else
                vectorMinimos(4)=distancia;
                vectorNombresMinimos(4)= cell2mat(datos(2));
            end
        else 
            vectorMinimos(5)=distancia;
            vectorNombresMinimos(5)= cell2mat(datos(2));
        end 
    end
end    
 %muestra las 5 firmas mas parecidas      
 disp('Sea la imagen original:');     
 imshow(imagen);      
 disp('La imagen con menos distancias son');      
 
 
 for m=1:5
     consulta2= strcat('select nombreim from nombres where idnombres=',int2str(vectorNombresMinimos(m)));
     curs2= exec(conn,consulta2);
     curs2= fetch(curs2);
     datos2=curs2.data;
     disp(strcat('La imagen: ',cell2mat(datos2(1))));
     disp(strcat('Con distancia de: ', num2str(vectorMinimos(m))));
    imaux=imread(char(strcat(direccion,datos2(1)))); 
    %imaux=imread(char(strcat(direccion,cell2mat(datos2(1))'))); 
    figure(m);
    imshowpair(imagen,imaux,'montage');
    %pause(20);
    %imshow(imaux);
 end
    

