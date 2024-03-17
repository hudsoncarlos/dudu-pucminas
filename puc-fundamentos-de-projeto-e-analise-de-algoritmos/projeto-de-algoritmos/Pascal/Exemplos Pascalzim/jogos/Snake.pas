Program Jogo_Snake;
{Nome: Snake
 Autor: GRSá(2013)
 Licença: GNU-GPL}

  Uses Crt{, Windows, MMSystem};

  Const
    POSICAO_HORIZONTAL = 16; //Posicao horizontal da área de movimento do snake;
    POSICAO_VERTICAL = 5; //Posicao vertical da área de movimento do snake;
    DIMENSAO_HORIZONTAL = 50; //Dimensao horizontal da área de movimento do snake;
    DIMENSAO_VERTICAL = 15; //Dimensao vertical da área de movimento do snake;
    AREA_ESPACO = DIMENSAO_HORIZONTAL * DIMENSAO_VERTICAL; //Espaço da área de movimento do snake;

    COR_AREA = BLUE; //Cor do fundo;
    COR_SNAKE = YELLOW; //Cor do snake;
    COR_OBSTACULO = LIGHTRED; //Cor do obstáculo;
    COR_COMIDA = LIGHTGREEN; //Cor da comida

    CARACTERE_SNAKE = #4; //Caracteres que representam cada segmento do snake;
    CARACTERE_OBSTACULO = #219; //Caractere do obstáculo;
    CARACTERE_COMIDA = #15; //Caractere da comida

    TAXA_CRESCIMENTO = 4; //Quantidade de segmentos ganhos a cada comida;

    //DIRETORIO_SONS = '.\SONS';

  Type //Tipo composto por um registro que armazena uma referência a uma posição;
    T_Posicao = record
                  horizontal : integer;
                  vertical : integer;
                end;
  Var
    snake : record
              segmento : array[1..AREA_ESPACO] of T_Posicao; //Armazena em fila as posições dos segmentos do snake;
              quantSegmento : integer; //Quantidade de segmentos visíveis;
              dimensao : integer; //Dimensao desejada do snake;
              direcao : char; //Direção do snake: N, S, L, O;
              atraso : integer; //Atraso do movimento;
            end;

    movimentoLegal : boolean; //Armazerna 'true' caso o último movimento não tenha resultado em colisão;
    posicaoComida : T_Posicao; //Posição da comida;

  {EXIBE UM CARACTERE EM DETERMINDADA POSIÇÃO COM A COR DEFINIDA}
  Procedure DesenhaCaractere (caractere : char;
                              posH, posV,
                              cor: integer);
  Begin
    gotoxy(POSICAO_HORIZONTAL + posH - 1,
           POSICAO_VERTICAL + posV - 1);
    textcolor(cor);
    textbackground(COR_AREA);
    write(caractere);
  End;

  {VERIFICA SE A POSICAO REFERENCIADA COINCIDE COM ALGUM SEGMENTO DO SNAKE, RETORNA 'TRUE' SE SIM}
  Function CoincideCorpo (refHorizontal,
                          refVertical : integer) : Boolean;
    Var
      cont : integer;
  Begin
    for cont := 1 to snake.quantSegmento do
    begin
      if (snake.segmento[cont].horizontal = refHorizontal) and
         (snake.segmento[cont].vertical = refVertical) then
      begin
        CoincideCorpo := true;
        Exit;
      end;
    end;
    CoincideCorpo := false;
  End;

  {CRIA COMIDA EM ALGUMA POSIÇÃO ALEATÉORIA QUE NÃO COINCIDA ALGUM SEGMENTO DO SNAKE, RETORNA A POSIÇÃO ESCOLHIDA}
  Function CriaComida : T_Posicao;
    Var
      posicaoLivre : array[1..AREA_ESPACO] of T_Posicao;
      quantidadePosicaoLivre : integer;
      contH, contV : integer;
      posicaoSorteada : integer;
  Begin
    quantidadePosicaoLivre := 0;
    for contH := 1 to DIMENSAO_HORIZONTAL do
    begin
      for contV := 1 to DIMENSAO_VERTICAL do
      begin
        if not(CoincideCorpo(contH, contV)) then
        begin
          inc(quantidadePosicaoLivre);
          posicaoLivre[quantidadePosicaoLivre].horizontal := contH;
          posicaoLivre[quantidadePosicaoLivre].vertical := contV;
        end;
      end;
    end;
    randomize;
    posicaoSorteada := random(quantidadePosicaoLivre) + 1;
    DesenhaCaractere(CARACTERE_COMIDA,
                     posicaoLivre[posicaoSorteada].horizontal,
                     posicaoLivre[posicaoSorteada].vertical,
                     COR_COMIDA);
    CriaComida := posicaoLivre[posicaoSorteada];
  End;

  {REALIZA O MOVIMENTO DO SNAKE, RETORNA 'TRUE' SE NÃO HOUVER COLISÃO}
  Function MoveSnake : Boolean;
    Const
    COMPENSACAO_OBSTACULO = 45;
    Var
      cont : integer;
      posicaoCandidata : T_Posicao;

    {SUB-FUNÇÃO DE MoveSnake: VERIFICA SE HOUVE COLISÃO COM O PRÓPRIO SNAKE OU OBSTÁCULO}
    Function Colisao(refHorizontal,
                     refVertical : integer) : Boolean;
    Begin
      if (refHorizontal = 0) or
         (refHorizontal > DIMENSAO_HORIZONTAL) or
         (refVertical = 0) or
         (refVertical > DIMENSAO_VERTICAL) or
         CoincideCorpo(refHorizontal, refVertical) then
      begin
        Colisao := true;
      end else
      begin
        Colisao := false;
      end;
    End;

  Begin
	
    posicaoCandidata := snake.segmento[1];

    case snake.direcao of
      'N' : dec(posicaoCandidata.vertical);
      'S' : inc(posicaoCandidata.vertical);
      'L' : inc(posicaoCandidata.horizontal);
      'O' : dec(posicaoCandidata.horizontal);
    end;

    if not(Colisao(posicaoCandidata.horizontal,
                   posicaoCandidata.vertical)) then
    begin

      if snake.quantSegmento < snake.dimensao then
      begin
        inc(snake.quantSegmento);
      end else
      begin
        DesenhaCaractere(#32,
                         snake.segmento[snake.quantSegmento].horizontal,
                         snake.segmento[snake.quantSegmento].vertical,
                         COR_AREA);
      end;

      DesenhaCaractere(CARACTERE_SNAKE,
                       posicaoCandidata.horizontal,
                       posicaoCandidata.vertical,
                       COR_SNAKE);

      for cont := snake.quantSegmento downto 1 + 1 do
      begin
        snake.segmento[cont] := snake.segmento[cont - 1];
      end;

      snake.segmento[1] := posicaoCandidata;

      if (snake.segmento[1].horizontal = posicaoComida.horizontal) and
         (snake.segmento[1].vertical = posicaoComida.vertical) and
         not(snake.quantSegmento = AREA_ESPACO) then
      begin
        //SndPlaySound(concat(DIRETORIO_SONS, '\captura.wav'), SND_ASYNC);
        posicaoComida := CriaComida;
        snake.dimensao := snake.dimensao + TAXA_CRESCIMENTO;
      end;

      MoveSnake := true;
    end else
    begin
      {Compensa curvas frente a obstáculos. Força-se um pequeno atraso nessa circunstância}
      delay(COMPENSACAO_OBSTACULO);
      if keypressed then
      begin
        //SndPlaySound(concat(DIRETORIO_SONS, '\resvalo.wav'), SND_ASYNC);
        MoveSnake := true;
      end else
      begin
        for cont := 1 to snake.quantSegmento do
          DesenhaCaractere(CARACTERE_SNAKE,
                           snake.segmento[cont].horizontal,
                           snake.segmento[cont].vertical,
                           COR_OBSTACULO);
        MoveSnake := false;
      end;
    end;

  End;

  {DESENHA OBSTÁCULOS E INICIA SNAKE}
  Procedure IniciaRodada;
    Var
      posInicialH, posInicialV : integer;
      cont : integer;
  Begin
    textbackground(COR_AREA); clrscr;

    {Desenha as paredes horizontais}
    for cont := 1 to DIMENSAO_HORIZONTAL + 2 do
    begin
      textcolor(COR_OBSTACULO);
      textbackground(COR_AREA);
      gotoxy(POSICAO_HORIZONTAL - 2 + cont, POSICAO_VERTICAL - 1);
      write(CARACTERE_OBSTACULO);
      gotoxy(POSICAO_HORIZONTAL - 2 + cont, POSICAO_VERTICAL + DIMENSAO_VERTICAL);
      write(CARACTERE_OBSTACULO);
    end;
    {Desenha as paredes verticais}
    for cont := 1 to DIMENSAO_VERTICAL + 2 do
    begin
      textcolor(COR_OBSTACULO);
      textbackground(COR_AREA);
      gotoxy(POSICAO_HORIZONTAL - 1, POSICAO_VERTICAL - 2 + cont);
      write(CARACTERE_OBSTACULO);
      gotoxy(POSICAO_HORIZONTAL + DIMENSAO_HORIZONTAL, POSICAO_VERTICAL - 2 + cont);
      write(CARACTERE_OBSTACULO);
    end;

    posInicialH := DIMENSAO_HORIZONTAL div 2;
    posInicialV := DIMENSAO_VERTICAL div 2;

    snake.quantSegmento := 1;
    snake.dimensao := TAXA_CRESCIMENTO;
    snake.direcao := 'L';
    snake.segmento[1].horizontal := posInicialH;
    snake.segmento[1].vertical := posInicialV;

    DesenhaCaractere(CARACTERE_SNAKE,
                     snake.segmento[1].horizontal,
                     snake.segmento[1].vertical,
                     COR_SNAKE);
    movimentoLegal := true;
    posicaoComida := CriaComida;

    gotoxy(1,1);
  End;

