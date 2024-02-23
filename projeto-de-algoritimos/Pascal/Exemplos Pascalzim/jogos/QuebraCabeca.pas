// ----------------------------------------------------------------------------
//
//   Programa: Quebra-Cabeça 
//   Versão: 2.0v
//   Autor : Raphael Augusto        
//   Descrição: Programa que implementa o jogo de quebra-cabeça 
//   Email: computabits@gmail.com
// ----------------------------------------------------------------------------

Program RachaCuca;
Const
   POSICAO_X = 38; // Posiciona o tabuleiro na posição X
   POSICAO_Y = 03; // Posiciona o tabuleiro na posição Y

//    Matriz do campo
//
//    | 1 2 3 |
//    | 4 5 6 |
//    | 7 8 0 |

Var
  tabuleiro : array[1..3, 1..3] of integer; // Matriz do tabuleiro
       sair : boolean;                      // Variável que cria o loop infinito.
    posicao : record                        // Armazena a posição (x, y) do cursor.
       x, y : integer;
    end;

// ----------------------------------------------------------------------------
// Verifica se todas as peças estão nos lugares corretos.
// ----------------------------------------------------------------------------
Function fimDeJogo() : boolean;
begin

  if (tabuleiro[1, 1] = 1) and (tabuleiro[2, 1] = 2) and (tabuleiro[3, 1] = 3) and
     (tabuleiro[1, 2] = 4) and (tabuleiro[2, 2] = 5) and (tabuleiro[3, 2] = 6) and
     (tabuleiro[1, 3] = 7) and (tabuleiro[2, 3] = 8) and (tabuleiro[3, 3] = 0) then
    fimDeJogo := true
  else
    fimDeJogo:= False;
end;

// ----------------------------------------------------------------------------
// Função que embaralhas as peças do jogo.
// ----------------------------------------------------------------------------
Procedure embaralhar();
var
 numAleatorio : integer;                // Variável que armazena os números gerados Aleatoriamente.
      memoria : array[0..8] of boolean; // Array que armazena os valores já sorteados evitando repetições.
         i, j : integer;                // Utilizado para posicionar em cada posição da matriz.
begin

  // Coloca todas as posições como não sorteadas.
  for i := 0 to 8 do
    memoria[i] := false;

  for i := 1 to 3 do
  for j := 1 to 3 do
  begin

    numAleatorio := random(9);
    while memoria[numAleatorio] do  // Gerar um novo numero aleatório para cada posição.
      numAleatorio := random(9);

    tabuleiro[i, j] := numAleatorio;        // Coloca o numero na posição.
    memoria[numAleatorio] := true;  // Marca o numero como já usado para evitar repetições.

  end;
end;

