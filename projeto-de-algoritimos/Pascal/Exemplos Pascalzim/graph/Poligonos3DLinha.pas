// -------------------------------------------------------------
//   Programa que mostra como renderizar um objeto em 3D bem
//   como rotacion�-lo em seus eixos
//
//   Pol�gonos 3D (linhas) - vers�o 1.0
//                                     
//   Autor   : Stanley A. Sales 
//
// ------------------------------------------------------------- 
//  
//   Nota: Para fins did�ticos. Portanto, sem otimiza��o.
//         Assim � poss�vel ver cada etapa de como s�o feitos os
//         c�lculos.
//
// ------------------------------------------------------------- 
//
// Sugest�es:
// ==========
//
// Coloque os pontos para seus pol�gonos em um arquivo e fa�a a
// leitura do mesmo para que o c�digo n�o fique extenso.
//
// Otimize o c�digo para desenhar as linhas do pol�gono usando
// la�os de repeti��o e coordenadas relativas, quando poss�vel.
//
// Crie outros pol�gonos
//
// Desenhe mais de um pol�gono na tela
//
// Movimente horizontal e/ou verticalmente
//
// Pode-se utilizar teclas para mudar o pol�gino, sua velocidade
// de rota��o bem como qual o eixo a ser rotacionado
//
// Mudar a cor de todo o pol�gono ou somente das arestas
//
// Preencher as faces
//
// Fa�a pol�gonos m�rficos
//
// -------------------------------------------------------------
// 
Program Poligonos3DLinha;
uses graph;

const
   PI            = 4 * arctan(1);
   FOV           = 180;
   MAX_DISTANCIA = 60;
   MIN_DISTANCIA = 8;

type tipoPontos = record
   x1 : real;              //-
   y1 : real;              //- vari�veis X, Y e Z
   z1 : real;              //-
   xg : real;              //.
   yg : real;              //. buffers para as equa��es
   zg : real;              //.
end;

var
   pontos        : array [0..6, 0..6, 0..6] of tipoPontos;
   sinTable      : array [-360..360] of real;        		// tabela de senos p/ melhorar a performance
   cosTable      : array [-360..360] of real;        		// tabela de cossenos p/ melhorar a performance
   driver        : integer;
   modo          : integer;
   xResolucao    : integer;
   yResolucao    : integer;
   z             : integer;
   xs            : integer;
   ys            : integer;
   zs            : integer;
   t1            : integer;
   t2            : integer;
   t3            : integer;
   dx            : integer;
   dy            : integer;
   dz            : integer;
   j             : integer;
   k             : integer;
   tempo         : integer;
   dist          : real;
   wx1           : real;
   wy1           : real;
   wx2           : real;
   wy2           : real;
   isCubo        : boolean;                              // desenhar cubo?
   isAumentando  : boolean;                              // dist�ncia aumentando?
	    
begin
// Inicializa o modo gr�fico
   driver := Detect;
   initgraph(driver, modo, '');
  
// Verifica se a inicializa��o foi feita com sucesso
   if (graphResult <> grOk) then
      begin
         writeln('Erro ao inicializar o modo gr�fico:', GraphErrorMsg(graphResult));
         exit;
      end;
   
   getAspectRatio(xResolucao, yResolucao);
(*
   Mude esses valores desde que sejam apenas 7 (-3 at� 3 s�o 7 valores)
  
   Se o centro n�o for zero, o pol�gono todo vai girar no espa�o 3D
  
   Esses valores mudam o ponto de rota��o do pol�gono
*)
   for xs := -3 to 3 do                                       // experimente -6 to 0
       begin
          for ys := -3 to 3 do                                // experimente 0 to 6
              begin
                 for zs := -3 to 3 do                         // experimente -1 to 5
                     begin
                        pontos[t1, t2, t3].xg := xs;
                        pontos[t1, t2, t3].yg := ys;
                        pontos[t1, t2, t3].zg := zs;
                        t3                    := t3 + 1;
                     end;
                     
                 t2 := t2 + 1;
                 t3 := 0;
              end;
        
          t1 := t1 + 1;
          t2 := 0;
       end;
(*
   Inicializa as tabelas de seno e cosseno
  
   Calcular seno e cosseno custa caro. Ent�o � melhor
   calcul�-los e guard�-los em vetores para futura
   refer�ncia.
  
   Esses vetores s�o utilizados para rotacionar o objeto
   em um determinado �ngulo que vai de -360 a 360 graus.
   Assim, podemos rotacion�-lo em qualquer dire��o.
  
   N�o podemos usar graus, ent�o convertemos em radianos
   para que o computador possa trabalhar melhor com eles.
  
   Para converter graus em radianos, basta multiplicar
   graus por PI e dividir por 180.
*)  
	 for z := -360 to 360 do
	     begin                                  
	        sinTable[z] := sin(z * (PI / 180));
	        cosTable[z] := cos(z * (PI / 180));
	     end;
