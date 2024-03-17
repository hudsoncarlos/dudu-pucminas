// -------------------------------------------------------------
//   Programa que implementa o esboço de jogo em primeira pessoa
//   Raycast - versão 1.0
//                                     
//   Autor   : Stanley A. Sales 
//
// ------------------------------------------------------------- 
//  
//   Caracteríticas
//   
//   O programa desenha um mapa no qual o jogador pode percorrer
//   utilizando as teclas de direção.
//
//   Demais teclas:
//   "A" - strafe à esquerda
//   "D" - strafe à direita
//   "W" - olhar para cima
//   "S" - olhar para baixo
//
//   Pressione ESC para encerrar.
//
//   Nota: Para fins didáticos, esse programa mostra como se dá a
//         projeção 3D de um ambiente do ponto de vista do
//         observador.
//   
//   
// ------------------------------------------------------------- 
//
// Raycasting é o nome da técnica utilizada para projetar um mapa 
// 3D a partir de um 2D, através da emissão de raios do ponto de
// vista do observador.
//
// Quando um desses raios atinge uma parede, ele retorna e então
// podemos calcular sua distância em relação ao observador.
//
// Quanto maior a distância, menor a parede será desenhada na tela
// e vice-versa, dando a ideia de perspectiva.
//
// -------------------------------------------------------------

Program Raycast;
uses graph;

   
const
   PI                 =   4 * arctan(1);
   LARGURA_COLUNA     =  10;                            // as paredes sao desenhadas em colunas (recomendado próximo de 10)
   MIN_ALTURA_VISAO   =   2;                            // maximo ao olhar pra baixo
   MAX_ALTURA_VISAO   =  10;                            // máximo ao olhar pra cima
   VELOCIDADE         =   2;                            // velocidade p/ andar
   MAX_LINHAS_MAPA    =  15;                            // quantidade de linhas do mapa no arquivo
   MAX_COLUNAS_MAPA   =  30;                            // quantidade de colunas do mapa no arquivo
   ROTACIONA_DIREITA  = #75;                            // ->
   ROTACIONA_ESQUERDA = #77;                            // <-
   FRENTE             = #72;                            // ^
   TRAS               = #80;                            // V
   STRAFE_DIREITA     = #68;                            // D
   STRAFE_ESQUERDA    = #65;                            // A
   OLHAR_PRA_CIMA     = #87;                            // W
   OLHAR_PRA_BAIXO    = #83;                            // S
   ESC                = #27;                            //
   
var
   sinTable      : array [-359..359] of integer;        // tabela de senos p/ melhorar a performance
   cosTable      : array [-359..359] of integer;        // tabela de cossenos p/ melhorar a performance
   mapa          : array [1..MAX_LINHAS_MAPA, 1..MAX_COLUNAS_MAPA] of integer;     // mapa (world)
   driver        : integer;
   modo          : integer;
   z             : integer;
   px            : integer;                             // coordenada onde o jogador
   py            : integer;                             // se encontra no mapa
   opx           : integer;                             // coordenada
   opy           : integer;                             // anterior
   angulo        : integer;                             // ângulo de visão no mapa
   corCeu        : integer;
   corChao       : integer;
   xResolucao    : integer;
   yResolucao    : integer;
   alturaVisao   : integer;                             // olha pra cima ou pra baixo
   arquivoMapa   : text;

procedure raycast;
var
   s             : integer;
   a             : integer;
   m             : integer;
   dd            : integer;
   ds            : integer;
   xx            : integer;
   yy            : integer;
   stepX         : integer;
   stepY         : integer;

begin
   s := -LARGURA_COLUNA;
   
   for z := -31 to 32 do
       begin
          s := s + LARGURA_COLUNA;
          a := angulo + z;
       
          if a < 0 then
             a := a + 360;
          
          if a > 359 then
             a := a - 360;
          
          xx    := px;
          yy    := py;
          stepX := sinTable[a];
          stepY := cosTable[a];
          dd    := 0;
       
          repeat
             xx := xx - stepX;
             yy := yy - stepY;
             m  := mapa[int(xx / 1024), int(yy / 1024)];
             dd := dd + 1;
          until m <> 0;
       
          ds := int(1000 / dd);                         // distância
       	          
          setColor(corCeu);
          setFillStyle(1, corCeu);
          bar(s, 0, s + (LARGURA_COLUNA - 1), (yResolucao div alturaVisao - 1) - ds);

          setColor(m);
          setFillStyle(1, m);
          bar(s, (yResolucao div alturaVisao) - ds, s + (LARGURA_COLUNA - 1), (yResolucao div alturaVisao) + ds);
          
          setColor(corChao);
          setFillStyle(1, corChao);
          bar(s, (yResolucao div alturaVisao + 1) + ds, s + (LARGURA_COLUNA - 1), yResolucao);
   end;
