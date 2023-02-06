%Pedir por teclado el nombre de la imagen con la que se desea trabajar. Utilizar la imagen
%im6.jpg. 

flag = 0;
while(flag == 0)
    A = uigetfile('*.*');
    img=imread(A);
    img_A=im2double(img);
    [M,N,C]=size(img_A);
    if C>1
        disp('La imagen debe estar en escala de grises');
    else
        flag=1;
    end
end
        
%Mostrar la imagen y su histograma. 
figure, subplot(1,2,1), imshow(img_A),title("Imagen Original");
subplot(1,2,2), imhist(img_A),title("Histograma");

disp('Pulsa INTRO para continuar...');
pause();

%Detectar los objetos presentes en la imagen utilizando la técnica de umbralización o bien
%la técnica de detección de contornos. 
img_bin = imbinarize(img_A, 0.5);
img_bin_inv = zeros(M, N);

for i=1:M
    for j=1:N
        img_bin_inv(i,j) = 1 - img_bin(i,j);
    end
end

img_er = bwareaopen(img_bin_inv, 200);

figure, imshow(img_er),title("Imagen Binaria");

disp('Pulsa INTRO para continuar...');
pause();

%Visualizar la matriz de etiquetas de los objetos detectados utilizando un mapa de color y
%su barra de color correspondiente. El número de colores utilizado en el mapa de color
%debe estar adecuado al número de objetos detectados. 
[L, num] = bwlabel(img_er);
img_L = mat2gray(L);
figure, imshow(img_L),title("Imagen Coloreada");
colormap(jet(num+1));

disp('Pulsa INTRO para continuar...');
pause();

%Señalar sobre la imagen original los objetos detectados con su correspondiente rectángulo
%de área mínima y enumerarlos utilizando la función text

rprop = regionprops(L, 'Centroid');
rect = regionprops(L,'BoundingBox');

figure,imshow(img_A),title("Pastillas identificadas y numeradas");


for k = 1 : num 
    thisBB = rect(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'LineWidth', 3, 'EdgeColor','b' );
    text(rprop(k).Centroid(1),rprop(k).Centroid(2),int2str(k));
end

disp('Pulsa INTRO para continuar...');
pause();

%Cargar la imagen en color im11.jpg. ¿Cuántas monedas aparecen en la imagen? Señalar cada moneda con su correspondiente rectángulo de área mínima.

img=imread("im11.jpg");
img_B=im2double(img);
[M,N,C]=size(img_B);

figure, subplot(1,2,1), imshow(img_B),title("Imagen Original");
subplot(1,2,2), imhist(img_B),title("Histograma");

disp('Pulsa INTRO para continuar...');
pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img_Bg=rgb2gray(img_B);
img_bin = imbinarize(img_Bg, 0.35);
se = strel('line', 10, 10);
img_er = bwareaopen(img_bin, 200);

figure, imshow(img_er),title("Imagen Binaria");

disp('Pulsa INTRO para continuar...');
pause();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[L, num] = bwlabel(img_er);
rprop = regionprops(L, 'Centroid');
centros = cat(1, rprop.Centroid);
rect = regionprops(L,'BoundingBox');

figure,imshow(img_B),title("Monedas identificadas y numeradas");


for k = 1 : num 
    thisBB = rect(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'LineWidth', 3, 'EdgeColor','b' );
    text(rprop(k).Centroid(1),rprop(k).Centroid(2),int2str(k));
end

