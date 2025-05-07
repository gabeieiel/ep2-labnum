function [] = decompress(compressed_image, method, k, h)
    cmp_img = imread(compressed_image);
    [cmp_a, cmp_l, c] = size(cmp_img);

    n = cmp_a; % como imagem e quadrada, cmp_a = cmp_l
    p = n + (n-1)*k; % (k+1)(n-1)+1
    decmp_img = zeros(p, p, c, 'uint8');

    B = zeros(4, 4, 'single');

    if (method == 1)
        B(:, 1) = 1;
        B(2, 3) = h;
        B(3, 2) = h;
        B(4, 2) = h;
        B(4, 3) = h;
        B(4, 4) = h*h;

        M = zeros(4, 1, c); %Matriz(vetor coluna) que guarda os valores avaliados para calculo de A(vetor colunas dos coef.)
    endif

    if (method == 2) 
        % matrizes que guardam valor das derivadas para facil implementacao e calculo
        dx = zeros(p, p, c, 'single');
        dy = zeros(p, p, c, 'single');
        dxdy = zeros(p, p, c, 'single');

        %PRIMEIRAS DERIVADAS
        for i = 2:n-1 
            for j = 2:n-1
                dx(i, j, :) = (cmp_img(i, j+1) - cmp_img(i, j-1))/(2*h);
                dy(i, j, :) = (cmp_img(i+1, j) - cmp_img(i-1, j))/(2*h);
            endfor
        endfor
        %   casos de borda
        for t = 1:n
            dx(t, 1, :) = (cmp_img(t, 2, :) - cmp_img(t, 1, :))/h;
            dx(t, n, :) = (cmp_img(t, n, :) - cmp_img(t, n-1, :))/h;

            dy(1, t, :) = (cmp_img(2, t, :) - cmp_img(1, t, :))/h;
            dy(n, t, :) = (cmp_img(n, t, :) - cmp_img(n-1, t, :))/h;
        endfor

        %DERIVADAS PARCIAIS
        for i = 2:n-1 
            for j = 1:n
                dxdy(i, j, :) = (dy(i+1, j, :) - dy(i-1, j, :))/(2*h);
            endfor
        endfor
        %   casos de borda
        for t = 1:n
            dxdy(1, t, :) = (dy(2, t, :) - dy(1, t, :))/h;
            dxdy(n, t, :) = (dy(n, t, :) - dy(n-1, t, :))/h;
        endfor

        B(1,1) = 1;
        B(2,1) = 1;
        B(2,2) = h;
        B(2,3) = h*h;
        B(2,4) = h*h*h;
        B(3,2) = 1;
        B(4,2) = 1;
        B(4,3) = 2*h;
        B(4,4) = 3*h*h;

        M = zeros(4, 4); %Matriz que guarda os valores avaliados para calculo de A(matriz dos coef.)
    endif

    B_inv = inv(B);

    % Calculo dos coeficientes polinomiais e interpolacao
    % (I, J): indices em decmp_img || (i, j): indices em cmp_img
    for i = 0:n-2 
        for j = 0:n-2
            % Iterando sobre os (xi, yi), cantos inferiores esquerdos dos quadrados 
            if (method == 1)
                for ch = 1:c % Para cada canal
                    M(1, 1) = cmp_img(i+1, j+1, ch);
                    M(2, 1) = cmp_img(i+1, j+2, ch);
                    M(3, 1) = cmp_img(i+2, j+1, ch);
                    M(4, 1) = cmp_img(i+2, j+2, ch);

                    A = B_inv * M;
                    % Iterando sobre os pixels do quadrado, inclui todas as arestas
                    for di = 0:k+1
                        for dj = 0:k+1
                            decmp_img(1+(k+1)*i+di, 1+(k+1)*j+dj, ch) = A(1,1) + A(2,1)*di + A(3,1)*dj + A(4,1)*di*dj;
                        endfor
                    endfor

                endfor 
            endif
            
            if (method == 2)
                for ch = 1:c % Para cada canal
                    M(1, 1) = cmp_img(i+1, j+1, ch);
                    M(2, 1) = cmp_img(i+2, j+1, ch);
                    M(1, 2) = cmp_img(i+1, j+2, ch);
                    M(2, 2) = cmp_img(i+2, j+2, ch);
                    
                    M(3, 1) = dx(i+1, j+1, ch);
                    M(4, 1) = dx(i+2, j+1, ch);
                    M(3, 2) = dx(i+1, j+2, ch);
                    M(4, 2) = dx(i+2, j+2, ch);

                    M(1, 3) = dy(i+1, j+1, ch);
                    M(2, 3) = dy(i+2, j+1, ch);
                    M(1, 4) = dy(i+1, j+2, ch);
                    M(2, 4) = dy(i+2, j+2, ch);

                    M(3, 3) = dxdy(i+1, j+1, ch);
                    M(4, 3) = dxdy(i+2, j+1, ch);
                    M(3, 4) = dxdy(i+1, j+2, ch);
                    M(4, 4) = dxdy(i+2, j+2, ch);

                    A = B_inv * M * (B_inv);
                    % Iterando sobre os pixels do quadrado, inclui todas as arestas
                    for di = 0:k+1
                        for dj = 0:k+1
                            v_x = [1, di, di*di, di*di*di];
                            v_y = [1; dj; dj*dj; dj*dj*dj];
                            decmp_img(1+(k+1)*i+di, 1+(k+1)*j+dj, ch) = v_x * A * v_y;
                        endfor
                    endfor

                endfor 
            endif 
        endfor
    endfor

    imwrite(decmp_img, "saida.png");

endfunction
