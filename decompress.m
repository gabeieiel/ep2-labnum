function [] = decompress(compressed_image, method, k, h)
    cmp_img = imread(compressed_image);
    [cmp_a, cmp_l, c] = size(cmp_img);

    n = cmp_a; % como imagem e quadrada, cmp_a = cmp_l
    p = n + (n-1)*k; % (k+1)(n-1)+1
    decmp_img = zeros(p, p, c, 'uint8');
    hIk = h/(k+1);

    B = zeros(4, 4, 'single');

    if (method == 1)
        B = [1 0 0 0;
             1 0 h 0;
             1 h 0 0;
             1 h h h^2];

        M = zeros(4, 1); %Matriz(vetor coluna) que guarda os valores avaliados para calculo de A(vetor colunas dos coef.)
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

        B = [1 0 0 0;
             1 h h^2 h^3;
             0 1 0 0;
             0 1 2*h 3*h^2];

        M = zeros(4, 4); %Matriz que guarda os valores avaliados para calculo de A(matriz dos coef.)
    endif

    B_inv = inv(B);

    for i = 0:n-2 
        for j = 0:n-2
            % Iterando sobre os (i, j), cantos inferiores esquerdos dos quadrados 
            if (method == 1)
                for ch = 1:c % Para cada canal
                    M(1, 1) = cmp_img(i+1, j+1, ch);
                    M(2, 1) = cmp_img(i+1, j+2, ch);
                    M(3, 1) = cmp_img(i+2, j+1, ch);
                    M(4, 1) = cmp_img(i+2, j+2, ch);

                    A = B \ M; %Resolve o sistema B*A = M
                    % Iterando sobre os pixels do quadrado, inclui todas as arestas
                    for I = 0:k+1
                        for J = 0:k+1
                            decmp_img(1+(k+1)*i+I, 1+(k+1)*j+J, ch) = A(1,1) + A(2,1)*I*hIk + A(3,1)*J*hIk + A(4,1)*I*J*(hIk^2);
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
                    
                    A = (B \ M) / B'; %Resolve o sistema B*A*B' = M
                    % Iterando sobre os pixels do quadrado, inclui todas as arestas
                    for I = 0:k+1
                        for J = 0:k+1
                            v_x = [1, I*hIk, (I*hIk)^2, (I*hIk)^3];
                            v_y = [1; J*hIk; (J*hIk)^2; (J*hIk)^3];
                            decmp_img(1+(k+1)*i+I, 1+(k+1)*j+J, ch) = v_x * A * v_y;
                        endfor
                    endfor

                endfor 
            endif 
        endfor
    endfor

    if (method == 1)
        imwrite(decmp_img, "saida1.png");
    else
        imwrite(decmp_img, "saida2.png");
    endif

endfunction