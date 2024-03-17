// *----------------------------------------------------------------------*
// *  Campo Minado na Unit Graph - v1.0                                   *
// *  Desenvolvido por Gustavo Antoniassi                                 *
// *  Curso de Sistemas de Informa��o, UNIPAR - Umuarama, PR              *
// *  Contato: scripts.gus@gmail.com                                      *
// *======================================================================* 
// * Este c�digo � livre, pode ser editado, reaproveitado e distribu�do,  *
// * desde que se fa�a cita��o ao autor original.                         *
// *----------------------------------------------------------------------*

Program Campo_Minado_Graph ;
uses Graph;            

type type_tabuleiro = array[0..40, 0..30] of char; // Matriz do tabuleiro, com tamanho m�ximo de 40x30

var driver, mode : integer; // Vari�veis da biblioteca Graph
		tabuleiro, tabuleiroMostrar : type_tabuleiro; // Tabuleiro com as minas e o tabuleiro para mostrar ao jogador
		
		metadeX, metadeY : integer; // Metade X e Y da tela
		tamanhoTile, tamanhoTileDesenhar, // Tamanho do tile, quantidade de tiles e de minas
		qtdeTilesX, qtdeTilesY, qtdeMinas : integer; // Ser�o definidos na escoha da dificulade
		dificuldade : integer; // Dificuldade do jogo
		
		cursorX, cursorY : integer; // Posi��o X e Y atual do cursor
		casasReveladas : integer; // Total de casas que foram reveladas                                        
		desenharQuandoRevelar : boolean; // Boolean que decide se vai desenhar casa por casa ou o tabuleiro todo quando revelar
		
		mensagemSaida : string; // Mensagem de sa�da do jogo ("Parab�ns" ou "Que pena")
		mensagemX, mensagemY : integer; // Posi��o X e Y da mensagem de sa�da
		
		saiu : boolean; // Boolean de sa�da do jogo
		
// Desenha um quadrado vazio e sem borda, que pode ser cinza ou amarelo dependendo dos par�metros
procedure desenharTileVazio(x, y : integer; cursor, movimentarCursor : boolean);
var deslocamento : integer; 
begin
	// Pinta o tile de cinza ou amarelo dependendo do par�metro 'cursor'
	if cursor then                   
	  setFillStyle(SolidFill, YELLOW)
	else 
		setFillStyle(SolidFill, LIGHTGRAY);       
		
	// Se estivermos desenhando um tile vazio onde est� ou estava o cursor, temos que tirar
	// 1 pixel de sua �rea, se n�o ele sobrepor� a borda do tile ao lado ou abaixo. 	
	if movimentarCursor then 
		deslocamento:= 1
	else      
		deslocamento:= 0;
		
	// Desenha o tile vazio ap�s o processamento
	bar(x, y, x+tamanhoTileDesenhar-deslocamento, y+tamanhoTileDesenhar-deslocamento);
end;

// Desenha um quadrado com borda, usado como base para os pr�ximos m�todos desenharTile
procedure desenharTileFundo(x, y : integer; cursor : boolean);
begin 
	// Desenha um quadrado cinza vazio
	desenharTileVazio(x, y, cursor, false);
	
	// Desenha a borda
	setColor(DARKGRAY);
	
	// Aqui, usamos line() pois ela � mais r�pida que rectangle() para desenhar a borda do tile
	// bordas horizontais                                                                                                            
	line(x+tamanhoTileDesenhar, y-1, x, y-1); // de cima
	line(x, y+tamanhoTileDesenhar, x+tamanhoTileDesenhar, y+tamanhoTileDesenhar); // de baixo
	
	// bordas verticais                                                                              
	line(x-1, y, x-1, y+tamanhoTileDesenhar); // da esquerda
	line(x+tamanhoTileDesenhar, y, x+tamanhoTileDesenhar, y+tamanhoTileDesenhar); // da direita
end;

