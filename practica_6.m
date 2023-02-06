%Seleccionar un dispositivo entre todos los disponibles. En general, se puede crear un
%menú de opciones para facilitar la selección: 

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

cam = webcam(dID);
disp('Elige una resolucion: ');
disp(cam.AvailableResolutions);
num=input('1 2 3 4 5 6: ');
Resolution = cam.AvailableResolutions(num);

%Mostrar la información asociada al objeto de vídeo creado. 
disp(set(cam));

%Abrir una ventana de previsualización. 
preview(cam);

pause();
%Capturar dos imágenes utilizando la función snapshot. Mostrar las dos imágenes 
%capturadas. 

[frame1, t1]= snapshot(cam);
figure, imshow(frame1);

pause();
[frame2, t2]= snapshot(cam);
figure, imshow(frame2);

pause();

%Señalar con un rectángulo de área mínima los objetos desaparecidos. 
frame1gray = rgb2gray(frame1);
frame2gray = rgb2gray(frame2);
se = strel('disk',5);

imfinal = abs(frame1gray - frame2gray);
finalbin = imbinarize(imfinal, 0.01);
imc = imclose(finalbin,se);
finalinv = 1-imc;
figure, imshow(finalinv) ,title("Imagen inversa");
pause();

[L, num] = bwlabel(finalinv);
rprop = regionprops(L, 'Centroid');
rect = regionprops(L,'BoundingBox');

figure,imshow(frame1),title("Objetos identificados");

for k = 1 : num 
    thisBB = rect(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'LineWidth', 3, 'EdgeColor','b' );
end
