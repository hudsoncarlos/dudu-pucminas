Program ComponentesExemplo;
Uses ComponentesInterfaceTexto;

Var
    Distancia: real;
    Tempo: real;
    FatorV: real;
    Velocidade: real;
    CatetoA: real;
    CatetoB: real;
    FatorH: real;
    Hipotenusa: real;
    I: byte;
    Ordem: byte = 0;
    CodErro: byte;
    TelaInicial: Fundo;
    TelaSobre: Fundo;
    QuadVelocidade: Quadro;
    QuadUnidadeV: Quadro;
    QuadPitagoras: Quadro;
		QuadUnidadeH: Quadro;
    CampDistancia: Campo;
    CampTempo: Campo;
    CampVelocidade: Campo;
    CampCatetoA: Campo;
    CampCatetoB: Campo;
		CampHipotenusa: Campo;
		BotTipoCalculo: array[0..2] of BotaoOpcao;
		BotUnidadeV: array[0..2] of BotaoOpcao;
		BotUnidadeH: array[0..2] of BotaoOpcao;
		ListTipoCalculo: ListBotOpc;
		ListUnidadeV: ListBotOpc;
		ListUnidadeH: ListBotOpc;
		BotMenu: array[0..3] of Botao;
		BotOk: Botao;
		ListMenu: ListBotao;	  

    StrFundo: array[0..1] of string[28] = (
		    'Exemplo de Componentes Texto',
				'Sobre o Programa');
		StrQuadro: array[0..3] of string[20] = (
		    'Velocidade Média',
				'Teorema de Pitágoras',
				'Unidade de v',
				'Unidade de H');
    StrBotaoOpcao: array[0..2] of string[19] = (
		    'Calcular Velocidade',
				'Calcular Hipotenusa',
				'Calcular Ambos');
    StrBotao: array[0..4] of string[8] = (
		    'Calcular',
				'Limpar',
				'Sobre...',
				'Sair',
				'OK');
    StrUnidade: array[0..5] of string[4] = (
		    'm/s',
				'km/h',
				'Mph',
				'm',
				'cm',
				'in');