{PROGRAMA PRINCIPAL}
Begin
  IniciaRodada;
  //SetConsoleTitle('Snake');
  snake.atraso := 60;
  CursorOff; //Desativa a visualização do cursor;
  repeat
    delay(snake.atraso);

    if (keypressed) then
    begin
      case upcase(readkey) of
         #0: begin
               case upcase(readkey) of
                 #75: if snake.direcao <> 'L' then snake.direcao := 'O'; //ESQUERDA
                 #77: if snake.direcao <> 'O' then snake.direcao := 'L'; //DIREITA
                 #80: if snake.direcao <> 'N' then snake.direcao := 'S'; //BAIXO
                 #72: if snake.direcao <> 'S' then snake.direcao := 'N'; //CIMA
               end;
             end;
        #27: begin
               Exit;
             end;
        'R': begin
               IniciaRodada;
             end;
        #13: begin
               readkey;
             end;
      end;
    end;

    movimentoLegal := MoveSnake;
    textcolor(WHITE); textbackground(COR_AREA);
    gotoxy(POSICAO_HORIZONTAL, POSICAO_VERTICAL - 2);
    write((100 * snake.quantSegmento) div AREA_ESPACO, '%');

    if snake.quantSegmento = AREA_ESPACO then
    begin
      textcolor(WHITE); textbackground(COR_AREA);
      gotoxy(POSICAO_HORIZONTAL, POSICAO_VERTICAL + DIMENSAO_VERTICAL + 1);
      write('JOGO ZERADO :)');
      readkey;
      IniciaRodada;
    end else
    begin
      if not (movimentoLegal) then
      begin
        //SndPlaySound(concat(DIRETORIO_SONS, '\colisao.wav'), SND_ASYNC);
        delay(2500);
        IniciaRodada;
      end;
    end;

  until (false);

End.
