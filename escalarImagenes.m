function cant=escalarImagenes()
dirBin = 'D:\Escritorio\ffmpeg-20190429-ac551c5-win64-static\ffmpeg-20190429-ac551c5-win64-static\bin\';
%comando = strcat(dirBin, '\ffmpeg.exe -i input.jpg -vf scale=320:240 output_320x240.png');
cant=0;
srcDir = 'D:\Escritorio\disminuyendo\';
list_dir=dir(fullfile(srcDir,'*.bmp'));
nombres={list_dir.name};
[m,n] = size (nombres); %m=1, n=cantidad  de imagenes
for i=1:n
    comando = [dirBin, 'ffmpeg.exe -i', ' ', srcDir, char(nombres(i)),' ','-y -vf scale=100:-1,hue=s=0 -sws_flags bicubic', ' ', '"D:\Escritorio\imagenes esqueletizadas mini\',char(nombres(i)),'"'];
    system(comando);
    cant= cant+1;
    disp(int2str(cant));
end   
end 