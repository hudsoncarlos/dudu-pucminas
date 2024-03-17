{ -------------------------------------------------------------
   Programa que implementa um jogo de aventura em mapa
   Operação Mapa - Dezembro de 2012
                                     
   Autor : GRSá
   Contato : gresendesa@gmail.com
   Versão: 1.0 - 26/12/2012
   
   Licença : GPL - General Public License               


   Nota: ESTE CÓDIGO É LIVRE E PODE SER REAPROVEITADO, MODIFICADO E APERFEIÇOADO
         DESDE DE QUE SE FAÇA AS DEVIDAS CITAÇÕES AO AUTOR ORIGINAL (GUILHERME R SÁ - G.R.SA).
         QUALQUER TRABALHO DERIVADO DESTE DEVE SER REDISTRUBUÍDO E DISPONIBILIZADO
         SOB OS MESMOS TERMOS DESTA LICENÇA. (VEJA DETALHES DA LICENÇA GPL)

 ------------------------------------------------------------- 
  
   Descrição
   
   O jogo baseia-se em movimento e interação de personagens em um mapa.
   O objetivo do jogo é capturar terroristas escondidos em locais do mapa
   e ao mesmo tempo administrar o perigo iminete de ataques de animais selvagens.
   O programa faz distição entre tipos de terrenos e gerencia o movimento dos elementos
   dinâmicos em suas peculiaridades.
  
 -------------------------------------------------------------}

Program OperacaoMapa;
uses CRT;

Const
QP = 1000; {Quantidade de personagens}
{STATUS DE TERRENO}
PASSAVEL = 0;
SOLIDO = 1;
SOBREPOSTO = 2;
LIQUIDO = 3;
DEPRESSAO = 16;

{STATUS DE PERSONAGENS}
PERSONAGEM_ALIADO = 4;
PERSONAGEM_ELEMENTO = 17;
PERSONAGEM_OPONENTE = 5;
PERSONAGEM_1 = 6; {SERPENTE}
PERSONAGEM_2 = 7; {MORCEGO}
PERSONAGEM_3 = 8; {ARANHA}                                                 
PERSONAGEM_4 = 9; {URSO POLAR}
PERSONAGEM_5 = 10; {TIGRE}
PERSONAGEM_6 = 11; {LOBO}
PERSONAGEM_7 = 12; {CROCODILO}
PERSONAGEM_8 = 13; {RENA}
PERSONAGEM_9 = 14; {PASSARO}
PERSONAGEM_10 = 15; {VESPA}

