Program InstalacaoEletrica;
Uses ComponentesInterfaceTexto;
{ -------------------------------------------------------------
   InstalacaoEletrica - versão 1.2

   Autor   : Alexandre Moreira Versiani
   Contato : alexandre-versiani@hotmail.com

  -------------------------------------------------------------

   Este programa tem como principal objetivo apresentar uma in-
   terface de usuário baseada em texto, semelhante a uma inter-
	 face gráfica, com elementos interativos visíveis na
   tela, como botões, listas, campos etc. Tomou-se como refe-
   rência a interface do Microsoft Word 6.0 para MS-DOS, com
   algumas diferenças.

   Como exemplo demonstrativo, o atual programa implementa uma
   calculadora de potência para projetos de instalação elétri-
   ca residencial. Todos os cálculos aqui presentes estão de a-
   cordo com as normas da NBR 5410:2004 e com o manual da Prys-
   mian Cables & Systems, que pode ser baixado no link:

   http://www.prysmian.com.br/export/sites/prysmian-ptBR/energy
	 /pdfs/Manualinstalacao.pdf

   Este programa foi concebido com finalidade meramente ilus-
   trativa. Existem no mercado soluções em softwares mais pro-
   fissionais para um projeto de instalação elétrica.

   Nota: Este código é livre e pode ser reaproveitado, modifi-
	 cado e aperfeiçoado, sem que haja prejuízos legais.
  ------------------------------------------------------------- }

Type
    Dependencia = record
        Area: real;
        Perimetro: real;
        NumTUG: integer;
        PotIlum: integer;
        PotTUG: real;
        PotTUE: integer;
    end;
    PtrDependencia = ^Dependencia;

 Var
     // Variáveis de uso geral

     I: byte;             // Contador de uso geral
		 Temp: real;          // Variável temporária
     IndDep: shortint;    // Índice no vetor de dependências da casa (referente à última posição)
     CodErro: byte;       // Posição no campo em que foi digitado um caractere inválido
     OrdemTela1: byte;    // Especifica o componente a ser selecionado na tela inicial
     OrdemTela2: byte;    // Especifica o componente a ser selecionado na tela de cadastro
		 ErroPot: boolean;    // Verdadeiro = erro nos campos de potência
     ZeroDep: boolean;    // Verdadeiro = nenhuma dependência cadastrada
     MaxDep: boolean;     // Verdadeiro = alcançou o número máximo de dependências

     // Variáveis do projeto de instalação elétrica

     Area: real;          // Área da dependência
     Perimetro: real;     // Perímetro da dependência
     NumTomadas: integer; // Número de tomadas de uso geral da dependência
     PotIlum: integer;    // Potência de iluminação da dependência
     PotTUG: real;        // Potência das tomadas de uso geral (TUG)
     PotTUE: integer;     // Potência das tomadas de uso específico (TUE)
     PotTemp: integer;    // Variável Temporária (intermediária para o cálculo de PotTUE)
     PotAtiva: real;      // Potência ativa total da casa
     VetDependencia: array[0..19] of Dependencia; // Vetor com informações de cada dependência da casa

     // Variáveis dos componentes de interface com o usuário

     TelaInicio: Fundo;   // Fundo inicial do programa
     TelaNovaDep: Fundo;  // Fundo para cadastro de nova dependência
     TelaPotTotal: Fundo; // Fundo para potência ativa total
     ListPadrao: Lista;   // Lista contendo os tipos padrões das dependências (sala, quarto, cozinha, etc)
     ListNovaDep: Lista;  // Lista contendo as dependências cadastradas
     QuadInfo: Quadro;    // Quadro para informações da dependência selecionada no menu
     QuadTomada: Quadro;  // Quadro das tomadas de uso específico
     CampNome: Campo;     // Campo para nome da dependência
     CampArea: Campo;     // Campo para área da dependência
     CampPerim: Campo;    // Campo para perímetro da dependência

		 BotTela1: array[0..4] of Botao;           // Botões da tela inicial
		 BotTela2: array[0..1] of Botao;           // Botões da tela de novo cadastro
		 BotOk: Botao;                             // Botão OK da tela de resultado dos cálculos
		 CaixaTomada: array[0..6] of CaixaSelecao; // Caixas de seleção das tomadas de uso específico
		 CampPotencia: array[0..6] of Campo;       // Campos referentes à potência de tomada de uso específico 

		 ListBotTela1: ListBotao;
		 ListBotTela2: ListBotao;

		 // strings visíveis nos componentes de interface

		 StrFundo: array[0..2] of string[24] = (
		     'Instalação Elétrica Pzim',
		     'Nova Dependência',
		     'Potência Total');
		 StrQuadro: array[0..1] of string[24] = (
		     'Info',
		     'Tomada de Uso Específico');
     StrBotao: array[0..6] of string[8] = (
		     'Novo...',
				 'Info',
				 'Deletar',
				 'Calcular',
				 'Sair',
				 'OK',
				 'Cancelar');
     StrCaixa: array[0..6] of string[17] = (
		     'Chuveiro',
		     'Ar Condicionado',
		     'Torneira Elétrica',
		     'Microondas',
		     'Geladeira',
		     'Máquina de Lavar',
				 'Secadora de Roupa');
     StrDependencia: array[0..10] of string[21] = (
         'Sala',
				 'Quarto',
				 'Copa',
				 'Cozinha',
				 'Banheiro',
				 'Área de Serviço',
				 'Corredor',
				 'Varanda',
				 'Hall',
				 'Sótão',
				 'Garagem');

