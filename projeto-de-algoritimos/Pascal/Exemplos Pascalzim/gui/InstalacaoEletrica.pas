Program InstalacaoEletrica;
Uses ComponentesInterfaceTexto;
{ -------------------------------------------------------------
   InstalacaoEletrica - vers�o 1.2

   Autor   : Alexandre Moreira Versiani
   Contato : alexandre-versiani@hotmail.com

  -------------------------------------------------------------

   Este programa tem como principal objetivo apresentar uma in-
   terface de usu�rio baseada em texto, semelhante a uma inter-
	 face gr�fica, com elementos interativos vis�veis na
   tela, como bot�es, listas, campos etc. Tomou-se como refe-
   r�ncia a interface do Microsoft Word 6.0 para MS-DOS, com
   algumas diferen�as.

   Como exemplo demonstrativo, o atual programa implementa uma
   calculadora de pot�ncia para projetos de instala��o el�tri-
   ca residencial. Todos os c�lculos aqui presentes est�o de a-
   cordo com as normas da NBR 5410:2004 e com o manual da Prys-
   mian Cables & Systems, que pode ser baixado no link:

   http://www.prysmian.com.br/export/sites/prysmian-ptBR/energy
	 /pdfs/Manualinstalacao.pdf

   Este programa foi concebido com finalidade meramente ilus-
   trativa. Existem no mercado solu��es em softwares mais pro-
   fissionais para um projeto de instala��o el�trica.

   Nota: Este c�digo � livre e pode ser reaproveitado, modifi-
	 cado e aperfei�oado, sem que haja preju�zos legais.
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
     // Vari�veis de uso geral

     I: byte;             // Contador de uso geral
		 Temp: real;          // Vari�vel tempor�ria
     IndDep: shortint;    // �ndice no vetor de depend�ncias da casa (referente � �ltima posi��o)
     CodErro: byte;       // Posi��o no campo em que foi digitado um caractere inv�lido
     OrdemTela1: byte;    // Especifica o componente a ser selecionado na tela inicial
     OrdemTela2: byte;    // Especifica o componente a ser selecionado na tela de cadastro
		 ErroPot: boolean;    // Verdadeiro = erro nos campos de pot�ncia
     ZeroDep: boolean;    // Verdadeiro = nenhuma depend�ncia cadastrada
     MaxDep: boolean;     // Verdadeiro = alcan�ou o n�mero m�ximo de depend�ncias

     // Vari�veis do projeto de instala��o el�trica

     Area: real;          // �rea da depend�ncia
     Perimetro: real;     // Per�metro da depend�ncia
     NumTomadas: integer; // N�mero de tomadas de uso geral da depend�ncia
     PotIlum: integer;    // Pot�ncia de ilumina��o da depend�ncia
     PotTUG: real;        // Pot�ncia das tomadas de uso geral (TUG)
     PotTUE: integer;     // Pot�ncia das tomadas de uso espec�fico (TUE)
     PotTemp: integer;    // Vari�vel Tempor�ria (intermedi�ria para o c�lculo de PotTUE)
     PotAtiva: real;      // Pot�ncia ativa total da casa
     VetDependencia: array[0..19] of Dependencia; // Vetor com informa��es de cada depend�ncia da casa

     // Vari�veis dos componentes de interface com o usu�rio

     TelaInicio: Fundo;   // Fundo inicial do programa
     TelaNovaDep: Fundo;  // Fundo para cadastro de nova depend�ncia
     TelaPotTotal: Fundo; // Fundo para pot�ncia ativa total
     ListPadrao: Lista;   // Lista contendo os tipos padr�es das depend�ncias (sala, quarto, cozinha, etc)
     ListNovaDep: Lista;  // Lista contendo as depend�ncias cadastradas
     QuadInfo: Quadro;    // Quadro para informa��es da depend�ncia selecionada no menu
     QuadTomada: Quadro;  // Quadro das tomadas de uso espec�fico
     CampNome: Campo;     // Campo para nome da depend�ncia
     CampArea: Campo;     // Campo para �rea da depend�ncia
     CampPerim: Campo;    // Campo para per�metro da depend�ncia

		 BotTela1: array[0..4] of Botao;           // Bot�es da tela inicial
		 BotTela2: array[0..1] of Botao;           // Bot�es da tela de novo cadastro
		 BotOk: Botao;                             // Bot�o OK da tela de resultado dos c�lculos
		 CaixaTomada: array[0..6] of CaixaSelecao; // Caixas de sele��o das tomadas de uso espec�fico
		 CampPotencia: array[0..6] of Campo;       // Campos referentes � pot�ncia de tomada de uso espec�fico 

		 ListBotTela1: ListBotao;
		 ListBotTela2: ListBotao;

		 // strings vis�veis nos componentes de interface

		 StrFundo: array[0..2] of string[24] = (
		     'Instala��o El�trica Pzim',
		     'Nova Depend�ncia',
		     'Pot�ncia Total');
		 StrQuadro: array[0..1] of string[24] = (
		     'Info',
		     'Tomada de Uso Espec�fico');
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
		     'Torneira El�trica',
		     'Microondas',
		     'Geladeira',
		     'M�quina de Lavar',
				 'Secadora de Roupa');
     StrDependencia: array[0..10] of string[21] = (
         'Sala',
				 'Quarto',
				 'Copa',
				 'Cozinha',
				 'Banheiro',
				 '�rea de Servi�o',
				 'Corredor',
				 'Varanda',
				 'Hall',
				 'S�t�o',
				 'Garagem');