{CARACTERES PREDETERMINADOS}
PADRAO_OPACO = #219;
PADRAO_TRANSLUCIDO_1 = #177;
PADRAO_TRANSLUCIDO_2 = #176;
TRIANGULO = #30;
RETA = #179;
ASTERISCO = #42;
PONTO = #250;

 Var                       
 mapa : record {PERSONAGEM}
          matriz : array[1..500, 1..300, 1..4] of char ; {(1-4) carac - cor - corFundo - status}
          dC, dL : integer; {Dimensões do mapa} 
          rC, rL : integer; {Referência de localização}
        end;

 tela : record {TELA}
          matriz : array[1..79, 1..41, 1..3] of char ; {(1-3) carac - cor - corFundo}
          dC, dL : integer; {Dimensões da tela}
          pC, pL : integer; {Posição no prompt}
        end;
        
 pers : record {PERSONAGEM}
          matriz : array[1..QP, 1..3] of char; {(1-3) carac - cor - corFundo}
          status : array[1..QP, 1..10] of integer ; {(1-9) pC - pL - destC - destL - alvo - tipo - veloc - cont - vitalidade - dano}
          cache : array[1..QP, 1..6] of integer ; {(1-6) carac - cor - corFundo - status, pC, pL}
          quant : integer;
        end;       
 
 curs : record {CURSOR}
          carac : char;
          ativo, aMostra : boolean;
          pC, pL : integer;
          cor, cont, veloc : integer;
          foco : string;
        end;
 
 jogo : record {JOGO}
          velocidadePersAliado : integer;
          vitalidadePersAliado : integer;
          quantOponentesCapt : integer;
          oponenteReiniciado : boolean;
          quantPersOponentes : integer;
          passarSobreLiquido : boolean;
          cursorLimitado : boolean;
          movimentoAutomatico : boolean;
          pontuacao : integer;
          delayPadrao : integer;
          raioDePerseguicao : integer;
        end;
 	           
 aux : integer;
 	   	         
 {---------------------------------------------
         Gerencia a exibição de tela
  ---------------------------------------------}  
 Procedure ExibeTela (posCol, posLin : integer);
  Var
  col, lin : integer;
  Begin
    if ((posCol+tela.dC-1) <= mapa.dC) and
       ((posLin+tela.dL-1) <= mapa.dL) and
       (posCol > 0) and (posLin > 0)
    then
    begin   
      for col := 1 to tela.dC do
        for lin := 1 to tela.dL do
        begin
          if (mapa.matriz[posCol-1+col, posLin-1+lin, 1] <> tela.matriz[col, lin, 1]) or
		   (mapa.matriz[posCol-1+col, posLin-1+lin, 2] <> tela.matriz[col, lin, 2]) or
		   (mapa.matriz[posCol-1+col, posLin-1+lin, 3] <> tela.matriz[col, lin, 3]) then
          begin
            {Não escreve caso seja a mesma posição do cursor}
		  if not((col = curs.pC) and (lin = curs.pL) and (curs.ativo)) then
		  begin 
		    tela.matriz[col, lin, 1] := mapa.matriz[posCol-1+col, posLin-1+lin, 1];
              tela.matriz[col, lin, 2] := mapa.matriz[posCol-1+col, posLin-1+lin, 2];
              tela.matriz[col, lin, 3] := mapa.matriz[posCol-1+col, posLin-1+lin, 3];
              gotoxy(tela.pC-1+col, tela.pL-1+lin);
              textcolor(ord(tela.matriz[col, lin, 2])); 
		    textbackground(ord(tela.matriz[col, lin, 3]));
              write(tela.matriz[col, lin, 1]);
            end;
            textcolor(white) ; textbackground(black);
            gotoxy(80, 1)
          end;
        end ;
      {DESENHA O CURSOR O ALTERNANDO}
      if (curs.ativo) then
        if (curs.aMostra) then
        begin
          tela.matriz[curs.pC, curs.pL, 1] := curs.carac;
          tela.matriz[curs.pC, curs.pL, 2] := chr(curs.cor);
          tela.matriz[curs.pC, curs.pL, 3] := mapa.matriz[posCol-1+curs.pC, posLin-1+curs.pL, 3];
	     gotoxy(tela.pC-1+curs.pC, tela.pL-1+curs.pL);
	     textcolor(curs.cor);
	     textbackground(ord(mapa.matriz[posCol-1+curs.pC, posLin-1+curs.pL, 3]));
	     write(curs.carac);
	   end else
	   begin
	     tela.matriz[curs.pC, curs.pL, 1] := mapa.matriz[posCol-1+curs.pC, posLin-1+curs.pL, 1];
          tela.matriz[curs.pC, curs.pL, 2] := mapa.matriz[posCol-1+curs.pC, posLin-1+curs.pL, 2];
          tela.matriz[curs.pC, curs.pL, 3] := mapa.matriz[posCol-1+curs.pC, posLin-1+curs.pL, 3];
	     gotoxy(tela.pC-1+curs.pC, tela.pL-1+curs.pL);
	     textcolor(ord(tela.matriz[curs.pC, curs.pL, 2]));
	     textbackground(ord(tela.matriz[curs.pC, curs.pL, 3]));
	     write(tela.matriz[curs.pC, curs.pL, 1]);
	   end; 	   
	 gotoxy(80, 1); 
	 textcolor(white) ; textbackground(black);       
    end;  
 End;
 
 {---------------------------------------------
      Insere elemento na matriz principal
  ---------------------------------------------} 
 Procedure InsereElemento (carac : char;
                           cor, corFundo, status : integer;
                           pC, pL : integer);
  Begin
    if (pC <= mapa.dC) and (pL <= mapa.dL) and
       (pC > 0) and  (pL > 0) then
    begin
      mapa.matriz[pC, pL, 1] := carac;
      mapa.matriz[pC, pL, 2] := chr(cor);
      mapa.matriz[pC, pL, 3] := chr(corFundo);
      mapa.matriz[pC, pL, 4] := chr(status);
    end;	
 End;
 

 {---------------------------------------------
         Inicia um personagem
  ---------------------------------------------}   
 Procedure CriaPersonagem (carac : char;
                           cor, tipo, pC, pL, destC, destL, posMatriz : integer);
 Begin
   if (pC <= mapa.dC) and (pL <= mapa.dL) and
      (destC <= mapa.dC) and (destL <= mapa.dL) and
      (pC > 0) and (pL > 0) and
      (destC > 0) and (destL > 0) then
   begin
     if (posMatriz = pers.quant) and
	   (posMatriz < jogo.quantPersOponentes) then
	begin   
       inc(pers.quant);
       posMatriz := pers.quant;
     end;
     pers.matriz[posMatriz, 1] := carac;
     pers.matriz[posMatriz, 2] := chr(cor);
     pers.matriz[posMatriz, 3] := chr(tipo);
     pers.status[posMatriz, 1] := pC;
     pers.status[posMatriz, 2] := pL;
     pers.status[posMatriz, 3] := destC;
     pers.status[posMatriz, 4] := destL;
     pers.status[posMatriz, 5] := 0;
     pers.status[posMatriz, 6] := tipo;
     
     {DEFINE VELOCIDADE}
	case (tipo) of 
       PERSONAGEM_ALIADO: pers.status[posMatriz, 7] := jogo.velocidadePersAliado;
       PERSONAGEM_1: pers.status[posMatriz, 7] := 30;
       PERSONAGEM_2: pers.status[posMatriz, 7] := 10;
       PERSONAGEM_3: pers.status[posMatriz, 7] := 70;
       PERSONAGEM_4: pers.status[posMatriz, 7] := 70;
       PERSONAGEM_5: pers.status[posMatriz, 7] := 20;
       PERSONAGEM_6: pers.status[posMatriz, 7] := 10;
       PERSONAGEM_7: pers.status[posMatriz, 7] := 10;
       PERSONAGEM_8: pers.status[posMatriz, 7] := 20;
       PERSONAGEM_9: pers.status[posMatriz, 7] := 10;
       PERSONAGEM_10: pers.status[posMatriz, 7] := 5;
       PERSONAGEM_ELEMENTO: pers.status[posMatriz, 7] := 50;
       PERSONAGEM_OPONENTE: pers.status[posMatriz, 7] := 10;
     end;
	
	pers.status[posMatriz, 8] := random(pers.status[posMatriz, 7]);
	  
	{DEFINE VITALIDADE}
	case (tipo) of 
       PERSONAGEM_ALIADO: pers.status[posMatriz, 9] := jogo.vitalidadePersAliado;
       PERSONAGEM_1: pers.status[posMatriz, 9] := 200;
       PERSONAGEM_2: pers.status[posMatriz, 9] := 150;
       PERSONAGEM_3: pers.status[posMatriz, 9] := 100;
       PERSONAGEM_4: pers.status[posMatriz, 9] := 350;
       PERSONAGEM_5: pers.status[posMatriz, 9] := 300;
       PERSONAGEM_6: pers.status[posMatriz, 9] := 200;
       PERSONAGEM_7: pers.status[posMatriz, 9] := 500;
       PERSONAGEM_8: pers.status[posMatriz, 9] := 50;
       PERSONAGEM_9: pers.status[posMatriz, 9] := 50;
       PERSONAGEM_10: pers.status[posMatriz, 9] := 100;
       PERSONAGEM_ELEMENTO: pers.status[posMatriz, 9] := 1;
       PERSONAGEM_OPONENTE: pers.status[posMatriz, 9] := 1;
     end; 
	    
     {DEFINE PODER DE DANO}
	case (tipo) of 
       PERSONAGEM_ALIADO: pers.status[posMatriz, 10] := 10;
       PERSONAGEM_1: pers.status[posMatriz, 10] := 7;
       PERSONAGEM_2: pers.status[posMatriz, 10] := 7;
       PERSONAGEM_3: pers.status[posMatriz, 10] := 5;
       PERSONAGEM_4: pers.status[posMatriz, 10] := 25;
       PERSONAGEM_5: pers.status[posMatriz, 10] := 7;
       PERSONAGEM_6: pers.status[posMatriz, 10] := 5;
       PERSONAGEM_7: pers.status[posMatriz, 10] := 50;
       PERSONAGEM_8: pers.status[posMatriz, 10] := 0;
       PERSONAGEM_9: pers.status[posMatriz, 10] := 0;
       PERSONAGEM_10: pers.status[posMatriz, 10] := 2;
       PERSONAGEM_ELEMENTO: pers.status[posMatriz, 10] := 0;
       PERSONAGEM_OPONENTE: pers.status[posMatriz, 10] := 0;
     end; 
   end;
 End; 
 
 {---------------------------------------------
            Gerencia os personagens 
  ---------------------------------------------}  
 Procedure GerenciaPersonagem ;
 Var
 caracAux : char;
 contA, contB, contC, contD, coord, corAux, statusAux : integer;
 pCAux, pLAux : integer;
 destino, distDestino, dist : integer;
 
 Begin
   dist := jogo.raioDePerseguicao; {RAIO DE BUSCA DO PERSONAGEM ALVO}
    
   for contA := 1 to pers.quant do
   begin    
	{SEGUE O PERSONAGEM PRINCIPAL SE ELE ESTIVER POR PERTO}
	pCAux := pers.status[contA, 1] - pers.status[1, 1];
	pLAux := pers.status[contA, 2] - pers.status[1, 2];
	pCAux := abs(pCAux);
	pLAux := abs(pLAux);
	caracAux := chr(pers.cache[1, 1]); {ARMAZENA O CARACTERE EM CACHE DO PERSONAGEM PRINCIPAL}
	corAux := pers.cache[1, 2]; {ARMAZENA A COR DO CARACTERE EM CACHE DO PERSONAGEM PRINCIPAL}
	statusAux := pers.cache[1, 4]; {ARMAZENA O TIPO DE TERRENO DO PERSONAGEM PRINCIPAL}
	   
	if ((pCAux <= dist) and
	    (pLAux <= dist)) and
	    
	    ((pers.status[contA, 6] = PERSONAGEM_1) or
	     {(pers.status[contA, 6] = PERSONAGEM_2) or}
		(pers.status[contA, 6] = PERSONAGEM_3) or
		(pers.status[contA, 6] = PERSONAGEM_4) or
		(pers.status[contA, 6] = PERSONAGEM_5) or
		(pers.status[contA, 6] = PERSONAGEM_6) or
		(pers.status[contA, 6] = PERSONAGEM_7) or
		{(pers.status[contA, 6] = PERSONAGEM_8) or
		(pers.status[contA, 6] = PERSONAGEM_9) or}
		(pers.status[contA, 6] = PERSONAGEM_10) {or
		(pers.status[contA, 6] = PERSONAGEM_OPONENTE)}) and
	   
	    not((caracAux = PADRAO_OPACO) and  {NÃO SEGUE CASO ESTEJA NA SOMBRA DA ROCHA}
	    (corAux = black) and
	    (statusAux = SOBREPOSTO)) and
	    
	    not((caracAux = PADRAO_OPACO) and {NÃO SEGUE CASO ESTEJA NA ÁGUA E SEJA DIFERENTE DE CROCODILO}
	    (corAux = blue) and
	    (statusAux = LIQUIDO) and
	    (pers.status[contA, 6] <> PERSONAGEM_7)) and
	    
	    not((pers.status[contA, 6] = PERSONAGEM_5) and {NÃO SEGUE CASO SEJA TIGRE E O PERSONAGEM ESTEJA ATRÁS DE DE UMA ÁRVORE}
	      (((caracAux = TRIANGULO) and (corAux = lightgreen)) or 
	       ((caracAux = RETA) and (corAux = brown)))) then
	begin
	  pers.status[contA, 3] := pers.status[1, 1];
	  pers.status[contA, 4] := pers.status[1, 2];
	end;
	
	{VERIFICA SE O PERSONAGEM TEM ALGUM ALVO}
	if (pers.status[contA, 5] > 0) then 
     begin
       pers.status[contA, 3] := pers.status[pers.status[contA, 5], 1];
       pers.status[contA, 4] := pers.status[pers.status[contA, 5], 2];
     end;    
	
	{DIMINUI VITALIDADE CASO OPONENTE ESTEJA EM CONTATO}
	caracAux := chr(pers.cache[1, 1]); {ARMAZENA O CARACTERE EM CACHE DO PERSONAGEM PRINCIPAL}
	corAux := pers.cache[1, 2]; {ARMAZENA A COR DO CARACTERE EM CACHE DO PERSONAGEM PRINCIPAL}
	statusAux := pers.cache[1, 4]; {ARMAZENA O TIPO DE TERRENO DO PERSONAGEM PRINCIPAL}
	pCAux := pers.status[contA, 1];
	pLAux := pers.status[contA, 2];
	if (pers.status[contA, 6] = PERSONAGEM_ALIADO) then
	begin
       for contB := pCAux - 1 to pCAux + 1 do
       begin
         for contC := pLAux - 1 to pLAux + 1 do
         begin
           if (contB > 0) and (contB <= mapa.dC) and
              (contC > 0) and (contC <= mapa.dL) then
           begin
           
             if ((ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_1) or
		       (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_2) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_3) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_4) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_5) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_6) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_7) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_8) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_9) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_10) or
			  (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_ELEMENTO) or
		       (ord(mapa.matriz[contB, contC, 4]) = PERSONAGEM_OPONENTE)) then
		   begin
		     {LOCALIZA OPONENTE E DIMINUI SUA VITALIDADE}
		     for contD := 2 to jogo.quantPersOponentes do
               begin
                 if ((pers.status[contD, 1] = contB) and 
				 (pers.status[contD, 2] = contC)) then
			  break;    
               end;
               if ((pers.status[contD, 6] = PERSONAGEM_1) or
                   (pers.status[contD, 6] = PERSONAGEM_2) or
                   (pers.status[contD, 6] = PERSONAGEM_3) or
                   (pers.status[contD, 6] = PERSONAGEM_4) or
                   (pers.status[contD, 6] = PERSONAGEM_5) or
                   (pers.status[contD, 6] = PERSONAGEM_6) or
                   (pers.status[contD, 6] = PERSONAGEM_7) or
                   (pers.status[contD, 6] = PERSONAGEM_8) or
                   {(pers.status[contD, 6] = PERSONAGEM_9) or}
                   (pers.status[contD, 6] = PERSONAGEM_10) or
			    (pers.status[contD, 6] = PERSONAGEM_ELEMENTO) or
			    (pers.status[contD, 6] = PERSONAGEM_OPONENTE)) then
               begin
			  pers.status[contD, 9] := pers.status[contD, 9] - pers.status[contA, 10];  
               end;
               
               {DIMINUI VITALIDADE DE PERSONAGEM PRINCIPAL}
               if ((pers.status[contD, 6] = PERSONAGEM_1) or
                   (pers.status[contD, 6] = PERSONAGEM_2) or
                   (pers.status[contD, 6] = PERSONAGEM_3) or
                   (pers.status[contD, 6] = PERSONAGEM_4) or
                   (pers.status[contD, 6] = PERSONAGEM_5) or
                   (pers.status[contD, 6] = PERSONAGEM_6) or
                   (pers.status[contD, 6] = PERSONAGEM_7) or
                   {(pers.status[contD, 6] = PERSONAGEM_8) or}
                   {(pers.status[contD, 6] = PERSONAGEM_9) or}
                   (pers.status[contD, 6] = PERSONAGEM_10) {or
			    (pers.status[contD, 6] = PERSONAGEM_ELEMENTO)} or
			    (pers.status[contD, 6] = PERSONAGEM_OPONENTE)) then
               begin
			  if not((caracAux = PADRAO_OPACO) and  //NÃO DIMINUI CASO ESTEJA NA SOMBRA DA ROCHA
	                   (corAux = black) and
	                   (statusAux = SOBREPOSTO)) then
			  pers.status[contA, 9] := pers.status[contA, 9] - pers.status[contD, 10];  
               end;
               
               {AUMENTA VITALIDADE CASO SEJA LIFE}
               if (pers.status[contD, 6] = PERSONAGEM_ELEMENTO) or
			   (pers.status[contD, 6] = PERSONAGEM_OPONENTE) then
               begin
                 pers.status[contA, 9] := jogo.vitalidadePersAliado;
               end;
               
		   end;	  
           end;
         end;
       end;
     end;  

     {ZERA A VITALIDADE DO PERSONAGEM CASO ESTE ENTRE EM ALGUMA DEPRESSAO}
	if ((pers.status[contA, 6] = PERSONAGEM_ALIADO) and
	    (pers.cache[contA, 4] = DEPRESSAO)) then
	begin
	  pers.status[1, 9] := 0;
	end;    
	
	{REINICIA PERSONAGEM EM POSIÇÃO ALEATÓRIA CASO OS PONTOS DE VIDA ACABEM}		
	if (pers.status[contA, 9] <= 0) then
	begin
	 {ADICIONA À PONTUAÇÃO PONTOS DE VIDA DO ADVERSÁRIO}
	 if not(jogo.oponenteReiniciado) then
	 begin
	   case (pers.status[contA, 6]) of 
          PERSONAGEM_1: jogo.pontuacao := jogo.pontuacao + 200;
          PERSONAGEM_2: jogo.pontuacao := jogo.pontuacao + 150;
          PERSONAGEM_3: jogo.pontuacao := jogo.pontuacao + 100;
          PERSONAGEM_4: jogo.pontuacao := jogo.pontuacao + 350;
          PERSONAGEM_5: jogo.pontuacao := jogo.pontuacao + 200;
          PERSONAGEM_6: jogo.pontuacao := jogo.pontuacao + 200;
          PERSONAGEM_7: jogo.pontuacao := jogo.pontuacao + 500;
          PERSONAGEM_8: jogo.pontuacao := jogo.pontuacao + 50;
          PERSONAGEM_9: jogo.pontuacao := jogo.pontuacao + 50;
          PERSONAGEM_10: jogo.pontuacao := jogo.pontuacao + 100;
          PERSONAGEM_OPONENTE: jogo.pontuacao := jogo.pontuacao + 1000;
        end;
      end;
	  randomize;
	  repeat
	    pCAux := random(mapa.dC - 1) + 1; {DEFINE POSIÇÃO DA COLUNA}
         pLAux := random(mapa.dL - 1) + 1; {DEFINE POSIÇÃO DA LINHA}
       until ((ord(mapa.matriz[pCAux, pLAux, 4]) = PASSAVEL) and
			        (pers.status[contA, 6] <> PERSONAGEM_7)) or
			       ((ord(mapa.matriz[pCAux, pLAux, 4]) = LIQUIDO) and
						  (pers.status[contA, 6] = PERSONAGEM_7)) ;
	  case(pers.status[contA, 6]) of
	    PERSONAGEM_ALIADO: begin
	                        delay(2500);
	                        if (jogo.vitalidadePersAliado >= 1200) then
	                        jogo.vitalidadePersAliado := jogo.vitalidadePersAliado - 200;
	                        InsereElemento(chr(pers.cache[1, 1]),
		                                  pers.cache[1, 2],
					                   pers.cache[1, 3],
					                   pers.cache[1, 4],
					                   pers.status[1, 1],
					                   pers.status[1, 2]);
					                   
					    {ARMAZENA CACHE DA NOVA POSIÇÃO}                        
	                        pers.cache[1, 1] := ord(mapa.matriz[pCAux, pLAux, 1]); 
	                        pers.cache[1, 2] := ord(mapa.matriz[pCAux, pLAux, 2]);
	                        pers.cache[1, 3] := ord(mapa.matriz[pCAux, pLAux, 3]);
	                        pers.cache[1, 4] := ord(mapa.matriz[pCAux, pLAux, 4]);
	                        pers.cache[1, 5] := pCAux;
	                        pers.cache[1, 6] := pLAux;
					                   
					    CriaPersonagem(#2, yellow, PERSONAGEM_ALIADO, pCAux, pLAux, pCAux + 1, pLAux + 1, 1);                              
	            write(#7);
							            {CENTRALIZA O PERSONAGEM NA TELA}
		                   if (pers.status[1,1] > (tela.dC div 2) - 1) then
			              begin
			                if (pers.status[1,1] < mapa.dC - (tela.dC div 2) + 1) then		      
		                     mapa.rC := pers.status[1,1] - (tela.dC div 2) + 1
		                     else
		                     mapa.rC := mapa.dC - tela.dC + 1;
		                   end
			              else
		                   mapa.rC := 1; 
		       
		                   if (pers.status[1,2] > (tela.dL div 2) - 1) then
			              begin
			                if (pers.status[1,2] < mapa.dL - (tela.dL div 2) + 1) then		      
		                     mapa.rL := pers.status[1,2] - (tela.dL div 2) + 1
		                     else
		                     mapa.rL := mapa.dL - tela.dL + 1;  
			              end
			              else
		                   mapa.rL := 1;
		                   
		                   jogo.quantOponentesCapt := 0; {ZERA QUANTIDADE DE OPONENTES CAPTURADOS}
		                   jogo.pontuacao := 0; {ZERA PONTUAÇÃO}
					  end;
	    else begin 
			InsereElemento(chr(pers.cache[contA, 1]),
		                    pers.cache[contA, 2],
					     pers.cache[contA, 3],
					     pers.cache[contA, 4],         
					     pers.status[contA, 1],
					     pers.status[contA, 2]);
			{ARMAZENA CACHE DA NOVA POSIÇÃO}                        
	          pers.cache[contA, 1] := ord(mapa.matriz[pCAux, pLAux, 1]); 
	          pers.cache[contA, 2] := ord(mapa.matriz[pCAux, pLAux, 2]);
	          pers.cache[contA, 3] := ord(mapa.matriz[pCAux, pLAux, 3]);
	          pers.cache[contA, 4] := ord(mapa.matriz[pCAux, pLAux, 4]);
	          pers.cache[contA, 5] := pCAux;
	          pers.cache[contA, 6] := pLAux;
									   
	          CriaPersonagem(pers.matriz[contA, 1], ord(pers.matriz[contA, 2]), 
			               pers.status[contA, 6], pCAux, pLAux, pCAux, pLAux, contA);
			
			{INCREMENTA QUANTIDADE DE OPONENTES CAPTURADOS} 
			if(pers.status[contA, 6] = PERSONAGEM_OPONENTE) then
			begin
			  if not(jogo.oponenteReiniciado) then
			  inc(jogo.quantOponentesCapt) else
			  jogo.oponenteReiniciado := false;
			end;              
			 
		    end;			  			    
	  end;
     end; 
	
	
     {VERIFICA SE A POSIÇÃO DE ORIGEM É DIFERENTE DA POSIÇÃO DE DESTINO}
     if ((pers.status[contA, 1]) <> (pers.status[contA, 3])) or
	   ((pers.status[contA, 2]) <> (pers.status[contA, 4])) then
	begin    
       if (pers.status[contA, 8]) < (pers.status[contA, 7] + jogo.delayPadrao) then
       inc(pers.status[contA, 8])
       else
       begin
         pers.status[contA, 8] := 0; {ZERA O CONTADOR}
	    
	    {ENCAMINHA O PERSONAGEM ATÉ O DESTINO}			    
	    if pers.status[contA, 1] < pers.status[contA, 3] then
	    pCAux := pers.status[contA, 1] + 1
	    else
	    if pers.status[contA, 1] > pers.status[contA, 3] then 
	    pCAux := pers.status[contA, 1] - 1 
	    else
	    pCAux := pers.status[contA, 1];
	    
	    if pers.status[contA, 2] < pers.status[contA, 4] then
	    pLAux := pers.status[contA, 2] + 1
	    else
	    if pers.status[contA, 2] > pers.status[contA, 4] then 
	    pLAux := pers.status[contA, 2] - 1 
	    else
	    pLAux := pers.status[contA, 2];

	    {VERIFICA REGRAS PARA A MOVIMENTAÇÃO}
	    if ((pCAux <> 0) or (pLAux <> 0)) and 
	    
	       (((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) or
		   (mapa.matriz[pCAux, pLAux, 4] = chr(SOBREPOSTO))) and
			 (pers.status[contA, 6] <> PERSONAGEM_7)) or
		   
		  ((((jogo.passarSobreLiquido) and 
		     (mapa.matriz[pCAux, pLAux, 4] = chr(LIQUIDO))) or
		     (mapa.matriz[pCAux, pLAux, 4] = chr(DEPRESSAO))) and
		     (pers.status[contA, 6] = PERSONAGEM_ALIADO)) or 
		  
		  ((mapa.matriz[pCAux, pLAux, 4] = chr(LIQUIDO)) and
		   (pers.status[contA, 6] = PERSONAGEM_7)) or
		  
		  (((mapa.matriz[pCAux, pLAux, 4] = chr(LIQUIDO)) or
		    (mapa.matriz[pCAux, pLAux, 4] = chr(SOLIDO)) or
		    (mapa.matriz[pCAux, pLAux, 4] = chr(DEPRESSAO))) and
		   ((pers.status[contA, 6] = PERSONAGEM_2) or
		    (pers.status[contA, 6] = PERSONAGEM_9))) then
	    begin	
	      pers.status[contA, 1] := pCAux;
	      pers.status[contA, 2] := pLAux;
	      
	      {RECUPERA CACHE}
		 InsereElemento(chr(pers.cache[contA, 1]),
		                pers.cache[contA, 2],
					 pers.cache[contA, 3],
					 pers.cache[contA, 4],
					 pers.cache[contA, 5],
					 pers.cache[contA, 6]);
					 
		 {ARMAZENA CACHE}                        
	      pers.cache[contA, 1] := ord(mapa.matriz[pCAux, pLAux, 1]); 
	      pers.cache[contA, 2] := ord(mapa.matriz[pCAux, pLAux, 2]);
	      pers.cache[contA, 3] := ord(mapa.matriz[pCAux, pLAux, 3]);
	      pers.cache[contA, 4] := ord(mapa.matriz[pCAux, pLAux, 4]);
	      pers.cache[contA, 5] := pCAux;
	      pers.cache[contA, 6] := pLAux;
	      
	
	      if (mapa.matriz[pCAux, pLAux, 4] <> chr(SOBREPOSTO)) then
	      begin
	        {DESENHA O PERSONAGEM NA NOVA POSIÇÃO} 
	        InsereElemento(pers.matriz[contA, 1],
	                       ord(pers.matriz[contA, 2]),
				        pers.cache[contA, 3], {UTILIZA A COR DE FUNDO DO MAPA}
				        ord(pers.matriz[contA, 3]),
				        pers.status[contA, 1],
				        pers.status[contA, 2]);
		 end else
		 begin
		   {INSERE O PERSONAGEM NA FORMA DO CARACTERE ATUAL PARA
		    DAR A IMPRESSÃO QUE SE PASSA POR BAIXO} 
	        InsereElemento(chr(pers.cache[contA, 1]),
	                       pers.cache[contA, 2],
				        pers.cache[contA, 3], {UTILIZA A COR DE FUNDO DO MAPA}
				        ord(pers.matriz[contA, 3]),
				        pers.status[contA, 1],
				        pers.status[contA, 2]);
		 end;			   	     
	    end else
	    begin 
	      {NESTE CASO O PERSONAGEM ENCONTRA-SE TRAVADO, PORTANTO SERÁ
	       DADO UM NOVO DESTINO A ELE}
	       //randomize;
	       if (contA > 1) and (pers.status[contA, 5] = 0) then
	       for coord := 3 to 4 do
            begin
		    distDestino := random(16);
		    case (random(2)) of  
                0: destino := pers.status[contA, coord] + distDestino;
                1: destino := pers.status[contA, coord] - distDestino;
              end;
              if (destino > 0) and 
			  (destino < mapa.dC) and 
		       (coord = 3) then
              pers.status[contA, coord] := destino;
              if (destino > 0) and 
			  (destino < mapa.dL) and 
			  (coord = 4) then
              pers.status[contA, coord] := destino;     
            end;
	    end;   
       end;
     end else
	begin
	  if (contA > 1) and (pers.status[contA, 5] = 0) then
	  for coord := 3 to 4 do
       begin
	    distDestino := random(16);
	    case (random(2)) of  
           0: destino := pers.status[contA, coord] + distDestino;
           1: destino := pers.status[contA, coord] - distDestino;
         end;
         if (destino > 0) and 
		  (destino < mapa.dC) and 
		  (coord = 3) then
         pers.status[contA, coord] := destino;
         if (destino > 0) and 
		  (destino < mapa.dL) and 
		  (coord = 4) then
         pers.status[contA, coord] := destino;      
       end;	   
	end;
	{ALTERA A VELOCIDADE CONFORME O TERRENO}
	if (pers.status[contA, 6]= PERSONAGEM_ALIADO) then
	begin
	  if (pers.cache[contA, 4] = LIQUIDO) then
	  pers.status[contA, 7] := jogo.velocidadePersAliado + 10; 
	
	  if (pers.cache[contA, 4] = SOBREPOSTO) then
	  pers.status[contA, 7] := jogo.velocidadePersAliado + 5;
	
	  if (pers.cache[contA, 4] = PASSAVEL) then
	  pers.status[contA, 7] := jogo.velocidadePersAliado;
	end;
   end;
 End; 

 {---------------------------------------------
         Gerencia definições do cursor
  ---------------------------------------------} 
 Procedure Gerenciacursor;
 Var
 caracAux : char;
 statAux, corAux : integer;
 Begin
   {REALIZA O GERENCIAMENTO DO CONTADOR DO CURSOR}
   if (curs.cont < curs.veloc) then
   begin
     inc(curs.cont);
   end else
   begin
     curs.cont := 0;
   end;
   
   {GERENCIA A VARIÁVEL RESPONSÁVEL POR INDICAR
    A ALTERNÂNCIA DO CURSOR}
   if(curs.cont = 0) then
   begin
     curs.aMostra := true;
   end else
   begin
     if(curs.cont = (curs.veloc div 2)) then
     begin
       curs.aMostra := false;
     end;
   end;
   
   {INDICA O TIPO DE CURSOR}
   
   statAux := ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 4]);
   
   case (ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 4])) of 
     PASSAVEL: begin
	            curs.carac := #24;
	            curs.cor := white;
	          end;    
     SOLIDO: begin
               curs.carac := 'X' ;
	          curs.cor := red;
	        end;
	SOBREPOSTO : begin
	               curs.carac := #24;
	               curs.cor := white;
	             end;
	PERSONAGEM_ALIADO : begin
	                     curs.carac := #24;
	                     curs.cor := white;
	                   end;
	LIQUIDO: begin
	            curs.carac := #24;
	            curs.cor := white;
	          end;
	DEPRESSAO: begin
	            curs.carac := #33;
	            curs.cor := yellow;
	          end; 		 			    		   	     
   end;
   
   if (statAux = PERSONAGEM_1) or
      (statAux = PERSONAGEM_2) or
      (statAux = PERSONAGEM_3) or
      (statAux = PERSONAGEM_4) or
      (statAux = PERSONAGEM_5) or
      (statAux = PERSONAGEM_6) or
      (statAux = PERSONAGEM_7) or
      (statAux = PERSONAGEM_10) or
	 (statAux = PERSONAGEM_OPONENTE) then
   begin
     curs.carac := #25;
	curs.cor := lightred;
   end else
   begin
     if (statAux = PERSONAGEM_8) or
        (statAux = PERSONAGEM_9) or
	   (statAux = PERSONAGEM_ELEMENTO) then
     begin
	  curs.carac := #25;
	  curs.cor := lightblue;   
     end;   
   end;   
   
   {INDICA O QUE ESTÁ SENDO APONTADO PELO CURSOR}
   caracAux := mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 1];
   corAux := ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 2]);
   
   if (caracAux = PADRAO_OPACO) and (statAux = PASSAVEL) and (corAux = green) then
   curs.foco := 'Grama';
   if (caracAux = PADRAO_OPACO) and (statAux = LIQUIDO) and (corAux = blue) then
   curs.foco := concat(#181, 'gua');
   if ((caracAux = #30) and (statAux = SOBREPOSTO) and (corAux = lightgreen)) or 
      ((caracAux = RETA) and (statAux = SOBREPOSTO) and (corAux = brown)) then
   curs.foco := concat(#181, 'rvore');
   if (caracAux = PADRAO_OPACO) and (statAux = SOLIDO) and (corAux = 7) then
   curs.foco := 'Rocha';
   if (caracAux = PADRAO_OPACO) and (statAux = SOBREPOSTO) and (corAux = 16) then
   curs.foco := 'Grama';
   if (caracAux = PADRAO_OPACO) and (statAux = DEPRESSAO) and (corAux = black) then
   curs.foco := concat('Depress', #198, 'o');
   if (caracAux = PADRAO_TRANSLUCIDO_1) and (statAux = PASSAVEL) then
   curs.foco := 'Grama';
   if (caracAux = PADRAO_TRANSLUCIDO_2) and (statAux = PASSAVEL) then
   curs.foco := 'Grama';
   if (caracAux = ASTERISCO) and (statAux = PASSAVEL) then
   curs.foco := 'Arbusto';
   if (caracAux = ASTERISCO) and (statAux = LIQUIDO) then
   curs.foco := 'Alga';
   if (caracAux = ASTERISCO) and (statAux = SOLIDO) then
   curs.foco := 'Arbusto';
   if (caracAux = ASTERISCO) and (statAux = SOBREPOSTO) then
   curs.foco := 'Arbusto';
   if (caracAux = PONTO) and (statAux = PASSAVEL) then
   curs.foco := 'Grama';
   if (caracAux = PONTO) and (statAux = SOLIDO) then
   curs.foco := 'Pedra';
   if (caracAux = PADRAO_OPACO) and (statAux = SOLIDO) and (corAux = black) then
   curs.foco := 'Rocha';
   if (caracAux = PADRAO_OPACO) and (statAux = SOLIDO) and (corAux = white) then
   curs.foco := 'Neve';
   if (caracAux = PADRAO_TRANSLUCIDO_1) and (statAux = SOLIDO) and (corAux = white) then
   curs.foco := 'Neve';
   if (caracAux = PADRAO_OPACO) and (statAux = SOBREPOSTO) and (corAux = black) then
   curs.foco := 'Esconderijo';
   
   if statAux = PERSONAGEM_ALIADO then
   curs.foco := concat('Voc', #136);
   if statAux = PERSONAGEM_OPONENTE then
   curs.foco := concat('Terrorista');
   if statAux = PERSONAGEM_1 then
   curs.foco := 'Serpente';
   if statAux = PERSONAGEM_2 then
   curs.foco := 'Morcego';
   if statAux = PERSONAGEM_3 then
   curs.foco := 'Aranha';
   if statAux = PERSONAGEM_4 then
   curs.foco := 'Urso';
   if statAux = PERSONAGEM_5 then
   curs.foco := 'Tigre';
   if statAux = PERSONAGEM_6 then
   curs.foco := 'Lobo';
   if statAux = PERSONAGEM_7 then
   curs.foco := 'Crocodilo';
   if statAux = PERSONAGEM_8 then
   curs.foco := 'Coelho';
   if statAux = PERSONAGEM_9 then
   curs.foco := concat('P', #160, 'ssaro');
   if statAux = PERSONAGEM_10 then
   curs.foco := 'Vespa';
   if statAux = PERSONAGEM_ELEMENTO then
   curs.foco := 'Vida';
   
 End;
 
 {---------------------------------------------
         Desenha um retângulo maciço
  ---------------------------------------------}
 Procedure DesenhaRetangulo(pC, pL,           
                            dC, dL, 
				        cor, corF : integer ;
					   carac : char);
 Var
 cont : integer; linha : string; 			    
 Begin
   textcolor(cor) ;
   textbackground(corF) ;
   for cont := 1 to dC do
	if (cont > 1) then
	linha := concat(linha, carac)
	else
	linha := carac;
   for cont := 1 to dL do
   begin
     gotoxy(pC, pL + cont - 1) ;
     write(linha);
   end;
 End;
 
 {---------------------------------------------
         Gerencia o painel lateral
  ---------------------------------------------}  
 Procedure GerenciaPainel ;
 Begin      

   gotoxy(tela.pC + tela.dC + 2, tela.pL + 1);
   textcolor(yellow); textbackground(3);
   write('OPERA', #128, #199, 'O MAPA');

   gotoxy(tela.pC + tela.dC + 4, tela.pL + 3);
   textcolor(lightgreen); textbackground(3);
   write('N');
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 5);
   textcolor(lightgreen); textbackground(3);
   write('O   L');
   gotoxy(tela.pC + tela.dC + 4, tela.pL + 7);
   textcolor(lightgreen); textbackground(3);
   write('S');
   
   textcolor(black); textbackground(3);
   gotoxy(tela.pC + tela.dC + 9, tela.pL + 4);
   write('Posi', #135, #198, 'o relativa');
   gotoxy(tela.pC + tela.dC + 10, tela.pL + 6);
   write('do  terrorista');
   
   if (pers.status[jogo.quantPersOponentes, 1] < pers.status[1, 1]) then {ALVO À ESQUERDA}
   begin
     gotoxy(tela.pC + tela.dC + 3, tela.pL + 5);
     textcolor(yellow); textbackground(3); write(#17);
   end else
   begin
     gotoxy(tela.pC + tela.dC + 3, tela.pL + 5);
     textcolor(3); textbackground(3); write(#17);
   end;
   if (pers.status[jogo.quantPersOponentes, 1] > pers.status[1, 1]) then {ALVO À DIREITA}
   begin
     gotoxy(tela.pC + tela.dC + 5, tela.pL + 5);
     textcolor(yellow); textbackground(3); write(#16);
   end else
   begin
     gotoxy(tela.pC + tela.dC + 5, tela.pL + 5);
     textcolor(3); textbackground(3); write(#17);
   end;
   
   
   if (pers.status[jogo.quantPersOponentes, 2] < pers.status[1, 2]) then {ALVO A FRENTE}
   begin
     gotoxy(tela.pC + tela.dC + 4, tela.pL + 4);
     textcolor(yellow); textbackground(3); write(#30);
   end else
   begin
     gotoxy(tela.pC + tela.dC + 4, tela.pL + 4);
     textcolor(3); textbackground(3); write(#30);
   end;
   if (pers.status[jogo.quantPersOponentes, 2] > pers.status[1, 2]) then {ALVO À TRÁS}
   begin
     gotoxy(tela.pC + tela.dC + 4, tela.pL + 6);
     textcolor(yellow); textbackground(3); write(#31);
   end else
   begin
     gotoxy(tela.pC + tela.dC + 4, tela.pL + 6);
     textcolor(3); textbackground(3); write(#31);
   end; 
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 9);
   textcolor(7); textbackground(3);
   write('P - Procurar outro');
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 11);
   textcolor(7); textbackground(3);
   write('R - Recome', #135, 'ar');                                                                               
  
   gotoxy(tela.pC + tela.dC + 2, tela.pL + tela.dL - 9);
   textcolor(lightmagenta); textbackground(3); write(#2);
   textcolor(white); textbackground(3);
   write(' ', jogo.quantOponentesCapt, '   ');
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + tela.dL - 7);
   textcolor(yellow); textbackground(3); write(#4);
   textcolor(white); textbackground(3);
   write(' ', jogo.pontuacao, '        ');
  
   gotoxy(tela.pC + tela.dC + 2, tela.pL + tela.dL - 5);
   textcolor(lightred); textbackground(3); write(#3);
   textcolor(white); textbackground(3);
   write(' ', pers.status[1, 9], '   ');
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + tela.dL - 2);
   textcolor(ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 2])); 
   textbackground(ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 3]));                                            
   write(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 1]);
   textcolor(red); textbackground(3); write(' ', curs.foco, '         ');   

 End;
  
 {---------------------------------------------
         Inicializa definições iniciais
  ---------------------------------------------}  
 Procedure Inicializa ;
 Var
 contA, contB: integer;
 corAux, pCAux, pLAux, dAux, qAux : integer;
 
   Procedure ExibeDica;
   Var
   escolha : integer;
   Begin
     escolha := random(33) + 1;
     gotoxy(2, tela.pL + tela.dL);
     textcolor(white);
     textbackground(black);
     write('                                                                              ');
     gotoxy(2, tela.pL + tela.dL);
		 case (escolha) of 
       1: write('Mantenha distância de certos animais');
       2: write('Nada te pega entre os esconderijos nas rochas');
       3: write('As águas então infestadas de crocodilos');
       4: write('Você ouvirá três bips no caso de bônus de vida por experiência');
       5: write('Você ganha experiência quando confronta animais');
       6: write('Acumule 500 pontos de experiência para ganhar +100 em limite de vida');
       7: write('Cuidado com as florestas, tudo fica oculto sob as árvores');
       8: write('Caso o agente morra ele é reiniciado em algum lugar do mapa');
       9: write('Evite confrontos da água');
       10: write('Nessa área as rochas são muito íngrimes para serem exploradas');
       11: write('Frente a alguma depressão no solo cuide para não avançar sobre o precipício');
       12: write('Quanto maior a dificuldade, de mais longe os animais te percebem');
       13: write('Os animais irão te perseguir');
       14: write('Capture os corações vermelhos para recuperar os pontos de vida');
       15: write('Siga a direção indicada para encontrar os terroristas');
       16: write('Pressione L para navegar livremente sobre o mapa sem o agente');
       17: write('Um novo mapa é gerado a cada vez que o jogo é aberto');
       18: write('O cursor é a seta branca que fica piscando no meio da tela');
       19: write('Aponte o cursor do jogo para os elementos do mapa e veja o que eles são');
       20: write('Pressione ESPAÇO para movimentar o agente até a posição do cursor');
       21: write('Os lobos passeiam livremente nessa área');
       22: write('Esteja preparado contra as vespas');
       23: write('Há muitas cobras vivendo neste bioma, cuidado!');
       24: write('Durante o jogo aperte ESC para pausar ou sair');
       25: write('Os terroristas vestem uma roupa roxa');
       26: write('É provável que você encontre belas paisagens entre rochas e rios');
       27: write('Na água e na floresta a velocidade fica mais lenta');
       28: write('Guie o agente pelo mapa');
       29: write('Pressione TAB para ocultar o cursor');
       30: write('Coelhos e pássaros são inofensivos'); 
       31: write('Morcegos vivem à espreita');
       32: write('Dentro da água você está à salvo, menos dos crocodilos');
       else ;
     end;
   End;
   
 Begin
   randomize;
   mapa.dC := 500;
   mapa.dL := 300;
   mapa.rC := 1;
   mapa.rL := 1;
   tela.dC := 50;
   //tela.dL := 23; {DECLARADA NO PROCEDIMENTO ExibeMensagensIniciais()}
   tela.pC := 2;
   tela.PL := 2;
   curs.pC := (tela.dC div 2) ; 
   curs.pL := (tela.dL div 2) ;
   curs.veloc := 5;
   curs.cont := 0;
   curs.ativo := true;
   curs.aMostra := true;
   curs.cor := yellow;
   jogo.velocidadePersAliado := 1;
   jogo.vitalidadePersAliado := 500;
   jogo.passarSobreLiquido := true;
   jogo.cursorLimitado := true;
   jogo.delayPadrao := 0;
   //jogo.quantPersOponentes := 1000; {DECLARADA NO PROCEDIMENTO ExibeMensagensIniciais()}
   
   DesenhaRetangulo(tela.pC, tela.pL, tela.dC, tela.dL,
                    green, green, PADRAO_OPACO);
   DesenhaRetangulo(tela.pC + tela.dC + 1, tela.pL, 
                    27, tela.dL,
                    3, 3, PADRAO_OPACO);                 
   gotoxy(80, 1);
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 1);
   textcolor(yellow); textbackground(3);
   write('Gerando mundo...'); gotoxy(80,1);
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 3);
   textcolor(white); textbackground(3);
   write(#4, ' Terreno'); gotoxy(80,1);
   
   ExibeDica;
   
   {DEFINE O TERRENO PADRÃO} 
   for contA := 1 to mapa.dC do
     for contB := 1 to mapa.dL do
     begin
       InsereElemento(PADRAO_OPACO, green, green, PASSAVEL, contA, contB) ;  
     end; 
   ExibeTela(mapa.rC, mapa.rL); delay(500);
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 5);
   textcolor(white); textbackground(3);
   write(#4, ' Recursos h', #161, 'dricos'); gotoxy(80,1);
   	    
   {DEFINE OS LAGOS ALEATÓRIOS} 
   qAux := random(150) + 1; {DEFINE QUANTIDADE DE LAGOS}
   contA := 0;
   contB := 0;
   repeat
     dAux := random(500) + 1; {DEFINE DIMENSÃO DO LAGO}
     pCAux := random(mapa.dC) + 1; {DEFINE POSIÇÃO DA COLUNA DO LAGO}
     pLAux := random(mapa.dL) + 1; {DEFINE POSIÇÃO DA LINHA DO LAGO}
     repeat
       case (random(3)) of 
         0: pCAux := pCAux + 1;
         1: pCAux := pCAux - 1;
         2: ;
       end;
       case (random(3)) of 
         0: pLAux := pLAux + 1;
         1: pLAux := pLAux - 1;
         2: ;
       end;
       if (pCAux > 0) and (pCAux <= mapa.dC) and 
		(pLAux > 0) and (pLAux <= mapa.dL) then
	    if (mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) then	
           InsereElemento(PADRAO_OPACO, blue, blue, LIQUIDO, pCAux, pLAux);
       inc(contB);
     until(contB = dAux);
      contB := 0;
	inc(contA);   
   until (contA = qAux);
  ExibeTela(mapa.rC, mapa.rL); delay(300);
      
   {DEFINE AS BORDAS DO LAGO} 
   for contA := 1 to mapa.dC do
     for contB := 2 to mapa.dL do                              
     begin
	  if (mapa.matriz[contA, contB, 4] = chr(LIQUIDO)) then
	  begin
	    if (contA > 1) then
	      if (mapa.matriz[contA - 1, contB, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, 1, ord(mapa.matriz[contA - 1, contB, 3]), PASSAVEL, contA - 1, contB) ;
	    if (contA < mapa.dC) then
	      if (mapa.matriz[contA + 1, contB, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, 1, ord(mapa.matriz[contA + 1, contB , 3]), PASSAVEL, contA + 1, contB) ;
	    if (contB > 1) then
	      if (mapa.matriz[contA, contB - 1, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, 1, ord(mapa.matriz[contA, contB - 1, 3]), PASSAVEL, contA, contB - 1) ;
	    if (contB < mapa.dL) then
	      if (mapa.matriz[contA, contB + 1, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, 1, ord(mapa.matriz[contA, contB + 1, 3]), PASSAVEL, contA, contB + 1) ;	   	       
	  end; 
     end; 
  ExibeTela(mapa.rC, mapa.rL); delay(500);
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 7);
   textcolor(white); textbackground(3);
   write(#4, ' Depress', #228, 'es'); gotoxy(80,1);
   
  ExibeDica;
   
   
   {DEFINE DEPRESSÕES ALEATÓRIAS} 
   qAux := random(5) + 1; {DEFINE QUANTIDADE DE DEPRESSÕES}
   contA := 0;
   contB := 0;
   repeat
     dAux := random(1500) + 1; {DEFINE DIMENSÃO DA DEPRESSÃO}
     pCAux := random(mapa.dC) + 1; {DEFINE POSIÇÃO DA COLUNA DA DEPRESSÃO}
     pLAux := random(mapa.dL) + 1; {DEFINE POSIÇÃO DA LINHA DA DEPRESSÃO}
     repeat
       case (random(3)) of 
         0: pCAux := pCAux + 1;
         1: pCAux := pCAux - 1;
         2: ;
       end;
       case (random(3)) of 
         0: pLAux := pLAux + 1;
         1: pLAux := pLAux - 1;
         2: ;
       end;
       if (pCAux > 0) and (pCAux <= mapa.dC) and 
		(pLAux > 0) and (pLAux <= mapa.dL) then
	    if (mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) then	
           InsereElemento(PADRAO_OPACO, black, black, DEPRESSAO, pCAux, pLAux);
       inc(contB);
     until(contB = dAux);
      contB := 0;
	inc(contA);   
   until (contA = qAux);
   ExibeTela(mapa.rC, mapa.rL); delay(300);
   
   
   {DEFINE AS BORDAS DA DEPRESSÃO} 
   for contA := 1 to mapa.dC do
     for contB := 2 to mapa.dL do                              
     begin
	  if (mapa.matriz[contA, contB, 4] = chr(DEPRESSAO)) then
	  begin
	    if (contA > 1) then
	      if (mapa.matriz[contA - 1, contB, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_2, 10, ord(mapa.matriz[contA - 1, contB, 3]), PASSAVEL, contA - 1, contB) ;
	    if (contA < mapa.dC) then
	      if (mapa.matriz[contA + 1, contB, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_2, 10, ord(mapa.matriz[contA + 1, contB , 3]), PASSAVEL, contA + 1, contB) ;
	    if (contB > 1) then
	      if (mapa.matriz[contA, contB - 1, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_2, 10, ord(mapa.matriz[contA, contB - 1, 3]), PASSAVEL, contA, contB - 1) ;
	    if (contB < mapa.dL) then
	      if (mapa.matriz[contA, contB + 1, 4] = chr(PASSAVEL)) then
	        InsereElemento(PADRAO_TRANSLUCIDO_2, 10, ord(mapa.matriz[contA, contB + 1, 3]), PASSAVEL, contA, contB + 1) ;	   	       
	  end; 
     end; 
   ExibeTela(mapa.rC, mapa.rL); delay(500);
   
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 9);
   textcolor(white); textbackground(3);
   write(#4, ' Rochas'); gotoxy(80,1);
      
   {DEFINE OS ROCHEDOS ALEATÓRIOS}
   qAux := random(100) + 1; {DEFINE QUANTIDADE DE ROCHEDOS}
   contA := 0;
   contB := 0;
   repeat
     dAux := random(1000) + 1; {DEFINE DIMENSÃO DO ROCHEDO}
     pCAux := random(mapa.dC) + 1; {DEFINE POSIÇÃO DA COLUNA DO ROCHEDO}
     pLAux := random(mapa.dL) + 1; {DEFINE POSIÇÃO DA LINHA DO ROCHEDO}
     repeat
       case (random(3)) of 
         0: pCAux := pCAux + 1;
         1: pCAux := pCAux - 1;
         2: ;
       end;
       case (random(3)) of 
         0: pLAux := pLAux + 1;
         1: pLAux := pLAux - 1;
         2: ;
       end;
       if (pCAux > 0) and (pCAux <= mapa.dC) and 
		(pLAux > 0) and (pLAux <= mapa.dL) then
	    if (mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) then	
           InsereElemento(PADRAO_OPACO, 7, 7, SOLIDO, pCAux, pLAux);
       inc(contB);
     until(contB = dAux);
      contB := 0;
	inc(contA);   
   until (contA = qAux);
                                                            
   {DEFINE AS BORDAS DO ROCHEDO} 
   for contA := 1 to mapa.dC do
     for contB := 2 to mapa.dL do                              
     begin
	  if (mapa.matriz[contA, contB, 4] = chr(SOLIDO)) then
	  begin
	     if (contB < mapa.dL) then
	       if (mapa.matriz[contA, contB + 1, 4] = chr(PASSAVEL)) then
	       begin
	         InsereElemento(PADRAO_OPACO, black, black, SOLIDO, contA, contB + 1) ;
		    InsereElemento(PADRAO_OPACO, black, black, SOBREPOSTO, contA, contB + 2) ;	   	       
	       end;
	  end; 
     end; 
   ExibeTela(mapa.rC, mapa.rL); delay(500);
   
   {DEFINE ÁREAS COM NEVE}
   qAux := random(10000) + 1; {DEFINE QUANTIDADE DE ÁREAS COM NEVE}
   contA := 0;
   contB := 0;
   repeat
     dAux := random(10) + 1; {DEFINE DIMENSÃO DAS ÁREAS COM NEVE}
     pCAux := random(mapa.dC) + 1; {DEFINE POSIÇÃO DAS COLUNA DA ÁREAS COM NEVE}
     pLAux := random(mapa.dL) + 1; {DEFINE POSIÇÃO DAS LINHA DA ÁREAS COM NEVE}
     repeat
       case (random(3)) of 
         0: pCAux := pCAux + 1;
         1: pCAux := pCAux - 1;
         2: ;
       end;
       case (random(3)) of 
         0: pLAux := pLAux + 1;
         1: pLAux := pLAux - 1;
         2: ;
       end;
       if (pCAux > 0) and (pCAux <= mapa.dC) and 
		(pLAux > 0) and (pLAux <= mapa.dL) then
	    if (mapa.matriz[pCAux, pLAux, 4] = chr(SOLIDO)) and 
	       (mapa.matriz[pCAux, pLAux, 2] = chr(7)) then	
           InsereElemento(PADRAO_OPACO, white, white, SOLIDO, pCAux, pLAux);
       inc(contB);
     until(contB = dAux);
      contB := 0;
	inc(contA);   
   until (contA = qAux);
   ExibeTela(mapa.rC, mapa.rL); delay(300);
   
   {DEFINE AS BORDAS DAS ÁREAS COM NEVE} 
   for contA := 1 to mapa.dC do
     for contB := 2 to mapa.dL do                              
     begin
	  if ((mapa.matriz[contA, contB, 4] = chr(SOLIDO)) and
	      (mapa.matriz[contA, contB, 1] = PADRAO_OPACO) and
	      (mapa.matriz[contA, contB, 2] = chr(white))) then
	  begin
	    if (contA > 1) then
	      if ((mapa.matriz[contA - 1, contB, 4] = chr(SOLIDO)) and
		     (mapa.matriz[contA - 1, contB, 2] = chr(7))) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, white, ord(mapa.matriz[contA - 1, contB, 3]), SOLIDO, contA - 1, contB) ;
	    if (contA < mapa.dC) then
	      if ((mapa.matriz[contA + 1, contB, 4] = chr(SOLIDO)) and
		     (mapa.matriz[contA + 1, contB, 2] = chr(7))) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, white, ord(mapa.matriz[contA + 1, contB , 3]), SOLIDO, contA + 1, contB) ;
	    if (contB > 1) then
	      if ((mapa.matriz[contA, contB - 1, 4] = chr(SOLIDO)) and
		     (mapa.matriz[contA, contB - 1, 2] = chr(7))) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, white, ord(mapa.matriz[contA, contB - 1, 3]), SOLIDO, contA, contB - 1) ;
	    if (contB < mapa.dL) then
	      if ((mapa.matriz[contA, contB + 1, 4] = chr(SOLIDO)) and
		     (mapa.matriz[contA, contB + 1, 2] = chr(7))) then
	        InsereElemento(PADRAO_TRANSLUCIDO_1, white, ord(mapa.matriz[contA, contB + 1, 3]), SOLIDO, contA, contB + 1) ;	   	       
	  end; 
     end; 
   ExibeTela(mapa.rC, mapa.rL); delay(500);

   gotoxy(tela.pC + tela.dC + 2, tela.pL + 11);
   textcolor(white); textbackground(3);
   write(#4, ' Vegeta', #135, #198,'o'); gotoxy(80,1);

  ExibeDica;
   
   {INICIA FLORESTAS} 
   qAux := random(10) + 1; {DEFINE QUANTIDADE DE FLORESTAS}
   contA := 0;
   contB := 0;
   repeat
     dAux := random(2000) + 1; {DEFINE DIMENSÃO DA FLORESTA}
     pCAux := random(mapa.dC) + 1; {DEFINE POSIÇÃO DA COLUNA DA FLORESTA}
     pLAux := random(mapa.dL) + 1; {DEFINE POSIÇÃO DA LINHA DA FLORESTA}
     repeat
       case (random(3)) of 
         0: pCAux := pCAux + 1;
         1: pCAux := pCAux - 1;
         2: {NADA FAZ;}
       end;
       case (random(3)) of 
         0: pLAux := pLAux + 1;
         1: pLAux := pLAux - 1;
         2: {NADA FAZ;}
       end;
       if (pLAux > 1) and (pLAux <= mapa.dL) and
	     (pCAux > 0) and (pCAux <= mapa.dC) then
       begin
         if (mapa.matriz[pCAux, pLAux - 1, 4] = chr(PASSAVEL)) and
            (mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) then
         begin   
           InsereElemento(TRIANGULO, lightgreen, green, SOBREPOSTO, pCAux, pLAux - 1);
           InsereElemento(RETA, brown, green, SOBREPOSTO, pCAux, pLAux);
         end;
	  end;    
       inc(contB);
     until(contB = dAux);
      contB := 0;
	inc(contA);   
   until (contA = qAux); 
   
   {INICIA ÁRVORES} 
   for contA := 1 to 1000 do
   begin
     while (true) do
     begin
       pCAux := random(mapa.dC) + 1;
       pLAux := random(mapa.dL) + 1;
       case (random(5)) of 
         0: corAux := lightgreen;
         1: corAux := lightgreen;
         2: corAux := lightgreen;
         3: corAux := lightgreen;
         4: corAux := lightgreen;
         else ;
       end;
       if (mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)) then
         if (pLAux > 1) and 
	       (mapa.matriz[pCAux, pLAux - 1, 4] = chr(PASSAVEL)) then
         begin
           InsereElemento(TRIANGULO, corAux, green, SOBREPOSTO, pCAux, pLAux - 1);
           InsereElemento(RETA, brown, green, SOBREPOSTO, pCAux, pLAux);
           break;
         end;
	end; 
   end;
  
   {INICIA ARBUSTOS}
   for contA := 1 to 1000 do
   begin
     pCAux := random(mapa.dC) + 1;
     pLAux := random(mapa.dL) + 1;
     case (random(2)) of 
       0: corAux := lightgreen;
       1: corAux := yellow;
     end;
     if (mapa.matriz[pCAux, pLAux, 4] <> chr(SOBREPOSTO)) and
	   (mapa.matriz[pCAux, pLAux, 4] <> chr(DEPRESSAO)) then
     InsereElemento(ASTERISCO, corAux, ord(mapa.matriz[pCAux, pLAux, 3]), PASSAVEL, pCAux, pLAux);
   end;
   
   {INICIA PEDRAS}
   for contA := 1 to 12000 do
   begin
     pCAux := random(mapa.dC) + 1;
     pLAux := random(mapa.dL) + 1;
     case (random(2)) of 
       0: corAux := black;
       1: corAux := red;
     end;
     if (mapa.matriz[pCAux, pLAux, 4] <> chr(SOBREPOSTO)) then
     InsereElemento(PONTO, corAux, ord(mapa.matriz[pCAux, pLAux, 3]), ord(mapa.matriz[pCAux, pLAux, 4]), pCAux, pLAux);
   end;
   ExibeTela(mapa.rC, mapa.rL); delay(500);
  
   gotoxy(tela.pC + tela.dC + 2, tela.pL + 13);
   textcolor(white); textbackground(3);
   write(#4, ' Personagens'); gotoxy(80,1);
  randomize;
  
  repeat
    pCAux := random(mapa.dC) + 1;
    pLAux := random(mapa.dL) + 1;
  until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
  CriaPersonagem(#2, yellow, PERSONAGEM_ALIADO, pCAux, pLAux, pCAux, pLAux, pers.quant);
  pers.status[1, 9] := 0;
  
   {INICIA OS PERSONAGENS} 
   for contA := 2 to jogo.quantPersOponentes do
   begin
	 	
	if (contA < jogo.quantPersOponentes) then
	begin	   
	  contB := random(105) + 1;
	  if (contB <= 10) then
		begin 
		  repeat
        pCAux := random(mapa.dC) + 1;
        pLAux := random(mapa.dL) + 1;
			until ((mapa.matriz[pCAux, pLAux, 4] = chr(LIQUIDO))); 	 	   
	    CriaPersonagem(#18, lightgreen, PERSONAGEM_7, pCAux, pLAux, pCAux, pLAux, pers.quant) {CROCODILO}
	  end else
	    if (contB <= 20) then 
	    begin
	      repeat
          pCAux := random(mapa.dC) + 1;
          pLAux := random(mapa.dL) + 1;
			  until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	      CriaPersonagem(#173, lightgray, PERSONAGEM_6, pCAux, pLAux, pCAux, pLAux, pers.quant) {LOBO}
	    end else
	      if (contB <= 30) then 
	      begin
	        repeat
            pCAux := random(mapa.dC) + 1;
            pLAux := random(mapa.dL) + 1;
			    until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	        CriaPersonagem(#210, white, PERSONAGEM_5, pCAux, pLAux, pCAux, pLAux, pers.quant) {TIGRE}
	      end else
	        if (contB <= 40) then
					begin 
					  repeat
              pCAux := random(mapa.dC) + 1;
              pLAux := random(mapa.dL) + 1;
			      until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	          CriaPersonagem(#220, white, PERSONAGEM_4, pCAux, pLAux, pCAux, pLAux, pers.quant) {URSO}
	        end else
	          if (contB <= 50) then 
	          begin
	            repeat
                pCAux := random(mapa.dC) + 1;
                pLAux := random(mapa.dL) + 1;
			        until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	            CriaPersonagem(#42, black, PERSONAGEM_3, pCAux, pLAux, pCAux, pLAux, pers.quant) {ARANHA}
	          end else
	            if (contB <= 60) then
							begin 
							  repeat
                  pCAux := random(mapa.dC) + 1;
                  pLAux := random(mapa.dL) + 1;
			          until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	              CriaPersonagem(#126, lightmagenta, PERSONAGEM_1, pCAux, pLAux, pCAux, pLAux, pers.quant) {SERPENTE}
	            end else
	               if (contB <= 70) then
								 begin
								   repeat
                     pCAux := random(mapa.dC) + 1;
                     pLAux := random(mapa.dL) + 1;
			             until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL))); 
	                 CriaPersonagem(#96, black, PERSONAGEM_2, pCAux, pLAux, pCAux, pLAux, pers.quant) {MORCEGO}
	               end else
	                 if (contB <= 80) then
									 begin 
									   repeat
                       pCAux := random(mapa.dC) + 1;
                       pLAux := random(mapa.dL) + 1;
			               until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	                   CriaPersonagem(#250, lightred, PERSONAGEM_10, pCAux, pLAux, pCAux, pLAux, pers.quant) {VESPA}
	                 end else
	                   if (contB <= 90) then
										 begin
										   repeat
                         pCAux := random(mapa.dC) + 1;
                         pLAux := random(mapa.dL) + 1;
			                 until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL))); 
	                     CriaPersonagem(#247, white, PERSONAGEM_8, pCAux, pLAux, pCAux, pLAux, pers.quant) {COELHO}
	                   end else
	                     if (contB <= 100) then 
	                     begin
	                       repeat
                           pCAux := random(mapa.dC) + 1;
                           pLAux := random(mapa.dL) + 1;
			                   until((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
	                       CriaPersonagem(#96, white, PERSONAGEM_9, pCAux, pLAux, pCAux, pLAux, pers.quant){PÁSSARO}
	                     end else
	                         if (contB <= 105) then 
	                         begin
	                           CriaPersonagem(#3, lightred, PERSONAGEM_ELEMENTO, pCAux, pLAux, pCAux, pLAux, pers.quant) {LIFE}
	end;                       
end else
begin
  	  {INICIA TERRORISTA}
	  //randomize;
	  repeat
      pCAux := random(mapa.dC) + 1;
      pLAux := random(mapa.dL) + 1;
		until ((mapa.matriz[pCAux, pLAux, 4] = chr(PASSAVEL)));
    CriaPersonagem(#2, lightmagenta, PERSONAGEM_OPONENTE, pCAux, pLAux, pCAux, pLAux, pers.quant);
end;
end;		    
   ExibeTela(mapa.rC, mapa.rL);
   GerenciaPersonagem;   
   DesenhaRetangulo(tela.pC + tela.dC + 1, tela.pL, 
                    27, tela.dL,
                    3, 3, PADRAO_OPACO);
   	 
   textcolor(white);
   textbackground(black);
	 gotoxy(2, tela.pL + tela.dL);
	 write('                                                                              ');
 End;

 {---------------------------------------------
         Exibe mensagens iniciais
  ---------------------------------------------}  
 Procedure ExibeMensagensIniciais ;
 Var
 cont, dimLTela, quantOponentes : integer;
 Begin
   tela.dL := 23; {DIMENSÃO DA TELA}
   jogo.quantPersOponentes := 1000; {QUANTIDADE DE ANIMAIS}
 
   textcolor(7); gotoxy(2, tela.pL + tela.dL + 1);
   write('F2 - Configurar dimens', #198,'o da tela');
   gotoxy(34, 8);
   textcolor(yellow); textbackground(black);
   write('OPERA', #128, #199, 'O MAPA');
   gotoxy(31, 11);
   textcolor(white); write('Guilherme Resende S', #160);                             						      
   for cont := 38 to 44 do
   begin
     textcolor(white); textbackground(black);
     gotoxy(cont, 13); write(#250);
     gotoxy(80, 1); delay(500);
     if (keypressed) then
       if (readkey = #0) then
         case (readkey) of 
           #60: begin //F2
                  gotoxy(2, tela.pL + tela.dL + 1); write('                                                     ');
                  gotoxy(2, tela.pL + tela.dL + 1);
		        write('Dimens', #198,'o (min. 23 - max. 40): '); read(dimLTela);
                  if(dimLTela <= 40) and
		          (dimLTela >= 23) then
                  tela.dL := dimLTela
		        else
		        begin
		          textcolor(lightred); write(' Erro: Dimens', #198,'o indevida'); 
		          gotoxy(80,1); delay(2000);
	             end;
		      end;
           #61: begin //F3
                  gotoxy(2, tela.pL + tela.dL + 1); write('                                ');
                  gotoxy(2, tela.pL + tela.dL + 1);
		        write('Quantidade de animais - ',jogo.quantPersOponentes, ' - (max. ', QP,'): '); read(quantOponentes);
                  if(quantOponentes > 0) and
		          (quantOponentes <= QP) then
                  jogo.quantPersOponentes := quantOponentes
		        else
		        begin
		          textcolor(lightred); write(' Erro: Quantidade indevida'); 
		          gotoxy(80,1); delay(2000);
	             end;
		      end;
         else ;
       end;
   end;
 
   textbackground(black); clrscr;
   DesenhaRetangulo(2, 2, 
                    78, tela.dL,
                    3, 3, PADRAO_OPACO);
   gotoxy(30, 3);
   textcolor(yellow); textbackground(3);
   write('N', #214, 'VEL DE DIFICULDADE');
   textcolor(white);
   gotoxy(35, 8); write('1 - F', #160, 'cil');   
   gotoxy(35, 12); write('2 - Normal');
   gotoxy(34, 16); write('3 - Dif', #161, 'cil');
   textcolor(yellow);
   gotoxy(32, 20); write('Escolha um n', #161, 'vel');
   while (true) do begin
     gotoxy(80, 1);
     case (readkey) of 
       '1': begin
              jogo.raioDePerseguicao := 2; break;
	       end;
       '2': begin
              jogo.raioDePerseguicao := 7; break;
	       end;
       '3': begin
              jogo.raioDePerseguicao := 12; break;
	       end;
       else ;
     end;
   end;                    
   
   textbackground(black); clrscr;
   DesenhaRetangulo(2, 2, 
                    78, tela.dL,
                    3, 3, PADRAO_OPACO);
   gotoxy(33, 3);
   textcolor(yellow); textbackground(3);
   write('OPERA', #128, #199, 'O MAPA');
   textcolor(white); textbackground(3);
   gotoxy(5, 8);
   write('Terroristas atacaram nosso pa', #161, 's e 5 deles est', #198, 'o escondidos neste local;');
   gotoxy(80, 1); delay(500);
   gotoxy(8, 12);
   write('Como agente especial treinado, sua miss', #198, 'o ', #130, ' perseguir e eliminar;');
   gotoxy(80, 1); delay(500);
   gotoxy(15, 16);
   write('Fique atento aos animais selvagens deste ambiente.');
   gotoxy(80, 1); delay(500); 
   textcolor(yellow);
   gotoxy(29, 20);
   write('[ENTER] para continuar');
   gotoxy(80, 1); 
   while (true) do begin {LOOP ATÉ QUE ENTER SEJA PRESSIONADO}
     if (keypressed) then
       if (readkey = #13) then
         break;
     delay(50);    
   end; 
   DesenhaRetangulo(2, 2, 
                    78, tela.dL,
                    3, 3, PADRAO_OPACO);
   
   gotoxy(32, 3);
   textcolor(yellow); textbackground(3);
   write('INSTRU', #128, #229, 'ES DE JOGO');
   textcolor(white); textbackground(3);
   gotoxy(31, 8);
   write('1 - N', #198, 'o use o mouse.' );
   gotoxy(15, 9);
   write('Use as teclas direcionais para movimentar o cursor ', #24);
   gotoxy(80, 1); delay(500);
   gotoxy(5, 13);
   write('2 - Pressione [ESPA', #128, 'O] para mover o personagem ');
   textcolor(yellow); textbackground(3); write(#2);
   textcolor(white); textbackground(3);
   write(' at', #130, ' a posi', #135, #198, 'o do cursor');
   gotoxy(80, 1); delay(500);
   textcolor(white); textbackground(3);
   gotoxy(26, 17);
   write('3 - Elimine os terroristas ');
   textcolor(lightmagenta); textbackground(3); write(#2);
   gotoxy(80, 1); delay(500); 
   textcolor(yellow);
   gotoxy(27, 21);
   write('[ENTER] para iniciar miss', #198, 'o');
   gotoxy(80, 1); 
   while (true) do begin {LOOP ATÉ QUE ENTER SEJA PRESSIONADO}
     if (keypressed) then
       if (readkey = #13) then
         break;
     delay(50);    
   end;                   
   textbackground(black); clrscr;
    
 End;
 
  {---------------------------------------------
         Exibe mensagens finais
  ---------------------------------------------}  
 Procedure ExibeMensagensFinais ;
 Begin
   textbackground(black);
   clrscr;
   DesenhaRetangulo(2, 2, 
                    78, tela.dL,
                    3, 3, PADRAO_OPACO);
   
   gotoxy(33, 3);
   textcolor(yellow); textbackground(3);
   write('OPERA', #128, #199, 'O MAPA');
   textcolor(white); textbackground(3);
   gotoxy(32, 8);
   write('Miss', #198, 'o cumprida!');
   gotoxy(80, 1); delay(2000);
   gotoxy(16, 12);
   write('Sua na', #135, #198, 'o o admira por sua per', #161, 'cia nessa miss', #198, 'o;');
   gotoxy(80, 1); delay(2000);
   gotoxy(9, 16);
   write('Como recompensa voc', #136, ' ser', #160, ' designado a um alto cargo na ag', #136, 'ncia.');
   gotoxy(80, 1); delay(2000); 
   textcolor(yellow);
   gotoxy(29, 20);
   write('[ENTER] para continuar');
   gotoxy(80, 1);
   while (true) do begin {LOOP ATÉ QUE ENTER SEJA PRESSIONADO}
     if (keypressed) then
       if (readkey = #13) then
         break;
     delay(50);    
   end;
   jogo.vitalidadePersAliado := jogo.vitalidadePersAliado + 10200;
   textbackground(black); clrscr;
   DesenhaRetangulo(tela.pC, tela.pL, tela.dC, tela.dL,
                    green, green, PADRAO_OPACO);
   DesenhaRetangulo(tela.pC + tela.dC + 1, tela.pL, 
                    27, tela.dL,
                    3, 3, PADRAO_OPACO);                 
   gotoxy(80, 1);
   pers.status[1, 9] := 0;   
   textbackground(black);
 End;
 
 {---------------------------------------------
              Programa principal
  ---------------------------------------------}    	    
 Begin
   clrscr;
   {LINHA ACRESCIDA POR SUGESTÃO DO COLEGA @THOGA31 - http://www.portugal-a-programar.pt - 26/12/2012}
   //SetConsoleTitle(concat('Opera', #135, #198, 'o Mapa'));
   cursoroff;
	 ExibeMensagensIniciais;
   Inicializa;
   while (true) do begin
     gotoxy(80,1); delay(5); 
     ExibeTela(mapa.rC, mapa.rL);
	GerenciaPersonagem;
	GerenciaCursor;
	GerenciaPainel;
     if (keypressed) then   
     begin
	  if (jogo.cursorLimitado) and
	     ((mapa.rC = pers.status[1, 1] - tela.dC + 2) or
		 (mapa.rC = pers.status[1, 1] - 1) or
		 (mapa.rL = pers.status[1, 2] - tela.dL + 2) or
		 (mapa.rL = pers.status[1, 2] - 1)) then
	  begin
	    pers.status[1,3] := mapa.rC + curs.pC - 1;
	    pers.status[1,4] := mapa.rL + curs.pL - 1;
	    pers.status[1,5] := 0;
	  end;	              
	  case upcase(readkey) of
          #0: case (readkey) of                                      
                #75: begin // seta para esquerda
                       if (curs.pC = (tela.dC div 2)) and
				      (mapa.rC > 1) then
                       begin
                         if ((jogo.cursorLimitado) and
                            (mapa.rC > pers.status[1, 1] - tela.dC + 1)) or
					   not(jogo.cursorLimitado) then
                         dec(mapa.rC);
                       end else
                       begin
                         if (curs.pC > 1) then
                         dec(curs.pC);
                       end;
                     end;
                #77: begin // seta para direita
                       if (curs.pC = (tela.dC div 2)) and
				      (mapa.rC + tela.dC - 1 < mapa.dC) then
                       begin
                         if ((jogo.cursorLimitado) and
                            (mapa.rC <= pers.status[1, 1] - 1)) or
					   not(jogo.cursorLimitado) then
                         inc(mapa.rC);
                       end else
                       begin
                         if (curs.pC < tela.dC) then
                         inc(curs.pC);
                       end;
				 end;
                #80: begin // seta para baixo
                       if ((curs.pL = (tela.dL div 2)) and
				      (mapa.rL + tela.dL - 1 < mapa.dL)) then
                       begin
                         if ((jogo.cursorLimitado) and
                            (mapa.rL <= pers.status[1, 2] - 1)) or
					   not(jogo.cursorLimitado) then
			          inc(mapa.rL);
			        end else
			        begin
			          if (curs.pL < tela.dL) then
                         inc(curs.pL);
			        end;
			      end;            
                #72: begin // seta para cima
			        if (curs.pL = (tela.dL div 2)) and
				      (mapa.rL > 1) then
			        begin
			          if ((jogo.cursorLimitado) and
                            (mapa.rL > pers.status[1, 2] - tela.dL + 1)) or
					   not(jogo.cursorLimitado) then
			          dec(mapa.rL);
			        end else
				   begin
				     if (curs.pL > 1) then
                         dec(curs.pL);
				   end;  
			      end;
			  //#63: begin // Desvincula tela do personagem
			  //       jogo.cursorLimitado := not(jogo.cursorLimitado); 
			  //     end;     
			 #126: begin // incrementa
			         inc(jogo.quantOponentesCapt); 
			       end;
			 #127: begin // incrementa
				    jogo.pontuacao := jogo.pontuacao + 100; 
			       end;
			 #128: begin // incrementa
			         jogo.vitalidadePersAliado := jogo.vitalidadePersAliado + 100;
				    pers.status[1, 9] := jogo.vitalidadePersAliado; 
			       end;   	  	             	 
              end; 
		    
		 #9: curs.ativo := not(curs.ativo);    
	     #27: begin
		       textcolor(yellow); textbackground(black); 
			  gotoxy(2, tela.pL + tela.dL) ;
                 write('TECLE [ENTER] PARA SAIR OU [ESC] PARA VOLTAR'); gotoxy(80,1);
                 if (readkey = #13) then Exit;
                 gotoxy(2, tela.pL + tela.dL) ;
                 write('                                                '); gotoxy(80,1);
			end;  
		#32: begin
		       //pers.status[1, 8] := (pers.status[1, 7] + jogo.delayPadrao) div 2; {REDEFINE CONTADOR}
		       if (ord(mapa.matriz[mapa.rC-1+curs.pC, mapa.rL-1+curs.pL, 4]) <> PERSONAGEM_9) then 	
			  begin
			    {CRIA VÍNCULO COM O PERSONAGEM PARA O SEGUÍ-LO}
		         pers.status[1,3] := mapa.rC + curs.pC - 1;
		         pers.status[1,4] := mapa.rL + curs.pL - 1;
		         pers.status[1,5] := 0;
		       end else
			  begin 
			    {LOCALIZA A POSIÇÃO DO PERSONAGEM NA MATRIZ PERS.STATUS}
			    for aux := 2 to jogo.quantPersOponentes do
                   begin
                     if ((pers.status[aux, 1] = mapa.rC-1+curs.pC) and 
				     (pers.status[aux, 2] = mapa.rL-1+curs.pL)) then
				 break;    
                   end;
                   pers.status[1,5] := aux;
			  end;  
		     end;
	     'L': begin
	         jogo.cursorLimitado := not(jogo.cursorLimitado);
	            {CENTRALIZA O PERSONAGEM NA TELA}
		       if (pers.status[1,1] > (tela.dC div 2) - 1) then
			  begin
			    if (pers.status[1,1] < mapa.dC - (tela.dC div 2) + 1) then		      
		         mapa.rC := pers.status[1,1] - (tela.dC div 2) + 1
		         else
		         mapa.rC := mapa.dC - tela.dC + 1;
		       end
			  else
		       mapa.rC := 1; 
		       
		       if (pers.status[1,2] > (tela.dL div 2) - 1) then
			  begin
			    if (pers.status[1,2] < mapa.dL - (tela.dL div 2) + 1) then		      
		         mapa.rL := pers.status[1,2] - (tela.dL div 2) + 1
		         else
		         mapa.rL := mapa.dL - tela.dL + 1;  
			  end
			  else
		       mapa.rL := 1;
		       curs.pC := (tela.dC div 2);
		       curs.pL := (tela.dL div 2);
		     end;	
	     'R': begin
	            {REINICIA POSIÇÃO DO PERSONAGEM PRINCIPAL}
		       pers.status[1, 9] := 0;
		     end;
		'P': begin
		       {REINICIA POSIÇÃO DO TERRORISTA}
	            pers.status[jogo.quantPersOponentes, 9] := 0;
	            jogo.oponenteReiniciado := true;
		     end;	
		#45: begin
		       {DIMINUI VELOCIDADE DO JOGO}
	            if (jogo.delayPadrao < 50) then
	            begin
	            inc(jogo.delayPadrao); write(#7);
			  end;     
		     end; 
		#61: begin
		       {AUMENTA VELOCIDADE DO JOGO}
	            if (jogo.delayPadrao > 0) then
	            begin
	              dec(jogo.delayPadrao); write(#7);
	            end;
		     end; 								     
	   end;    
      end;
	 {FINALIZA O JOGO}	 
	 if (jogo.quantOponentesCapt = 5) then
	 ExibeMensagensFinais;
	 
	 {AUMENTA A CAPACIDADE DE VIDA DO PERSONAGEM CASO ELE CHEGUE AOS 500 PONTOS}
	 if (jogo.pontuacao >= 500) then
	 begin
	   jogo.vitalidadePersAliado := jogo.vitalidadePersAliado + 100;
	   pers.status[1, 9] := pers.status[1, 9] + 100;
	   jogo.pontuacao := 0;
	   write(#7); delay(100);
	   write(#7); delay(100);
	   write(#7); delay(500);
	 end;	    
     end;           
 	      
 End.