end;
   
begin
// Inicializa o modo grafico
   driver := Detect;
   initgraph(driver, modo, '');
  
// Verifica se a inicializacao foi feita com sucesso
   if (graphResult <> grOk) then
      begin
         writeln('Erro ao inicializar o modo gráfico:', GraphErrorMsg(graphResult));
         exit;
      end;
   
   getAspectRatio(xResolucao, yResolucao);
//
// inicializa as tabelas de seno e cosseno
//   
	 for z := -359 to 359 do
	     begin
	        sinTable[z] := int(sin(z * pi / 180) * 1024 / LARGURA_COLUNA);
	        cosTable[z] := int(cos(z * pi / 180) * 1024 / LARGURA_COLUNA);
	     end;
//
// seta posição inicial do jogador caso não tenha especificado no arquivo de mapa
//
	 px := 6;
	 py := 5;
//
// carrega o mapa
//
   assign(arquivoMapa, 'mapa.ray');
   reset(arquivoMapa);
	 
   for opy := 1 to MAX_LINHAS_MAPA do              // reaproveitando as variáveis
       begin
          for opx := 1 to MAX_COLUNAS_MAPA do      // para não precisar criar outras
              if not(eoln(arquivoMapa)) then
                 begin
                    read(arquivoMapa, mapa[opy, opx]);
                    
                    if mapa[opy, opx] = -1 then    // posição inicial do jogador
                       begin
                          px             := opx;
                          py             := opy;
                          mapa[opy, opx] := 0;     // mapa não pode ter valor -1
                       end;
                 end;
          readln(arquivoMapa);
       end;
   
	 px          := px * 1024;
	 py          := py * 1024;
	 angulo      := 90;
	 corCeu      := 9;
	 corChao     := 6;
	 alturaVisao := 3;
	 
	 repeat
	    raycast;

	    opx := px;
	    opy := py;
	    
      if (keypressed) then
			   begin
			      case upcase(readkey) of
				         #0:
						  	    case (readkey) of
                         FRENTE:
                             begin
                                px := px - sinTable[angulo] * VELOCIDADE;
                                py := py - cosTable[angulo] * VELOCIDADE;
                             end;
                         TRAS:
                            begin
                               px := px + sinTable[angulo] * VELOCIDADE;
                               py := py + cosTable[angulo] * VELOCIDADE;
                            end;
                         ROTACIONA_ESQUERDA:
											      begin
											         angulo := angulo + 5;
											      end;  
											   ROTACIONA_DIREITA:
											      begin
											         angulo := angulo - 5;
											      end;  
				            end;
							   STRAFE_ESQUERDA:
							      begin
				               px := px + cosTable[angulo] * VELOCIDADE;
				               py := py - sinTable[angulo] * VELOCIDADE;
							      end;
							   STRAFE_DIREITA:
							      begin
				               px := px - cosTable[angulo] * VELOCIDADE;
				               py := py + sinTable[angulo] * VELOCIDADE;
							      end;
							   OLHAR_PRA_CIMA:
							      begin
							         if alturaVisao > MIN_ALTURA_VISAO then
							            alturaVisao := alturaVisao - 1;
							      end;
							   OLHAR_PRA_BAIXO:
							      begin
							         if alturaVisao < MAX_ALTURA_VISAO then
							            alturaVisao := alturaVisao + 1;
							      end;
				         ESC:
				            begin
				               exit;
    		            end;
    		    end;
			   end;								    
	    	    
	    if angulo < 0 then
	       angulo := angulo + 360;
	          
	    if angulo > 359 then
	       angulo := angulo - 360;
	    	
	    if mapa[int(px / 1024), int(py / 1024)] > 0 then
	       begin
	          px := opx;
	          py := opy;
	       end;
				 			   
   until false;
   
   closegraph;
end.