{---------------------------------------------------------------------
 Procedure novaDependencia: Inicializa a variável do tipo Dependencia.
 ---------------------------------------------------------------------}
 Procedure novaDependencia(Dep: PtrDependencia; Area, Perimetro, PotTUG: real; NumTUG, PotIlum, PotTUE: integer);
 Begin
     Dep^.Area := Area;
     Dep^.Perimetro := Perimetro;
     Dep^.NumTUG := NumTUG;
     Dep^.PotTUG := PotTUG;
     Dep^.PotIlum := PotIlum;
     Dep^.PotTUE := PotTUE;
 End;

{------------------------------------------------------------------
 Procedure selecionaBotoesMenu: Permite ao usuário selecionar os
 botões do menu principal através das teclas <SETA_ESQUERDA>,
 <SETA_DIREITA> ou <TABLE>. Se <ENTER> for pressionado, o procedi-
 mento é encerrado. Esse procedimento faz o tratamento adequado de
 alguns botões desabilitados do menu, de acordo com as variáveis
 globais ZeroDep e MaxDep.
 ------------------------------------------------------------------}
 Procedure selecionaBotoesMenu();
 Var
     PtrAux1: PtrBotao;
     PtrAux2: PtrBotao;
     PtrFim: PtrBotao;
 Begin
     PtrAux1 := ListBotTela1.PtrOpcao;
     PtrAux2 := PtrAux1;
     PtrFim := ListBotTela1.PtrBase;
     inc(PtrFim, 4);
     gotoxy(PtrAux1^.CoordTtl, PtrAux1^.Y+1);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #77:
                         if((ListBotTela1.Col < 4) and not(ZeroDep)) then
                         begin
                             inc(ListBotTela1.I);
                             inc(ListBotTela1.Col);
                             inc(PtrAux2);
                         end
                         else if((ListBotTela1.Col = 0) and ZeroDep) then
                         begin
                             ListBotTela1.I := 4;
                             ListBotTela1.Col := 4;
                             PtrAux2 := PtrFim;
                         end
                         else
                             continue;

                     #75:
                         if(((ListBotTela1.Col > 0) and not(ZeroDep) and not(MaxDep)) or
												    ((ListBotTela1.Col > 1) and MaxDep)) then
                         begin
                             dec(ListBotTela1.I);
                             dec(ListBotTela1.Col);
                             dec(PtrAux2);
                         end
                         else if((ListBotTela1.Col = 4) and ZeroDep) then
                         begin
                             ListBotTela1.I := 0;
                             ListBotTela1.Col := 0;
                             PtrAux2 := ListBotTela1.PtrBase;
                         end
                         else
                             continue;

                     else
                         continue;
                 end;

             #9:
                 if((ListBotTela1.Col < 4) and not(ZeroDep)) then
                 begin
                     inc(ListBotTela1.I);
                     inc(ListBotTela1.Col);
                     inc(PtrAux2);
                 end
                 else if((ListBotTela1.Col = 0) and ZeroDep) then
                 begin
                     ListBotTela1.I := 4;
                     ListBotTela1.Col := 4;
                     PtrAux2 := PtrFim;
                 end
                 else
								 begin
                     if(not(MaxDep)) then
                     begin
                         ListBotTela1.I := 0;
                         ListBotTela1.Col := 0;
                         PtrAux2 := ListBotTela1.PtrBase;
                     end
                     else begin
                         ListBotTela1.I := 1;
                         ListBotTela1.Col := 1;
                         PtrAux2 := ListBotTela1.PtrBase;
                         inc(PtrAux2);
                     end;

                     PtrAux1^.Status := 1;
                     PtrAux2^.Status := 2;
                     ListBotTela1.PtrOpcao := PtrAux2;
                     desenhaBotao(PtrAux1);
                     desenhaBotao(PtrAux2);
                     break;
                 end;

             #13:
						 begin
						     ListBotTela1.PtrOpcao := PtrAux1;
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
 Procedure configuraMenuBot123: Os botões de índices 1, 2 e 3 do
 menu recebem o status de habilitado, sem atualizar o desenho.
 ------------------------------------------------------------------}
 Procedure configuraMenuBot123();
 Begin
     BotTela1[1].Status := 1;
     BotTela1[2].Status := 1;
     BotTela1[3].Status := 1;
 End;

