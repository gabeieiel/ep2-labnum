function [] = testa_p7(original_image, h)
    compress(original_image, 7);

    printf("Descomprimindo 1 vez com k = 7\n");
    printf("calculando erro metodo 1\n");
    decompress("comprimida.png",1,7,h);
    erro1 = calculateError(original_image,"saida1.png");

    printf("calculando erro metodo 2\n");
    decompress("comprimida.png",2,7,h);
    erro2 = calculateError(original_image,"saida2.png");

    printf("Erro metodo 1:%d\nErro metodo 2:%d\n",erro1,erro2);



    printf("Descomprimindo 3 vezes com k = 1\n");
    printf("calculando erro metodo 1\n");
    decompress("comprimida.png",1,1,h);
    decompress("saida1.png",1,1,h);
    decompress("saida1.png",1,1,h);
    erro1 = calculateError(original_image,"saida1.png");

    printf("calculando erro metodo 2\n");
    decompress("comprimida.png",2,1,h);
    decompress("saida2.png",2,1,h);
    decompress("saida2.png",2,1,h);
    erro2 = calculateError(original_image,"saida2.png");

    printf("Erro metodo 1:%d\nErro metodo 2:%d\n",erro1,erro2);
endfunction