%Seleccionar el dispositivo de captura.
clear;
disp('Dispositivos detectados:')
info = webcamlist;
nDEV = size(info,1);
for i = 1:nDEV
 nombre = info{i};
 disp(['[' num2str(i) '] ' nombre])
end
dID = input('> Selecciona dispositivo: [1]? ');
if(isempty(dID))
 dID = 1;
end

%Crear un menú de opciones para escoger la resolución de la imagen capturada.
cam = webcam(dID);
disp('Elige una resolucion: ');
disp(cam.AvailableResolutions);
num=input('1 2 3 4 5 6: ');
Resolution = cam.AvailableResolutions(num);
[resol, t] = snapshot(cam);
[Mr,Nr,Cr]=size(resol);
 
%Abrir una ventana de previsualización.
preview(cam);
get(cam);

pause();

%Cargar la imagen de fondo
flag = 0;

while(flag == 0)
    A = uigetfile('*.*');
    img=imread(A);
    img_A=im2double(img);
    [M,N,C]=size(img_A);
    if C>3
        disp('La imagen debe estar en color');
    else
        flag=1;
    end
end

im_Ar = imresize(img_A,[Mr, Nr]);        
disp(size(im_Ar));
pause();

%Pedir el número de imágenes que se van a capturar
n=input('¿Cuántas imágenes quieres capturar? ');
%Capturar una imagen con el fondo a eliminar
[cr_frame,cr_t] = snapshot(cam);
cr_frame_d = im2double(cr_frame);
frame1gray = rgb2gray(cr_frame_d);

se = strel('disk',20);

obj = VideoWriter(A,'MPEG-4');
set(obj,'FrameRate',24)
disp('-------------------------------------------------');
open(obj);


%Procesar cada frame para obtener el efecto de chroma
for k=1:n
    [frame2, t] = snapshot(cam);
    frame_d = im2double(frame2);
    frame2gray = rgb2gray(frame_d);
    imfinal = abs(frame1gray - frame2gray);
    finalbin = imbinarize(imfinal, 0.08);
    imc = imclose(finalbin,se);
    alpha = imfill(imc,'holes');
    finalinv = 1-alpha;
    fondo = finalinv .* im_Ar + frame_d .* alpha;
    writeVideo(obj,mat2gray(fondo));
    subplot(1,2,1),imshow(frame_d),title('Imagen original');
    subplot(1,2,2),imshow(fondo),title('Imagen procesada');
    drawnow;
end
    figure,imshow(finalinv);
    drawnow;
    
close(obj);