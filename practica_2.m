flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen entre comillas dobles:');
    if(exist(A, 'file') == 0)
        disp('No se encuentra la imagen introducida');
    else
        img=imread(A);
        img_A=im2double(img);
        [M,N,C]=size(img_A);
        figure, subplot(1,1,1), imshow(img_A);
        if C<3
            disp('La imagen debe estar a color');
        else
            flag=1;
        end
    end
end
 disp('Pulsa INTRO para continuar...');
 pause();

%Mostrar cada canal R, G y B junto con su histograma
canalR = img_A(:,:,1); 
canalG = img_A(:,:,2);
canalB = img_A(:,:,3);

figure, subplot(3,3,1), imshow(canalR), title('Canal ROJO');
subplot(3,3,2), imshow(canalG), title('Canal VERDE');
subplot(3,3,3), imshow(canalB), title('Canal AZUL');
subplot(3,3,4), imhist(canalR);
subplot(3,3,5), imhist(canalG);
subplot(3,3,6), imhist(canalB);

disp('Pulsa INTRO para continuar...');
pause();

%Convertir la imagen original al espacio HSV y mostrar cada canal junto con su
%histograma
foto_HSV = rgb2hsv(img_A);
canalH_HSV = foto_HSV(:,:,1); 
canalS_HSV = foto_HSV(:,:,2);
canalV_HSV = foto_HSV(:,:,3);


figure, subplot(3,3,1), imshow(canalH_HSV), title('Canal TONO');
subplot(3,3,2), imshow(canalS_HSV), title('Canal SATURACIÓN');
subplot(3,3,3), imshow(canalV_HSV), title('Canal BRILLO');
subplot(3,3,4), imhist(canalH_HSV);
subplot(3,3,5), imhist(canalS_HSV);
subplot(3,3,6), imhist(canalV_HSV);

disp('Pulsa INTRO para continuar...');
pause();
%Convertir la imagen original al espacio YCbCr y mostrar cada canal junto con su
%histograma
foto_ycbcr = rgb2ycbcr(img_A);
canalY_ycbcr = foto_ycbcr(:,:,1); 
canalCB_ycbcr = foto_ycbcr(:,:,2);
canalCR_ycbcr = foto_ycbcr(:,:,3);


figure, subplot(3,3,1), imshow(canalY_ycbcr), title('Canal Y');
subplot(3,3,2), imshow(canalCB_ycbcr), title('Canal CB');
subplot(3,3,3), imshow(canalCR_ycbcr), title('Canal CR');
subplot(3,3,4), imhist(canalY_ycbcr);
subplot(3,3,5), imhist(canalCB_ycbcr);
subplot(3,3,6), imhist(canalCR_ycbcr);

disp('Pulsa INTRO para continuar...');
pause();

%Utilizando la función impixel, seleccionar un color de la imagen y modificarla para
%que solo aparezca dicho color y el resto en escala de grises
figure, subplot(1,1,1), [x,y,P] = impixel(img_A);
if (isempty(x) && isempty(y) && isempty(P))
    X = [1,1];
    y = [1,1];
end

color = foto_HSV(y(1),x(1),1);
rango = [color-0.1, color +0.1];

if rango(1)< 0
    rango (1) = 1 + rango(1);
end

if rango(2) >= 1
    rango(2) = rango(2) -1;
end

H=foto_HSV(:,:,1);

% Obtenemos la máscara para dejar sólo el tono de color seleccionado
if (rango(1) < rango(2))
    masc_H = (H > rango(1) & H < rango(2));
else
    masc_H = (H > rango(1) | H < rango(2));
end

H = H .* masc_H;

S = foto_HSV(:,:,2);

% Aplicamos la máscara obtenida para dejar el resto en escala de grises
S = S .* masc_H;

foto_HSV(:,:,1) = H;
foto_HSV(:,:,2) = S;

IMG_TONO = hsv2rgb(foto_HSV);

figure, imshow(IMG_TONO), title('Imagen de un único tono');

disp('Pulse una tecla para continuar.')
pause()






%Cargar una imagen en escala de grises (imágenes im1.jpg a im6.jpg) 
flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen entre comillas dobles:');
    if(exist(A, 'file') == 0)
        disp('No se encuentra la imagen introducida');
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

%Convertir a color la imagen cargada utilizando un mapa de color definido con la función
%colormap. El usuario debe poder escoger el mapa de color. Visualizar la imagen
%coloreada junto a la barra de color correspondiente
color = input('Escribe entre comillas el numero de colores a aplicar: ');
mapa=input('0 - JET   1 - HOT   2 - COOL   3 - COPPER   4 - PINK   5 - HSV: ');
switch(mapa)
    case 0 
figure, subplot(1,1,1), imshow(img_A);
m = colormap(jet(color));
colorbar;
    case 1
figure, subplot(1,1,1), imshow(img_A);
m = colormap(hot(color));
colorbar;
    case 2
figure, subplot(1,1,1), imshow(img_A);
m = colormap(cool(color));
colorbar;
    case 3
figure, subplot(1,1,1), imshow(img_A);
m = colormap(copper(color));
colorbar;
    case 4
figure, subplot(1,1,1), imshow(img_A);
m = colormap(pink(color));
colorbar;
    case 5
figure, subplot(1,1,1), imshow(img_A);
m = colormap(hsv(color));
colorbar;
end

disp('Pulsa INTRO para continuar...');
pause();

%Convertir nuevamente la imagen en escala de grises en otra imagen en color 
%utilizando ahora el espacio de color HSV. Seleccionar el tono y la saturación 
%a partir de la rueda de color mostrada en la imagen ‘colorWheel.png’.

B = "colorWheel.png";
cw=imread(B);
[x,y,P] = impixel(cw);
cwhsv = rgb2hsv(cw);

canal_h2 = cwhsv(y,x,1);
canal_s2 = cwhsv(y,x,2);

[M,N,X] = size(img_A);

im2h = ones(M,N) * canal_h2;
im2s = ones(M,N) * canal_s2;

imfinal = cat(3, im2h, im2s, img_A);

imfinalrgb = hsv2rgb(imfinal);

imshow(imfinal);

disp('Pulsa INTRO para continuar...');
pause();

%Cargar la imagen im10.jpg. Sabiendo que la imagen representa una superficie aproximada
%de 4800 mm2, ¿cuál podría ser el diámetro de la moneda? 

C = "im10.jpg";
im10=imread(C);
contador = 0;

im10gris = rgb2gray(im10);
[M,N,C] = size(im10gris);
central = round(N/2);

for i=1:N
    disp(i);
    if(im10gris(central, i) < 250)
        contador = contador + 1;
    end
end

disp('El diametro de la moneda es');
disp(contador/2);