// Desenha um tile com uma mina dentro. Quando explodiu � true, o fundo da mina � pintado de vermelho
procedure desenharMina(x, y : integer; explodiu : boolean);
var raio, deslocamento : integer;
begin	
	// Pinta o fundo de vermelho 
	if explodiu then
	begin
		setFillStyle(SolidFill, LIGHTRED);
		bar(x, y, x+tamanhoTileDesenhar, y+tamanhoTileDesenhar);
	end
	else
	begin
		desenharTileFundo(x, y, false);
	end;
	
	// Tamanho geral da mina (contando com espinhos)
	raio:= int(tamanhoTileDesenhar*0.4);
	
	// Vari�vel necess�ria para deixar os espinhos em 45� levemente menores que os outros
	deslocamento:= int(raio*0.41);
	
	// Centralizar X e Y
	x:= x + int(tamanhoTileDesenhar/2); 
	y:= y + int(tamanhoTileDesenhar/2);
	
	// Espinhos em 90�
	setColor(RED);
	pieSlice(x, y+raio, 80, 100, raio); 
	pieSlice(x+raio, y, 170, 190, raio);
	pieSlice(x, y-raio, 260, 280, raio);
	pieSlice(x-raio, y, 350, 370, raio);  
	
	// Espinhos em 45�
	pieSlice(x-raio+deslocamento, y+raio-deslocamento, 35, 55, raio); 
	pieSlice(x+raio-deslocamento, y+raio-deslocamento, 123, 145, raio); 
	pieSlice(x+raio-deslocamento, y-raio+deslocamento, 215, 235, raio); 
	pieSlice(x-raio+deslocamento, y-raio+deslocamento, 305, 325, raio); 
	 
	// C�rculo principal 
	setColor(BLACK);
	sector(x, y, 0, 360, int(raio*0.5), int(raio*0.5));  
	
	// Brilho 	
	setColor(WHITE);
	sector(x+int(raio*0.2), y-int(raio*0.2), 0, 360, int(raio*0.15), int(raio*0.1));  
end;

// Desenhar um tile com uma bandeira dentro. Basicamente 2 ret�ngulos vermelhos.
procedure desenharBandeira(x, y : integer; cursor : boolean);
begin
	desenharTileFundo(x, y,  cursor);
 	setFillStyle(SolidFill, LIGHTRED);
	bar(x+int(tamanhoTileDesenhar*0.25), y+int(tamanhoTileDesenhar*0.2), x+int(tamanhoTileDesenhar*0.3), y+int(tamanhoTileDesenhar*0.8));
	bar(x+int(tamanhoTileDesenhar*0.25), y+int(tamanhoTileDesenhar*0.26), x+int(tamanhoTileDesenhar*0.75), y+int(tamanhoTileDesenhar*0.55));
end;

// Desenhar um tile com um char dentro.
procedure desenharTileCarac(x, y : integer; carac : char; cor : integer; cursor : boolean);
begin
	desenharTileFundo(x, y, cursor);
	setTextStyle(SmallFont, HorizDir, int(tamanhoTile*0.5)); 
 	setTextJustify(CenterText, CenterText);
	setColor(cor);
	// 0.1 na posi��o y � s� at� arrumar o bug da centraliza��o vertical, deveria ser *0.5
 	outTextXY(x + int(tamanhoTileDesenhar*0.5), y + int(tamanhoTileDesenhar*0.1), carac);
end;

// Procedure que vai ser chamada no jogo, e que vai escolher qual procedure de desenhar ser� chamada.
procedure desenharTile(x, y : integer; carac : char; cursor, movimentarCursor : boolean);
var cor : integer;
begin
	x:= x * tamanhoTile;
	y:= y * tamanhoTile;
	
	// Escolher a cor com base no caractere passado
	case carac of
		'1' : cor:= LIGHTBLUE;
		'2' : cor:= GREEN;
		'3' : cor:= LIGHTRED;
		'4' : cor:= BLUE;
		'5' : cor:= RED;
		'6' : cor:= CYAN;
		'7' : cor:= MAGENTA;
		'8', '?' : cor:= BLACK;
	end;
	
	// Escolher qual procedure chamar
	case carac of
		'0' : desenharTileVazio(x, y, cursor, movimentarCursor);
		'1'..'8' : desenharTileCarac(x, y, carac, cor, cursor);
		'?' : desenharTileCarac(x, y, carac, cor, cursor);
		'!' : desenharBandeira(x, y, cursor);
		'*' : desenharMina(x, y, cursor);
	end;
