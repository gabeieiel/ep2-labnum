function [] = gera_zoologico(p, h, x0, y0);
    zoo = zeros(p, p, 3, 'uint8');

    for i = 1:p
        for j = 1:p
            zoo(i, j, 1) = uint8( (sin(x0+h*(i-1)) + 1) * 127.5 );  % Canal R
            zoo(i, j, 2) = uint8( ((sin(x0+h*(i-1))+sin(y0+h*(j-1)))/2 + 1) * 127.5 );  % Canal G
            zoo(i, j, 3) = uint8( (sin(y0+h*(j-1)) + 1) * 127.5 );  % Canal B
            
            %zoo(j, i, 1) = j*2;
            %zoo(j, i, 2) = (j+i);
            %zoo(j, i, 3) = i*2;
        endfor
    endfor

    imshow(zoo);
    imwrite(zoo, "zoo.png");
endfunction