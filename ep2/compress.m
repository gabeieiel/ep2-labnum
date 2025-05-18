%Guilherme Kuhlkamp Gulka | NUSP: 15456984
%Gabriel Ferreira dos Santos Esteves | NUSP: 15453240
%EP2

function [] = compress(original_image, k)
    orig = imread(original_image);
    [a, l, c] = size(orig); %orig deve ser quadrada, logo a = l

    p = a;
    n = (p+k)/(k+1);
    comp = zeros(n, n, c, 'uint8'); %zeros(altura, largura, canais, unsigned_int);

    for i = 0:n-1
        for j = 0:n-1
            comp(i+1, j+1, :) = orig(((k+1)*i)+1, ((k+1)*j)+1, :);
        endfor
    endfor

    imwrite(comp, "comprimida.png");
endfunction