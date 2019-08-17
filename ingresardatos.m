function cantGuardado= ingresardatos()


cantGuardado=0;
directorio='D:\Escritorio\pasando';
tipo= '*.bmp';
fotospasadas=1999;
%angulos= [18 36 54 72 90 108 126 144 162 180]; %180 
%proporciones = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
list_dir=dir(fullfile(directorio,tipo));
nombres={list_dir.name};
[m,n] = size (nombres); %m=1, n=cantidad  de imagenes
conn=database('histogramas','','');
for i = 1:n
    %histogramaAux;
    Im=nombres(i);
    cadena=strcat(directorio,'\', Im);
    imagen=imread(char(cadena));
    P=imagePoints(char(cadena));
    pTam=size(P);
    centroide=centroidOf(char(cadena));
    histogramaAux = zeros(10, 10);
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

                histogramaAux(angleRangeInterval, proportionRangeInterval) = 1 + histogramaAux(angleRangeInterval, proportionRangeInterval);    
                
            end
        end
       
            
    
    end
     %normalización
     histogramaAuxNorma = norm(histogramaAux);        
        if(histogramaAuxNorma > 0)
                histogramaAux = histogramaAux/histogramaAuxNorma;
        end   
        
     %consultas para insertar el nombre de la imagen
        consulta1= strcat('Insert into nombres (idnombres,nombreim) values(',int2str(i+fotospasadas),',"',char(Im),'")');
       
        
     %consultas para insertar el histograma
        consulta2= strcat('Insert into histograma (idnombre,idhistograma,h0101,h0102,h0103,h0104,h0105,h0106,h0107,h0108,h0109,h0110,h0201,h0202,h0203,h0204,h0205,h0206,h0207,h0208,h0209,h0210,h0301,h0302,h0303,h0304,h0305,h0306,h0307,h0308,h0309,h0310,h0401,h0402,h0403,h0404,h0405,h0406,h0407,h0408,h0409,h0410,h0501,h0502,h0503,h0504,h0505,h0506,h0507,h0508,h0509,h0510,h0601,h0602,h0603,h0604,h0605,h0606,h0607,h0608,h0609,h0610,h0701,h0702,h0703,h0704,h0705,h0706,h0707,h0708,h0709,h0710,h0801,h0802,h0803,h0804,h0805,h0806,h0807,h0808,h0809,h0810,h0901,h0902,h0903,h0904,h0905,h0906,h0907,h0908,h0909,h0910,h1001,h1002,h1003,h1004,h1005,h1006,h1007,h1008,h1009,h1010) values(',int2str(i+fotospasadas),',',int2str(i+fotospasadas));
        contador=0;
        for j = 1:10
            for k= 1:10
                consulta2= strcat(consulta2,',',num2str(histogramaAux(j,k),5));
                contador=contador+1;
            end
        end
        consulta2= strcat(consulta2, ')');
        
    %ejecutar consulta
    exec(conn,consulta1);
    exec(conn,consulta2);
    disp(consulta1);
    disp(consulta2);
    disp(contador);
    %save(filename,'histogramaAux', 'Im', '-ascii')
    %datos1 = table (i, Im, 'VariableNames' , { 'nombreimagen' 'idimagen'});
    %datos2 = table (i,i, histogramaAux(1,1),histogramaAux(1,2),histogramaAux(1,3),histogramaAux(1,4),histogramaAux(1,5),histogramaAux(1,6),histogramaAux(1,7),histogramaAux(1,8),histogramaAux(1,9),histogramaAux(1,10),'VariableNames' , { 'idhistograma' 'idimagen' 'h11' 'h12' 'h13' 'h14' 'h15' 'h16' 'h17' 'h18' 'h19' 'h110'});
    
    %sqlwrite(conn, 'nombres', datos1);
    %sqlwrite(conn, 'histograma', datos2);
    
    %exec(conn, 'Insert into nombres (nombreimagen, idimagen) values(Im, i)'); 
    
    %exec(conn,consulta1);
    
    
    %exec(conn, 'Insert into histograma (nombreimagen, idimagen) values(Im, i)'); 
    
    cantGuardado=cantGuardado + 1;
    
    
end 