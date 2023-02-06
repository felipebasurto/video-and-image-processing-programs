%Escribir en un fichero llamado “practica_8.m” un script para la lectura y 
%procesado de un archivo de vídeo. El programa debe cumplir las siguientes 
%características:

%Pedir por teclado el nombre del archivo de vídeo con el que se desea trabajar.
A = uigetfile('*.*');
info = mmfileinfo (A);
vid = VideoReader(A);

%Mostrar las propiedades relacionadas con el archivo de vídeo.
disp(info);
disp('-------------------------------------------------');
disp(info.Video)
disp('-------------------------------------------------');

%Crear un archivo de escritura de vídeo y fijar su velocidad de 
%reproducción a 24 fps.
obj = VideoWriter(A,'MPEG-4');
set(obj,'FrameRate',24)
get(obj);
disp('-------------------------------------------------');
open(obj);

%Leer y procesar cada frame del archivo de vídeo original 
%aplicando un mapa de color.
m = colormap(jet(256));
tic;
while hasFrame(vid)
    frame = readFrame(vid);
    gris = rgb2gray(frame);
    cmap = ind2rgb(gris,m);
    writeVideo(obj,cmap);
end
toc;
disp('-------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pause();
disp('El número real de frames es: ');
disp(vid.NumFrames/vid.Duration);
close(obj);