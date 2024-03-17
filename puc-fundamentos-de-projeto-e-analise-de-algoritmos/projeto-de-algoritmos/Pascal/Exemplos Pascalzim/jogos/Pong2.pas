Program pong;
{****************************************************************

DESENVOLVIDO POR LYNCON GABRIEL KUSMINSKI
LYNCONGABRIEEEL@GMAIL.COM

Pong foi o primeiro videogame lucrativo da história, dando origem
a um novo setor da indústria. Não possuía gráficos espetaculares
ou jogabilidade excelente, mas foi de importância fundamental na
história do videogame. Foi criado por Nolan Bushnell e Ted Dabney
na forma de um console ligado a um monitor, movido a moedas.

A primeira instalação em um bar de San Francisco, Califórnia,
mostrou aos dois a possibilidade de lucro da criação. Assim,
em 27 de Junho de 1972, a empresa Atari foi fundada.

Desenvolvi o jogo, primeiramente em C++, e após isso portei ele
para o nosso querido PascalZim. O programa é composto por algumas
seções, e constantes. São elas:

larguraTela //define a largura em colunas da tela
alturaTela  //define a largura em colunas da tela

larguraBarra //define a largura em colunas da barra
alturaBarra  //define a largura em linhas da barra
distanciaBarra //define a largura em linhas da barra

tamanhoBola = 1 //define a dimensão da bola (1x1)



PROCEDURE inicio(): inicia as variaveis necessarias;

PROCEDURE meioTela(): calcula o ponto exato da tela a escrever uma string, contando o tamanho da string

PROCEDURE forma(): desenha uma forma na tela

PROCEDURE apresentacao(): apresenta o jogo

PROCEDURE desenharJogo(): desenha o jogo

PROCEDURE nomeJogadores(): lê o nome dos jogadores

PROCEDURE mapearTeclas(): faz o mapeamento das teclas pressionadas

PROCEDURE calcularMovimento(): calcula as posições do jogo

PROCEDURE instrucoes(): dá as intruções do jogo

****************************************************************}

const
//-------------------
larguraTela = 80;
alturaTela = 22 ;
//-------------------
larguraBarra= 1 ;
alturaBarra = 4 ;
distanciaBarra = 4 ;
//-------------------
tamanhoBola = 1 ;
//-------------------
pontos = 10;
//-------------------

var
pontoA, //ponto jogador A
pontoB, //ponto jogador B
localBarraA, //local em linha da Barra A
localBarraB, //local em linha da Barra B
ultimoLocalBarraA, //ultimo local em linha da Barra A
ultimoLocalBarraB:byte; //ultimo local em linha da Barra B

bolaX, //local em coluna da bola
bolaY:real; //local em linha da bola

velocidadeBolaX, //velocidade em coluna da bola
velocidadeBolaY:integer; //velocidade em linha da bola

jogadorA,
jogadorB:String[25]; //armazena os nomes dos jogadores

fimJogo:boolean; //calcula o fim do jogo

{---------------------------------------------------------
O procedure a seguir, inicia as variaveis necessarias para 
o inicio do programa.
----------------------------------------------------------}
procedure inicio();
begin
  localBarraA := int(alturaTela/2);//meio da tela (linha)
  localBarraB := int(alturaTela/2);//meio da tela (linha)
  
  ultimoLocalBarraA := 0;
  ultimoLocalBarraB := 0;
  
  bolaX := larguraTela/2; //meio da tela (coluna)
  bolaY := alturaTela/2;  //meio da tela (linha)
  
  velocidadeBolaX := 1; //velocidade de deslocamento da bola (coluna)
  velocidadeBolaY := 1; //velocidade de deslocamento da bola (linha)
  
  pontoA := 0; //ponto jogador A
  pontoB := 0; //ponto jogador B
  
  fimJogo:=false;

end;

{---------------------------------------------------------
O procedure a seguir, escreve uma string no meio da tela
se baseando nas constantes de comprimento, e no tamanho
da String.

texto: String a ser escrita;
y: linha;
----------------------------------------------------------}
procedure meioTela(texto:String; y:byte);
var
x:byte;
begin
  x:= int ( ( (larguraTela)/2) - (   (length(texto)  /2 )  ) ); //calculo do meio da tela, menos o tamanho da String
  
  gotoxy( x,y); //vamos pro lugar calculado
  
  write(texto); //escrevemos a string
  