end;

// Desenha o fundo das mensagens, centralizado na tela
procedure desenharFundoCentralizado(largura, altura, cor : integer);
begin
	mensagemX:= int(metadeX-(largura/2));
	mensagemY:= int(metadeY-(altura/2));
	
	// fundo
	setFillStyle(SolidFill, cor);
	bar(mensagemX, mensagemY, mensagemX + largura, mensagemY + altura);
	
	// borda
	setColor(BLACK);
	rectangle(mensagemX + 3, mensagemY + 3, mensagemX + largura - 3, mensagemY + altura - 3);
end;

// Desenha uma string formatada, pulando uma linha quando acha um '\n'
procedure desenharTexto(x, y, alturaLinha : integer; texto : string);
var contCarac, contLinhas : integer; // Contadores de caracteres passados e de linhas impressas
		strTemporaria : string; // String tempor�ria que armazenar� cada linha
begin
	// Resetar as vari�veis por seguran�a
	contCarac:= 1; contLinhas:= 0; strTemporaria:= '';                                           				
	// Se o par�metro da altura for 0, usar a altura natural do texto
	if alturaLinha = 0 then alturaLinha:= textHeight(texto);
	
	// Loop que vai repetir por todos os caracteres do texto passado
	while contCarac <= length(texto) do
	begin
		// Se detectarmos um caractere de barra, teremos que verificar o pr�ximo caractere pra saber qual a��o tomar
		if (texto[contCarac] = '\') then
		begin
			// Se o pr�ximo caractere for uma barra, seguindo de um n ('\\n'), significa que � um \n escapado, portanto agir normalmente
			if ((texto[contCarac+1] = '\') and (texto[contCarac+2] = 'n')) then
			begin
				// Pular os tr�s caracteres do \\n
				contCarac:= contCarac+3;
				// Adicionar o \n na string, sem a primeira barra
				strTemporaria:= strTemporaria + '\n';
			end
			// Se o pr�ximo caractere for um n ('\n'), ent�o � um linebreak
			else if (texto[contCarac+1] = 'n') then
			begin
				// Escrever a string que obtemos at� aqui na tela
				outTextXY(x, y + (alturaLinha * contLinhas), strTemporaria);
				// Resetar a string tempor�ria, j� que come�aremos uma nova linha
				strTemporaria:= '';
				contLinhas:= contLinhas + 1;			
				contCarac:= contCarac + 2; // +2 pra pular o '\' e o 'n', e ir pro pr�ximo caractere depois deles
			end               
			// Se for s� uma barra no meio do texto, agir normalmente
			else
			begin
				strTemporaria:= strTemporaria + texto[contCarac];
				contCarac:= contCarac + 1;	
			end;
		end
		// Se n�o for uma \, vai jogando os caracteres na strTempor�ria at� chegar no linebreak.
		else
		begin
			strTemporaria:= strTemporaria + texto[contCarac];
			contCarac:= contCarac + 1;
		end;
	end;
	// Printar a �ltima linha, caso a string n�o termine com um '\n'		
	outTextXY(x, y + (alturaLinha * contLinhas), strTemporaria);
end;

// Desenha o cursor para alternar n op��es verticais
procedure alternarOpcoes(x, y, largura, altura, numOpcoes, indice : integer);
var i : integer;
begin		
		// Desenha um fundo cinza em todas as op��es
		setFillStyle(SolidFill, DARKGRAY);
		for i:= 0 to numOpcoes-1 do
		begin
			bar(x, y + (altura * i), x + largura, y + (altura * i) + altura); 	
		end;
		
		// Desenha um fundo amarelo em cima da op��o que est� em 'indice'
		setFillStyle(SolidFill, YELLOW);
		bar(x, y + (altura * indice), x + largura, y + (altura * indice) + altura);
end;

// Desenha o cursor para alternar duas op��es horizontais, 'Sim' e 'N�o'
procedure alternarOpcoesSimOuNao(bool : boolean);
var simX, naoX, posY, largura, altura : integer;
begin
		largura:= 20;
		altura:= 20;
		
		simX:= mensagemX + int(480/2) - 50;
		naoX:= mensagemX + int(480/2) + 50;
		posY:= mensagemY + int(96/2) + 14;
		
		// Se for 'Sim', desenhar o cursor � esquerda
		if bool then
		begin
			setFillStyle(SolidFill, YELLOW);
			bar(simX-22, posY, simX+20, posY+20);                          
			setFillStyle(SolidFill, DARKGRAY);
			bar(naoX-22, posY, naoX+20, posY+20);
		end
		else
		// Se for 'N�o', desenhar o cursor � direita
		begin
			setFillStyle(SolidFill, YELLOW);
			bar(naoX-22, posY, naoX+20, posY+20);                          
			setFillStyle(SolidFill, DARKGRAY);
			bar(simX-22, posY, simX+20, posY+20); 
		end;
		
		// Desenhar os dois textos com uma barra no meio
 		outTextXY(simX, posY, 'Sim');
		outTextXY(mensagemX + int(480/2), posY, '/'); 
 		outTextXY(naoX, posY, 'N�o');
end;

// Verifica uma �rea 3 de 9 tiles est� intercedendo com uma coordenada X e Y, e retorna true ou false dependendo do resultado
function verificar3x3(x, y, valorX, valorY:integer):boolean;
var i, j : integer;
begin    
	// Verifica as coordenadas (x-1, y-1), (x-1, y), (x, y-1), (x, y), (x+1, y), (x, y+1) e (x+1, y+1)
	for i:= -1 to 1 do
	begin
		for j:= -1 to 1 do
		begin
			if (x+i = valorX) and (y+j = valorY) then
			begin
				verificar3x3:= true;
				exit;
			end		
		end;
	end;
	// Se chegou at� aqui, quer dizer que as coordenadas n�o intercederam
	verificar3x3:= false; 
end;

// Criar as minas do tabuleiro (chamado apenas depois da primeira casa revelada)
procedure criarMinas();
var i, k, l, x, y : integer;
begin
	// Criar as minas no tabuleiro
  for i:= 1 to qtdeMinas do
  begin
  	// Gerar uma casa X e Y entre 1 e o tamanho do tabuleiro
    x:= Random(qtdeTilesX);
    y:= Random(qtdeTilesY);
       
    // Evita minas em uma �rea de 3x3 ao redor do primeiro "clique" do jogador
    if (tabuleiro[x][y] = '*') or verificar3x3(x, y, cursorX, cursorY) then
    begin
			i := i - 1; // "ignorar" essa passada e repetir novamente
    	continue;
		end
		else // Colocar a mina no tabuleiro
    begin
			// Em todas as casas ao redor da mina, adicionar 1 ao n�mero da casa
		 	for k:= -1 to 1 do
			begin
				for l:= -1 to 1 do
					begin
						// Evitar um valor menor que 1 para n�o sair do limite da array
						if (x+k >= 0) and (y+l >= 0)
						// Evitar um valor maior que o TAM, para n�o estourar o limite da array
						and (x+k < qtdeTilesX) and (y+l < qtdeTilesY)
						// Evitar processar uma mina   
						and (tabuleiro[x+k][y+l] <> '*') then
							// Aqui, convertemos o caractere em numeral com a fun��o ord,
							// depois adicionamos +1 ao n�mero e usamos como �ndice na array casas
							tabuleiro[x+k][y+l]:= chr(ord(tabuleiro[x+k][y+l])+1);
					end;
			end; 	
			tabuleiro[x][y] := '*'; // Colocar a mina na posi��o x, y
    end;
  end;
end;

// Cria e inicializa os tabuleiros com os caracteres padr�es
procedure criarTabuleiros();
var i, j : integer;
begin
	for i:= 0 to qtdeTilesX-1 do
	begin
		for j:= 0 to qtdeTilesY-1 do
		begin
			tabuleiro[i][j]:= '0';
			tabuleiroMostrar[i][j]:= '?';
		end;
	end;
end;

// Desenha o tabuleiro passado como par�metro
procedure desenharTabuleiro(tabuleiro : type_tabuleiro);
var i, j : integer;
begin
	for i:= 0 to qtdeTilesX-1 do
	begin
		for j:= 0 to qtdeTilesY-1 do
		begin
			desenharTile(i, j, tabuleiro[i][j], false, false);
		end;
	end;
end; 


// Declara��o necess�ria para fazer a recurs�o m�tua
procedure revelar(x,y:integer); forward;

// Se a casa for '?', revela o que tem dentro dela
procedure revelarCasa(x, y : integer);
begin
	// Se a posi��o x, y no tabuleiroMostrar n�o for um '?', ent�o a casa j� foi revelada
  if (tabuleiroMostrar[x][y] <> '?') then exit; 
  
  // Se n�o for uma mina, revelamos a casa
  if (tabuleiro[x][y] <> '*') then
  begin
  	tabuleiroMostrar[x][y] := tabuleiro[x][y];			
  	casasReveladas:= casasReveladas + 1;               
		
		// Desenhamos a casa revelada instantaneamente, dependendo da vari�vel desenharQuandoRevelar  
		if (desenharQuandoRevelar) then
		begin
			desenharTile(x, y, tabuleiroMostrar[x][y], false, false);
		end;
  end; 
  
  // Se � uma casa vazia, tentar revelar a pr�xima 
	if (tabuleiro[x][y] = '0') then
  begin
    revelar(x, y);
  end 
end;

// Revela todas as casas em uma �rea de 3x3 at� que acabem as casas a ser reveladas
procedure revelar(x, y : integer);
 var i, j : integer;
begin
  if (tabuleiro[x][y] = '0') then
  begin
  	// Fazer os bloqueios para evitar sair da faixa da array
  	if (x+1 > qtdeTilesX) then x:= qtdeTilesX-1
		else if (x-1 < 0) then x:= 1;
		
		if (y+1 > qtdeTilesY) then y:= qtdeTilesY-1
		else if (y-1 < 0) then y:= 1;
		
	  // Revelar todas as casas ao redor de (x, y)
	  for i:= -1 to 1 do
	  begin
	  	for j:= -1 to 1 do
	  	begin
	  		revelarCasa(x-i, y-j);
	  	end;
	  end;
	 end 
	// Se n�o for uma casa vazia, s� revelar o n�mero/mina/etc   	
 	else 
	begin
 			revelarCasa(x, y);
 	end;
end;

// Soma a casa passada com +1, fazendo os testes necess�rios
function casaMaisUm(cursor : integer; direcao : string):integer;
var tamMax : integer;
begin	
	// Definir o tamanho m�ximo dependendo da string 'direcao' passada por par�metro
	if direcao = 'vertical' then tamMax:= qtdeTilesY
	else tamMax:= qtdeTilesX;
	
	// Se o cursor estiver na �ltima casa, voltar ele para a primeira, se n�o, ir para a pr�xima casa
	if cursor >= tamMax-1 then
	  casaMaisUm := 0
	else
	  casaMaisUm := cursor + 1
end;

// Subtrai a casa passada com -1, fazendo os testes necess�rios
function casaMenosUm(cursor : integer; direcao : string):integer;
var tamMax : integer;
begin
	// Definir o tamanho m�ximo dependendo da string 'direcao' passada por par�metro
	if direcao = 'vertical' then tamMax:= qtdeTilesY 
	else tamMax:= qtdeTilesX;
	
  // Se o cursor estiver na �ltima casa, voltar ele para a primeira, se n�o, ir para a pr�xima casa
  if cursor <= 0 then
  	casaMenosUm := tamMax - 1
  else
  	casaMenosUm := cursor - 1
end;

// Loop principal do jogo, que vai gerenciar os movimentos do jogador
procedure gerenciarCursor();
var tecla : char; sair : boolean;
begin
	repeat
		// Se o jogador revelou todas as casas
	  if (casasReveladas >= (qtdeTilesX * qtdeTilesY) - qtdeMinas) then
	  begin
	  	// Mensagem que vai ser mostrada ao jogador
	  	mensagemSaida:= 'Parab�ns! Voc� ganhou o jogo!';
	  	desenharTabuleiro(tabuleiro);
	  	break;
	  end;
	  
		tecla:= readkey();
		
		// Aqui pintamos a casa onde o cursor estava de cinza, para poder mov�-lo
		desenharTile(cursorX, cursorY, tabuleiroMostrar[cursorX][cursorY], false, true);
		
		case upcase(tecla) of
			#0 : case readkey of // Teclas direcionais, mover cursor                                    
				#72 : cursorY:= casaMenosUm(cursorY, 'vertical'); // Cima
		  	#80 : cursorY:= casaMaisUm(cursorY, 'vertical'); // Baixo
		  	#75 : cursorX:= casaMenosUm(cursorX, 'horizontal'); // Esquerda
		  	#77 : cursorX:= casaMaisUm(cursorX, 'horizontal'); // Direita
		  end;
		 	#13 : begin // Enter, revelar casa 
				// Se for uma bandeira ou um n�mero, n�o fazer nada  
		   	if (tabuleiroMostrar[cursorX][cursorY] <> '?') then 
				begin                  
					// Como apagamos o cursor do tile atual ali em cima, aqui precisamos desenhar ele denovo              
					desenharTile(cursorX, cursorY, tabuleiroMostrar[cursorX][cursorY], true, true);
					continue;                                         
				end;
		   	
		   	// Se for o primeiro enter da partida, criar as minas (evita que a primeira casa seja uma mina)
				if (casasReveladas = 0) then
		   	begin
					criarMinas();
		   	end	    	
		   	
		   	// Se a casa clicada for uma mina
		   	else if (tabuleiro[cursorX][cursorY] = '*') then
				begin
					desenharTabuleiro(tabuleiro);
		  		// Depois de desenhar todo o tabuleiro, pintar a mina que o jogador acertou de vermelho
					desenharTile(cursorX, cursorY, tabuleiro[cursorX][cursorY], true, false);
		  		// Mensagem que vai ser mostrada ao jogador
					mensagemSaida:= 'Que pena, voc� acertou uma mina!';
					break;
				end; 
					
				// Aqui n�s vemos se o jogador j� revelou mais de um ter�o das casas. Essa � uma forma de tentar balancear 
				// as coisas, pois revelar o tabuleiro todo demora, mas revelar casa por casa � uma anima��o feia quando 
				// h� v�rias casas em branco para revelar
				if (casasReveladas > qtdeTilesX*qtdeTilesY*0.4) then
					desenharQuandoRevelar := true // Passamos a desenhar casa por casa revelada
				else
					desenharQuandoRevelar := false; // Passamos a desenhar o tabuleiro todo depois que revelar
				
				// Revelar a casa escolhida (vai entrar em recurs�o m�tua at� n�o ter mais nenhuma casa que pode ser revelada)
		   	revelar(cursorX, cursorY);
		   	
		   	if not(desenharQuandoRevelar) then
		   		desenharTabuleiro(tabuleiroMostrar);
		    end;
		    
		    'F', #47 : begin // F ou Insert, colocar uma bandeira
		    	// Se houver uma bandeira, tirar ela 
					if (tabuleiroMostrar[cursorX][cursorY] = '!') then
			    	tabuleiroMostrar[cursorX][cursorY]:= '?'
			    // Se n�o houver uma bandeira, colocar uma
			   	else if (tabuleiroMostrar[cursorX][cursorY] = '?') then
				  		tabuleiroMostrar[cursorX][cursorY]:= '!';
			  end;
			   
			  #27, #8 : begin // Esc ou Backspace, sair do jogo
			  	// Desenhar a mensagem de fim de jogo
					desenharFundoCentralizado(480, 96, DARKGRAY); 
					
					setTextStyle(SansSerifFont, HorizDir, 8); 
			 		setTextJustify(CenterText, CenterText);
					setColor(BLACK);
					// -30 aqui � necess�rio at� consertarem o setTextJustify
					desenharTexto(metadeX, metadeY-30, 0, 'Tem certeza que deseja sair?');
						
					// Desenhar o cursor na op��o 'N�o'
					sair:= false;
					alternarOpcoesSimOuNao(sair);
						
					repeat
						case upcase(readkey) of
							#0 : case readkey of  // Se for uma direcional
							 	#75, #77 : begin // Alternar entre 'Sim' e 'N�o'
										sair:= not(sair);
										alternarOpcoesSimOuNao(sair);	
									end;
							end;
									
							#13 : begin // Se for enter
								if sair then begin // Sair do jogo
									halt(0);
								end
								else begin // Desenhar o tabuleiro por cima da mensagem e continuar o jogo
								  desenharTabuleiro(tabuleiroMostrar);
									break;
								end;
							end;
						end;
					until false;
											
			  end;
			end;
			// Desenhamos o cursor ap�s a movimenta��o
			desenharTile(cursorX, cursorY, tabuleiroMostrar[cursorX][cursorY], true, true);
	until false;
end;

// Gerencia a escolha da dificuldade e retorna um n�mero de 0 a 2 dependendo da escolha
function gerenciarCursorInicioDeJogo():integer;
var cursor : integer; tecla : char;
begin
	setbkcolor(BLACK);
	cleardevice;
		
	desenharFundoCentralizado(480, 320, DARKGRAY); 
	
	// Desenhar texto introdut�rio
	setTextStyle(SansSerifFont, HorizDir, 8); 
 	setTextJustify(CenterText, CenterText);
	setColor(BLACK);
	
	desenharTexto(metadeX, metadeY-150, 0, 
	'O Campo Minado � um jogo aparentemente simples de me-\n' +
	'm�ria e racioc�nio. O objetivo do Campo Minado � virar \n' +
	'todos os quadrados vazios e evitar aqueles que escondem \n' + 
	'minas. Se voc� clicar em uma mina, o jogo terminar�. \n');                 
	
	setColor(BLUE);
	desenharTexto(metadeX, metadeY-50, 0,  
	'Controles: \n' +
	'Setas direcionais - Movimentar o cursor \n' +
	'Enter - Revelar a casa selecionada \n' +
	'F ou / - Sinalizar uma uma poss�vel mina com uma bandeira \n' +
	'Backspace ou Esc - Sair do jogo \n\n');  
	                     
	setColor(BLACK);
	desenharTexto(metadeX, metadeY + 65, 0, 
	'Escolha uma dificuldade: ');
	
	cursor:= 0;
	repeat
		// Desenha o cursor em cima da op��o desejada
  	alternarOpcoes(metadeX-45, metadeY + 87, 90, 18, 3, cursor);
		desenharTexto(metadeX, metadeY + 87, 0, 'F�cil\nModerado\nDif�cil');
 		
		tecla:= readkey();
 		case upcase(tecla) of
 			#0 : case readkey of // Direcionais
	 			#72 : begin // Cima
	 				if cursor = 0 then cursor:= 2
	 				else cursor:= (cursor-1);
				end;
								  	
				#80 : begin // Baixo
					cursor:= (cursor+1) mod 3;
				end;
			end;
 		end;
 	until tecla = #13; // Sair do loop quando pressionar Enter.
 	
 	// Retornar a dificuldade escolhida
 	gerenciarCursorInicioDeJogo:= cursor;
end;

// Gerencia a escolha de jogar novamente ou n�o
function gerenciarCursorFimDeJogo():boolean;
var cursorSaida : boolean; tecla : char;
begin
	desenharFundoCentralizado(480, 96, DARKGRAY); 
	
	// Desenhar a mensagem de fim de jogo	
	setTextStyle(SansSerifFont, HorizDir, 8); 
 	setTextJustify(CenterText, CenterText);
	setColor(BLACK);
	
	// -30 aqui � necess�rio at� consertarem o setTextJustify
	desenharTexto(metadeX, metadeY-30, 0, mensagemSaida + '\n' + 'Deseja jogar novamente?\n');
	
 	cursorSaida:= true;
	alternarOpcoesSimOuNao(cursorSaida);
 		
 	repeat
 		tecla:= readkey();
 		case upcase(tecla) of
			#0 : case readkey of // Direcionais
				#75, #77 : begin
					cursorSaida:= not(cursorSaida);
					alternarOpcoesSimOuNao(cursorSaida);			
				end;
			end; 
 		end;
 	until tecla = #13; // Repetir at� pressionarem Enter
 	
 	// Retornar a op��o escolhida
 	gerenciarCursorFimDeJogo:= cursorSaida;
end;

// Reseta algumas vari�veis no in�cio de jogo e define valores para outras
procedure inicializar(dificuldade : integer);
begin	
	setbkcolor(LIGHTGRAY);
	cleardevice;
	
	// Definir tamanho do tile, quantidade de tiles e quantidade de minas dependendo da dificuldade escolhida
	case dificuldade of 
		0 : begin // F�cil 
			tamanhoTile:= 54;  
			qtdeTilesX:= 12;
			qtdeTilesY:= 9;
			qtdeMinas:= 10;
		end;
		
		1 : begin // M�dia
			tamanhoTile:= 32;
			qtdeTilesX:= 20;
			qtdeTilesY:= 15;
			qtdeMinas:= 30;
		end;
		
		2 : begin // Dif�cil
		  tamanhoTile:= 16;
		  qtdeTilesX:= 40;
			qtdeTilesY:= 30;
			qtdeMinas:= 99;
		end;	
	end;
	
	// Precisamos dessa vari�vel pra desenhar formas exatamente do tamanho do tile                     
	tamanhoTileDesenhar:= tamanhoTile - 1;
	
	// Posicionar o cursor no meio do tabuleiro
	cursorX:= round(qtdeTilesX/2)-1;
	cursorY:= round(qtdeTilesY/2)-1; 	
	
	casasReveladas:= 0;
	
	criarTabuleiros();
	//desenharTabuleiro(tabuleiro);
	desenharTabuleiro(tabuleiroMostrar);
	
	// Pintar o cursor de amarelo no in�cio do jogo
	desenharTile(cursorX, cursorY, '?', true, false);	
end;	
		
Begin
	// Inicializando a tela do Graph
	driver:= Detect;
	initgraph(driver, mode, '');	
	
	if (graphResult <> grOk) then
	begin
		writeln('Erro "', GraphErrorMsg(graphResult), '" ao executar o modo gr�fico.');
		exit;
	end;
	
	metadeX:= int(getMaxX()/2);
	metadeY:= int(getMaxY()/2);
	
	// Desenhar a tela inicial, com um "logotipo"
	setbkcolor(LIGHTGRAY);
	cleardevice();
	
	setTextStyle(DefaultFont, HorizDir, 140); 
 	setTextJustify(CenterText, CenterText);
	setColor(RED);
	desenharTexto(metadeX, metadeY-220, 120, 'Campo\nMinado');
	 
	setTextStyle(SansSerifFont, HorizDir, 10);
	setColor(BLACK);
	OutTextXY(metadeX, 440, 'Pressione qualquer tecla para come�ar...');
	readkey();
	
	// Loop principal do jogo 
	repeat
		// Pegar a dificuldade desejada	
		dificuldade:= gerenciarCursorInicioDeJogo();
		// Inicializar as vari�veis
		inicializar(dificuldade);
		// Chamar o loop principal do jogo
		gerenciarCursor();
		// Perguntar se o jogador quer jogar de novo ou n�o
		saiu:= not(gerenciarCursorFimDeJogo());
	until saiu; 
	
	closeGraph();
End.