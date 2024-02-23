// -------------------------------------------------------------
//   Programa que mostra como renderizar um objeto em 3D bem
//   como rotacioná-lo em seus eixos
//
//   Polígonos 3D (linhas) - versão 1.0
//                                     
//   Autor   : Stanley A. Sales 
//
// ------------------------------------------------------------- 
//  
//   Nota: Para fins didáticos. Portanto, sem otimização.
//         Assim é possível ver cada etapa de como são feitos os
//         cálculos.
//
// ------------------------------------------------------------- 
//
// Sugestões:
// ==========
//
// Coloque os pontos para seus polígonos em um arquivo e faça a
// leitura do mesmo para que o código não fique extenso.
//
// Otimize o código para desenhar as linhas do polígono usando
// laços de repetição e coordenadas relativas, quando possível.
//
// Crie outros polígonos
//
// Desenhe mais de um polígono na tela
//
// Movimente horizontal e/ou verticalmente
//
// Pode-se utilizar teclas para mudar o polígino, sua velocidade
// de rotação bem como qual o eixo a ser rotacionado
//
// Mudar a cor de todo o polígono ou somente das arestas
//
// Preencher as faces
//
// Faça polígonos mórficos
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
   y1 : real;              //- variáveis X, Y e Z
   z1 : real;              //-
   xg : real;              //.
   yg : real;              //. buffers para as equações
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
   isAumentando  : boolean;                              // distância aumentando?
	    
begin
// Inicializa o modo gráfico
   driver := Detect;
   initgraph(driver, modo, '');
  
// Verifica se a inicialização foi feita com sucesso
   if (graphResult <> grOk) then
      begin
         writeln('Erro ao inicializar o modo gráfico:', GraphErrorMsg(graphResult));
         exit;
      end;
   
   getAspectRatio(xResolucao, yResolucao);
(*
   Mude esses valores desde que sejam apenas 7 (-3 até 3 são 7 valores)
  
   Se o centro não for zero, o polígono todo vai girar no espaço 3D
  
   Esses valores mudam o ponto de rotação do polígono
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
  
   Calcular seno e cosseno custa caro. Então é melhor
   calculá-los e guardá-los em vetores para futura
   referência.
  
   Esses vetores são utilizados para rotacionar o objeto
   em um determinado ângulo que vai de -360 a 360 graus.
   Assim, podemos rotacioná-lo em qualquer direção.
  
   Não podemos usar graus, então convertemos em radianos
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
// Seed aleatória
//
   randomize;
//
// Inicializa a distância e cor das linhas
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
          dy    := random(13) - 6;          //- de rotação        (-6 a 6)
          dz    := random(13) - 6;          //- de cada eixo      (-6 a 6)
          tempo := random(101) + 50;        // tempo até próximo passo  (50 a 150)
          
					if random(100) mod 2 = 0 then
					   isCubo := not isCubo;          // alterna entre cubo e qualquer outra coisa (no nosso exemplo, pirâmide)
					   
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
                                   cada rotação é composta de 2 equações
                                   cada rotação usa YG, XG ou ZG na equação em vez de Y1, X1 ou Z1
                                   isso se deve ao fato de que, se usássemos Y1, X1 ou Z1, seria usado
                                   novamente na próxima equação e então teria valor diferente e os
                                   resultados seriam incorretos.
                                   depois das duas equações, YG, XG ou ZG é atualizada
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

 Entender a matriz de pontos 3D é bem simples:
 
 (x, y, z)
  |  |  |
  |  |  +-----> 0 = frente     6 = trás      (Obs.)
  |  +--------> 0 = superior   6 = inferior  (Obs.)
	+-----------> 0 = esquerda   6 = direita
	
	
	Obs.: Dizer se é frente ou não depende do jeito que olhamos.
	      No desenho abaixo, podemos enxergar um cubo com a face frontal
	      em um nível inferior à face traseira (vendo de cima pra baixo) ou
	      a face frontal em um nível superior à face traseira (vendo de baixo pra
	      cima). Em uma renderização mais elaborada, o que manda é o sombreamento
	      (shading). Com o sobreamento, somos forçados a enxergar de um só modo.
	      
	      Se enxergarmos, no exemplo abaixo, um cubo visto de cima então a face
	      frontal estará mais abaixo da traseira e será a de coordenadas
	      (0, 0, 0), (0, 6, 0), (6, 0, 0) e (6, 6, 0).
	      
	      Se enxergarmos, no exemplo abaixo, um cubo visto de baixo então a face
	      frontal estará mais acima da traseira e será a de coordenadas
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

 
 
 Conhecendo isso, é possível desenhar vários polígonos, bastando informar os pontos nos quais
 começam e terminam as linhas!!!
 
 Esses pontos podem estar nos limites externos da matriz ou dentro da mesma.
 
 Nossa matriz tem 7 x 7 x 7 = 7^3 = 343 pontos... dá pra desenhar polínogos interessantes.
 
 Por que 7? Ora, de 0 a 6 são 7 valores possíveis.
 

Desenhando os pontos na tela
=============================

como desenhar um objeto 3D em uma tela 2D?

temos que converter os pontos X, Y e Z de um espaço matemático
em um plano 2D. Isso é chamado de projeção perspectiva e é bem simples:

X = X * FOV / Z
Y = Y * FOV / Z

onde: FOV = field of view (campo de visão)

adicionamos xResolucao / 2 e yResolucao / 2 a X e Y, respectivamente,
para centralizar na tela

adicionamos dist no Z para aumentar ou diminuir a distância do observador
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