// ----------------------------------------------------------------------------
// Procedimento de desenhar o Tabuleiro e as instruções.
// ----------------------------------------------------------------------------
procedure desenharTabuleiro(x, y : integer);
var i : integer;
begin

	textcolor(White);
  gotoxy(x, y);
  write(#218, #196, #196, #196, #191);
  y := y + 1;
  for i := 1 to 3 do
  begin
    gotoxy(x, y);
    write(#179, '   ', #179);
    y := y + 1;
  end;
  gotoxy(x, y);
  write(#192, #196, #196, #196, #217);

	textcolor(lightGreen);
  gotoxy(34, 1);
  write('Quebra-Cabeça');
  gotoxy(31, 9);
  write(#24, ' Move para cima.');
  gotoxy(31, 10);
  write(#25, ' Move para baixo.');
  gotoxy(29, 11);
  write(#26, ' Move para direita.');
  gotoxy(29, 12);
  write(#27, ' Move para esquerda.');
  gotoxy(19, 13);
  write('Aperte [ESPACE] troca o numero pelo vazio.');
  gotoxy(26, 14);
  write('Aperte R para resetar o jogo.');
  gotoxy(29, 15);
  write('Aperte [ESC] para sair.');

end;

// ----------------------------------------------------------------------------
// Procedimento de desenhar os números.
// ----------------------------------------------------------------------------
procedure desenharNumeros(x, y : integer);
var i, j : integer;
begin

  textcolor(lightgreen);
  textbackground(black);

  for i := 1 to 3 do
  for j := 1 to 3 do
  begin

    gotoxy(x + i, y + j);
    if tabuleiro[i, j] <> 0 then
      write(tabuleiro[i, j])
    else
      write(#1);

  end;
end;

// ----------------------------------------------------------------------------
// Verifica se o cursor esta dentro dos limites da borda.
// ----------------------------------------------------------------------------
Function eBorda( i, j: integer ): boolean ;
Begin

  if (i <=POSICAO_X) or (i >=POSICAO_X + 4) or (j <= POSICAO_Y) or (j >= POSICAO_Y + 4) then
    eBorda := true
  else
    eBorda := false;

End;

// ----------------------------------------------------------------------------
// Procedimento que move o cursor.
// ----------------------------------------------------------------------------
procedure mover(x, y : integer);
var i, j : integer;
begin

  i := posicao.x + x;
  j := posicao.y + y;

  if not eBorda(i, j) then
  begin
    gotoxy(posicao.x, posicao.y);

    if(tabuleiro[posicao.x -POSICAO_X, posicao.y - POSICAO_Y] <> 0)then
      write(tabuleiro[posicao.x -POSICAO_X, posicao.y - POSICAO_Y])
    else
      write(#1);

    textcolor(black);
    textbackground(lightgreen);

    gotoxy(i, j);

    if(tabuleiro[i -POSICAO_X, j - POSICAO_Y] <> 0)then
      write(tabuleiro[i -POSICAO_X, j - POSICAO_Y])
    else
      write(#1);

    textcolor(lightgreen);
    textbackground(black);

    posicao.x := i;
    posicao.y := j;

    gotoxy(1, 1);;

  end;

end;


// ----------------------------------------------------------------------------
// Procedimento que inverte dois números
// ----------------------------------------------------------------------------
Procedure inverter(var a, b : integer);
begin
  
  a := a + b;
  b := a - b;
  a := a - b;

end;

// ----------------------------------------------------------------------------
// Procedimento que inverte dois números
// ----------------------------------------------------------------------------
Function limite(num, min, max : integer) : integer;
begin

  if (num < min) then
    limite := min
  else if (num > max) then
    limite := max
  else
    limite := num;

end;

// ----------------------------------------------------------------------------
// Procedimento que troca a posição de um valor qualquer pelo valor de espaço
// vazio ao lado.
// ----------------------------------------------------------------------------
procedure mudar;
var
  i, j : integer;
        
begin

  i := posicao.x - POSICAO_X;
  j := posicao.y - POSICAO_Y;

  if (tabuleiro[i, j] = 0) then 
    write(#7)
  else if (tabuleiro[i, j] <> 0) then
  begin
  
    if (tabuleiro[limite(i + 1, 1, 3), j] = 0) then
      inverter(tabuleiro[limite(i + 1, 1, 3), j], tabuleiro[i, j])
    else if (tabuleiro[i, limite(j + 1, 1, 3)] = 0) then
      inverter(tabuleiro[i, limite(j + 1, 1, 3)], tabuleiro[i, j])
    else if (tabuleiro[limite(i - 1, 1, 3), j] = 0) then
      inverter(tabuleiro[limite(i - 1, 1, 3), j], tabuleiro[i, j])
    else if (tabuleiro[i, limite(j - 1, 1, 3)] = 0) then
      inverter(tabuleiro[i, limite(j - 1, 1, 3)], tabuleiro[i, j])
  
  end;    

  sair := fimDeJogo();
  desenharnumeros(POSICAO_X, POSICAO_Y);
  mover(0, 0);

end;

// ----------------------------------------------------------------------------
// Inicializa alguns processos fundamentais para o funcionamento do jogo.
// ----------------------------------------------------------------------------
procedure iniciar();
begin

	randomize;
  cursoroff;
      
  embaralhar();
  desenhartabuleiro(POSICAO_X, POSICAO_Y);
  desenharnumeros(POSICAO_X, POSICAO_Y);
      
  sair := false;
      
  posicao.x :=POSICAO_X + 1;
  posicao.y := POSICAO_Y + 1;
      
  gotoxy(1, 1);;
  mover(0, 0);

end;

begin

	iniciar();

  while not sair do
  case upcase(ReadKey) of

    #72 : mover(0, -1);   // seta para cima
    #80 : mover(0, +1);   // seta para baixo
    #77 : mover(+1, 0);   // seta para esquerda
    #75 : mover(-1, 0);   // seta para direita
    #27 : sair := true;   // Sai do loop, terminando o jogo.
    #32 : mudar;          
    'R' : begin

			embaralhar();   // Reseta o jogo
  		desenharnumeros(POSICAO_X, POSICAO_Y);
			mover(0, 0);

		end;
  end;

  // Mostra a mensagem de fim de jogo.
  if fimDeJogo() then
  begin

    clrscr;
    gotoxy(34, 13);
    write('Você conseguiu!');
    delay(5000);

  end;
end.