end;
  
{---------------------------------------------------------
O procedure a seguir, desenha na tela um quadrado/retan-
gulo, a partir das dimensões dadas quando chamado. Ele
utiliza os caracteres da tabela ASCII para cumprir seu
objetivo.

X: coluna;
Y: linha;
X1: dimensão em colunas;
Y1: dimensão em linhas;
Cor: a cor do quadrado;

OBS: caso as dimensões sejam 1, irá sair um quadrado perfeito.
----------------------------------------------------------}
procedure forma(X,Y,X1,Y1,Cor:byte;preencher:boolean);
Var i,coluna,linha: integer;
begin
  textcolor(cor);
  
  if ((preencher) and (Y1<>1)) then
  begin
    
    
    for linha:=Y+1 to Y1+Y do
    for coluna:=X+1 to X1+X do
    begin
      gotoxy(coluna,linha);
      write(#219);
    end;
  end;
  
  gotoxy(X,Y);
  
  if ((X1=1) and (Y1=1)) then
  begin
    
    Write(#218,#191);
    gotoxy(X,Y+1);
    write(#192,#217);
    
  end
  else
  begin
    
    write(#218);
    
    for i:=1 to X1 do
    write(#196);
    
    textcolor(cor);
    write(#191+#10+#8);
    
    for i:=1 to Y1 do
    write(#179+#10+#8);
    
    textcolor(cor);
    gotoxy(X, Y + 1);
    
    for i:=1 to Y1 do
    write(#179+#10+#8);
    
    write(#192);
    
    textcolor(cor);
    
    for i:=1 to X1 do
    write(#196);
    
    write(#217);
    
    textbackground(black);
    
  end;
end;

{----------------------------------------------
O procedure a seguir, faz a apresentação do
jogo, usando os procedures FORMA, e MEIOTELA.

O jogo só continua após o enter ser pressionado
----------------------------------------------}
procedure apresentacao();
begin
  meioTela('---------------------------------------------------',1); //Escrita meio da tela
  meioTela('----------------------- PONG ----------------------',2); //Escrita meio da tela
  meioTela('---------------------------------------------------',3); //Escrita meio da tela
  meioTela('LGK ENTERPRISES',10); //Escrita meio da tela
  meioTela('Desenvolvido por',12);//Escrita meio da tela
  meioTela('Lyncon Gabriel',14);  //Escrita meio da tela
  meioTela('LYNCONGABRIEEEL@GMAIL.COM',14);  //Escrita meio da tela
  meioTela('Aperte [Enter] para comecar!    ',alturaTela-5);//Escrita meio da tela
  
                                      
  forma(20,alturaTela-6,larguraTela-45,1,lightgreen,false); //Retangulo em volta da String anterior
  
  While not (readkey=#13) do //espera o enter[#13] ser pressionado
   
end;

{-------------------------------------------------
O procedure a seguir, lê o nome dos dois jogadores,
após a leitura do primeiro, ele atualiza o status.
----------------------------------------------}
procedure nomeJogadores();
begin

  meioTela('---------------------------------------------------',1); //Escrita meio da tela
  meioTela('----------------------- PONG ----------------------',2); //Escrita meio da tela
  meioTela('Digite os nomes dos jogadores',3); //Escrita meio da tela
  meioTela('Status: aguardando jogador 1',alturaTela); //Escrita meio da tela
  
  gotoxy(10,10);
  Write('Jogador 1:');
  gotoxy(10,15);
  Write('Jogador 2:');
  
  forma(21,9,25,2,lightgreen,false);  //caixa de texto

  forma(21,14,25,2,lightgreen,false); //caixa de texto
  
  gotoxy(23,10); 
	read(jogadorA);//lemos jogador A
	
	meioTela('Status: aguardando jogador 2',alturaTela); //atualizamos status
	
	gotoxy(23,15); 
	read(jogadorB);//lemos jogador B
	
end;

{------------------------------------------
 O procedure a seguir desenha todos as form
 as do jogo. Barras, Bola, e pontilhados.
 
 Ele também faz o calculo da coluna de escri
 ta dos pontos.
------------------------------------------}
procedure desenharJogo();
var
i,comprimentoPontoA:integer;
begin
  
  forma(distanciaBarra,localBarraA,larguraBarra,alturaBarra,lightgreen,true); //desenha barra A
  
  forma(larguraTela-larguraBarra-distanciaBarra-1,localBarraB,larguraBarra,alturaBarra,lightgreen,true); //desenha barra B
  
  forma(int(bolaX),int(bolaY),tamanhoBola,tamanhoBola,lightgreen,true); //desenha bola
  
  //o for abaixo desenha o prontilhado na tela a cada duas linhas
  
  for i:= 2 to alturaTela-2 do //linha 2 até altura total menos dois
  begin   
    gotoxy(int((larguraTela)/2), i); // meio da tela na linha i
    Write(#178);                     // pontilhado
    
    i:=i+2; // pulamos 2 linhas  
  end;
  
//Abaixo temos um calculo "sujo" pra posição dos pontos na tela
  
  comprimentoPontoA := 5;
  
  if (pontoA > 9) then
  comprimentoPontoA := comprimentoPontoA+6  ;
  
  if (pontoA > 99) then
  comprimentoPontoA := comprimentoPontoA+8 ;
  
  if (pontoA > 999) then
  comprimentoPontoA := comprimentoPontoA+10 ;
  
  if (pontoA > 9999) then
  comprimentoPontoA := comprimentoPontoA+12 ;
  
  gotoxy(int((larguraTela)/2 - pontos - comprimentoPontoA - length(jogadorA)),1); //calculo sujo
  write(jogadorA,': ',pontoA);  //jogador A + pontoA
  
  gotoxy(int((larguraTela)/2 + pontos+1 + (length(jogadorB)/3)),1); //calculo sujo
  write(jogadorB,': ',pontoB); //jogador B + pontoB
  
end;

{--------------------------------------
 Mapeia as teclas necessarias.
--------------------------------------}

procedure mapearTeclas();
begin
  
  if (keypressed) then  //se tecla pressionada
  begin
    case upcase(readkey) of
    
      #0:Begin //se tecla pressionada
        case upcase(readkey) of //ler tecla de novo
        
          #80: inc(localBarraB); //seta baixo, aumentamos a linha da barra B
          #72: dec(localBarraB); //seta cima,  diminuimos a linha da barra B
          
        end;
      end;
      
      '8':dec(localBarraB); //tecla 8, diminuimos a linha da barra B
      '2':inc(localBarraB); //tecla 2, aumentamos a linha da barra B
      
      'S': inc(localBarraA);//tecla S, aumentamos a linha da barra A
      'W': dec(localBarraA);//tecla W, diminuimos a linha da barra B
      
      'R': begin
			      inicio(); //reiniciamos as variaveis;
			      clrscr;
			     end;
      
      #27: fimJogo:=true; //acabamos o jogo
      
      'P': begin
             gotoxy (1,22);
             write('pausado');
             
			       while not ((readkey='p') or (readkey='P')) do ; //não faz nada até que seja despausado 
			       
			       gotoxy (1,22);
 						 write('jogando');
           end;
      
    end;
  end;
  
  if(localBarraA<=1) then //se a posição da barra A for menor que a linha 1
  localBarraA:=1; //travamos na linha atual
  
  if(localBarraA >= alturaTela - alturaBarra) then //se a posição da barra A for maior que a a altura da tela menos o comprimento da barra
  localBarraA:= alturaTela - alturaBarra - 1; //travamos na linha atual
  
  if(localBarraB<=1) then//se a posição da barra B for menor que a linha 1
  localBarraB:=1; //travamos na linha atual
  
  if(localBarraB>=alturaTela - alturaBarra)then //se a posição da barra A for maior que a a altura da tela menos o comprimento da barra
  localBarraB:=alturaTela - alturaBarra-1;//travamos na linha atual
end;

{-----------------------------------------------
 O procedure a seguir é responsavel por todo o 
 calculo do jogo. Ele calcula a posição e veloci
 dade da bola, as posições da barra e a pontuação.
 
 Ele chama o procedure MAPEARTECLAS pra ler as 
 teclas atuais, após isto faz os calculos das 
 variaveis globais.

-----------------------------------------------}
procedure calcularMovimento();
begin
  
  mapearTeclas(); //lemos as teclas
  
  if (localBarraA<>ultimoLocalBarraA) then //se a posição atual da barra A, é diferente da anterior
  forma(distanciaBarra,ultimoLocalBarraA,larguraBarra,alturaBarra,BLACK,true); //apagamos barra A antiga
  
  if (localBarraB<>ultimoLocalBarraB) then //se a posição atual da barra B, é diferente da anterior
  forma(larguraTela-larguraBarra-distanciaBarra-1,ultimoLocalBarraB,larguraBarra,alturaBarra,BLACK,true); //apagamos barra B antiga
  
  forma(int(bolaX),int(bolaY),tamanhoBola,tamanhoBola,BLACK,true); //apagamos a bola anterior
   
  bolaX := bolaX+velocidadeBolaX; //incrementamos a coluna da bola 
  bolaY := bolaY+velocidadeBolaY; //incrementamos a linha da bola 
  

  if ((bolaY >= alturaTela - tamanhoBola-1 ) or (bolaY <=2)) then //condições se a bola for menor que a linha 2 ou maior que a altura da tela
  velocidadeBolaY := velocidadeBolaY*-1; //multiplicamos por menos 1, invertendo sempre o sinal
  
	//colisão com a barra A
  if ((bolaX >= distanciaBarra) and (bolaX <= distanciaBarra+tamanhoBola+alturaBarra-2) and (velocidadeBolaX < 0)) then 
  begin
    if ((bolaY > localBarraA - tamanhoBola) and (bolaY < localBarraA + alturaBarra+1)) then
    begin
      velocidadeBolaX := velocidadeBolaX*-1;
    end;
  end;
  
  //colisão com a barra B
  if ((bolaX >= (larguraTela-3)-larguraBarra-distanciaBarra-tamanhoBola) and (bolaX <= (larguraTela)-distanciaBarra-tamanhoBola) and (velocidadeBolaX > 0)) then
  begin
    if ((bolaY > localBarraB - tamanhoBola) and (bolaY < localBarraB + alturaBarra+1)) then
    begin
      velocidadeBolaX := velocidadeBolaX*-1;
    end;
  end;
  
  
  if ((bolaX >= (larguraTela) - tamanhoBola) or (bolaX <= 1)) then //se "encostar" em alguma das paredes, faz o ponto
  begin
    
    if (velocidadeBolaX > 0) then //se a direção (velocidade) for negativa
    begin
      inc(pontoA); //jogador A pontua
      bolaX := larguraTela / 4;   
    end;
    
    if (velocidadeBolaX < 0) then  //se a direção (velocidade) for positiva
    begin
      inc(pontoB); //jogador B pontua
      bolaX := larguraTela / 4 * 3;
    end;
    
  end;
  
  ultimoLocalBarraA := localBarraA; //salvamos barra A
  ultimoLocalBarraB := localBarraB; //salvamos barra B
end;

procedure intrucoes();
begin
 meioTela('Jogador 1       W:Sobe          S: Desce',5);
 meioTela('Jogador 2       8: Sobe         2: Desce',8);
 
 meioTela('Aperte [Enter] para comecar!    ',alturaTela-5);//Escrita meio da tela
  
 forma(20,alturaTela-6,larguraTela-45,1,lightgreen,false); //Retangulo em volta da String anterior
 
 while not (readkey=#13) do // não faz nada até a tecla enter[#13] ser pressionada
end;

Begin
  cursoroff();     //desligamos o cursor
  
  inicio();        //iniciamos as variaveis
             
  apresentacao();  //nos apresentamos
  
  clrscr;          //limpamos a tela
  
  nomeJogadores(); //lemos nomes dos jogadores A e B
  
  clrscr;					 //limpamos a tela
  
  intrucoes();     //instruimos os jogadores
  
  clrscr;
  
  meioTela('P: Pausar -- ESC: Sair -- R: Reiniciar',alturaTela); //Escrita meio da tela
  
  gotoxy (1,22);
  write('jogando');
  
  while not (fimJogo) do   //enquanto o fim de jogo não for detectado (ESC)
  begin    
    calcularMovimento(); //calcula o movimento
    desenharJogo();      //desenha o jogo
    delay(40);           //atrasa
  end;
  
  
end.