{------------------------------------------------------------------
 Procedure configuraMenuZeroDep: Desabilita os botões de índices 1,
 2 e 3 do menu. O botão de índice 0 recebe o status de selecionado.
 Esse procedimento atualiza o desenho.
 ------------------------------------------------------------------}
 Procedure configuraMenuZeroDep();
 Begin
     ListBotTela1.I := 0;
     ListBotTela1.Col := 0;
     ListBotTela1.PtrOpcao := ListBotTela1.PtrBase;
     BotTela1[0].Status := 2;
		 BotTela1[1].Status := 0;
     BotTela1[2].Status := 0;
     BotTela1[3].Status := 0;
     desenhaBotao(@BotTela1[0]);
     desenhaBotao(@BotTela1[1]);
     desenhaBotao(@BotTela1[2]);
     desenhaBotao(@BotTela1[3]);
 End;

{------------------------------------------------------------------
 Procedure configuraMenuMaxDep: Desabilita o botão de índice 0 do
 menu. O botão de índice 1 recebe o status de selecionado. Esse
 procedimento não atualiza o desenho.
 ------------------------------------------------------------------}
 Procedure configuraMenuMaxDep();
 Begin
     ListBotTela1.I := 1;
     ListBotTela1.Col := 1;
     ListBotTela1.PtrOpcao := ListBotTela1.PtrBase;
     inc(ListBotTela1.PtrOpcao);
		 BotTela1[0].Status := 0;
     BotTela1[1].Status := 2;
 End;

