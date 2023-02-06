flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen entre comillas dobles:');
    if(exist(A, 'file') == 0)
        disp("No se encuentra la imagen introducida");
    else
        img=imread(A);
        img_A=im2double(img);
        [M,N,C]=size(img_A);
        if C>1
            disp('La imagen debe estar en escala de grises');
        else
            flag=1;
        end
    end
end

%Cargar la imagen en MATLAB y mostrarla en una ventana junto a su 
%histograma
subplot(2,2,1), imshow(img_A), title('Imagen original');
subplot(2,2,2), imhist(img_A), title('Histograma');
disp('Pulsa ENTER para avanzar');
pause();

%Aumentar o disminuir el brillo de la imagen original a petición del 
%usuario y mostrar en la misma ventana la imagen resultante y su histograma
brillo = 2;
while(brillo > 1 || brillo < -1)
    brillo = input('Introduce el brillo que quieres ponerle a la imagen (numero entre el -1 y el 1):');
    foto_brillo = img_A + brillo;
end
subplot(2,2,3), imshow(foto_brillo), title('Foto con el brillo indicado');
subplot(2,2,4), imhist(foto_brillo), title('Histograma');
disp('Pulsa ENTER para avanzar');
pause();

%Ecualizar la imagen y mostrar en la misma ventana la imagen resultante y 
%su histograma
disp('Imagen ecualizada');
J = histeq(img_A);
figure, subplot(2,2,1), imshow(J), title('Imagen Ecualizada');
subplot(2,2,2), imhist(J), title('Histograma');
disp('Pulsa ENTER para avanzar');
pause();

%Eliminar de la imagen píxeles cuya intensidad sea menor que un determinado
%valor escogido por el usuario y mostrar el resultado.
pixel = input('Introduce la intensidad minima de los pixeles a mostrar [0-1]:');
impix = img_A;
for i=1:size(img_A,1)
    for j=1:size(img_A,2)
        if impix(i,j) < pixel
            impix(i,j)=0;
        end
    end
end

subplot(2,2,3), imshow(impix), title('Imagen con los píxeles seleccionados');
disp('Pulsa ENTER para avanzar');
pause();

%Suavizar la imagen utilizando un suavizado de media y un suavizado 
%gaussiano, solicitando al usuario los parámetros necesarios. 

media = input('Introduce el parámetro para el suavizado de media:');
filtro_media = fspecial('average', [media media]);
foto_media = imfilter(img_A, filtro_media);
figure, subplot(2,1,1), imshow(foto_media), title('Suavizado de media');
sigma = input('Introduce el valor de sigma:');
gauss = 6 * sigma + 1;
filtro_gauss = fspecial('gaussian', [gauss gauss], sigma);
foto_gauss = imfilter(img_A, filtro_gauss);
subplot(2,1,2), imshow(foto_gauss), title('Suavizado Gaussiano');
disp('Pulsa ENTER para avanzar');
pause();

%Calcular el gradiente de la imagen y visualizar el módulo y sus dos componentes. 
disp('Gradiente de la imagen');
Hx = fspecial('prewitt');
Hy = Hx';
Gx = imfilter(img_A,Hx);
Gy = imfilter(img_A,Hy);
G = abs(Gx) + abs(Gy);

figure, subplot(1,3,1), imshow(Gx), title('Gradiente X');
subplot(1,3,2), imshow(Gy), title('Gradiente Y');
subplot(1,3,3), imshow(G), title('Gradiente completo');
disp('Pulsa ENTER para avanzar');
pause();

%Realzar la imagen original utilizando el gradiente y el laplaciano.
disp('Realzar imagen');
foto_realzada_grad = img_A + 0.5*G;
H = fspecial('laplacian', 0.2);
L = imfilter(img_A, H);
foto_realzada_lap = img_A - L;

figure, subplot(1,2,1), imshow(foto_realzada_grad), title('Foto realzada con gradiente');
subplot(1,2,2), imshow(foto_realzada_lap), title('Foto realzada con laplaciano');
disp('Pulsa ENTER para avanzar');
pause();

%Cargar la imagen im4.jpg. Utilizando la función plot, representar los valores
%correspondientes a la fila central del gradiente de la imagen. 
disp('Cargando imagen 4');
img_4 = imread("im4.jpg");
img_A_4=im2double(img_4);

Hx_4 = fspecial('prewitt');
Hy_4 = Hx_4';
Gx_4 = imfilter(img_A_4,Hx_4);
Gy_4 = imfilter(img_A_4,Hy_4);
G_4 = abs(Gx_4) + abs(Gy_4);
foto_realzada_grad_4 = img_A_4 + (0.5*G_4);
[M,N,C]=size(img_A_4);
central = round(M/2);


figure, subplot(2,2,1), imshow(img_A_4), title('Imagen original');
subplot(2,2,2), imshow(G_4), title('Gradiente');
subplot(2,2,3), plot(G_4(central, :)), title('Línea central');
disp('Pulsa ENTER para avanzar');
pause();


%La imagen im4.jpg es una captura de una cinta transportadora con botellas. En la imagen
%se han capturado 90 cm de dicha cinta. Utilizando la información proporcionada por el
%gradiente, ¿cuál es la separación aproximada entre cada botella? ¿Cuál es el ancho
%aproximado de cada botella? 
contador = 0;
[M,N,C]=size(G_4);
disp(N);

for i=1:size(G_4,1)  
    if G_4(central, i) == 0
    contador= contador+1;
    end
end
anchura = (round((M-contador)/4));
disp ('Anchura de cada botella en píxeles');
disp (anchura);
disp ('Anchura de cada botella en centímetros');
disp(anchura * 90 / M);