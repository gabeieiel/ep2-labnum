function [] = testa(original_image, k, h)
    compress(original_image, k);
    decompress("comprimida.png",1,k,h);
    printf("calculando erro metodo 1\n");
    erro1 = calculateError(original_image,"saida.png");
    printf("calculando erro metodo 2\n");
    decompress("comprimida.png",2,k,h);
    erro2 = calculateError(original_image,"saida.png");
    printf("Erro metodo 1:%d\nErro metodo 2:%d\n",erro1,erro2);
endfunction