//
// Seed aleat�ria
//
   randomize;
//
// Inicializa a dist�ncia e cor das linhas
//
   dist := MAX_DISTANCIA;
   SetColor(15);
//
// Loop principal
//
   writeln('Pressione (e mantenha pressionada) uma tecla para finalizar.  :)');
	    
   while not keypressed do
       begin
          dx    := random(13) - 6;          //- velocidade        (-6 a 6)
          dy    := random(13) - 6;          //- de rota��o        (-6 a 6)
          dz    := random(13) - 6;          //- de cada eixo      (-6 a 6)
          tempo := random(101) + 50;        // tempo at� pr�ximo passo  (50 a 150)
          
					if random(100) mod 2 = 0 then
					   isCubo := not isCubo;          // alterna entre cubo e qualquer outra coisa (no nosso exemplo, pir�mide)
					   
          for k := 0 to tempo do
              begin
              
                 if isAumentando then
                    begin
                       dist := dist + 0.5;
                    
                       if dist = MAX_DISTANCIA then
                          isAumentando := false;
                    end
                  else
                    begin
                       dist := dist - 0.5;
                    
                       if dist = MIN_DISTANCIA then
                          isAumentando := true;
                    end;
                
                 for t1 := 0 to 6 do                   //-
                     for t2 := 0 to 6 do               //- rotaciona todos os pontos
                         for t3 := 0 to 6 do           //-
                             begin
                                (*
                                   cada rota��o � composta de 2 equa��es
                                   cada rota��o usa YG, XG ou ZG na equa��o em vez de Y1, X1 ou Z1
                                   isso se deve ao fato de que, se us�ssemos Y1, X1 ou Z1, seria usado
                                   novamente na pr�xima equa��o e ent�o teria valor diferente e os
                                   resultados seriam incorretos.
                                   depois das duas equa��es, YG, XG ou ZG � atualizada
                                *)
                                
                                // rotaciona o objeto no eixo X. Muda os valores de Y1 e Z1
                                pontos[t1, t2, t3].y1 := pontos[t1, t2, t3].yg * cosTable[dx] - pontos[t1, t2, t3].zg * sinTable[dx];
                                pontos[t1, t2, t3].z1 := pontos[t1, t2, t3].yg * sinTable[dx] + pontos[t1, t2, t3].zg * cosTable[dx];
                                pontos[t1, t2, t3].yg := pontos[t1, t2, t3].y1;
                                pontos[t1, t2, t3].zg := pontos[t1, t2, t3].z1;

								                // rotaciona o objeto no eixo Y. Muda os valores de Z1 e X1
                                pontos[t1, t2, t3].z1 := pontos[t1, t2, t3].zg * cosTable[dy] - pontos[t1, t2, t3].xg * sinTable[dy];
                                pontos[t1, t2, t3].x1 := pontos[t1, t2, t3].zg * sinTable[dy] + pontos[t1, t2, t3].xg * cosTable[dy];
                                pontos[t1, t2, t3].xg := pontos[t1, t2, t3].x1;
    					       	          pontos[t1, t2, t3].zg := pontos[t1, t2, t3].z1;

                                // rotaciona o objeto no eixo Z. Muda os valores de X1 e Y1
                                pontos[t1, t2, t3].x1 := pontos[t1, t2, t3].xg * cosTable[dz] - pontos[t1, t2, t3].yg * sinTable[dz];
                                pontos[t1, t2, t3].y1 := pontos[t1, t2, t3].xg * sinTable[dz] + pontos[t1, t2, t3].yg * cosTable[dz];
                                pontos[t1, t2, t3].xg := pontos[t1, t2, t3].x1;
                                pontos[t1, t2, t3].yg := pontos[t1, t2, t3].y1;
                             end;
                             
                 cleardevice;