{------------------------------------------------------------------
 Procedure selecionaTomadas: Permite ao usuário navegar entre as
 linhas do vetor de caixas de seleção, usando as teclas de setas ou
 <TABLE>. Caso <TABLE> seja pressionado e a caixa esteja marcada, o
 usuário pode digitar a potência no campo ao lado.
 ------------------------------------------------------------------}
 Procedure selecionaTomadas();
 Var
     I: byte;
     Lin: byte;
 Begin
     I := 0;
     Lin := 12;
     gotoxy(31, 12);

     while(true) do
     begin
         Tecla := readkey;
         case(Tecla) of
             #0:
                 case(readkey) of
                     #80:
                         if(Lin < 18) then
                         begin
                             inc(I);
                             inc(Lin);
                             gotoxy(31, Lin);
                         end;
                     #72:
                         if(Lin > 12) then
                         begin
                             dec(I);
                             dec(Lin);
                             gotoxy(31, Lin);
                         end;
                 end;

             #9:
						 begin
                 if(CaixaTomada[I].Selecao) then
                 begin
                     digitaCampo(@CampPotencia[I]);
                     if((Tecla = #13) or (Tecla = #27)) then
                         break;
                 end;

                 if(Lin < 18) then
                 begin
                     inc(I);
                     inc(Lin);
                     gotoxy(31, Lin);
                 end
                 else
                     break;
             end;

             #32:
						 begin
                 marcaCaixaSelecao(@CaixaTomada[I]);

                 if(CaixaTomada[I].Selecao) then
                 begin
                     CampPotencia[I].Status := true;
                     textcolor(BLACK);
                 end
                 else begin
                     CampPotencia[I].Status := false;
                     textcolor(DARKGRAY);
                 end;

                 gotoxy(53, Lin);
                 write('Potência:');
                 desenhaCampo(@CampPotencia[I]);
                 gotoxy(31, Lin);
             end;

             #13, #27:
                 break;
         end;
     end;
 End;

{------------------------------------------------------------------
 Procedure resetaTomadas: desmarca todas as caixas de seleção, lim-
 pa todos os campos de potência e desabilita os mesmos.
 ------------------------------------------------------------------}
 Procedure resetaTomadas();
 Var
     I: byte;
 Begin
     for I:=0 to 6 do
     begin
         CaixaTomada[I].Selecao := false;
         CampPotencia[I].Status := false;
         CampPotencia[I].Conteudo^[0] := #0;
     end;
 End;

{------------------------------------------------------------------
                         PROGRAMA PRINCIPAL
 ------------------------------------------------------------------}
 Begin
     TelaInicio := novoFundo(MAGENTA, @StrFundo[0]);
     TelaNovaDep := novoFundo(MAGENTA, @StrFundo[1]);
     TelaPotTotal := novoFundo(MAGENTA, @StrFundo[2]);

		 QuadInfo := novoQuadro(33, 6, 40, 7, @StrQuadro[0]);
     QuadTomada := novoQuadro(28, 10, 41, 8, @StrQuadro[1]);

		 ListNovaDep := novaLista(5, 6, 24, 7);
     ListPadrao := novaLista(2, 10, 22, 8);

		 CampNome := novoCampo(28, 4, 15, 25, true);
     CampArea := novoCampo(28, 5, 15, 7, true);
     CampPerim := novoCampo(28, 6, 15, 7, true);

		 for I:=0 to 6 do
         CampPotencia[I] := novoCampo(63, I+12, 5, 4, false);

		 BotTela1[0] := novoBotao(9, 22, 10, 2, @StrBotao[0], nil);
     BotTela1[1] := novoBotao(22, 22, 10, 0, @StrBotao[1], nil);
     BotTela1[2] := novoBotao(35, 22, 10, 0, @StrBotao[2], nil);
     BotTela1[3] := novoBotao(48, 22, 10, 0, @StrBotao[3], nil);
     BotTela1[4] := novoBotao(61, 22, 10, 1, @StrBotao[4], nil);
     ListBotTela1 := novaListBotao(0, 5, 5, @BotTela1[0]);

		 BotTela2[0] := novoBotao(46, 22, 10, 2, @StrBotao[5], nil);
     BotTela2[1] := novoBotao(59, 22, 10, 1, @StrBotao[6], nil);
     ListBotTela2 := novaListBotao(0, 2, 2, @BotTela2[0]);

		 BotOk := novoBotao(35, 22, 10, 2, @StrBotao[5], nil);

		 for I:=0 to 6 do
		     CaixaTomada[I] := novaCaixaSelecao(30, I+12, false, true, @StrCaixa[I], nil);

    {-------------------------------------------------
     A lista inicialmente é vazia. O procedimento a-
     baixo insere os itens visíveis da lista.
     -------------------------------------------------}
     for I:=0 to 10 do
         insereFimLista(@ListPadrao, @StrDependencia[I]);

     OrdemTela1 := 0;
     IndDep := -1;
     ZeroDep := true;
     MaxDep := false;
     cursoron;

    {-------------------------------------------------
     while para o retorno à tela inicial.
     -------------------------------------------------}
     while(true) do
     begin

         // Desenha todos os componentes visíveis na primeira tela.
         textcolor(BLACK);
         gotoxy(5, 5);
         write('Dependência cadastrada:');

         desenhaFundo(@TelaInicio);
         desenhaLista(@ListNovaDep);
         desenhaQuadro(@QuadInfo);
         desenhaListBotao(@ListBotTela1);

         textcolor(DARKGRAY);
         gotoxy(35, 8);
         write('Área (m'+#253+')');
         gotoxy(35, 9);
         write('Perímetro (m)');
         gotoxy(35, 10);
         write('Número de TUG'+#39+'s');
         gotoxy(35, 11);
         write('Potência Iluminação (VA)');
         gotoxy(35, 12);
         write('Potência TUG'+#39+'s (VA)');
         gotoxy(35, 13);
         write('Potência TUE'+#39+'s (VA)');

         gotoxy(70, 8);
         write('0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00');

        {-------------------------------------------------
         while para retorno à lista após a exibição de in-
         formações no quadro ou após remoção de elemento.
         -------------------------------------------------}
         while(true) do
         begin

            {-------------------------------------------------
             while para retorno à lista após o usuário apertar
             a tecla <TABLE> com o cursor no botão 'Sair'.
             -------------------------------------------------}
             while(true) do
             begin
                 if(OrdemTela1 = 0) then
                 begin
										 selecionaLista(@ListNovaDep);
                     if(Tecla = #13) then          // Se última tecla for <ENTER>
                         break;                    // Encerra imediatamente o laço while
                 end;

                 if(OrdemTela1 <= 1) then
                 begin
										 selecionaBotoesMenu();
                     if(Tecla = #13) then          // Se última tecla for <ENTER>
                         break;                    // Encerra imediatamente o laço while
                 end;

                 OrdemTela1 := 0;
             end;

             I := ListBotTela1.I;
						 pressionaBotao(@BotTela1[I]);

             if(I = 1) then
             begin
                 OrdemTela1 := 0;
                 desenhaBotao(@BotTela1[1]);
                 I := ListNovaDep.I;

                 textbackground(LIGHTGRAY);
                 textcolor(BLACK);
                 gotoxy(35, 8);
                 write('Área (m'+#253+')                ', VetDependencia[I].Area:14:2);
                 gotoxy(35, 9);
                 write('Perímetro (m)            ', VetDependencia[I].Perimetro:14:2);
                 gotoxy(35, 10);
                 write('Número de TUG'+#39+'s          ', VetDependencia[I].NumTUG:11, '.00');
                 gotoxy(35, 11);
                 write('Potência Iluminação (VA) ', VetDependencia[I].PotIlum:11, '.00');
                 gotoxy(35, 12);
                 write('Potência TUG'+#39+'s (VA)      ', VetDependencia[I].PotTUG:14:2);
                 gotoxy(35, 13);
                 write('Potência TUE'+#39+'s (VA)      ', VetDependencia[I].PotTUE:11, '.00');
             end
             else if(I = 2) then
             begin
                 OrdemTela1 := 0;
                 desenhaBotao(@BotTela1[2]);
                 I := ListNovaDep.I;
                 removeSelLista(@ListNovaDep);
                 dec(IndDep);

                 for I:=I to IndDep do
                     VetDependencia[I] := VetDependencia[I+1];

                 if(IndDep = -1) then
                 begin
                     ZeroDep := true;
                     configuraMenuZeroDep();
                 end;

                 if(MaxDep) then
                 begin
                     MaxDep := false;
                     habilitaBotao(@BotTela1[0]);
                 end;
             end
             else
                 break;
         end;

         if(I = 0) then
         begin
             desenhaFundo(@TelaNovaDep);

             textbackground(LIGHTGRAY);
             textcolor(BLACK);

             gotoxy(1, 4);
             write(' Nome para dependência:'+#10+#13+
                   ' Área (m'+#253+'):'+#10+#13+
                   ' Perímetro (m):'+#10+#10+#10+#13+
                   ' Tipo de dependência:');

             desenhaCampo(@CampNome);
             desenhaCampo(@CampArea);
             desenhaCampo(@CampPerim);
             desenhaLista(@ListPadrao);
             desenhaQuadro(@QuadTomada);

             for I:=0 to 6 do
             begin
                 desenhaCaixaSelecao(@CaixaTomada[I]);
                 textcolor(DARKGRAY);
                 gotoxy(53, I+12);
                 write('Potência:');
                 desenhaCampo(@CampPotencia[I]);
             end;

             desenhaListBotao(@ListBotTela2);
             OrdemTela2 := 0;

            {-------------------------------------------------
             while para retorno aos campos após a verificação
             e confirmação de erros nos campos.
             -------------------------------------------------}
             while(true) do
             begin

                {-------------------------------------------------
                 while para retorno aos campos após o usuário a-
                 pertar a tecla <TABLE> com o cursor no botão
                 'Cancelar'.
                 -------------------------------------------------}
                 while(true) do
                 begin
                     if(OrdemTela2 = 0) then
                     begin
												 digitaCampo(@CampNome);
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     if(OrdemTela2 <= 1) then
                     begin
												 digitaCampo(@CampArea);
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     if(OrdemTela2 <= 2) then
                     begin
												 digitaCampo(@CampPerim);
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     if(OrdemTela2 <= 3) then
                     begin
												 selecionaLista(@ListPadrao);
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     if(OrdemTela2 <= 4) then
                     begin
												 selecionaTomadas();
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     if(OrdemTela2 <= 5) then
                     begin
												 selecionaListBotao(@ListBotTela2);
                         if((Tecla = #13) or (Tecla = #27)) then
                             break;
                     end;

                     OrdemTela2 := 0;
                 end;

                 // Quando apertar <Esc>
                 if(Tecla = #27) then
                     break;

                 if(ListBotTela2.I = 0) then
                 begin
                     pressionaBotao(@BotTela2[0]);

                     if(length(CampNome.Conteudo^) = 0) then
                     begin
                         //mensagem de erro
                         desenhaBotao(@BotTela2[0]);
                         write(#7);
                         OrdemTela2 := 0;
                         continue;
                     end;

                     val(CampArea.Conteudo^, Area, CodErro);
                     if((CodErro <> 0) or (Area <= 0)) then
                     begin
                         //mensagem de erro
                         desenhaBotao(@BotTela2[0]);
                         write(#7);
                         OrdemTela2 := 1;
                         continue;
                     end;

                     val(CampPerim.Conteudo^, Perimetro, CodErro);
                     if((CodErro <> 0) or (Perimetro <= 0)) then
                     begin
                         //mensagem de erro
                         desenhaBotao(@BotTela2[0]);
                         write(#7);
                         OrdemTela2 := 2;
                         continue;
                     end;

                     PotTUE := 0;
                     ErroPot := false;

                     for I:=0 to 6 do
                         if(CampPotencia[I].Status) then
                         begin
                             val(CampPotencia[I].Conteudo^, PotTemp, CodErro);

                             if((CodErro <> 0) or (PotTemp <= 0)) then
                             begin
                                 //mensagem de erro
                                 desenhaBotao(@BotTela2[0]);
                                 write(#7);
                                 ErroPot := true;
                                 OrdemTela2 := 4;
                                 break;
                             end;

                             PotTUE := PotTUE + PotTemp;
                         end;

                     if(ErroPot) then
                         continue;

                     // Potência de Iluminação------------------------------

                     if(Area > 6) then
                         PotIlum := 100 + 60*trunc((Area - 6)/4)
                     else
                         PotIlum := 100;

                     // Número de TUG's-------------------------------------

                     case(ListPadrao.I) of

                         // sala, quarto, hall
                         0, 1, 8:  
                             if(Area > 6) then
                             begin
                                 Temp := Perimetro/5;
                                 if(frac(Temp) > 0) then
                                     NumTomadas := trunc(Temp) + 1
                                 else
                                     NumTomadas := trunc(Temp);
                             end
                             else
                                 NumTomadas := 1; // cômodos com área igual
                                                  // ou inferior a 6m²

                         // cozinha, copa, área de serviço
                         2, 3, 5:
                             if(Area > 6) then
                             begin
                                 Temp := Perimetro/3.5;
                                 if(frac(Temp) > 0) then
                                     NumTomadas := trunc(Temp) + 1
                                 else
                                     NumTomadas := trunc(Temp);
                             end
                             else
                                 NumTomadas := 2;

                         // banheiros, varandas, subsolos, garagens, sotãos
                         4, 7, 9, 10:
                             NumTomadas := 1;

                         // corredor
                         6:
                             NumTomadas := 0;
                     end;

                     // Potencia das TUG's----------------------------------

                     case(ListPadrao.I) of

                         // banheiro, cozinha, copa, area de serviço
                         2, 3, 4, 5:
                             if(NumTomadas > 3) then
                                 PotTUG := 1800 + 100*(NumTomadas - 3)
                             else
                                 PotTUG := 600*NumTomadas;
                         else
                             PotTUG := 100*NumTomadas; // demais cômodos
                     end;

                     inc(IndDep);
										 insereFimLista(@ListNovaDep, CampNome.Conteudo);
                     novaDependencia(@VetDependencia[IndDep], Area, Perimetro, PotTUG, NumTomadas, PotIlum, PotTUE);

                     if(IndDep = 19) then
                     begin
                         MaxDep := true;
                         configuraMenuMaxDep();
                     end;

                     if(ZeroDep) then
                     begin
                         ZeroDep := false;
                         configuraMenuBot123();
                     end;

                     break;
                 end
                 else begin
                     //quando cancelar
                     pressionaBotao(@BotTela2[1]);
                     break;
                 end;
             end;

             OrdemTela1 := 0;
						 limpaCampo(@CampNome);
             limpaCampo(@CampArea);
             limpaCampo(@CampPerim);
             resetaLista(@ListPadrao);
             resetaListBotao(@ListBotTela2);
             resetaTomadas();
         end
         else if(I = 3) then
         begin
             desenhaFundo(@TelaPotTotal);
             desenhaBotao(@BotOk);

             PotIlum := 0;
             PotTUG := 0;
             PotTUE := 0;

             for I:=0 to IndDep do
             begin
                 PotIlum := PotIlum + VetDependencia[I].PotIlum;
                 PotTUG := PotTUG + VetDependencia[I].PotTUG;
                 PotTUE := PotTUE + VetDependencia[I].PotTUE;
             end;

             PotTUG := PotTUG*0.8;
             PotAtiva := PotTUG + PotIlum + PotTUE;

             textbackground(LIGHTGRAY);
             textcolor(BLACK);
             gotoxy(1, 4);

             write(' Potência Ativa Total de Iluminação (W).........', PotIlum, '.00'+#13+#10+
                   ' Potência Ativa Total das TUG'+#39+'s (W).............', PotTUG:0:2, #13+#10+
                   ' Potência Ativa Total das TUE'+#39+'s (W).............', PotTUE, '.00'+#13+#10+
                   ' Potência Ativa Total da Residência (W).........', PotAtiva:0:2, #13+#10+#10+
                   ' Sua instalação necessita de um padrão de entrada ');

             if(PotAtiva <= 12000) then
                 write('monofásico.')
             else if((PotAtiva > 12000) and (PotAtiva <= 25000)) then
                 write('bifásico.')
             else
                 write('trifásico.');

             gotoxy(1, 15);
             write(' Nota: TUG = Tomada de Uso Geral;'+#13+#10+
                   '       TUE = Tomada de Uso Específico.');

             gotoxy(40, 23);

             while(true) do
             begin
                 Tecla := readkey;
                 if(Tecla = #13) then
                 begin
            		     pressionaBotao(@BotOk);
                     break;
                 end;
                 if(Tecla = #27) then
                     break;
             end;

             OrdemTela1 := 1;
         end
         else begin
            {-------------------------------------------------
             Libera memória antes do programa encerrar.
             -------------------------------------------------}
             limpaLista(@ListNovaDep);
             limpaLista(@ListPadrao);
             liberaMemCampo(@CampNome);
             liberaMemCampo(@CampArea);
             liberaMemCampo(@CampPerim);
             for I:=0 to 6 do
                 liberaMemCampo(@CampPotencia[I]);
						 exit;
         end;
     end;
 End.
