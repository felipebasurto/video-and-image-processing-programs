%Seleccionar un dispositivo entre todos los disponibles. 

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
 
%Abrir una ventana de previsualización.
preview(cam);
pause();

%Capturar una secuencia de al menos 200 imágenes
n=input('¿Cuántas imágenes quieres capturar? ');
ts=zeros(1,n);
for k=1:n
    [frame, t] = snapshot(cam);
    ts(k)=t;
end

%Utilizando la función stem, representar en la misma ventana el instante de tiempo en que
%ha sido capturada cada imagen y la diferencia de tiempo entre cada captura. 
figure,stem(ts);

tdif=zeros(1,n-1);

for k=2:n
   tdif(k)=(ts(k)-ts(k-1));
end

figure,stem(tdif);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Tiempo de procesamiento');
disp(ts(n));
tadq = n/(ts(n)-ts(1));
disp('Tasa de adquisición');
disp(tadq);