Procedure habilitaCalculo(I: byte);
Begin
    if(I <> 1) then
    begin
        habilitaCampo(@CampDistancia);
        habilitaCampo(@CampTempo);
        habilitaCampo(@CampVelocidade);
        habilitaBotaoOpcao(@BotUnidadeV[0]);
        habilitaBotaoOpcao(@BotUnidadeV[1]);
        habilitaBotaoOpcao(@BotUnidadeV[2]);
        textcolor(BLACK);
    end
    else begin
        desabilitaCampo(@CampDistancia);
        desabilitaCampo(@CampTempo);
        desabilitaCampo(@CampVelocidade);
        desabilitaBotaoOpcao(@BotUnidadeV[0]);
        desabilitaBotaoOpcao(@BotUnidadeV[1]);
        desabilitaBotaoOpcao(@BotUnidadeV[2]);
        textcolor(DARKGRAY);
    end;

    gotoxy(32, 5);
    write('Distância:');
    gotoxy(32, 6);
    write('Tempo:');
    gotoxy(32, 7);
    write('Velocidade:');
    gotoxy(55, 5);
    write('m'+#8+#10+'s');

    if(I <> 0) then
    begin
        habilitaCampo(@CampCatetoA);
        habilitaCampo(@CampCatetoB);
        habilitaCampo(@CampHipotenusa);
        habilitaBotaoOpcao(@BotUnidadeH[0]);
        habilitaBotaoOpcao(@BotUnidadeH[1]);
        habilitaBotaoOpcao(@BotUnidadeH[2]);
        textcolor(BLACK);
    end
    else begin
        desabilitaCampo(@CampCatetoA);
        desabilitaCampo(@CampCatetoB);
        desabilitaCampo(@CampHipotenusa);
        desabilitaBotaoOpcao(@BotUnidadeH[0]);
        desabilitaBotaoOpcao(@BotUnidadeH[1]);
        desabilitaBotaoOpcao(@BotUnidadeH[2]);
        textcolor(DARKGRAY);
    end;

    gotoxy(32, 12);
    write('Cateto a:');
    gotoxy(32, 13);
    write('Cateto b:');
    gotoxy(32, 14);
    write('Hipotenusa:');
    gotoxy(55, 12);
    write('m'+#8+#10+'m');
End;

Begin
    TelaInicial := novoFundo(BLUE, @StrFundo[0]);
    TelaSobre := novoFundo(BLUE, @StrFundo[1]);

		BotTipoCalculo[0] := novoBotaoOpcao(2, 4, true, true, @StrBotaoOpcao[0], habilitaCalculo);
    BotTipoCalculo[1] := novoBotaoOpcao(2, 5, false, true, @StrBotaoOpcao[1], habilitaCalculo);
    BotTipoCalculo[2] := novoBotaoOpcao(2, 6, false, true, @StrBotaoOpcao[2], habilitaCalculo);
    ListTipoCalculo := novaListBotOpc(0, 3, 3, @BotTipoCalculo[0]);

    QuadVelocidade := novoQuadro(30, 3, 25, 4, @StrQuadro[0]);
    QuadPitagoras := novoQuadro(30, 10, 25, 4, @StrQuadro[1]);
    QuadUnidadeV := novoQuadro(58, 3, 20, 4, @StrQuadro[2]);
    QuadUnidadeH := novoQuadro(58, 10, 20, 4, @StrQuadro[3]);

    CampDistancia := novoCampo(44, 5, 8, 10, true);
    CampTempo := novoCampo(44, 6, 8, 10, true);
		CampVelocidade := novoCampo(44, 7, 8, 10, true);
    CampCatetoA := novoCampo(44, 12, 8, 10, false);
    CampCatetoB := novoCampo(44, 13, 8, 10, false);
    CampHipotenusa := novoCampo(44, 14, 8, 10, false);

    BotUnidadeV[0] := novoBotaoOpcao(60, 5, true, true, @StrUnidade[0], nil);
    BotUnidadeV[1] := novoBotaoOpcao(60, 6, false, true, @StrUnidade[1], nil);
    BotUnidadeV[2] := novoBotaoOpcao(60, 7, false, true, @StrUnidade[2], nil);
    ListUnidadeV := novaListBotOpc(0, 3, 3, @BotUnidadeV[0]);

		BotUnidadeH[0] := novoBotaoOpcao(60, 12, true, false, @StrUnidade[3], nil);
    BotUnidadeH[1] := novoBotaoOpcao(60, 13, false, false, @StrUnidade[4], nil);
    BotUnidadeH[2] := novoBotaoOpcao(60, 14, false, false, @StrUnidade[5], nil);
    ListUnidadeH := novaListBotOpc(0, 3, 3, @BotUnidadeH[0]);

		BotMenu[0] := novoBotao(26, 20, 12, 2, @StrBotao[0], nil);
    BotMenu[1] := novoBotao(42, 20, 12, 1, @StrBotao[1], nil);
    BotMenu[2] := novoBotao(26, 23, 12, 1, @StrBotao[2], nil);
    BotMenu[3] := novoBotao(42, 23, 12, 1, @StrBotao[3], nil);
    BotOk := novoBotao(35, 22, 10, 2, @StrBotao[4], nil);
    ListMenu := novaListBotao(0, 2, 4, @BotMenu[0]);

   {-------------------------------------------------
    while para o retorno à tela inicial.
    -------------------------------------------------}
    while(true) do
    begin
        desenhaFundo(@TelaInicial);
        desenhaListBotOpc(@ListTipoCalculo);
        desenhaQuadro(@QuadVelocidade);
        desenhaQuadro(@QuadUnidadeV);
        desenhaQuadro(@QuadPitagoras);
        desenhaQuadro(@QuadUnidadeH);

		    if(ListTipoCalculo.I <> 1) then
				    textcolor(BLACK)
				else
				    textcolor(DARKGRAY);
		    gotoxy(32, 5);
        write('Distância:');
        gotoxy(32, 6);
        write('Tempo:');
        gotoxy(32, 7);
        write('Velocidade:');
        gotoxy(55, 5);
        write('m'+#8+#10+'s');

		    desenhaCampo(@CampDistancia);
        desenhaCampo(@CampTempo);
        desenhaCampo(@CampVelocidade);
        desenhaListBotOpc(@ListUnidadeV);

		    if(ListTipoCalculo.I <> 0) then
				    textcolor(BLACK)
				else
				    textcolor(DARKGRAY);
		    gotoxy(32, 12);
        write('Cateto a:');
        gotoxy(32, 13);
        write('Cateto b:');
        gotoxy(32, 14);
        write('Hipotenusa:');
        gotoxy(55, 12);
        write('m'+#8+#10+'m');

		    desenhaCampo(@CampCatetoA);
        desenhaCampo(@CampCatetoB);
        desenhaCampo(@CampHipotenusa);
        desenhaListBotOpc(@ListUnidadeH);
        desenhaListBotao(@ListMenu);

       {-------------------------------------------------
        while para retorno aos componentes da tela inici-
        al. O componente selecionado dependerá do valor
        da variável Ordem.
        -------------------------------------------------}
				while(true) do
        begin
        
           {-------------------------------------------------
            while para retorno ao primeiro componente após o
						usuário apertar a tecla <TABLE> com o cursor no
						botão 'Sair'.
            -------------------------------------------------}
            while(true) do
            begin
                if(Ordem = 0) then
                begin
										selecionaListBotOpc(@ListTipoCalculo);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 1) then
                begin
										digitaCampo(@CampDistancia);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 2) then
                begin
										digitaCampo(@CampTempo);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 3) then
                begin
										selecionaListBotOpc(@ListUnidadeV);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 4) then
                begin
										digitaCampo(@CampCatetoA);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 5) then
                begin
										digitaCampo(@CampCatetoB);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 6) then
                begin
										selecionaListBotOpc(@ListUnidadeH);
                    if(Tecla = #13) then
                        break;
                end;

                if(Ordem <= 7) then
                begin
										selecionaListBotao(@ListMenu);
                    if(Tecla = #13) then
                        break;
                end;

                Ordem := 0;
            end;

            I := ListMenu.I;
				    pressionaBotao(@BotMenu[I]);

				    case(I) of
				        0:
				        begin
				            desenhaBotao(@BotMenu[I]);

										if(ListTipoCalculo.I <> 1) then
				            begin
				                val(CampDistancia.Conteudo^, Distancia, CodErro);
				                if(CodErro <> 0) then
				                begin
				                    Ordem := 1;
				                    write(#7);
                            continue;
				                end;

				                val(CampTempo.Conteudo^, Tempo, CodErro);
				                if((CodErro <> 0) or (Tempo <= 0)) then
				                begin
				                    Ordem := 2;
				                    write(#7);
                            continue;
				                end;
				            end;

				            if(ListTipoCalculo.I <> 0) then
				            begin
				                val(CampCatetoA.Conteudo^, CatetoA, CodErro);
				                if((CodErro <> 0) or (CatetoA <= 0)) then
				                begin
				                    Ordem := 4;
				                    write(#7);
                            continue;
				                end;

				                val(CampCatetoB.Conteudo^, CatetoB, CodErro);
				                if((CodErro <> 0) or (CatetoB <= 0)) then
				                begin
				                    Ordem := 5;
				                    write(#7);
                            continue;
                        end;
				            end;
				            
				            if(ListTipoCalculo.I <> 1) then
				            begin
				                case(ListUnidadeV.I) of
				                    0: FatorV := 1;
				                    1: FatorV := 3.6;
				                    2: FatorV := 2.236936292054402;
				                end;
												Velocidade := FatorV * (Distancia / Tempo);
				                str(Velocidade, CampVelocidade.Conteudo^);
				                desenhaCampo(@CampVelocidade);
				            end;

				            if(ListTipoCalculo.I <> 0) then
				            begin
				                case(ListUnidadeH.I) of
				                    0: FatorH := 1;
				                    1: FatorH := 100;
				                    2: FatorH := 39.37007874015748;
				                end;
												Hipotenusa := FatorH * sqrt( sqr(CatetoA) + sqr(CatetoB) );
                        str(Hipotenusa, CampHipotenusa.Conteudo^);
                        desenhaCampo(@CampHipotenusa);
				            end;

				            Ordem := 7;
				            continue;
				        end;

				        1:
				        begin
				            limpaCampo(@CampDistancia);
				            limpaCampo(@CampTempo);
				            limpaCampo(@CampVelocidade);
				            limpaCampo(@CampCatetoA);
				            limpaCampo(@CampCatetoB);
				            limpaCampo(@CampHipotenusa);
				            Ordem := 7;
				            break;
				        end;

				        2:
				        begin
				            desenhaFundo(@TelaSobre);
				            gotoxy(1, 3);
								    textbackground(LIGHTGRAY);
								    textcolor(BLACK);
								    write(#9+#9+'   Interface em Texto Pzim - versão 1.2'+#13+#10+#10+
								          #9+#9+'   Autor   : Alexandre Moreira Versiani'+#13+#10+
				                  #9+#9+'   Contato : alexandre-versiani@hotmail.com'+#13+#10+#10+
				                  #9+'---------------------------------------------------------------'+#13+#10+#10);
				            write(#9+'   Este programa tem como principal objetivo apresentar uma in-'+#13+#10+
								          #9+'terface de usuário baseada em texto, semelhante a uma interface'+#13+#10+
													#9+'gráfica, com elementos interativos visíveis na tela, como botõ-'+#13+#10);
										write(#9+'es, listas, campos etc. Tomou-se como referência a interface do'+#13+#10+
													#9+'Microsoft Word 6.0 para MS-DOS, com algumas diferenças.');

				            desenhaBotao(@BotOk);
								    gotoxy(40, 23);

                    while(true) do
                    begin
                        Tecla := readkey;
                        if(Tecla = #13) then
                        begin
            		            pressionaBotao(@BotOk);
                            break;
                        end;
                        if(Tecla = #27) then
                            break;
                    end;

								    Ordem := 7;
										break;
				        end;

				        else
				        begin
				           {-------------------------------------------------
                    Libera memória antes do programa encerrar.
                    -------------------------------------------------}
				            liberaMemCampo(@CampDistancia);
				            liberaMemCampo(@CampTempo);
				            liberaMemCampo(@CampVelocidade);
				            liberaMemCampo(@CampCatetoA);
				            liberaMemCampo(@CampCatetoB);
				            liberaMemCampo(@CampHipotenusa);
				            exit;
				        end;
				    end;
				end;
    end;
End.
