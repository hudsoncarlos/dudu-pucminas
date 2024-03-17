Unit ComponentesInterfaceTexto;

Interface

Type
    PtrString = ^string;
		PtrEvento = procedure(I: byte);
		Fundo = record
        CorFaixa: byte;
        CoordTtl: byte;
				Titulo: PtrString;
    end;
    PtrFundo = ^Fundo;
    Quadro = record
        X: byte;
        Y: byte;
        TamHori: byte;
        TamVert: byte;
        LinhaTitulo: byte;
				Titulo: PtrString;
    end;
    PtrQuadro = ^Quadro;
    Botao = record
        X: byte;
        Y: byte;
        Largura: byte;
        Status: byte;
        CoordTtl: byte;
        Titulo: PtrString;
        Evento: PtrEvento;
    end;
    PtrBotao = ^Botao;
    ListBotao = record
        I: byte;
        Lin: byte;
        Col: byte;
        IndPadrao: byte;
        TamHori: byte;
        Total: byte;
        PtrBase: PtrBotao;
        PtrOpcao: PtrBotao;
    end;
    PtrListBotao = ^ListBotao;
    Campo = record
        X: byte;
        Y: byte;
        Largura: byte;
        Capacidade: byte;
        Status: boolean;
        Conteudo: PtrString;
    end;
    PtrCampo = ^Campo;
    Elemento = record
        Ante: ^Elemento;
        Prox: ^Elemento;
        Titulo: string;
    end;
    PtrElemento = ^Elemento;
		Lista = record
        X: byte;
        Y: byte;
        I: word;
        J: word;
        TamHori: byte;
        TamVert: byte;
        SelX: byte;
        SelY: byte;
        BarraX: byte;
        BarraY: byte;
        Total: word;
        NoInicio: PtrElemento;
        NoTopo: PtrElemento;
        NoAtual: PtrElemento;
        NoFim: PtrElemento;
    end;
    PtrLista = ^Lista;
    BotaoOpcao = record
        X: byte;
        Y: byte;
        Selecao: boolean;
				Status: boolean;
				Titulo: PtrString;
				Evento: PtrEvento;
		end;
		PtrBotaoOpcao = ^BotaoOpcao;
    ListBotOpc = record
        I: byte;
        Lin: byte;
        Col: byte;
        TamVert: byte;
        Total: byte;
        PtrBase: PtrBotaoOpcao;
        PtrOpcao: PtrBotaoOpcao;
    end;
    PtrListBotOpc = ^ListBotOpc;
    CaixaSelecao = record
        X: byte;
        Y: byte;
        Selecao: boolean;
        Status: boolean;
        Titulo: PtrString;
        Evento: PtrEvento;
    end;
    PtrCaixaSelecao = ^CaixaSelecao;
    ListCxaSel = record
        I: byte;
        Lin: byte;
        Col: byte;
        TamVert: byte;
        Total: byte;
        PtrBase: PtrCaixaSelecao;
        PtrAtual: PtrCaixaSelecao;
    end;
    PtrListCxaSel = ^ListCxaSel;

Var
    Tecla: char;  // Código ASCII da tecla (exemplo: Esc = #27, Enter = #13)

Function novoFundo(CorFaixa: byte; Titulo: PtrString): Fundo;
Procedure desenhaFundo(Fund: PtrFundo);
Function novoQuadro(X, Y, TamHori, TamVert: byte; Titulo: PtrString): Quadro;
Procedure desenhaQuadro(Quad: PtrQuadro);
Function novoBotao(X, Y, Largura, Status: byte; Titulo: PtrString; Evento: PtrEvento): Botao;
Function novaListBotao(IndPadrao, TamHori, Total: byte; PtrBase: PtrBotao): ListBotao;
Procedure desenhaBotao(Bot: PtrBotao);
Procedure desenhaListBotao(List: PtrListBotao);
Procedure habilitaBotao(Bot: PtrBotao);
Procedure desabilitaBotao(Bot: PtrBotao);
Procedure selecionaBotao(Bot: PtrBotao);
Procedure pressionaBotao(Bot: PtrBotao);
Procedure selecionaListBotao(List: PtrListBotao);
Procedure resetaListBotao(List: PtrListBotao);
Function novoCampo(X, Y, Largura, Capacidade: byte; Status: boolean): Campo;
Procedure desenhaCampo(Camp: PtrCampo);
Procedure habilitaCampo(Camp: PtrCampo);
Procedure desabilitaCampo(Camp: PtrCampo);
Procedure digitaCampo(Camp: PtrCampo);
Procedure limpaCampo(Camp: PtrCampo);
Procedure liberaMemCampo(Camp: PtrCampo);
Function novaLista(X, Y, TamHori, TamVert: byte): Lista;
Procedure desenhaLista(List: PtrLista);
Procedure insereFimLista(List: PtrLista; Cadeia: PtrString);
Procedure selecionaLista(List: PtrLista);
Procedure removeSelLista(List: PtrLista);
Procedure resetaLista(List: PtrLista);
Procedure limpaLista(List: PtrLista);
Function novoBotaoOpcao(X, Y: byte; Selecao, Status: boolean; Titulo: PtrString; Evento: PtrEvento): BotaoOpcao;
Function novaListBotOpc(I, TamVert, Total: byte; PtrBase: PtrBotaoOpcao): ListBotOpc;
Procedure desenhaBotaoOpcao(Bot: PtrBotaoOpcao);
Procedure habilitaBotaoOpcao(Bot: PtrBotaoOpcao);
Procedure desabilitaBotaoOpcao(Bot: PtrBotaoOpcao);
Procedure desenhaListBotOpc(List: PtrListBotOpc);
Procedure selecionaListBotOpc(List: PtrListBotOpc);
Procedure setIndListBotOpc(List: PtrListBotOpc; I: byte);
Function novaCaixaSelecao(X, Y: byte; Selecao, Status: boolean; Titulo: PtrString; Evento: PtrEvento): CaixaSelecao;
Function novaListCxaSel(I, TamVert, Total: byte; PtrBase: PtrCaixaSelecao): ListCxaSel;
Procedure desenhaCaixaSelecao(Caixa: PtrCaixaSelecao);
Procedure habilitaCaixaSelecao(Caixa: PtrCaixaSelecao);
Procedure desabilitaCaixaSelecao(Caixa: PtrCaixaSelecao);
Procedure desenhaListCxaSel(List: PtrListCxaSel);
Procedure marcaCaixaSelecao(Caixa: PtrCaixaSelecao);
Procedure selecionaListCxaSel(List: PtrListCxaSel);
Procedure resetaListCxaSel(List: PtrListCxaSel);
Procedure limpaListCxaSel(List: PtrListCxaSel);

Implementation

{------------------------------------------------------------------
 Function novoFundo: inicializa a variável do tipo Fundo.
 ------------------------------------------------------------------}
 Function novoFundo(CorFaixa: byte; Titulo: PtrString): Fundo;
 Var
     Fund: Fundo;
 begin
     Fund.CorFaixa := CorFaixa;
     Fund.CoordTtl := round((80 - length(Titulo^))/2) + 1;
     Fund.Titulo := Titulo;
     novoFundo := Fund;
 end;

