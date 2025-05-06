function [] = gera_zoologico(p)
    zoo = zeros(p, p, 3, 'uint8');

    for i = 1:p
        for j = 1:p
            %zoo(j, i, 1) = uint8( (sin(i) + 1) * 127.5 );  % Canal R
            %zoo(j, i, 2) = uint8( ((sin(i)+sin(j))/2 + 1) * 127.5 );  % Canal G
            %zoo(j, i, 3) = uint8( (sin(j) + 1) * 127.5 );  % Canal B
            
            zoo(j, i, 1) = j*2;
            zoo(j, i, 2) = (j+i)*2;
            zoo(j, i, 3) = i*2;
        endfor
    endfor

    imshow(zoo);
    imwrite(zoo, "zoo2.png");
endfunction