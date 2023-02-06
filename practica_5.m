%Pedir por teclado el nombre de una imagen con la que se desea trabajar. Utilizar la
%imagen im12.jpg

flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen:', 's');
    if(exist(A, 'file') == 0)
        disp('No se encuentra la imagen introducida');
    else
        img=imread(A);
        img_A=im2double(img);
        [M,N,C]=size(img_A);
        if C<3
            disp('La imagen debe estar en escala de grises');
        else
            flag=1;
        end
    end
end

%Realizar un proceso de segmentación para la detección de objetos.
figure, imshow(img_A), title("Imagen Original");
pause();

img_bin = im2bw(img_A, 0.8);

img_bin_inv = 1 - img_bin;
im_fill = imfill(img_bin_inv);

figure, imshow(im_fill), title("Imagen Binaria");
pause();

%Visualizar los objetos detectados con su correspondiente rectángulo de área mínima y
%enumerarlos utilizando la función text
[L, num] = bwlabel(im_fill);
rprop = regionprops(L, 'Centroid');
rect = regionprops(L,'BoundingBox');

figure,imshow(img_A),title("Objetos identificados y numerados");

for k = 1 : num 
    thisBB = rect(k).BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'LineWidth', 3, 'EdgeColor','b' );
    text(rprop(k).Centroid(1),rprop(k).Centroid(2),int2str(k));
end

pause();

%Utilizando la función stem, representar el factor de forma y la textura de
%cada objeto.
im_gris = rgb2gray(img_A);
rpropA = regionprops(L, 'Area');
rpropP = regionprops(L, 'Perimeter');
form_factor = zeros(1,num);
E = zeros(1,num);
pValues = regionprops(L,im_gris,'PixelValues');

for i = 1 : num
    form_factor(1,i) = (4*pi*rpropA(i).Area)/(rpropP(i).Perimeter)^2;
    E(1,i) = entropy(pValues(i).PixelValues);
end

figure, stem(form_factor), title("Factor de forma");
figure, stem(E), title("Textura");

pause();

%Utilizando la función plot (ver figura 0.7) representar cada objeto en una gráfica cuyo
%eje horizontal represente el factor de forma y el eje vertical represente la textura. 
figure, plot(form_factor, E, 'o'), title("Gráfico del factor de forma y la textura de todos los objetos");
pause();

%Señalar en la imagen original únicamente los elementos que correspondan a objetos
%reales.
figure,imshow(img_A),title("Objetos reales identificados");

for j = 1 : num 
    if(E(1,j) > 2)
        thisBB = rect(j).BoundingBox;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'LineWidth', 3, 'EdgeColor','b' );
    end
end
