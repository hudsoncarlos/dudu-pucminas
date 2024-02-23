Program Jogo_da_vida;
	
	{
	
	Programa escrito por Jo�o Lucas de Oliveira Torres (J.L.O.T.)
	Curso de Engenharia El�trica da Univ. Federal do Cear� - Sobral
							    <joao.lucas.torres@gmail.com>
							    
										  Setembro de 2012

	Este programa simula o jogo de zero jogadores "Conway's game of life"
	Ou como tamb�m � conhecido no Brasil, "Jogo da vida".
	
	"O jogo da vida � um aut�mato celular desenvolvido pelo matem�tico 
	 brit�nico John Horton Conway em 1970. � o exemplo mais bem conhecido
	 de aut�mato celular. O jogo foi criado de modo a reproduzir, atrav�s de 
	 regras simples, as altera��es e mudan�as em grupos de seres vivos,
	 tendo aplica��es em diversas �reas da ci�ncia. As regras definidas s�o 
	 aplicadas a cada nova "gera��o"; assim, a partir de uma imagem em um 
	 tabuleiro bi-dimensional definida pelo jogador, percebem-se mudan�as muitas
	 vezes inesperadas e belas a cada nova gera��o, variando de padr�es fixos a ca�ticos."
	 							
								 Defini��o de acordo com o art�go na Wikip�dia.
								 
	Regras do jogo:
	1�: Qualquer c�lula viva com menos de dois vizinhos vivos morre de solid�o.
	2�: Qualquer c�lula viva com mais de tr�s vizinhos vivos morre de superpopula��o.
	3�: Qualquer c�lula com exatamente tr�s vizinhos vivos se torna uma c�lula viva.
	4�: Qualquer c�lula com dois ou tr�s vizinhos vivos continua no mesmo estado para a pr�xima gera��o.
	
	Esse programa � popularmente chamado de jogo de zero jogadores pois, dada uma
	condi��o inicial, n�o � preciso a intera��o humana para o desenrolar das gera��es futuras
	
	}

 Const altura = 23; //define a altura (em tela) do mundo
	  largura = 50; //define a largura (em tela) do mundo
	  
	  //posi��o inicial do desenho do mundo
	  xo = 2; 
	  yo = 2;
	  
	  //animal
	  animal = #1;

 Type TMundo = Record //tipo que define o mundo(grade) cada celula pode ou n�o conter um ser vivo
 			//est_atual informa se h� algu�m em dada posi��o da grade
 			//est_futuro informa se em dada posi��o existir� algu�m na pr�xima gera��o
 			est_atual, est_futuro : Array[1..altura,1..largura] of Boolean;
 			End;
 	 TDirecao = (cima, baixo, direita, esquerda,nada);

 Var mundo : TMundo;
 	x, y, i, j : Integer;
 	tecla : char;
 	geracao : integer;
 	
 //Esse procedimento � responss�vel por incrementar uma gera��o
 //na hist�ria do mundo em quest�o.
 //De maneira mais espec�fica o que este procedimento faz �, atrav�s
 //das regras, determinar quem sobrevive, morre ou nasse no mundo.
 Procedure incrementa_geracao(Var mundo_ : TMundo);
 Var i, j : Integer; //vetores can�nicos
 	vizinhos : Integer;
 Begin
 
 	inc(geracao);
 
 	//A grade ser� percorrida posi��o � posi��o a fim de se calcular
 	//os vizinhos de cada uma. A defini��o de visinho � a mesma que 
 	//no movimento do Rei no jogo de xadrez
 	For j:=1	to altura do
 		For i:=1 to largura do
 		Begin
 			
 			//limpa vizinhos para a nova verifica��o
			vizinhos := 0;
 			
 			//Verifica se certa posi��o na vizinhan�a � v�lida e verifica se existe um vinho nela
			 //se existir incrmenta o n�mero de vizinhos da c�lula. 
			if ((i-1)>0) then if (mundo_.est_atual[j,i-1]=TRUE) then inc(vizinhos);
			if ((i-largura)<0) then if (mundo_.est_atual[j,i+1]=TRUE) then inc(vizinhos);
			if ((j-1)>0) then if (mundo_.est_atual[j-1,i]=TRUE) then inc(vizinhos);
			if ((j-altura)<0) then if (mundo_.est_atual[j+1,i]=TRUE) then inc(vizinhos);
			if (((i-1)>0)and((j-1)>0)) then if (mundo_.est_atual[j-1,i-1]=TRUE) then inc(vizinhos);
			if (((i-1)>0)and((j-altura)<0)) then if (mundo_.est_atual[j+1,i-1]=TRUE) then inc(vizinhos);
			if (((i-largura)<0)and((j-1)>0)) then if (mundo_.est_atual[j-1,i+1]=TRUE) then inc(vizinhos);
			if (((i-largura)<0)and((j-altura)<0)) then if (mundo_.est_atual[j+1,i+1]=TRUE) then inc(vizinhos);
			
			
			//Verifica em qual regra a posi��o analisada se enquadra
			{1� Regra} if (vizinhos<=1) then mundo_.est_futuro[j,i] := FALSE;
			{2� Regra} if ((vizinhos>=2)and(vizinhos<=3)) then mundo_.est_futuro[j,i] := mundo_.est_atual[j,i];
			{3� Regra} if (vizinhos=3) then mundo_.est_futuro[j,i] := TRUE;
			{4� Regra} if (vizinhos>3) then mundo_.est_futuro[j,i] := FALSE;					
 		End;
 		
 	//Atualiza estado do mundo (incrmenta gera��o)
 	mundo_.est_atual := mundo_.est_futuro;
 	
 End;
 
 //Desenha os seres no mundo
 Procedure desenha_mundo(mundo_ : TMundo);
 Var i, j : Integer; //vetores can�nicos
 Begin
 	//Percorre o mundo
 	For j:=1	to altura do
 		For i:=1 to largura do
 		Begin
 			//Caso encontre um ser plota como um '*' verde
 			//caso contr�rio plota o espa�o v�zio como
 			//um '-' azul.
 			if (mundo_.est_atual[j,i]=TRUE) then
 				Begin
 					textcolor(lightgreen);
 					GoToXY(xo+i-1,yo+j-1);
 					Write(animal);
 				End
 				else
 				Begin
 					textcolor(lightblue);
 					GoToXY(xo+i-1,yo+j-1);
 					Write('-');
 				End;
 		End;
 				
 End;
 
 //procedimento de desenho do cursor
 //repinta a posi��o antiga do cursor
 Procedure aponta_cursor(x_, y_ : Integer; dir : TDirecao; mundo_ : TMundo );
 Begin
 	if (mundo_.est_atual[(y_-yo+1),(x_-xo+1)]=TRUE) then textcolor(LightRed)
 	else textcolor(yellow);
	GoToXY(x_,y_);
 	write('+');
 	Case (dir) of
 	cima : Begin
 			if (mundo_.est_atual[(y_-yo+1)+1,(x_-xo+1)]=TRUE) then
 			Begin
 				textcolor(lightgreen);
 				GoToXY(x_,y_+1);
 				Write(animal);
 			End
 			else
 			Begin
 				textcolor(lightblue);
 				GoToXY(x_,y_+1);
 				Write('-');
 			End;	
 		  End;
 	baixo : Begin
 			if (mundo_.est_atual[(y_-yo+1)-1,(x_-xo+1)]=TRUE) then
 			Begin
 				textcolor(lightgreen);
 				GoToXY(x_,y_-1);
 				Write(animal);
 			End
 			else
 			Begin
 				textcolor(lightblue);
 				GoToXY(x_,y_-1);
 				Write('-');
 			End;
 		   End;
 	direita : Begin
 			if (mundo_.est_atual[(y_-yo+1),(x_-xo+1)-1]=TRUE) then
 			Begin
 				textcolor(lightgreen);
 				GoToXY(x_-1,y_);
 				Write(animal);
 			End
 			else
 			Begin
 				textcolor(lightblue);
 				GoToXY(x_-1,y_);
 				Write('-');
 			End;
 			End;
 	esquerda : Begin
 				if (mundo_.est_atual[(y_-yo+1),(x_-xo+1)+1]=TRUE) then
 				Begin
 					textcolor(lightgreen);
 					GoToXY(x_+1,y_);
 					Write(animal);
 				End
 				else
 				Begin
 					textcolor(lightblue);
 					GoToXY(x_+1,y_);
 					Write('-');
 				End;
 			 End;
 	End;
 	
 	GoToXY(x_,y_);
 End;
 
 Procedure inverte_est(x_, y_ : Integer; var mundo_ : TMundo);
 Begin
 	mundo_.est_atual[(y_-yo+1),(x_-xo+1)]:= not mundo_.est_atual[(y_-yo+1),(x_-xo+1)];
 End;
 
 Procedure desenha_painel;
 Var i : integer;
 Begin
 	
	 //desenha borda
 	textcolor(white);
 	GoToXY((xo-1),(yo-1));
 	write(#201);
 	GoToXY((xo-1),yo+altura);
 	write(#200);
 	GoToXY(xo+largura,(yo-1));
 	write(#187);
 	GoToXY(xo+largura,yo+altura);
 	write(#188);
 	for i:=xo to (xo+largura-1) do
	 	begin
	 		GoToXY(i,(yo-1));
	 		write(#205);
	 		GoToXY(i,(yo+altura));
	 		write(#205);                        
		end;
	for i:=yo to (yo+altura-1) do
	 	begin
	 		GoToXY((xo-1),i);
	 		write(#186);
	 		GoToXY((xo+largura),i);
	 		write(#186);
		end;	
	//Escreve instru��es
	GoToXY(largura+4,yo);
	write('Conway',#39,'s Game of Life');
	
	GoToXY(largura+4,yo+1);
	write('   *** J.L.O.T. ***');
	
	GoToXY(largura+4,yo+3);
	write('Gera',#135,#198,'o:');
	
	GoToXY(largura+4,yo+5);
	write('Controle: ');
	
	GoToXY(largura+4,yo+6);
	write(#24,', ',#25,', ',#26,', ',#27,' (MOV. CURSOR);');
	
	GoToXY(largura+4,yo+7);
	write('<ESPA',#128,'O> (SETA/RESETA);');
	
	GoToXY(largura+4,yo+8);
	write('<ENTER> (INCREMENTA GER.).');
	
	GoToXY(largura+4,yo+9);
	write('<ESC> (SAIR)');
	
	GoToXY(largura+4,yo+10);
	write('0: Limpa tudo');
	
	GoToXY(largura+4,yo+11);
	write('1: Thunder Bird');
	GoToXY(largura+4,yo+12);
	write('2: The Glider');
	GoToXY(largura+4,yo+13);
	write('3: The Clock');
	
 End;
 
 Procedure thunder_bird(x_,y_ : Integer; var mundo_ : TMundo);
 Var i, j : Integer;//base can�nica 
 Begin
 
 	i := (x_-xo+1);
	j := (y_-yo+1);
	
	//evita estouro de endere�o
	if (((i+2)>largura) or ((j+4)>altura)) then exit;
	
	mundo_.est_atual[j,i] := TRUE;
	mundo_.est_atual[j,i+1] := TRUE;
	mundo_.est_atual[j,i+2] := TRUE;
	mundo_.est_atual[j+2,i+1] := TRUE;
	mundo_.est_atual[j+3,i+1] := TRUE;
	mundo_.est_atual[j+4,i+1] := TRUE;	
 End;
 
 Procedure the_glider(x_,y_ : Integer; var mundo_ : TMundo);
 Var i, j : Integer;//base can�nica 
 Begin
 	
	i := (x_-xo+1);
	j := (y_-yo+1);
	
	//evita estouro de endere�o
	if (((i+2)>largura) or ((j+2)>altura)) then exit;
	
	mundo_.est_atual[j,i] := TRUE;
	mundo_.est_atual[j+1,i+1] := TRUE;
	mundo_.est_atual[j+1,i+2] := TRUE;
	mundo_.est_atual[j+2,i] := TRUE;
	mundo_.est_atual[j+2,i-1] := TRUE;
 End;
 
 Procedure the_clock(x_,y_ : Integer; var mundo_ : TMundo);
 Var i, j : Integer;//base can�nica 
 Begin
 	i := (x_-xo+1);
	j := (y_-yo+1);
	
	//evita estouro de endere�o
	if (((i+11)>largura) or ((j+11)>altura)) then exit;
	
	mundo_.est_atual[j+5,i+6] := TRUE;
	mundo_.est_atual[j+6,i+6] := TRUE;
	mundo_.est_atual[j+7,i+5] := TRUE;
	
	mundo_.est_atual[j+3,i+4] := TRUE;
	mundo_.est_atual[j+3,i+5] := TRUE;
	mundo_.est_atual[j+3,i+6] := TRUE;
	mundo_.est_atual[j+3,i+7] := TRUE;
	
	mundo_.est_atual[j+4,i+8] := TRUE;
	mundo_.est_atual[j+5,i+8] := TRUE;
	mundo_.est_atual[j+6,i+8] := TRUE;
	mundo_.est_atual[j+7,i+8] := TRUE;
	
	mundo_.est_atual[j+8,i+4] := TRUE;
	mundo_.est_atual[j+8,i+5] := TRUE;
	mundo_.est_atual[j+8,i+6] := TRUE;
	mundo_.est_atual[j+8,i+7] := TRUE;
	
	mundo_.est_atual[j+4,i+3] := TRUE;
	mundo_.est_atual[j+5,i+3] := TRUE;
	mundo_.est_atual[j+6,i+3] := TRUE;
	mundo_.est_atual[j+7,i+3] := TRUE;
	
	mundo_.est_atual[j+0,i+4] := TRUE;
	mundo_.est_atual[j+0,i+5] := TRUE;
	mundo_.est_atual[j+1,i+4] := TRUE;
	mundo_.est_atual[j+1,i+5] := TRUE;
	
	mundo_.est_atual[j+4,i+10] := TRUE;
	mundo_.est_atual[j+4,i+11] := TRUE;
	mundo_.est_atual[j+5,i+10] := TRUE;
	mundo_.est_atual[j+5,i+11] := TRUE;
	
	mundo_.est_atual[j+10,i+6] := TRUE;
	mundo_.est_atual[j+10,i+7] := TRUE;
	mundo_.est_atual[j+11,i+6] := TRUE;
	mundo_.est_atual[j+11,i+7] := TRUE;
	
	mundo_.est_atual[j+6,i+0] := TRUE;
	mundo_.est_atual[j+6,i+1] := TRUE;
	mundo_.est_atual[j+7,i+0] := TRUE;
	mundo_.est_atual[j+7,i+1] := TRUE;
	
	
 End;
 
 Procedure exibe_dados;
 Begin
 	textcolor(yellow);
 	if(geracao=0) then
 	Begin
 		GoToXY(largura+13,yo+3);
 		write('         ');
 		GoToXY(largura+13,yo+3);
		write(geracao);
 	End
 	else
 	Begin
 		GoToXY(largura+13,yo+3);
		write(geracao);
 	end;
 End;
 	
 Begin
 	
 	//posi��o inicial do cursor
 	x := (largura div 2)+xo-1;
 	y := (altura div 2)+yo-1;
 	
 	//inicia gera��o
 	geracao := 0;
 	
 	//inicializa
	desenha_painel;
	exibe_dados;
	desenha_mundo(mundo);
	aponta_cursor(x,y,nada,mundo);
	
	repeat
	
		//L� a tecla pressionada
		tecla := readkey;
		
		Case (tecla) of
			#13 : Begin //<ENTER> incrementa gera��o
					incrementa_geracao(mundo);
					desenha_mundo(mundo);
					exibe_dados;
				 End;
			#72 : Begin //<CIMA> move cursor para cima
					y:=y-1;
					if (y<yo) then y:=yo;
					aponta_cursor(x,y,cima,mundo);
				 End;
			#80 : Begin //<BAIXO> move cursor para baixo
					y:=y+1;
					if (y>(yo+altura-1)) then y:=yo+altura-1;
					aponta_cursor(x,y,baixo,mundo);
				 End;
			#75 : Begin //<ESQUERDA> move para esquerda
					x:=x-1;
					if (x<xo) then x:=xo;
					aponta_cursor(x,y,esquerda,mundo);
				 End;
			#77 : Begin //<DIREITA> move cursor para direita
					x:=x+1;
					if (x>(xo+largura-1)) then x:=xo+largura-1;
					aponta_cursor(x,y,direita,mundo);
				 End;
			#32 : Begin //<ESPA�O> inverte estado da posi��o
					inverte_est(x,y,mundo);
					aponta_cursor(x,y,nada,mundo);
				 End;
			'0' : Begin //<0> limpa tudo
					for j:=1 to altura do
						for i:=1 to largura do
							mundo.est_atual[j,i]:=FALSE;
					geracao := 0;
					x := (largura div 2)+xo-1;
 					y := (altura div 2)+yo-1;
					desenha_mundo(mundo);
					exibe_dados;
					aponta_cursor(x,y,nada,mundo);
				 End;
			'1' : Begin //<1> desenha thunder bird
					thunder_bird(x,y,mundo);
				     desenha_mundo(mundo);
				     aponta_cursor(x,y,nada,mundo);
				 End;
			'2' : Begin //<2> desenha the glider
					the_glider(x,y,mundo);
				     desenha_mundo(mundo);
				     aponta_cursor(x,y,nada,mundo);
				 End;
			'3' : Begin //<3> desenha the clock
					the_clock(x,y,mundo);
				     desenha_mundo(mundo);
				     aponta_cursor(x,y,nada,mundo);
				 End;
			
		End;
		 
	until (tecla = #27);
 End.