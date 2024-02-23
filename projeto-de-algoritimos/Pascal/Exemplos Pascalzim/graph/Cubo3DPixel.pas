// -------------------------------------------------------------
//   Programa que mostra como renderizar um objeto em 3D bem
//   como rotacion�-lo em seus eixos
//
//   Cubo 3D (pixel) - vers�o 1.0
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
Program Cubo3DPixel;
uses graph;

const
   PI  = 4 * arctan(1);
   FOV = 180;

type tipoPontos = record
   x1  : real;              //-
   y1  : real;              //- vari�veis X, Y e Z
   z1  : real;              //-
   xg  : real;              //.
   yg  : real;              //. buffers para as equa��es
   zg  : real;              //.
   cor : integer;           // cor dos pontos
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
   dist          : integer;
   dx            : integer;
   dy            : integer;
   dz            : integer;
   j             : integer;
   k             : integer;
   tempo         : integer;
	    
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
//
// Mude esses valores desde que sejam apenas 7 (-3 at� 3 s�o 7 valores)
//
// Se o centro n�o for zero, o cubo todo vai girar no espa�o 3D
//
// Esses valores mudam o ponto de rota��o do cubo
//
   for xs := -3 to 3 do                                       // experimente -6 to 0
       begin
          for ys := -3 to 3 do                                // experimente 0 to 6
              begin
                 for zs := -3 to 3 do                         // experimente -1 to 5
                     begin
                        pontos[t1, t2, t3].xg  := xs;
                        pontos[t1, t2, t3].yg  := ys;
                        pontos[t1, t2, t3].zg  := zs;
                        pontos[t1, t2, t3].cor := t1 + 8;   // (+8 = cores highlight)
                        t3                     := t3 + 1;
                     end;
                     
                 t2 := t2 + 1;
                 t3 := 0;
              end;
        
          t1 := t1 + 1;
          t2 := 0;
       end;
//
// Inicializa as tabelas de seno e cosseno
//
// Calcular seno e cosseno custa caro. Ent�o � melhor
// calcul�-los e guard�-los em vetores para futura
// refer�ncia.
//
// Esses vetores s�o utilizados para rotacionar o objeto
// em um determinado �ngulo que vai de -360 a 360 graus.
// Assim, podemos rotacion�-lo em qualquer dire��o.
//
// N�o podemos usar graus, ent�o convertemos em radianos
// para que o computador possa trabalhar melhor com eles.
//
// Para converter graus em radianos, basta multiplicar
// graus por PI e dividir por 180.
//  
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
// Inicializa a dist�ncia
//
   dist := 10;
//
// Loop principal
//
   writeln('Pressione (e mantenha pressionada) uma tecla para finalizar.  :)');
	   
   while not keypressed do
       begin
          dx    := random(13) - 6;          //- velocidade        (-6 a 6)
          dy    := random(13) - 6;          //- de rota��o        (-6 a 6)
          dz    := random(13) - 6;          //- de cada eixo      (-6 a 6)
          tempo := random(71) + 30;         // tempo at� pr�ximo passo  (30 a 100)
          
          if random(31) mod 3 = 0 then      // mudamos a dist�ncia s� de vez em quando
					   dist := random(26) + 10;       // dist�ncia do observador  (10 a 35)
					   
          for k := 0 to tempo do
              begin
                 delay(80);

                 cleardevice;
      
                 for t1 := 0 to 6 do                   //-
                     for t2 := 0 to 6 do               //- rotaciona todos os pontos
                         for t3 := 0 to 6 do           //-
                             begin
                             
                                // cada rota��o � composta de 2 equa��es
                                // cada rota��o usa YG, XG ou ZG na equa��o em vez de Y1, X1 ou Z1
                                // isso se deve ao fato de que, se us�ssemos Y1, X1 ou Z1, seria usado
                                // novamente na pr�xima equa��o e ent�o teria valor diferente e os
                                // resultados seriam incorretos.
                                // depois das duas equa��es, YG, XG ou ZG � atualizada
                                
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
										 
										            //
															  // desenha os pontos na tela
															  //
															  // como desenhar um objeto 3D em uma tela 2D?
															  //
															  // temos que converter os pontos X, Y e Z de um espa�o matem�tico
															  // em um plano 2D. Isso � chamado de proje��o perspectiva e � bem simples:
															  //
															  // X = X * FOV / Z
															  // Y = Y * FOV / Z
															  //
															  // onde: FOV = field of view (campo de vis�o)
															  //
															  // adicionamos xResolucao / 2 e yResolucao / 2 a X e Y, respectivamente,
																// para centralizar na tela
															  //
															  // adicionamos dist no Z para aumentar ou diminuir a dist�ncia do observador
																// (objeto fica menor ou maior na tela)
																// 
       										      putpixel(int(((pontos[t1, t2, t3].x1 * FOV) / (pontos[t1, t2, t3].z1 + dist)) + xResolucao / 2), int(((pontos[t1, t2, t3].y1 * FOV) / (pontos[t1, t2, t3].z1 + dist)) + yResolucao / 2), pontos[t1, t2, t3].cor);
                             end;
              end;
       end;

	 closegraph;  
end.