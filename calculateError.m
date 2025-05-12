function erro_calculado = calculateError(originalImg, decompressedImg)

    og      =   double(imread(originalImg));
    dcp     =   double(imread(decompressedImg));

    
    [linhas, cols, canais] = size(og);    % dimensões

    
    p           =   linhas;     % lado do quadrado da imagem
    erro_aux    =   0;

    for k = 1:canais

        somatorio   =   0;
        err_canal   =   0;

        for i = 1:linhas

            for j = 1:cols
            
            somatorio = somatorio + (og(i, j, k) - dcp(i, j, k))^2;      % somatório dos erros das duas imagens
            
            endfor

        endfor


        err_canal = sqrt((1/p^2)*somatorio);

        erro_aux = erro_aux + err_canal;

    endfor


    erro_calculado = erro_aux/canais;

endfunction 