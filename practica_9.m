%Crear el objeto de vídeo.
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

 

%Pedir el factor de aceleración deseado. 
acc = input('Introduce el factor de aceleracion: ');

 

%Pedir el tiempo de captura deseado (en segundos). 
tcapt = input('Introduce el tiempo de captura(en segundos): ');

 

%Calcular y mostrar la velocidad de captura necesaria (en fps). 
obj = VideoWriter('rapido');
set(obj,'FrameRate',24);
open(obj);
cam = webcam(dID);
preview(cam);
pause();
vel = 24/acc;
periodo = 1/vel;
taskstoexecute = vel*tcapt;
disp('FrameRate del vídeo');
disp(vel);



tm = timer('Period', periodo , 'TasksToExecute', taskstoexecute, 'ExecutionMode', 'fixedRate', 'timerFcn', {@miFuncion, cam, obj});
start(tm);
wait(tm);
delete(tm);

close(obj);
delete(cam);
 
function miFuncion(tm, event, cam, obj)
    [frame,t] = snapshot(cam);
    writeVideo(obj,frame);
end
 