{------------------------------------------------------------------
 Procedure desenhaFundo: limpa a tela com a a cor LIGHTGRAY e dese-
 nha uma faixa superior com o título da tela.
 ------------------------------------------------------------------}
 Procedure desenhaFundo(Fund: PtrFundo);
 Var
     I: byte;
     Lim1: byte;
     Lim2: byte;
 begin
     textbackground(LIGHTGRAY);
     textcolor(WHITE);
     Lim1 := Fund^.CoordTtl - 1;

     if(odd(length(Fund^.Titulo^))) then
         Lim2 := Lim1 - 1
     else
         Lim2 := Lim1;    

     clrscr;
     textbackground(Fund^.CorFaixa);
     gotoxy(1, 1);

     for I:=1 to Lim1 do
         write(#32);

     write(Fund^.Titulo^);

     for I:=1 to Lim2 do
         write(#32);
 end;

{------------------------------------------------------------------
 Function novoQuadro: inicializa a variável do tipo Quadro.
 ------------------------------------------------------------------}
 Function novoQuadro(X, Y, TamHori, TamVert: byte; Titulo: PtrString): Quadro;
 Var
     Quad: Quadro;
 begin
     Quad.X := X;
     Quad.Y := Y;
     Quad.TamHori := TamHori;
     Quad.TamVert := TamVert;
     Quad.Titulo := Titulo;
     Quad.LinhaTitulo := TamHori - length(Titulo^) - 2;
     novoQuadro := Quad;
 end;

{------------------------------------------------------------------
 Procedure desenhaQuadro: desenha o quadro na tela.
 ------------------------------------------------------------------}
 Procedure desenhaQuadro(Quad: PtrQuadro);
 Var
     I: byte;
 begin
     textbackground(LIGHTGRAY);
     textcolor(BLACK);

     gotoxy(Quad^.X, Quad^.Y);
     write(#218+#32+Quad^.Titulo^+#32);
     for I:=1 to Quad^.LinhaTitulo do
         write(#196);
     textcolor(WHITE);
     write(#191+#10+#8);
     for I:=1 to Quad^.TamVert do
         write(#179+#10+#8);
     textcolor(BLACK);
     gotoxy(Quad^.X, Quad^.Y + 1);
     for I:=1 to Quad^.TamVert do
         write(#179+#10+#8);
     write(#192);
     textcolor(WHITE);
     for I:=1 to Quad^.TamHori do
         write(#196);
     write(#217);
 end;

{------------------------------------------------------------------
 Function novoBotao: Inicializa a variável do tipo Botao
 ------------------------------------------------------------------}
 Function novoBotao(X, Y, Largura, Status: byte; Titulo: PtrString; Evento: PtrEvento): Botao;
 Var
     Bot: Botao;
 Begin
     Bot.X := X;
     Bot.Y := Y;
     Bot.Largura := Largura;
     Bot.Status := Status;
     Bot.CoordTtl := round((Largura - length(Titulo^))/2) + X + 1;
     Bot.Titulo := Titulo;
     Bot.Evento := Evento;
     novoBotao := Bot;
 End;

{------------------------------------------------------------------
 Function novaListBotao: Inicializa a variável do tipo ListBotao.
 PtrBase recebe o endereço do primeiro elemento de um vetor do tipo
 Botao. IndPadrao definie o índice padrão da lista de botões dese-
 nhados na tela. TamHori define o tamanho horizontal da lista de
 botões, ou seja, o número de botões desenhados lado a lado na te-
 la. Total representa o número de elementos do vetor de botões. Se
 Total é maior que TamHori, os elementos excedentes são considera-
 dos na próxima linha de uma matriz de botões.
 ------------------------------------------------------------------}
 Function novaListBotao(IndPadrao, TamHori, Total: byte; PtrBase: PtrBotao): ListBotao;
 Var
     Cont: byte;
     List: ListBotao;
 Begin
     List.I := IndPadrao;
     List.Lin := IndPadrao div TamHori;
     List.Col := IndPadrao mod TamHori;
     List.IndPadrao := IndPadrao;
		 List.TamHori := TamHori;
     List.Total := Total;
     List.PtrBase := PtrBase;
     inc(PtrBase, IndPadrao);
     PtrBase^.Status := 2;
     List.PtrOpcao := PtrBase;
     novaListBotao := List;
 End;

{------------------------------------------------------------------
 Procedure desenhaBotao: Desenha o botão na tela
 ------------------------------------------------------------------}
 Procedure desenhaBotao(Bot: PtrBotao);
 Var
     C: array[0..5] of char;
     Cor1: byte;
     Cor2: byte;
     I: byte;
 begin
     case(Bot^.Status) of
         0, 1: begin
             C[0] := #218;
             C[1] := #196;
             C[2] := #191;
             C[3] := #179;
             C[4] := #217;
             C[5] := #192;
         end;
         2: begin
             C[0] := #201;
             C[1] := #205;
             C[2] := #187;
             C[3] := #186;
             C[4] := #188;
             C[5] := #200;
         end;
         else
             exit;
     end;

     case(Bot^.Status) of
         0: begin
             Cor1 := DARKGRAY;
             Cor2 := DARKGRAY;
         end;
         1, 2: begin
             Cor1 := WHITE;
             Cor2 := BLACK;
         end;
     end;

     textbackground(LIGHTGRAY);
     textcolor(Cor1);
     gotoxy(Bot^.X, Bot^.Y);
     write(C[0]);
     for I:=1 to Bot^.Largura do
         write(C[1]);
     textcolor(Cor2);
     write(C[2]+#10+#8+C[3]);
     textcolor(Cor1);
     gotoxy(Bot^.X, Bot^.Y + 1);
     write(C[3]+#10+#8+C[5]);
     textcolor(Cor2);
     for I:=1 to Bot^.Largura do
         write(C[1]);
     write(C[4]);
     gotoxy(Bot^.CoordTtl, Bot^.Y + 1);
     write(Bot^.Titulo^);
 end;

{------------------------------------------------------------------
 Procedure desenhaListBotao: Desenha a lista de botões na tela.
 ------------------------------------------------------------------}
 Procedure desenhaListBotao(List: PtrListBotao);
 Var
     I: byte;
     Fim: byte;
     PtrAux: PtrBotao;
 Begin
     if(List^.Total = 0) then
         exit;

     Fim := List^.Total - 1;
		 PtrAux := List^.PtrBase;

		 for I:=0 to Fim do
     begin
         desenhaBotao(PtrAux);
         inc(PtrAux);
		 end;
 End;

{------------------------------------------------------------------
 Procedure habilitaBotao: muda o status do botão para habilitado,
 atualizando seu desenho. Se o botão já tem esse status, nenhuma a-
 ção é tomada.
 ------------------------------------------------------------------}
 Procedure habilitaBotao(Bot: PtrBotao);
 begin
     if(Bot^.Status <> 1) then
     begin
         Bot^.Status := 1;
         desenhaBotao(Bot);
     end;
 end;

{------------------------------------------------------------------
 Procedure desabilitaBotao: muda o status do botão para desabilita-
 do, atualizando seu desenho. Se o botão já tem esse status, nenhu-
 ma ação é tomada.
 ------------------------------------------------------------------}
 Procedure desabilitaBotao(Bot: PtrBotao);
 begin
     if(Bot^.Status <> 0) then
     begin
         Bot^.Status := 0;
         desenhaBotao(Bot);
     end;
 end;

{------------------------------------------------------------------
 Procedure selecionaBotao: muda o status do botão para selecionado,
 atualizando seu desenho. Se o botão já tem esse status, nenhuma a-
 ção é tomada.
 ------------------------------------------------------------------}
 Procedure selecionaBotao(Bot: PtrBotao);
 begin
     if(Bot^.Status <> 2) then
     begin
         Bot^.Status := 2;
         desenhaBotao(Bot);
     end;
 end;

{------------------------------------------------------------------
 Procedure pressionaBotao: desenha o botão de modo que pareça pres-
 sionado, sem alterar, no entanto, seu status. Não foi implementado
 um status de botão pressionado porque, em geral, o seu desenho a-
 parece na transição de telas. 
 ------------------------------------------------------------------}
 Procedure pressionaBotao(Bot: PtrBotao);
 Var
     I: byte;
 begin
     textbackground(LIGHTGRAY);
     textcolor(BLACK);
     gotoxy(Bot^.X, Bot^.Y);
     write(#201);
     for I:=1 to Bot^.Largura do
         write(#205);
     textcolor(WHITE);
     write(#187+#10+#8+#186);
     textcolor(BLACK);
     gotoxy(Bot^.X, Bot^.Y + 1);
     write(#186+#10+#8+#200);
     textcolor(WHITE);
     for I:=1 to Bot^.Largura do
         write(#205);
     write(#188);
     textbackground(BLACK);
     textcolor(LIGHTGRAY);
     gotoxy(Bot^.CoordTtl, Bot^.Y + 1);
     write(Bot^.Titulo^);
     delay(400);
 end;

{------------------------------------------------------------------
 Procedure selecionaListBotao: Permite ao usuário navegar entre li-
 nhas e colunas da matriz de botões, usando as teclas de setas ou
 <TABLE>. Caso <TABLE> seja pressionado e o último botão esteja se-
 cionado, a seleção retorna ao botão padrão da lista e o procedi-
 mento é encerrado. Caso <ENTER> seja pressionado, o desenho do bo-
 tão fica 'pressionado' e o procedimento é encerrado. Caso <ESC>
 seja pressionado, o procedimento é encerrado. Se o total de botões
 da lista é zero, Tecla recebe #0 e o procedimento é encerrado. Es-
 se procedimento não diferencia botões com status de habilitado ou
 desabilitado. Logo, para o tratamento de uma lista com alguns bo-
 tões desabilitadas, será necessária a implementação de um procedi-
 mento personalizado.
 ------------------------------------------------------------------}
 Procedure selecionaListBotao(List: PtrListBotao);
 Var
     IndFim: byte;
		 LimDir: byte;
     LimInf: byte;
     Temp: byte;
     PtrAux1: PtrBotao;
     PtrAux2: PtrBotao;
     Evt: PtrEvento;
 Begin
     if(List^.Total = 0 or not(List^.PtrOpcao^.Status)) then
         exit;

     IndFim := List^.Total - 1;
     LimDir := List^.TamHori - 1;
		 LimInf := IndFim div List^.TamHori;
     PtrAux2 := List^.PtrOpcao;
     PtrAux1 := PtrAux2;
     gotoxy(PtrAux1^.CoordTtl, PtrAux1^.Y+1);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #80:
                         if(List^.Lin < LimInf) then
                         begin
                             Temp := List^.I + List^.TamHori;

                             if(Temp <= IndFim) then
                             begin
                                 inc(List^.Lin);
                                 List^.I := Temp;
                                 inc(PtrAux2, List^.TamHori);
                             end
                             else
                                 continue;
                         end
                         else
                             continue;

                     #77:
                         if((List^.Col < LimDir) and (List^.I < IndFim)) then
                         begin
                             inc(List^.Col);
                             inc(List^.I);
                             inc(PtrAux2);
                         end
                         else
                             continue;

                     #72:
                         if(List^.Lin > 0) then
                         begin
                             dec(List^.Lin);
                             List^.I := List^.I - List^.TamHori;
                             dec(PtrAux2, List^.TamHori);
                         end
                         else
                             continue;

                     #75:
                         if(List^.Col > 0) then
                         begin
                             dec(List^.I);
                             dec(List^.Col);
                             dec(PtrAux2);
                         end
                         else
                             continue;

                     else
                         continue;
                 end;

             #9:
                 if(List^.I < IndFim) then
                 begin
                     inc(List^.I);
                     List^.Lin := List^.I div List^.TamHori;
                     List^.Col := List^.I mod List^.TamHori;
                     inc(PtrAux2);
                 end
                 else begin
                     List^.I := List^.IndPadrao;
										 List^.Lin := List^.IndPadrao div List^.TamHori;
                     List^.Col := List^.IndPadrao mod List^.TamHori;
                     PtrAux2 := List^.PtrBase;
                     inc(PtrAux2, List^.I);
                     PtrAux1^.Status := 1;
                     PtrAux2^.Status := 2;
                     List^.PtrOpcao := PtrAux2;
                     desenhaBotao(PtrAux1);
                     desenhaBotao(PtrAux2);
                     break;
                 end;

             #13:
						 begin
						     List^.PtrOpcao := PtrAux1;
						     Evt := PtrAux1^.Evento;
						     if(@Evt <> nil) then
						         Evt(List^.I)
						     else
						         break;
						 end;

						 #27:
						 begin
						     List^.PtrOpcao := PtrAux1;
                 break;
             end;

						 else
                 continue;
         end;

         PtrAux1^.Status := 1;
				 PtrAux2^.Status := 2;
         desenhaBotao(PtrAux1);
         desenhaBotao(PtrAux2);
         PtrAux1 := PtrAux2;
         gotoxy(PtrAux1^.CoordTtl, PtrAux1^.Y+1);
     end;
 End;

{------------------------------------------------------------------
 Procedure resetaListBotao: O botão atual perde a seleção e o botão
 com índice padrão é selecionado. O procedimento não atualiza o de-
 senho.
 ------------------------------------------------------------------}
 Procedure resetaListBotao(List: PtrListBotao);
 Var
     PtrAux: PtrBotao;
 Begin
     if(List^.I <> List^.IndPadrao) then
     begin
         List^.I := List^.IndPadrao;
         List^.Lin := List^.IndPadrao div List^.TamHori;
         List^.Col := List^.IndPadrao mod List^.TamHori;
         PtrAux := List^.PtrBase;
         inc(PtrAux, List^.IndPadrao);
         PtrAux^.Status := 2;
         List^.PtrOpcao^.Status := 1;
         List^.PtrOpcao := PtrAux;
     end;
 End;

{------------------------------------------------------------------
 Function novoCampo: inicializa a variável do tipo Campo. O parâme-
 tro Capacidade define o tamanho da string que será alocada dinami-
 camente. Esta armazenará os caracteres digitados pelo usuário do
 programa. Antes do programa encerrar, é necessário liberar a memó-
 ria alocada por meio do procedimento liberaMemCampo().
 ------------------------------------------------------------------}
 Function novoCampo(X, Y, Largura, Capacidade: byte; Status: boolean): Campo;
 Var
     Camp: Campo;
 Begin
     Camp.X := X;
     Camp.Y := Y;
     Camp.Largura := Largura;
     Camp.Capacidade := Capacidade;
     Camp.Status := Status;
		 GetMem(Camp.Conteudo, sizeof(char) * (Capacidade + 1));
		 Camp.Conteudo^[0] := #0;
     novoCampo := Camp;
 End;

{------------------------------------------------------------------
 Procedure desenhaCampo: desenha o campo na tela.
 ------------------------------------------------------------------}
 Procedure desenhaCampo(Camp: PtrCampo);
 Var
     I: byte;
     Lim1: byte;
     Lim2: byte;
     Cadeia: PtrString;
 begin
     textbackground(LIGHTGRAY);
     if(Camp^.Status) then
         textcolor(BLACK)
     else
         textcolor(DARKGRAY);

     Cadeia := Camp^.Conteudo;
		 Lim1 := length(Camp^.Conteudo^);
     if(Lim1 > Camp^.Largura) then
     begin
         Lim1 := Camp^.Largura;
         Lim2 := 0;
     end
     else
         Lim2 := Camp^.Largura - Lim1;

     gotoxy(Camp^.X, Camp^.Y);
     write('[');

     for I:=1 to Lim1 do
         write(Cadeia^[I]);
     for I:=1 to Lim2 do
         write(#250);
     write(']');
 end;

{------------------------------------------------------------------
 Procedure habilitaCampo: muda o status do campo para habilitado,
 atualizando o seu desenho. Se o campo já tem esse status, nenhuma
 ação é tomada.
 ------------------------------------------------------------------}
 Procedure habilitaCampo(Camp: PtrCampo);
 begin
     if(not(Camp^.Status)) then
     begin
         Camp^.Status := true;
         desenhaCampo(Camp);
     end;
 end;

{------------------------------------------------------------------
 Procedure desabilitaCampo: muda o status do campo para desabilita-
 do, atualizando o seu desenho. Se o campo já tem esse status, ne-
 nhuma ação é tomada.
 ------------------------------------------------------------------}
 Procedure desabilitaCampo(Camp: PtrCampo);
 begin
     if(Camp^.Status) then
     begin
         Camp^.Status := false;
         desenhaCampo(Camp);
     end;
 end;

{------------------------------------------------------------------
 Procedure digitaCampo: permite ao usuário digitar no campo, caso o
 mesmo esteja habilitado. O procedimento é encerrado caso o usuário
 pressione <ESC>, <TABLE> ou <ENTER>. O código ASCII da tecla pres-
 sionada é transferido à variável global Tecla. Se o campo está de-
 sabilitado, Tecla recebe #0 e o procedimento é encerrado.
 ------------------------------------------------------------------}
 Procedure digitaCampo(Camp: PtrCampo);
 Var
     I: byte;      // Índice da string referente à posição do cursor
     J: byte;      // Índice da string referente ao limite esquerdo do desenho
     K: byte;      // Índice da string referente ao limite direito do desenho
     Cont: byte;   // Contador
     Fim: byte;    // Índice da string referente à última posição 
     Cursor: byte; // Coordenada 'x' do cursor na tela
     Lim1: byte;   // Coordenada 'x' do limite esquerdo do desenho
     Lim2: byte;   // Coordenada 'x' do limite direito do desenho
     Cadeia: PtrString;
 begin
     if(not(Camp^.Status)) then
     begin
         Tecla := #0;
         exit;
     end;

     textbackground(LIGHTGRAY);
     textcolor(BLACK);

     Lim1 := Camp^.X + 1;             // posição após o colchete [
     Lim2 := Camp^.X + Camp^.Largura; // posição antes do colchete ]
     Fim := length(Camp^.Conteudo^);
     I := Fim + 1;                    // índice atual recebe a posição seguinte do fim da string
     Cadeia := Camp^.Conteudo;

     if(I <= Camp^.Largura) then      // se índice atual é menor ou igual ao tamanho do desenho
     begin
         J := 1;
         K := Camp^.Largura;
         Cursor := Camp^.X + I;
         gotoxy(Cursor, Camp^.Y);     // posiciona o cursor logo após o último caractere do campo
     end
     else
     begin
         J := I - Camp^.Largura + 1;
         K := I;
         Cursor := Lim2;
         gotoxy(Lim1, Camp^.Y);

         for Cont:=J to Fim do
             write(Cadeia^[Cont]);    // imprime os últimos caracteres da string
         write(#250+#8);              // o caractere 'ponto centralizado' é, por padrão, impresso na última posição do campo
     end;

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #77:                                // SETA_DIREITA
                         if(I <= Fim) then
                             if(Cursor < Lim2) then
                             begin
                                 inc(I);
                                 inc(Cursor);
                                 gotoxy(Cursor, Camp^.Y);
                                 continue;
                             end
                             else
                             begin
                                 inc(I);
                                 inc(J);
                                 inc(K);
                                 Cont := J;
                                 gotoxy(Lim1, Camp^.Y);
                             end
                         else
                             continue;
                     #75:                                // SETA_ESQUERDA
                         if(Cursor > Lim1) then
                         begin
                             dec(I);
                             dec(Cursor);
                             gotoxy(Cursor, Camp^.Y);
                             continue;
                         end
                         else
                             if(I > 1) then
                             begin
                                 dec(I);
                                 dec(J);
                                 dec(K);
                                 Cont := J;
                             end
                             else
                                 continue;
                     #83:                                // DELETE
                         if(I <= Fim) then
                         begin
                             dec(Fim);
                             delete(Cadeia^, I, 1);
                             Cont := I;
                         end
                         else
                             continue;
                     #71:                                // HOME
                         if(J > 1) then
                         begin
                             I := 1;
                             J := 1;
                             K := Camp^.Largura;
                             Cursor := Lim1;
                             Cont := 1;
                             gotoxy(Lim1, Camp^.Y);
                         end
                         else
                             if(I <> 1) then
                             begin
                                 I := 1;
                                 Cursor := Lim1;
                                 gotoxy(Lim1, Camp^.Y);
                                 continue;
                             end
                             else
                                 continue;
                     #79:                                // END
                         if(Fim >= K) then
                         begin
                             I := Fim + 1;
                             J := I - Camp^.Largura + 1;
                             K := I;
                             Cursor := Lim2;
                             Cont := J;
                             gotoxy(Lim1, Camp^.Y);
                         end
                         else
                             if(I <= Fim) then
                             begin
                                 I := Fim + 1;
                                 Cursor := Lim1 + (I - J);
                                 gotoxy(Cursor, Camp^.Y);
                                 continue;
                             end
                             else
                                 continue;
                     else
                         continue;
                 end;
             #8:                                         // BACKSPACE
                 if(Cursor > Lim1 + 1) then              // se Cursor é maior que a segunda posição
                 begin
                     dec(I);
                     dec(Fim);
                     dec(Cursor);
                     delete(Cadeia^, I, 1);
                     Cont := I;
                     gotoxy(Cursor, Camp^.Y);
                 end
                 else if(Cursor = Lim1 + 1) then         // se Cursor está na segunda posição
                     if(J = 1) then
                     begin
                         dec(I);
                         dec(Fim);
                         dec(Cursor);
                         delete(Cadeia^, I, 1);
                         Cont := 1;
                         gotoxy(Lim1, Camp^.Y);
                     end
                     else
                     begin
                         dec(I);
                         dec(J);
                         dec(K);
                         dec(Fim);
                         delete(Cadeia^, I, 1);
                         Cont := J;
                         gotoxy(Lim1, Camp^.Y);
                     end
                 else                                    // se não, o cursor está na primeira posição
                     if(J > 2) then
                     begin
                         dec(I);
                         dec(Fim);
                         inc(Cursor);
                         J := J - 2;
                         K := K - 2;
                         delete(Cadeia^, I, 1);
                         Cont := J;
                     end
                     else if(J = 2) then
                     begin
                         dec(I);
                         dec(J);
                         dec(K);
                         dec(Fim);
                         delete(Cadeia^, I, 1);
                         Cont := 1;
                     end
                     else
                         continue;

             #9, #13, #27:                               // TABLE, ENTER ou ESC
             begin
                 if(J <> 1) then
                 begin
                     if(Fim > Camp^.Largura) then
                         Fim := Camp^.Largura;
                     gotoxy(Lim1, Camp^.Y);
                     for Cont:=1 to Fim do
                         write(Cadeia^[Cont]);           // imprime os primeiros caracteres da string
                 end;
                 exit;                                   // finaliza o procedimento
             end;
             
             else                                        // se não, a tecla é um caractere alfanumérico
                 if(Fim < Camp^.Capacidade) then
                     if(Cursor < Lim2) then
                     begin
                         inc(Fim);
                         inc(Cursor);
                         insert(Tecla, Cadeia^, I);
                         Cont := I;
                         inc(I);
                     end
                     else
                     begin
                         inc(J);
                         inc(K);
                         inc(Fim);
                         insert(Tecla, Cadeia^, I);
                         inc(I);
                         Cont := J;
                         gotoxy(Lim1, Camp^.Y);
                     end
                 else    
                     continue;
         end;

         if(Fim < K) then
         begin
             for Cont:=Cont to Fim do
                 write(Cadeia^[Cont]);
             write(#250);
         end
         else
             for Cont:=Cont to K do
                 write(Cadeia^[Cont]);
         gotoxy(Cursor, Camp^.Y);
     end;
 end;

{------------------------------------------------------------------
 Procedure limpaCampo: remove todos os caracteres digitados no cam-
 po. A ação é feita apenas na memória, sem atualizar o desenho.
 ------------------------------------------------------------------}
 Procedure limpaCampo(Camp: PtrCampo);
 Begin
     Camp^.Conteudo^[0] := #0;
 End;
 
{------------------------------------------------------------------
 Procedure liberaMemCampo: libera a memória alocada dinamicamente
 para a string do campo.
 ------------------------------------------------------------------}
 Procedure liberaMemCampo(Camp: PtrCampo);
 Begin
     FreeMem(Camp^.Conteudo, sizeof(char) * (Camp^.Capacidade + 1));
 End;

{------------------------------------------------------------------
 Function novaLista: inicializa a variável do tipo Lista.
 ------------------------------------------------------------------}
 Function novaLista(X, Y, TamHori, TamVert: byte): Lista;
 Var
     List: Lista;
 Begin
     List.I := 0;
     List.J := 0;
     List.Total := 0;
     List.X := X;
     List.Y := Y;
     List.TamHori := TamHori;
     List.TamVert := TamVert;
     List.SelX := X + 1;
		 List.SelY := Y + 1;
     List.BarraX := X + TamHori + 1;
     List.BarraY := Y + 2;
     List.NoInicio := nil;
     List.NoTopo := nil;
     List.NoAtual := nil;
     List.NoFim := nil;
     novaLista := List;
 End;

{------------------------------------------------------------------
 Procedure desenhaLista: desenha a lista na tela.
 ------------------------------------------------------------------}
 Procedure desenhaLista(List: PtrLista);
 Var
     Cont: byte;
     Lim: byte;
     PtrAux: PtrElemento;
 begin
     textbackground(LIGHTGRAY);
     textcolor(BLACK);
     Lim := List^.TamVert - 2;

     gotoxy(List^.X, List^.Y);
     write(#218);
     for Cont:=1 to List^.TamHori do
         write(#196);
     textcolor(WHITE);
     write(#191+#10+#8+#24+#10+#8);
     for Cont:=1 to Lim do
         write(#176+#10+#8);
     write(#25);
     textcolor(BLACK);
     gotoxy(List^.X, List^.Y+1);
     for Cont:=1 to List^.TamVert do
         write(#179+#10+#8);
     write(#192);
     textcolor(WHITE);
     for Cont:=1 to List^.TamHori do
         write(#196);
     write(#217);
     gotoxy(List^.BarraX, List^.BarraY);
     write(#219);

     if(List^.Total = 0) then
         exit;

     PtrAux := List^.NoTopo;
     textcolor(BLACK);

     if(List^.Total < List^.TamVert) then
         Lim := List^.Y + List^.Total
     else
         Lim := List^.Y + List^.TamVert;

     for Cont:=List^.Y+1 to Lim do
     begin
         gotoxy(List^.SelX, Cont);
         write(#32+PtrAux^.Titulo);
         PtrAux := PtrAux^.Prox;
     end;

     textbackground(BLACK);
     textcolor(LIGHTGRAY);
     gotoxy(List^.SelX, List^.SelY);
     write(#32+List^.NoAtual^.Titulo);
 end;

{------------------------------------------------------------------
 Procedure insereFimLista: insere um novo elemento no final da lis-
 ta. Cadeia recebe o endereço da string título do elemento. A ação
 é feita apenas na memória, sem atualizar o desenho. Se a string é
 vazia, nenhum elemento é inserido e o procedimento é encerrado.
 ------------------------------------------------------------------}
 Procedure insereFimLista(List: PtrLista; Cadeia: PtrString);
 Var
     Cont: byte;
     Lim: byte;
     PtrAux: PtrElemento;
 begin
     if(length(Cadeia^) = 0) then
         exit;

     GetMem(PtrAux, 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori);
		 if(PtrAux = nil) then
         exit;
		 Lim := List^.TamHori - 1;
		 PtrAux^.Titulo := copy(Cadeia^, 1, Lim);

     for Cont:=length(Cadeia^)+1 to Lim do
         PtrAux^.Titulo[Cont] := #32;

		 PtrAux^.Titulo[0] := chr(Lim);
     PtrAux^.Prox := nil;
		 inc(List^.Total);

     if(List^.Total > 1) then
     begin
         PtrAux^.Ante := List^.NoFim;
         List^.NoFim^.Prox := PtrAux;
         List^.NoFim := PtrAux;
         if(List^.J > 0) then
             List^.BarraY := round(List^.J*(List^.TamVert - 3)/(List^.Total - List^.TamVert)) + List^.Y + 2;
     end
     else begin
         PtrAux^.Ante := nil;
         List^.NoInicio := PtrAux;
         List^.NoTopo := PtrAux;
         List^.NoAtual := PtrAux;
         List^.NoFim := PtrAux;
     end;
 end;

{------------------------------------------------------------------
 Procedure selecionaLista: permite ao usuário selecionar itens da
 lista, pressionando as teclas <SETA_ACIMA>, <SETA_ABAIXO>,
 <PAGE_UP>, <PAGE_DOWN>, <HOME> e <END>. O procedimento é encer-
 rado caso o usuário pressione <ESC>, <TABLE> ou <ENTER>. O código
 ASCII da tecla pressionada é transferido à variável global Tecla.
 Se a lista não possui elementos, Tecla recebe #0 e o procedimento
 é encerrado.
 ------------------------------------------------------------------}
 Procedure selecionaLista(List: PtrLista);
 Label
     ATUALIZA_SELECAO;
 Var
     Cont: byte;
     Temp: longint;
     IndFim: word;
     IndSup: word;
     LimSup: byte;
     LimInf: byte;
     Const1: real;
     Const2: byte;
     PtrAux: PtrElemento;
     PtrSup: PtrElemento;
     PtrInf: PtrElemento;
 Begin
     if(List^.Total = 0) then
     begin
         Tecla := #0;
         exit;
     end;

     IndFim := List^.Total - 1;
     LimSup := List^.Y + 1;
     Temp := List^.Total - List^.TamVert;

     if(Temp <= 0) then
         LimInf := List^.Y + List^.Total
     else
     begin
         IndSup := Temp;
         LimInf := List^.Y + List^.TamVert;
         Const1 := (List^.TamVert - 3)/IndSup;
         Const2 := List^.Y + 2;
         PtrSup := List^.NoFim;
				 PtrInf := List^.NoInicio;
         for Cont:=2 to List^.TamVert do
         begin
             PtrSup := PtrSup^.Ante;
             PtrInf := PtrInf^.Prox;
         end;
     end;

		 gotoxy(List^.SelX, List^.SelY);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #80:
                         if(List^.SelY < LimInf) then
                         begin
                             inc(List^.I);
                             inc(List^.SelY);
                             PtrAux := List^.NoAtual;
                             List^.NoAtual := List^.NoAtual^.Prox;
                             goto ATUALIZA_SELECAO;
                         end
                         else
                             if(List^.I < IndFim) then
                             begin
                                 inc(List^.I);
                                 inc(List^.J);
                                 List^.NoTopo := List^.NoTopo^.Prox;
                                 List^.NoAtual := List^.NoAtual^.Prox;
                             end
                             else
                                 continue;

										 #81:
                     begin
                         Temp := IndSup - List^.J;
                         if(Temp > List^.TamVert) then
                         begin
                             List^.J := List^.J + List^.TamVert;
                             List^.I := List^.J;
                             List^.SelY := LimSup;
                             for Cont:=1 to List^.TamVert do
                                 List^.NoTopo := List^.NoTopo^.Prox;
                             List^.NoAtual := List^.NoTopo;
                         end
                         else
												     if(Temp > 0) then
														 begin
                                 List^.J := IndSup;
                                 List^.NoTopo := PtrSup;
														     if(List^.I >= List^.J) then
                                     List^.SelY := List^.SelY - Temp
                                 else
																 begin
                                     List^.I := List^.J;
                                     List^.SelY := LimSup;
                                     List^.NoAtual := PtrSup;
                                 end;
                             end
                             else
                                 continue;
                     end;

										 #72:
                         if(List^.SelY > LimSup) then
                         begin
                             dec(List^.I);
                             dec(List^.SelY);
                             PtrAux := List^.NoAtual;
                             List^.NoAtual := List^.NoAtual^.Ante;
                             goto ATUALIZA_SELECAO;
                         end
                         else
                             if(List^.I > 0) then
                             begin
                                 dec(List^.I);
                                 dec(List^.J);
                                 List^.NoTopo := List^.NoTopo^.Ante;
                                 List^.NoAtual := List^.NoAtual^.Ante;
                             end
                             else
                                 continue;    

										 #73:
                     begin
                         Temp := List^.J;
                         if(Temp > List^.TamVert) then
                         begin
                             List^.J := List^.J - List^.TamVert;
                             List^.I := Temp - 1;
                             List^.SelY := LimInf;
                             List^.NoAtual := List^.NoTopo^.Ante;
                             for Cont:=1 to List^.TamVert do
                                 List^.NoTopo := List^.NoTopo^.Ante;
                         end
                         else
                             if(Temp > 0) then
                             begin
                                 List^.J := 0;
                                 List^.NoTopo := List^.NoInicio;
                                 if(List^.I < List^.TamVert) then
                                     List^.SelY := List^.SelY + Temp
                                 else
                                 begin
                                     List^.I := List^.TamVert - 1;
                                     List^.SelY := LimInf;
                                     List^.NoAtual := PtrInf;
                                 end;
                             end
                             else
                                 continue;
                     end;

										 #79:
										     if(List^.J < IndSup) then
										     begin
										         List^.J := IndSup;
										         List^.I := IndFim;
										         List^.SelY := LimInf;
										         List^.NoTopo := PtrSup;
										         List^.NoAtual := List^.NoFim;
										     end
										     else
												     if(List^.I < IndFim) then
														 begin
										             List^.I := IndFim;
										             List^.SelY := LimInf;
										             PtrAux := List^.NoAtual;
																 List^.NoAtual := List^.NoFim;
										             goto ATUALIZA_SELECAO;
										         end
										         else
										             continue;

										 #71:
										     if(List^.J > 0) then
										     begin
										         List^.J := 0;
										         List^.I := 0;
										         List^.SelY := LimSup;
										         List^.NoTopo := List^.NoInicio;
										         List^.NoAtual := List^.NoInicio;
										     end
										     else
										         if(List^.I > 0) then
										         begin
										             List^.I := 0;
										             List^.SelY := LimSup;
										             PtrAux := List^.NoAtual;
										             List^.NoAtual := List^.NoInicio;
										             goto ATUALIZA_SELECAO;
										         end
										         else
										             continue;

										 else
                         continue;
                 end;

             #9, #13, #27:
                 exit;

             else
                 continue;
         end;

         Temp := List^.BarraY;
         List^.BarraY := round(List^.J * Const1) + Const2;
				 PtrAux := List^.NoTopo;
				 textbackground(LIGHTGRAY);
         textcolor(BLACK);

         for Cont:=LimSup to LimInf do
         begin
             gotoxy(List^.SelX, Cont);
             write(#32+PtrAux^.Titulo);
             PtrAux := PtrAux^.Prox;
         end;

         textcolor(WHITE);
         gotoxy(List^.BarraX, Temp);
         write(#176);
         gotoxy(List^.BarraX, List^.BarraY);
         write(#219);

         textbackground(BLACK);
         textcolor(LIGHTGRAY);
         gotoxy(List^.SelX, List^.SelY);
         write(#32+List^.NoAtual^.Titulo);
         gotoxy(List^.SelX, List^.SelY);
         continue;

         ATUALIZA_SELECAO:

				 textbackground(LIGHTGRAY);
         textcolor(BLACK);
         write(#32+PtrAux^.Titulo);
         textbackground(BLACK);
         textcolor(LIGHTGRAY);
         gotoxy(List^.SelX, List^.SelY);
         write(#32+List^.NoAtual^.Titulo);
         gotoxy(List^.SelX, List^.SelY);
     end;
 End;

{------------------------------------------------------------------
 Procedure removeSelLista: remove o elemento atualmente selecionado
 na lista, liberando memória alocada e atualizando o desenho.
 ------------------------------------------------------------------}
 Procedure removeSelLista(List: PtrLista);
 Label
     ATUALIZA_LISTA;
 Var
     Cont: byte;
     Temp: byte;
     Lim: byte;
     PtrAux1: PtrElemento;
     PtrAux2: PtrElemento;
 Begin
     if(List^.Total = 0) then
         exit;

     if(List^.Total > List^.TamVert) then
         Lim := List^.Y + List^.TamVert
     else
         Lim := List^.Y + List^.Total - 1;

		 if(List^.I = 0) then  // Se o primeiro elemento está selecionado
     begin
         if(List^.Total > 1) then
         begin
             List^.NoInicio := List^.NoInicio^.Prox;
             FreeMem(List^.NoAtual, 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori);
             List^.NoInicio^.Ante := nil;
             List^.NoTopo := List^.NoInicio;
             List^.NoAtual := List^.NoInicio;
         end
         else begin
             FreeMem(List^.NoAtual, 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori);
             List^.NoInicio := nil;
             List^.NoTopo := nil;
             List^.NoAtual := nil;
             List^.NoFim := nil;
         end;

         dec(List^.Total);
         Cont := List^.Y + 1;
         PtrAux1 := List^.NoTopo;
         goto ATUALIZA_LISTA;
     end
     else begin
         if(List^.I < List^.Total - 1) then  // Se o elemento selecionado não é o último
         begin
             PtrAux1 := List^.NoAtual^.Ante;
             PtrAux2 := List^.NoAtual^.Prox;
             FreeMem(List^.NoAtual, 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori);
             PtrAux1^.Prox := PtrAux2;
             PtrAux2^.Ante := PtrAux1;
         end
         else begin
             PtrAux1 := List^.NoAtual^.Ante;
             FreeMem(List^.NoAtual, 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori);
             List^.NoFim := PtrAux1;
             List^.NoFim^.Prox := nil;
         end;

         if(List^.Total - List^.J > List^.TamVert) then  // Se existem elementos abaixo da lista visível
         begin
             List^.NoAtual := PtrAux2;

             if(List^.I = List^.J) then
                 List^.NoTopo := PtrAux2;

             dec(List^.Total);
             Cont := List^.SelY;
             PtrAux1 := List^.NoAtual;
         end
         else
             if(List^.J > 0) then   // Se existem elementos acima da lista visível
             begin
                 if(List^.I > List^.J) then  // Se o elemento selecionado não está no topo
                     List^.NoTopo := List^.NoTopo^.Ante
                 else
                     List^.NoTopo := PtrAux1;

                 if(List^.I < List^.Total - 1) then  // Se o elemento selecionado não é o último
                 begin
                     inc(List^.SelY);
                     List^.NoAtual := PtrAux2;
                 end
                 else begin
                     dec(List^.I);
                     List^.NoAtual := PtrAux1;
                 end;

                 dec(List^.J);
                 dec(List^.Total);
                 Cont := List^.Y + 1;
                 PtrAux1 := List^.NoTopo;
             end
             else begin
                 if(List^.I < List^.Total - 1) then  // Se o elemento selecionado não é o último
                     List^.NoAtual := PtrAux2
                 else
                 begin
                     dec(List^.I);
                     dec(List^.SelY);
                     List^.NoAtual := PtrAux1;
                 end;
                 
                 dec(List^.Total);
                 Cont := List^.SelY;
                 PtrAux1 := List^.NoAtual;
                 goto ATUALIZA_LISTA;
             end;
     end;

     Temp := List^.BarraY;

     if(List^.J > 0) then
         List^.BarraY := round(List^.J * (List^.TamVert - 3)/(List^.Total - List^.TamVert)) + List^.Y + 2
     else
         List^.BarraY := List^.Y + 2;

     textbackground(LIGHTGRAY);
     textcolor(WHITE);
     gotoxy(List^.BarraX, Temp);
     write(#176);
     gotoxy(List^.BarraX, List^.BarraY);
     write(#219);

     ATUALIZA_LISTA:

		 textbackground(LIGHTGRAY);
     textcolor(BLACK);

     for Cont:=Cont to Lim do
     begin
         gotoxy(List^.SelX, Cont);
         write(#32+PtrAux1^.Titulo);
         PtrAux1 := PtrAux1^.Prox;
     end;

     if(List^.Total < List^.TamVert) then
     begin
         gotoxy(List^.SelX, Lim+1);
         for Cont:=1 to List^.TamHori do
             write(#32);
     end;

     if(List^.Total > 0) then
     begin
         textbackground(BLACK);
         textcolor(LIGHTGRAY);
         gotoxy(List^.SelX, List^.SelY);
         write(#32+List^.NoAtual^.Titulo);
     end;
 End;

{------------------------------------------------------------------
 Procedure resetaLista: move o cursor da lista para o primeiro ele-
 mento, assim como o índice recebe 0 e a barra de rolamento retorna
 à primeira posição. A ação é feita apenas na memória, sem atuali-
 zar o desenho.
 ------------------------------------------------------------------}
 Procedure resetaLista(List: PtrLista);
 Begin
     if(List^.I > 0) then
     begin
         List^.I := 0;
         List^.J := 0;
         List^.SelY := List^.Y + 1;
         List^.BarraY := List^.Y + 2;
         List^.NoTopo := List^.NoInicio;
         List^.NoAtual := List^.NoInicio;
     end;
 End;

{------------------------------------------------------------------
 Procedure limpaLista: remove todos os itens inseridos na lista,
 liberando memória alocada. O procedimento não atualiza o desenho.
 ------------------------------------------------------------------}
 Procedure limpaLista(List: PtrLista);
 Var
     Tamanho: word;
     PtrAux1: PtrElemento;
     PtrAux2: PtrElemento;
 Begin
     if(List^.Total = 0) then
         exit;

     Tamanho := 2 * sizeof(PtrElemento) + sizeof(char) * List^.TamHori;
		 PtrAux1 := List^.NoFim;
     PtrAux2 := List^.NoFim^.Ante;
     FreeMem(PtrAux1, Tamanho);

     while(PtrAux2 <> nil) do
     begin
         PtrAux1 := PtrAux2;
         PtrAux2 := PtrAux2^.Ante;
         FreeMem(PtrAux1, Tamanho);
     end;

     List^.I := 0;
     List^.J := 0;
     List^.Total := 0;
     List^.SelY := List^.Y + 1;
     List^.BarraY := List^.Y + 2;
     List^.NoInicio := nil;
     List^.NoTopo := nil;
     List^.NoAtual := nil;
     List^.NoFim := nil;
 End;

{------------------------------------------------------------------
 Function novoBotaoOpcao: inicializa a variável do tipo BotaoOpcao
 ------------------------------------------------------------------}
 Function novoBotaoOpcao(X, Y: byte; Selecao, Status: boolean; Titulo: PtrString; Evento: PtrEvento): BotaoOpcao;
 Var
     Bot: BotaoOpcao;
 Begin
     Bot.X := X;
     Bot.Y := Y;
     Bot.Selecao := Selecao;
     Bot.Status := Status;
     Bot.Titulo := Titulo;
     Bot.Evento := Evento;
     novoBotaoOpcao := Bot;
 End;

{------------------------------------------------------------------
 Function novaListBotOpc: Inicializa a variável tipo ListBotOpc.
 PtrBase recebe o endereço do primeiro elemento de um vetor do tipo
 BotaoOpcao. I definie o índice do botão inicialmente selecionado
 na lista. TamVert define o tamanho vertical da lista de botões, ou
 seja, o número de botões desenhados de cima para baixo na tela.
 Total representa o número de elementos do vetor. Se Total é maior
 que TamVert, os elementos excedentes são considerados na segunda
 coluna de uma matriz de botões de opção.
 ------------------------------------------------------------------}
 Function novaListBotOpc(I, TamVert, Total: byte; PtrBase: PtrBotaoOpcao): ListBotOpc;
 Var
     List: ListBotOpc;
 Begin
     List.I := I;
     List.Lin := I mod TamVert;
     List.Col := I div TamVert;
     List.TamVert := TamVert;
     List.Total := Total;
     List.PtrBase := PtrBase;
     inc(PtrBase, I);
     List.PtrOpcao := PtrBase;
     List.PtrOpcao^.Selecao := true;
     novaListBotOpc := List;
 End;

{------------------------------------------------------------------
 Procedure desenhaBotaoOpcao: Desenha o botão de opção na tela.
 ------------------------------------------------------------------}
 Procedure desenhaBotaoOpcao(Bot: PtrBotaoOpcao);
 Begin
     textbackground(LIGHTGRAY);
		 if(Bot^.Status) then
         textcolor(BLACK)
     else
         textcolor(DARKGRAY);

		 gotoxy(Bot^.X, Bot^.Y);

		 if(Bot^.Selecao) then
				 write(#40+#248+#41+#32 + Bot^.Titulo^)
     else
				 write(#40+#32+#41+#32 + Bot^.Titulo^);
 End;

{------------------------------------------------------------------
 Procedure habilitaBotaoOpcao: muda o status do botão para habili-
 tado, atualizando seu desenho. Se o botão já tem esse status, ne-
 nhuma ação é tomada.
 ------------------------------------------------------------------}
 Procedure habilitaBotaoOpcao(Bot: PtrBotaoOpcao);
 Begin
     if(not(Bot^.Status)) then
     begin
         Bot^.Status := true;
         desenhaBotaoOpcao(Bot);
     end;
 End;

{------------------------------------------------------------------
 Procedure desabilitaBotaoOpcao: muda o status do botão para desa-
 bilitado, atualizando seu desenho. Se o botão já tem esse status,
 nenhuma ação é tomada.
 ------------------------------------------------------------------}
 Procedure desabilitaBotaoOpcao(Bot: PtrBotaoOpcao);
 Begin
     if(Bot^.Status) then
     begin
         Bot^.Status := false;
         desenhaBotaoOpcao(Bot);
     end;
 End;

{------------------------------------------------------------------
 Procedure desenhaListBotOpc: desenha a lista de botões de opção na
 tela.
 ------------------------------------------------------------------}
 Procedure desenhaListBotOpc(List: PtrListBotOpc);
 Var
     I: byte;
     Fim: byte;
     PtrAux: PtrBotaoOpcao;
 Begin
     if(List^.Total = 0) then
         exit;

     Fim := List^.Total - 1;
		 PtrAux := List^.PtrBase;

		 for I:=0 to Fim do
     begin
         desenhaBotaoOpcao(PtrAux);
         inc(PtrAux);
		 end;
 End;

{------------------------------------------------------------------
 Procedure selecionaListBotOpc: Permite ao usuário navegar entre as
 linhas e colunas da matriz de botões, usando as teclas de setas.
 Caso <TABLE>, <ENTER> ou <ESC> seja pressionado, o procedimento é
 encerrado. Se o total de botões da lista é zero, Tecla recebe #0 e
 o procedimento é encerrado. Esse procedimento não diferencia botõ-
 es com status de habilitado ou desabilitado. Logo, para o trata-
 mento de uma lista com alguns botões desabilitados, será necessá-
 ria a implementação de um procedimento personalizado.
 ------------------------------------------------------------------}
 Procedure selecionaListBotOpc(List: PtrListBotOpc);
 Var
     IndFim: byte;
		 LimDir: byte;
     LimInf: byte;
     Temp: byte;
     PtrOpc: PtrBotaoOpcao;
     Evt: PtrEvento;
 Begin
     if((List^.Total = 0) or not(List^.PtrOpcao^.Status)) then
         exit;

     IndFim := List^.Total - 1;
     LimDir := IndFim div List^.TamVert;
     LimInf := List^.TamVert - 1;
     PtrOpc := List^.PtrOpcao;
     PtrOpc^.Selecao := false;

     textbackground(LIGHTGRAY);
     textcolor(BLACK);
     gotoxy(PtrOpc^.X+1, PtrOpc^.Y);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #80:
                         if((List^.Lin < LimInf) and (List^.I < IndFim)) then
                         begin
                             inc(List^.Lin);
                             inc(List^.I);
                             inc(PtrOpc);
                         end
                         else
                             continue;
                     #77:
                         if(List^.Col < LimDir) then
                         begin
                             Temp := List^.I + List^.TamVert;

                             if(Temp <= IndFim) then
                             begin
                                 inc(List^.Col);
                                 List^.I := Temp;
                                 inc(PtrOpc, List^.TamVert);
                             end
                             else
                                 continue;
                         end
                         else
                             continue;
                     #72:
                         if(List^.Lin > 0) then
                         begin
                             dec(List^.Lin);
                             dec(List^.I);
                             dec(PtrOpc);
                         end
                         else
                             continue;
										 #75:
										     if(List^.Col > 0) then
										     begin
										         dec(List^.Col);
                             List^.I := List^.I - List^.TamVert;
                             dec(PtrOpc, List^.TamVert);
										     end
										     else
										         continue;
										 else
                         continue;
                 end;

             #9, #13, #27:
						 begin
						     PtrOpc^.Selecao := true;
						     List^.PtrOpcao := PtrOpc;
						     break;
						 end;

						 else
                 continue;
         end;

         write(#32);
         gotoxy(PtrOpc^.X+1, PtrOpc^.Y);
         write(#248+#8);

				 Evt := PtrOpc^.Evento;
				 if(@Evt <> nil) then
				 begin
						 Evt(List^.I);
						 textbackground(LIGHTGRAY);
						 textcolor(BLACK);
						 gotoxy(PtrOpc^.X+1, PtrOpc^.Y); 
         end;
     end;
 End;

{------------------------------------------------------------------
 Procedure setIndListBotOpc: Muda a seleção atual para o botão de
 índice definido no parâmetro I. O procedimento não atualiza o de-
 senho.
 ------------------------------------------------------------------}
 Procedure setIndListBotOpc(List: PtrListBotOpc; I: byte);
 Var
     PtrAux: PtrBotaoOpcao;
 Begin
     if((I <> List^.I) and (I < List^.Total)) then
     begin
         List^.I := I;
         List^.Col := I div List^.TamVert;
         List^.Lin := I mod List^.TamVert;
         PtrAux := List^.PtrBase;
         inc(PtrAux, I);
         PtrAux^.Selecao := true;
         List^.PtrOpcao^.Selecao := false;
         List^.PtrOpcao := PtrAux;
     end;
 End;

{------------------------------------------------------------------
 Function novaCaixaSelecao: inicializa a variável do tipo
 CaixaSelecao.
 ------------------------------------------------------------------}
 Function novaCaixaSelecao(X, Y: byte; Selecao, Status: boolean; Titulo: PtrString; Evento: PtrEvento): CaixaSelecao;
 Var
     Caixa: CaixaSelecao;
 Begin
     Caixa.X := X;
     Caixa.Y := Y;
     Caixa.Selecao := Selecao;
     Caixa.Status := Status;
     Caixa.Titulo := Titulo;
     Caixa.Evento := Evento;
     novaCaixaSelecao := Caixa;
 End;

{------------------------------------------------------------------
 Function novaListCxaSel: Inicializa a variável tipo ListCxaSel.
 PtrBase recebe o endereço do primeiro elemento de um vetor do tipo
 CaixaSelecao. I definie o índice da caixa que o cursor inicialmen-
 te se posiciona na lista. TamVert define o tamanho vertical da
 lista de caixas, ou seja, o número de caixas desenhados de cima
 para baixo na tela. Total representa o número de elementos do ve-
 tor. Se Total é maior que TamVert, os elementos excedentes são
 considerados na segunda coluna de uma matriz de caixas de seleção.
 ------------------------------------------------------------------}
 Function novaListCxaSel(I, TamVert, Total: byte; PtrBase: PtrCaixaSelecao): ListCxaSel;
 Var
     List: ListCxaSel;
 Begin
     List.I := I;
     List.Lin := I mod TamVert;
     List.Col := I div TamVert;
     List.TamVert := TamVert;
     List.Total := Total;
     List.PtrBase := PtrBase;
     inc(PtrBase, I);
     List.PtrAtual := PtrBase;
     novaListCxaSel := List;
 End;

{------------------------------------------------------------------
 Procedure desenhaCaixaSelecao: desenha a caixa de seleção na tela.
 ------------------------------------------------------------------}
 Procedure desenhaCaixaSelecao(Caixa: PtrCaixaSelecao);
 Begin
     textbackground(LIGHTGRAY);
     if(Caixa^.Status) then
         textcolor(BLACK)
     else
         textcolor(DARKGRAY);

     gotoxy(Caixa^.X, Caixa^.Y);
     
     if(Caixa^.Selecao) then
         write('[X] ' + Caixa^.Titulo^)
     else
         write('[ ] ' + Caixa^.Titulo^);
 End;

{------------------------------------------------------------------
 Procedure habilitaCaixaSelecao: muda o status da caixa de seleção
 para habilitado, atualizando seu desenho. Se a caixa já tem esse
 status, nenhuma ação é tomada.
 ------------------------------------------------------------------}
 Procedure habilitaCaixaSelecao(Caixa: PtrCaixaSelecao);
 begin
     if(not(Caixa^.Status)) then
     begin
         Caixa^.Status := true;
         desenhaCaixaSelecao(Caixa);
     end;
 end;

{------------------------------------------------------------------
 Procedure desabilitaCaixaSelecao: muda o status da caixa de sele-
 ção para desabilitado, atualizando seu desenho. Se a caixa já tem
 esse status, nenhuma ação é tomada.
 ------------------------------------------------------------------}
 Procedure desabilitaCaixaSelecao(Caixa: PtrCaixaSelecao);
 begin
     if(Caixa^.Status) then
     begin
         Caixa^.Status := false;
         desenhaCaixaSelecao(Caixa);
     end;
 end;

{------------------------------------------------------------------
 Procedure desenhaListCxaSel: Desenha a lista de caixas de seleção
 na tela.
 ------------------------------------------------------------------}
 Procedure desenhaListCxaSel(List: PtrListCxaSel);
 Var
     I: byte;
     Fim: byte;
     PtrAux: PtrCaixaSelecao;
 Begin
     if(List^.Total = 0) then
         exit;

     Fim := List^.Total - 1;
		 PtrAux := List^.PtrBase;

		 for I:=0 to Fim do
     begin
         desenhaCaixaSelecao(PtrAux);
         inc(PtrAux);
		 end;
 End;

{------------------------------------------------------------------
 Procedure marcaCaixaSelecao: Se a caixa está em branco, o caracte-
 re 'X' é desenhado no centro, ou, se está marcada com 'X', o ca-
 ractere é apagado.
 ------------------------------------------------------------------}
 Procedure marcaCaixaSelecao(Caixa: PtrCaixaSelecao);
 Var
     Marca: char;
 Begin
     textbackground(BLACK);
     textcolor(LIGHTGRAY);

     if(Caixa^.Selecao) then
     begin
         Marca := #32;
         Caixa^.Selecao := false;
     end
     else begin
         Marca := #88;
         Caixa^.Selecao := true;
     end;

     gotoxy(Caixa^.X, Caixa^.Y);
     write(#91+Marca+#93+#8+#8);
     delay(200);
     textbackground(LIGHTGRAY);
     textcolor(BLACK);
     write(#8+#91+Marca+#93+#8+#8);
 end;

{------------------------------------------------------------------
 Procedure selecionaListCxaSel: Permite ao usuário navegar entre as
 linhas e colunas da matriz de caixas de seleção, usando as teclas
 de setas ou <TABLE>. Caso <TABLE> seja pressionado e o cursor es-
 teja na última caixa, o índice I recebe 0 e o procedimento é en-
 cerrado. Caso <SPACE> seja pressionado, a caixa é marcada com 'X'
 ou desmarcada. Caso <ENTER> ou <ESC> seja pressionado, o procedi-
 mento é encerrado e o índice I permanece na posição atual. Se o
 total de caixas da lista é zero, Tecla recebe #0 e o procedimento
 é encerrado. Esse procedimento não diferencia caixas com status de
 habilitado ou desabilitado. Logo, para o tratamento de uma lista
 com algumas caixas desabilitadas, será necessária a implementação
 de um procedimento personalizado.
 ------------------------------------------------------------------}
 Procedure selecionaListCxaSel(List: PtrListCxaSel);
 Var
     IndFim: byte;
		 LimDir: byte;
     LimInf: byte;
     Temp: byte;
     PtrAux: PtrCaixaSelecao;
     Evt: PtrEvento;
 Begin
     if((List^.Total = 0) or not(List^.PtrAtual^.Status)) then
         exit;

     IndFim := List^.Total - 1;
     LimDir := IndFim div List^.TamVert;
     LimInf := List^.TamVert - 1;
     PtrAux := List^.PtrAtual;
     gotoxy(PtrAux^.X+1, PtrAux^.Y);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #80:
                         if((List^.Lin < LimInf) and (List^.I < IndFim)) then
                         begin
                             inc(List^.Lin);
                             inc(List^.I);
                             inc(PtrAux);
                         end
                         else
                             continue;
                     #77:
                         if(List^.Col < LimDir) then
                         begin
                             Temp := List^.I + List^.TamVert;

                             if(Temp <= IndFim) then
                             begin
                                 inc(List^.Col);
                                 List^.I := Temp;
                                 inc(PtrAux, List^.TamVert);
                             end
                             else
                                 continue;
                         end
                         else
                             continue;
                     #72:
                         if(List^.Lin > 0) then
                         begin
                             dec(List^.Lin);
                             dec(List^.I);
                             dec(PtrAux);
                         end
                         else
                             continue;
                     #75:
                         if(List^.Col > 0) then
										     begin
										         dec(List^.Col);
                             List^.I := List^.I - List^.TamVert;
                             dec(PtrAux, List^.TamVert);
                         end
										     else
                             continue;
                     else
                         continue;
                 end;

						 #9:
						     if(List^.I < IndFim) then
                 begin
                     inc(List^.I);
                     List^.Lin := List^.I mod List^.TamVert;
                     List^.Col := List^.I div List^.TamVert;
                     inc(PtrAux);
                 end
                 else begin
                     List^.I := 0;
                     List^.Lin := 0;
                     List^.Col := 0;
                     List^.PtrAtual := List^.PtrBase;
                     break;
                 end;

						 #32:
						 begin
						     marcaCaixaSelecao(PtrAux);
						     Evt := PtrAux^.Evento;
								 if(@Evt <> nil) then
								     Evt(List^.I)
								 else
                     continue;
						 end;

						 #13, #27:
						 begin
						     List^.PtrAtual := PtrAux;
                 break;
             end;

             else
						     continue;
         end;

         gotoxy(PtrAux^.X+1, PtrAux^.Y);
     end;
 end;

{------------------------------------------------------------------
 Procedure resetaListCxaSel: Índice I da lista recebe 0, ou seja, o
 cursor estará posicionado na primeira caixa de seleção na próxima
 chamada do procedimento selecionaListCxaSel();
 ------------------------------------------------------------------}
 Procedure resetaListCxaSel(List: PtrListCxaSel);
 Begin
     if(List^.I <> 0) then
     begin
         List^.I := 0;
         List^.Col := 0;
         List^.Lin := 0;
         List^.PtrAtual := List^.PtrBase;
     end;
 End;

{------------------------------------------------------------------
 Procedure limpaListCxaSel: Todas as caixas da lista, marcadas com
 'X', serão desmarcadas. O procedimento não atualiza o desenho.
 ------------------------------------------------------------------}
 Procedure limpaListCxaSel(List: PtrListCxaSel);
 Var
     I: byte;
     Fim: byte;
     PtrAux: PtrCaixaSelecao;
 Begin
     if(List^.Total = 0) then
         exit;

     Fim := List^.Total - 1;
		 PtrAux := List^.PtrBase;

		 for I:=0 to Fim do
     begin
         PtrAux^.Selecao := false;
         inc(PtrAux);
     end;
 End;

End.