(*

 Entender a matriz de pontos 3D � bem simples:
 
 (x, y, z)
  |  |  |
  |  |  +-----> 0 = frente     6 = tr�s      (Obs.)
  |  +--------> 0 = superior   6 = inferior  (Obs.)
	+-----------> 0 = esquerda   6 = direita
	
	
	Obs.: Dizer se � frente ou n�o depende do jeito que olhamos.
	      No desenho abaixo, podemos enxergar um cubo com a face frontal
	      em um n�vel inferior � face traseira (vendo de cima pra baixo) ou
	      a face frontal em um n�vel superior � face traseira (vendo de baixo pra
	      cima). Em uma renderiza��o mais elaborada, o que manda � o sombreamento
	      (shading). Com o sobreamento, somos for�ados a enxergar de um s� modo.
	      
	      Se enxergarmos, no exemplo abaixo, um cubo visto de cima ent�o a face
	      frontal estar� mais abaixo da traseira e ser� a de coordenadas
	      (0, 0, 0), (0, 6, 0), (6, 0, 0) e (6, 6, 0).
	      
	      Se enxergarmos, no exemplo abaixo, um cubo visto de baixo ent�o a face
	      frontal estar� mais acima da traseira e ser� a de coordenadas
	      (0, 0, 6), (0, 6, 6), (6, 0, 6) e (6, 6, 6).
	      
	       
                 (0,0,6) --------------------------------------- (6,0,6)
                         |\                                    |\
                         | \                                   | \
                         |  \                                  |  \
                         |   \                                 |   \
                         |    \                                |    \
                         |     \                               |     \
                         |      \                              |      \
                         |       \                             |       \
                         |        \                            |        \
                         | (0,0,0) -------------------------------------- (6,0,0)
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                         |         |                           |        |
                 (0,6,6) ----------|---------------------------- (6,6,6)|
                          \        |                           \        |
                           \       |                            \       |
                            \      |                             \      |
                             \     |                              \     |
                              \    |                               \    |
                               \   |                                \   |
                                \  |                                 \  |
                                 \ |                                  \ |
                                  \|                                   \|
                           (0,6,0) -------------------------------------- (6,6,0)

 
 
 Conhecendo isso, � poss�vel desenhar v�rios pol�gonos, bastando informar os pontos nos quais
 come�am e terminam as linhas!!!
 
 Esses pontos podem estar nos limites externos da matriz ou dentro da mesma.
 
 Nossa matriz tem 7 x 7 x 7 = 7^3 = 343 pontos... d� pra desenhar pol�nogos interessantes.
 
 Por que 7? Ora, de 0 a 6 s�o 7 valores poss�veis.
 

Desenhando os pontos na tela
=============================

como desenhar um objeto 3D em uma tela 2D?

temos que converter os pontos X, Y e Z de um espa�o matem�tico
em um plano 2D. Isso � chamado de proje��o perspectiva e � bem simples:

X = X * FOV / Z
Y = Y * FOV / Z

onde: FOV = field of view (campo de vis�o)

adicionamos xResolucao / 2 e yResolucao / 2 a X e Y, respectivamente,
para centralizar na tela

adicionamos dist no Z para aumentar ou diminuir a dist�ncia do observador
(objeto fica menor ou maior na tela)

*)

                 if isCubo then
								    begin                           
								       wx1 := ((pontos[0, 0, 0].x1 * FOV) / (pontos[0, 0, 0].z1 + dist)) + xResolucao / 2;    //
								       wy1 := ((pontos[0, 0, 0].y1 * FOV) / (pontos[0, 0, 0].z1 + dist)) + yResolucao / 2;    //
								       wx2 := ((pontos[6, 0, 0].x1 * FOV) / (pontos[6, 0, 0].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[6, 0, 0].y1 * FOV) / (pontos[6, 0, 0].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
                                                                                                              //
								       wx2 := ((pontos[6, 6, 0].x1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[6, 6, 0].y1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            // face frontal (vide obs.)
                                                                                                              //
								       wx2 := ((pontos[0, 6, 0].x1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 6, 0].y1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            //
                                                                                                              //
								       wx2 := ((pontos[0, 0, 0].x1 * FOV) / (pontos[0, 0, 0].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 0, 0].y1 * FOV) / (pontos[0, 0, 0].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            //

								       wx2 := ((pontos[0, 0, 6].x1 * FOV) / (pontos[0, 0, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 0, 6].y1 * FOV) / (pontos[0, 0, 6].z1 + dist)) + yResolucao / 2;    // aresta superior
																																																				      // esquerda
								       lineTo(int(wx2), int(wy2));                                                            //

								       wx2 := ((pontos[6, 0, 6].x1 * FOV) / (pontos[6, 0, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[6, 0, 6].y1 * FOV) / (pontos[6, 0, 6].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            //
                                                                                                              //
                       wx2 := ((pontos[6, 6, 6].x1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[6, 6, 6].y1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            // face traseira (vide obs.)
                                                                                                              //
                       wx2 := ((pontos[0, 6, 6].x1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 6, 6].y1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            //
                                                                                                              //
                       wx2 := ((pontos[0, 0, 6].x1 * FOV) / (pontos[0, 0, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 0, 6].y1 * FOV) / (pontos[0, 0, 6].z1 + dist)) + yResolucao / 2;    //
                                                                                                              //
								       lineTo(int(wx2), int(wy2));                                                            //

								       wx1 := ((pontos[6, 0, 0].x1 * FOV) / (pontos[6, 0, 0].z1 + dist)) + xResolucao / 2;    //
								       wy1 := ((pontos[6, 0, 0].y1 * FOV) / (pontos[6, 0, 0].z1 + dist)) + yResolucao / 2;    //
								       wx2 := ((pontos[6, 0, 6].x1 * FOV) / (pontos[6, 0, 6].z1 + dist)) + xResolucao / 2;    // aresta superior
								       wy2 := ((pontos[6, 0, 6].y1 * FOV) / (pontos[6, 0, 6].z1 + dist)) + yResolucao / 2;    // direita
                                                                                                              //
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
								 
								       wx1 := ((pontos[6, 6, 0].x1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy1 := ((pontos[6, 6, 0].y1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + yResolucao / 2;    //
								       wx2 := ((pontos[6, 6, 6].x1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + xResolucao / 2;    // aresta inferior
								       wy2 := ((pontos[6, 6, 6].y1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + yResolucao / 2;    // esquerda
                                                                                                              //
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
								 
								       wx1 := ((pontos[0, 6, 0].x1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy1 := ((pontos[0, 6, 0].y1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + yResolucao / 2;    //
								       wx2 := ((pontos[0, 6, 6].x1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + xResolucao / 2;    // aresta inferior
								       wy2 := ((pontos[0, 6, 6].y1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + yResolucao / 2;    // direita
                                                                                                              //
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
								    end
								 else
								    begin
								       wx1 := ((pontos[0, 6, 0].x1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy1 := ((pontos[0, 6, 0].y1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + yResolucao / 2;    //
								       wx2 := ((pontos[0, 6, 6].x1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + xResolucao / 2;    // 
								       wy2 := ((pontos[0, 6, 6].y1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + yResolucao / 2;    // 
							      																																									        //
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
								                                                                                              //
                       wx2 := ((pontos[6, 6, 6].x1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + xResolucao / 2;    //
			      					 wy2 := ((pontos[6, 6, 6].y1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + yResolucao / 2;    //
						      																																													  //
								       lineTo(int(wx2), int(wy2));                                                            // base (face inferior)
                                                                                                              //
                       wx2 := ((pontos[6, 6, 0].x1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + xResolucao / 2;    //
						      		 wy2 := ((pontos[6, 6, 0].y1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + yResolucao / 2;    //
									      																																										  //
      								 lineTo(int(wx2), int(wy2));                                                            //
			      					                                                                                        //
                       wx2 := ((pontos[0, 6, 0].x1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[0, 6, 0].y1 * FOV) / (pontos[0, 6, 0].z1 + dist)) + yResolucao / 2;    //
											      																																									//
      								 lineTo(int(wx2), int(wy2));                                                            //
			      					 
                       wx2 := ((pontos[3, 0, 3].x1 * FOV) / (pontos[3, 0, 3].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[3, 0, 3].y1 * FOV) / (pontos[3, 0, 3].z1 + dist)) + yResolucao / 2;    //
      																																																				//
			      					 lineTo(int(wx2), int(wy2));                                                            // um lado (face lateral)
						      																																														//
                       wx2 := ((pontos[6, 6, 0].x1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + xResolucao / 2;    //
			      					 wy2 := ((pontos[6, 6, 0].y1 * FOV) / (pontos[6, 6, 0].z1 + dist)) + yResolucao / 2;    //
						      																																														//
								       lineTo(int(wx2), int(wy2));                                                            //

      								 wx1 := ((pontos[0, 6, 6].x1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + xResolucao / 2;    //
			      					 wy1 := ((pontos[0, 6, 6].y1 * FOV) / (pontos[0, 6, 6].z1 + dist)) + yResolucao / 2;    //
						      		 wx2 := ((pontos[3, 0, 3].x1 * FOV) / (pontos[3, 0, 3].z1 + dist)) + xResolucao / 2;    // outro lado (outra face lateral)
								       wy2 := ((pontos[3, 0, 3].y1 * FOV) / (pontos[3, 0, 3].z1 + dist)) + yResolucao / 2;    // 
											      																																									//
								       line(int(wx1), int(wy1), int(wx2), int(wy2));                                          //
			      
                       wx2 := ((pontos[6, 6, 6].x1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + xResolucao / 2;    //
								       wy2 := ((pontos[6, 6, 6].y1 * FOV) / (pontos[6, 6, 6].z1 + dist)) + yResolucao / 2;    // terceira face lateral
											      																																									//
								       lineTo(int(wx2), int(wy2));                                                            //
								 end;
              end;
       end;

	 closegraph;  
end.