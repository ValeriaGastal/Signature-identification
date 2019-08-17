function cantImagen= pasarBMP(directorio)
tipo= '*.png'
nombres=get_list_files(directorio,tipo); %retorna solo los nombres
[m,n] = size (nombres); %m=1, n=15
cantImagen=0;
for t = 1:n
    I=nombres(t);
    cadena=strcat(directorio,I);
    Im=imread(char(cadena));
    %Im=imresize(Im,0.05);
    %Im=Imm(1:100:end,1:100:end,1:100:end);
    Im_u =uint8(Im);
    level=graythresh(Im_u);
    BW=im2bw(Im_u,level);
    directorio_salida= 'D:\Escritorio\Imagenes esqueletizadas en BMP';
    newName=strcat('imagenn',int2str(t),'.bmp');
    newFile = fullfile (directorio_salida, newName);
    imwrite(BW,newFile);
    cantImagen=cantImagen+1; %porque solo me almacena uno?
end;
%out (char(cantImagen));


    