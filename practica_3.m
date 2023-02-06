%Pedir el nombre del fichero con la imagen del motivo principal y del fichero con la
%imagen del nuevo fondo. Utilizar las imágenes im13.jpg a im20.jpg. 

flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen 1 entre comillas dobles:');
    if(exist(A, 'file') == 0)
        disp('No se encuentra la imagen introducida');
    else
        img=imread(A);
        img_A=im2double(img);
        [M,N,C]=size(img_A);
        if C<3
            disp('La imagen debe estar a color');
        else
            flag=1;
        end
    end
end

flag = 0;
while(flag == 0)
    A = input('Introduce el nombre de la imagen 2 entre comillas dobles:');
    if(exist(A, 'file') == 0)
        disp('No se encuentra la imagen introducida');
    else
        img=imread(A);
        img_B=im2double(img);
        [M,N,C]=size(img_B);
        if C<3
            disp('La imagen debe estar a color');
        else
            flag=1;
        end
    end
end

 figure, subplot(1,2,1),imshow(img_A), title("Imagen objeto");
 subplot(1,2,2),imshow(img_B), title("Imagen fondo");
 disp('Pulsa INTRO para continuar...');
 pause();

%Calcular el canal alfa o mascarilla utilizando la técnica de distancia de color.
figure, [M,N,C]=size(img_A);
[x,y,P] = impixel(img_A);

imbin = zeros(M, N);

for i=1:M
    for j=1:N
        dist = abs(img_A(i,j,1) - P(1)) + abs(img_A(i,j,2) - P(2)) + abs(img_A(i,j,3) - P(3));      
        imbin(i,j) = dist;
    end
end

mascara2 = imbinarize(imbin, 0.3);
figure, subplot(1,2,1), imshow(imbin), title("Imagen sin binarizar");
subplot(1,2,2), imshow(mascara2), title("Mascara 2");

disp('Pulsa INTRO para continuar...');
pause();

%Mostrar en una misma ventana el primer plano y el fondo multiplicados por sus
%respectivos canales alfa, así como la composición final. 
mascarainversa = not(mascara2);

imgAmasc = mascara2.*img_A;
imgBmasc = mascarainversa.*img_B;
figure, subplot(2,2,1), imshow(imgAmasc), title("OBJETO");
subplot(2,2,2), imshow(imgBmasc), title("FONDO");

imgfinal = imgAmasc + imgBmasc;
figure, subplot(1,1,1), imshow(imgfinal), title("Imagen final");

disp('Pulsa INTRO para continuar...');
pause();
%Hacer lo mismo pero con diferencia de color

R = img_A(:,:,1); 
G = img_A(:,:,2);
B = img_A(:,:,3);

Mn = G - max(R,B); 

m1 = imbinarize(Mn, 0.01);
figure, imshow(m1), title("Máscara de recorte");
disp('Pulsa INTRO para continuar...');
pause();

m1inv = not(m1);
figure, imshow(m1inv), title("Máscara inversa");
disp('Pulsa INTRO para continuar...');
pause();

pepe = m1inv.*img_A + m1.*img_B;
figure, imshow(pepe), title("Imagen final");

disp('Pulsa INTRO para continuar...');
pause();