{---------------------------------------------------------------------
 Procedure novaDependencia: Inicializa a vari�vel do tipo Dependencia.
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
 Procedure selecionaBotoesMenu: Permite ao usu�rio selecionar os
 bot�es do menu principal atrav�s das teclas <SETA_ESQUERDA>,
 <SETA_DIREITA> ou <TABLE>. Se <ENTER> for pressionado, o procedi-
 mento � encerrado. Esse procedimento faz o tratamento adequado de
 alguns bot�es desabilitados do menu, de acordo com as vari�veis
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
 Procedure configuraMenuBot123: Os bot�es de �ndices 1, 2 e 3 do
 menu recebem o status de habilitado, sem atualizar o desenho.
 ------------------------------------------------------------------}
 Procedure configuraMenuBot123();
 Begin
     BotTela1[1].Status := 1;
     BotTela1[2].Status := 1;
     BotTela1[3].Status := 1;
 End;

{------------------------------------------------------------------
 Procedure configuraMenuZeroDep: Desabilita os bot�es de �ndices 1,
 2 e 3 do menu. O bot�o de �ndice 0 recebe o status de selecionado.
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
 Procedure configuraMenuMaxDep: Desabilita o bot�o de �ndice 0 do
 menu. O bot�o de �ndice 1 recebe o status de selecionado. Esse
 procedimento n�o atualiza o desenho.
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
 Procedure selecionaTomadas: Permite ao usu�rio navegar entre as
 linhas do vetor de caixas de sele��o, usando as teclas de setas ou
 <TABLE>. Caso <TABLE> seja pressionado e a caixa esteja marcada, o
 usu�rio pode digitar a pot�ncia no campo ao lado.
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
                 write('Pot�ncia:');
                 desenhaCampo(@CampPotencia[I]);
                 gotoxy(31, Lin);
             end;

             #13, #27:
                 break;
         end;
     end;
 End;

{------------------------------------------------------------------
 Procedure resetaTomadas: desmarca todas as caixas de sele��o, lim-
 pa todos os campos de pot�ncia e desabilita os mesmos.
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
     A lista inicialmente � vazia. O procedimento a-
     baixo insere os itens vis�veis da lista.
     -------------------------------------------------}
     for I:=0 to 10 do
         insereFimLista(@ListPadrao, @StrDependencia[I]);

     OrdemTela1 := 0;
     IndDep := -1;
     ZeroDep := true;
     MaxDep := false;
     cursoron;

    {-------------------------------------------------
     while para o retorno � tela inicial.
     -------------------------------------------------}
     while(true) do
     begin

         // Desenha todos os componentes vis�veis na primeira tela.
         textcolor(BLACK);
         gotoxy(5, 5);
         write('Depend�ncia cadastrada:');

         desenhaFundo(@TelaInicio);
         desenhaLista(@ListNovaDep);
         desenhaQuadro(@QuadInfo);
         desenhaListBotao(@ListBotTela1);

         textcolor(DARKGRAY);
         gotoxy(35, 8);
         write('�rea (m'+#253+')');
         gotoxy(35, 9);
         write('Per�metro (m)');
         gotoxy(35, 10);
         write('N�mero de TUG'+#39+'s');
         gotoxy(35, 11);
         write('Pot�ncia Ilumina��o (VA)');
         gotoxy(35, 12);
         write('Pot�ncia TUG'+#39+'s (VA)');
         gotoxy(35, 13);
         write('Pot�ncia TUE'+#39+'s (VA)');

         gotoxy(70, 8);
         write('0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00'+#10+#8+#8+#8+#8+
               '0.00');

        {-------------------------------------------------
         while para retorno � lista ap�s a exibi��o de in-
         forma��es no quadro ou ap�s remo��o de elemento.
         -------------------------------------------------}
         while(true) do
         begin

            {-------------------------------------------------
             while para retorno � lista ap�s o usu�rio apertar
             a tecla <TABLE> com o cursor no bot�o 'Sair'.
             -------------------------------------------------}
             while(true) do
             begin
                 if(OrdemTela1 = 0) then
                 begin
										 selecionaLista(@ListNovaDep);
                     if(Tecla = #13) then          // Se �ltima tecla for <ENTER>
                         break;                    // Encerra imediatamente o la�o while
                 end;

                 if(OrdemTela1 <= 1) then
                 begin
										 selecionaBotoesMenu();
                     if(Tecla = #13) then          // Se �ltima tecla for <ENTER>
                         break;                    // Encerra imediatamente o la�o while
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
                 write('�rea (m'+#253+')                ', VetDependencia[I].Area:14:2);
                 gotoxy(35, 9);
                 write('Per�metro (m)            ', VetDependencia[I].Perimetro:14:2);
                 gotoxy(35, 10);
                 write('N�mero de TUG'+#39+'s          ', VetDependencia[I].NumTUG:11, '.00');
                 gotoxy(35, 11);
                 write('Pot�ncia Ilumina��o (VA) ', VetDependencia[I].PotIlum:11, '.00');
                 gotoxy(35, 12);
                 write('Pot�ncia TUG'+#39+'s (VA)      ', VetDependencia[I].PotTUG:14:2);
                 gotoxy(35, 13);
                 write('Pot�ncia TUE'+#39+'s (VA)      ', VetDependencia[I].PotTUE:11, '.00');
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
             write(' Nome para depend�ncia:'+#10+#13+
                   ' �rea (m'+#253+'):'+#10+#13+
                   ' Per�metro (m):'+#10+#10+#10+#13+
                   ' Tipo de depend�ncia:');

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
                 write('Pot�ncia:');
                 desenhaCampo(@CampPotencia[I]);
             end;

             desenhaListBotao(@ListBotTela2);
             OrdemTela2 := 0;

            {-------------------------------------------------
             while para retorno aos campos ap�s a verifica��o
             e confirma��o de erros nos campos.
             -------------------------------------------------}
             while(true) do
             begin

                {-------------------------------------------------
                 while para retorno aos campos ap�s o usu�rio a-
                 pertar a tecla <TABLE> com o cursor no bot�o
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

                     // Pot�ncia de Ilumina��o------------------------------

                     if(Area > 6) then
                         PotIlum := 100 + 60*trunc((Area - 6)/4)
                     else
                         PotIlum := 100;

                     // N�mero de TUG's-------------------------------------

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
                                 NumTomadas := 1; // c�modos com �rea igual
                                                  // ou inferior a 6m�

                         // cozinha, copa, �rea de servi�o
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

                         // banheiros, varandas, subsolos, garagens, sot�os
                         4, 7, 9, 10:
                             NumTomadas := 1;

                         // corredor
                         6:
                             NumTomadas := 0;
                     end;

                     // Potencia das TUG's----------------------------------

                     case(ListPadrao.I) of

                         // banheiro, cozinha, copa, area de servi�o
                         2, 3, 4, 5:
                             if(NumTomadas > 3) then
                                 PotTUG := 1800 + 100*(NumTomadas - 3)
                             else
                                 PotTUG := 600*NumTomadas;
                         else
                             PotTUG := 100*NumTomadas; // demais c�modos
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

             write(' Pot�ncia Ativa Total de Ilumina��o (W).........', PotIlum, '.00'+#13+#10+
                   ' Pot�ncia Ativa Total das TUG'+#39+'s (W).............', PotTUG:0:2, #13+#10+
                   ' Pot�ncia Ativa Total das TUE'+#39+'s (W).............', PotTUE, '.00'+#13+#10+
                   ' Pot�ncia Ativa Total da Resid�ncia (W).........', PotAtiva:0:2, #13+#10+#10+
                   ' Sua instala��o necessita de um padr�o de entrada ');

             if(PotAtiva <= 12000) then
                 write('monof�sico.')
             else if((PotAtiva > 12000) and (PotAtiva <= 25000)) then
                 write('bif�sico.')
             else
                 write('trif�sico.');

             gotoxy(1, 15);
             write(' Nota: TUG = Tomada de Uso Geral;'+#13+#10+
                   '       TUE = Tomada de Uso Espec�fico.');

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
             Libera mem�ria antes do programa encerrar.
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
