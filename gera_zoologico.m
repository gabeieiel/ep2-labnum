function [] = gera_zoologico(p, h, greyscale); % consideraremos x0, y0 = 0, logo xi, yi = h*i
    zoo = zeros(p, p, 3, 'uint8');

    for i = 0:p-1
        for j = 0:p-1
            %Funcao 1 (C2)
            %zoo(i+1, j+1, 1) = uint8( (sin(h*i) + 1) * 127.5 );  % Canal R
            %zoo(i+1, j+1, 2) = uint8( ((sin(h*i)+sin(h*j)/2 + 1) * 127.5 ));  % Canal G
            %zoo(i+1, j+1, 3) = uint8( (sin(h*j) + 1) * 127.5 );  % Canal B
            
            %Funcao 2 (C2) % se rodar com h = 5 da pra entender a funcao, mas com h = 1 fica mais legal
            zoo(i+1, j+1, 1) = 255 -((h*i-p*h/2)^2 +(h*j-p*h/2)^2)/100;
            zoo(i+1, j+1, 2) = 127 +h*i -h*j;
            zoo(i+1, j+1, 3) = 127 +h*j -((h*i-p*h/2)^2)/100;

            %Funcao 3 (Nao C2)
            %zoo(i+1, j+1, 1) = mod(h*i*5,255);
            %zoo(i+1, j+1, 2) = mod(h*i*j,255);
            %zoo(i+1, j+1, 3) = mod(h*j*5,255);

            %Funcao 4 (Nao C2)
            %zoo(i+1, j+1, 1) = 10000/(h*i-p*h/2)^2;
            %zoo(i+1, j+1, 2) = (h*(i+j)/2-p*h/2)^2;
            %zoo(i+1, j+1, 3) = 10000/(h*j-p*h/2)^2;
        endfor
    endfor
    if (greyscale == 1)
        zoog = rgb2gray(zoo);
        imshow(zoog);
        imwrite(zoog, "zoo.png");
    else
        imshow(zoo);
        imwrite(zoo, "zoo.png");
    endif

endfunction