program WASD_Paint;
 {
 INSTITUTO FEDERAL DA BAHIA - CAMPUS CAMAÇARI
 Curso: Técnico em Informática (TI)
 
 Autor: Hugo Deiró	Data: 21/03/2012
 	- Este programa simula uma tela de desenho;
 	
 	Alteração: Hugo Deiró - 22/03/2012
 		- Início da implementação de novas cores;
 		
 	Alteração: Hugo Deiró - 23/03/2012
 		- Finalização da implementação de novas cores;
 		- Implementação de estrela (*) ao comando E(estrela);
 		
 	Alteração: Hugo Deiró - 26/03/2012
 		- Implementação dos comandos em flecha(seta), Up(Cima), Down(Baixo), Left(Esquerda), Right(Direita).
 	
 	Alteração: Hugo Deiró - 20/04/2012
 		- Inserção no menu superior o comando E (desenhar *);
 		- Correção de Design em cor do menu de comandos;
 }
 var 
 	i, x, y, cor : integer;
 	comando : char;
 	ponto : string;
 	ativa : array[1..18] of boolean;

 procedure texto;
 begin
 	gotoxy(22,2);
	textcolor(14);
	writeln('==== BEM VINDO AO QUADRO DE DESENHOS ====');
	gotoxy(2,3);
	textcolor(10);
	writeln('W/UP - Move para cima;');
	gotoxy(2,4);
	writeln('A/LEFT - Move para esquerda;');
	gotoxy(2,5);
	writeln('S/DOWN - Move para baixo;');
	gotoxy(31,3);
	writeln('D/RIGHT - Move para direita;');
	gotoxy(31,4);
	writeln('B - Borracha;');
	gotoxy(31,5);
	writeln('C - Apaga todo desenho;');
	gotoxy(60,3);
	writeln('F - Encerra;');
	gotoxy(60,4);
	write('E - Desenha ');
	textcolor(15);
	write('*');
	textcolor(10);
	write(';');
	gotoxy(55,5);
	textcolor(8);
	writeln('Desenvolvedor: Hugo Deiró');
	gotoxy(4,27);
	textcolor(9);
	writeln('Azul(1)');
	gotoxy(16,27);
	textcolor(10);
	writeln('Verde(2)');
	gotoxy(28,27);
	textcolor(12);
	writeln('Vermelho(3)');
	gotoxy(43,27);
	textcolor(14);
	writeln('Amarelo(4)');
	gotoxy(58,27);
	textcolor(15);
	writeln('Branco(5)');
	gotoxy(71,27);
	textcolor(13);
	writeln('Rosa(6)');
 end;

 procedure layout;
 begin
 	{-------- Caixa Superior -----------}
 	textcolor(10);
 	for i := 1 to 500 do
 	begin
 		textbackground(0);
 		writeln(' ');
 	end;
 	for i := 2 to 79 do
	begin
		gotoxy(i,1);
		write('_'); 
		gotoxy(i,6);
		write('_');
	end;
	
	for i := 2 to 6 do
	begin
		gotoxy(1,i);
		write('|');
		gotoxy(80,i);
		write('|');
	end;
	{ ------- Caixa Meio ------------}
	
	for i := 2 to 79 do
	begin
		gotoxy(i,7);
		write('_'); 
		gotoxy(i,24);
		write('_');  
	end;
	
	for i := 8 to 24 do
	begin
		gotoxy(1,i);
		write('|');
		gotoxy(80,i);
		write('|');  
	end;
	
	{------- Caixa Inferior ----------}
	
	for i := 2 to 79 do
	begin
		gotoxy(i,25);
		write('_');
		gotoxy(i,29);
		write('_');
	end;
	
	for i := 26 to 29 do
	begin
		gotoxy(1,i);
		write('|');
		gotoxy(80,i);
		write('|');
	end;
	texto;
	{Logo, os movimentos possíveis são de acordo com a caixa menor, não
	podem passar a linha 23 nem da coluna 78}
 end;
 
 procedure movimento;
 begin
 	cor := 0;
 	y := 8;
	x := 2;
	i := 1;
	ponto := ' ';
	
	repeat
		repeat
	     	comando := readkey; //Lê uma tecla qualquer que o usuário insira;
	     	comando := upcase(comando); //Atribui à própria variável o seu valor em caixa alta (pra facilitar o tratamento);
	     	if(comando = #80)then
	     		comando := 'S';
	     	if(comando = #72)then
	     		comando := 'W';
	     	if(comando = #77)then
	     		comando := 'D';
	     	if(comando = #75)then
	     		comando := 'A';
	     until(comando = 'E') or (comando = '1') or (comando = '2') or (comando = '3') or (comando = '4') or (comando = '5') or (comando = '6') or(comando = 'W') or (comando = 'A') or (comando = 'S') or (comando = 'D') or (comando = 'C') or (comando = 'V') or (comando = 'F') or (comando = 'B');
	    	
		{Atribuição de valor para o vetor booleano ativa}
	     ativa[1] := (comando = 'W'); //Move o objeto uma posição acima;
	     ativa[2] := (comando = 'A'); //Move o objeto uma posição pra esquerda;
	     ativa[3] := (comando = 'S'); //Move o objeto uma posição pra baixo;
	     ativa[4] := (comando = 'D'); //Move o objeto uma posição pra direita;
	     ativa[5] := (comando = 'C'); //Limpa o rastro do objeto (Ativa clrscr);;
	     ativa[6] := (comando = 'F'); //Encerra o programa;
	     ativa[7] := (x > 78); //*
	     ativa[8] := (x < 3); //*
	     ativa[9] := (y < 9); //*
	     ativa[10] := (y > 22); //***Garante que o objeto esteja dentro do espaço determinado.
	     ativa[11] := (comando = 'B'); //Deleta o movimento através da mudança de cor para PRETO;
	     ativa[12] := (comando = '1'); //*
	     ativa[13] := (comando = '2'); //*
	     ativa[14] := (comando = '3'); //*
	     ativa[15] := (comando = '4'); //*
	     ativa[16] := (comando = '5'); //*
	     ativa[17] := (comando = '6'); //*****Muda a cor do objeto de acordo com o escolhido;
	     ativa[18] := (comando = 'E'); // Desenha uma estrela;
	     
		if(ativa[1])then //*
	     	y := y - 1;
	     if(ativa[2])then //*
	     	x := x - 1;
	     if(ativa[3])then //*
	     	y := y + 1;
	     if(ativa[4])then //* Muda, a partir das teclas W, A, S, D o valor de X e Y pra mudar também a posição em coordenada cartesiana x(ordenadas)/y(abcissas);
	     	x := x + 1;
	     if(ativa[5] = true)then 	
	     begin
	     	clrscr;
	     	layout;
	     end;
	     if(ativa[7])then
	     begin
	     	write(#7);
	     	x := 78;
	     end;
	     if(ativa[8])then
	     begin
	     	write(#7);
	     	x := 3;
	     end;
	     if(ativa[9])then
	     begin
	     	write(#7);
	     	y := 9;
	     end;
	     if(ativa[10])then
	     begin
	     	write(#7);
	     	y := 22; 	
	     end;
	     if(ativa[11])then
	  		cor := 0;  //*
	     if(ativa[12])then
	     	cor := 9; //*
	     if(ativa[13])then
	     	cor := 10; //*
	     if(ativa[14])then
	     	cor := 12; //*
	     if(ativa[15])then
	     	cor := 14; //*
	     if(ativa[16])then
	     	cor := 15; //*
	     if(ativa[17])then
	     	cor := 13; //****** Muda o valor da variável inteira COR, o textbackground(assim como o textcolor) trabalha com valores inteiros apenas; Quando você escreve "lightred", por exemplo, o compilador muda esse nome para o valor 10.
 	     if(ativa[18])then
 	     begin
 	     	textcolor(15);
 	     	ponto := '*';
 	     end
 	     else
 	     	ponto := ' ';
	     gotoxy(x,y); //Move o objeto "ponto" pra X/Y equivalente.        
	     textbackground(cor);
		write(ponto);
	until(ativa[6]); //Fecha a etapa de desenho;
 end;
 
 begin
 	layout;
 	movimento;
 end.
