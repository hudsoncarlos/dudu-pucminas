// ---------------------------------------------------------------------------- //
//   Programa: arvore                                                           //
//   Versão: 1.0v                                                               //
//   Autor : Raphael Augusto                                                    //
//   Descrição: Desenha uma árvore                                              //
// ---------------------------------------------------------------------------- //

Program arvore ;
uses graph;
const
	AUREA = (sqrt(5) - 1)/2;
	NIVEIS = 11;
	
var
	  var_angulo : real = 0;
	driver, modo : integer;
     quadro, c : byte;
						 
procedure fractal(cont : integer; x, y : real; angulo, tamanho : real);
var
	i, j : real;
	
begin

	if cont >= 1 then
	begin
		
		i := x + cos(angulo) * tamanho;
		j := y + sin(angulo) * tamanho;
		
		line(round(x), round(y), round(i), round(j));
		
		fractal(cont - 1, i, j, angulo - VAR_ANGULO, tamanho * AUREA);			
		fractal(cont - 1, i, j, angulo + VAR_ANGULO, tamanho * AUREA);			

	end;

end;
	
Begin
	
  // Inicializa o modo grafico
  driver := VGA;
  modo := GM_800x600;
  initgraph(driver, modo, '');

  // Verifica se a inicialização foi feita com sucesso
  if(graphResult <> grOk) then
  Begin
  
    writeln('Erro ao inicializar o modo grafico:', GraphErrorMsg(graphResult));
    exit;
  
	End;

	setbkcolor(white);
	setcolor(black);
	
	for c := 1 to 60 do
	begin
	
		if quadro = 0 then 
			quadro := 1 else quadro := 0;
		
		SetActivePage(quadro);
	  clearDevice();
		
		var_angulo := c * 0.017453; 
		fractal(NIVEIS, getMaxX/2, getMaxY, 3 * PI/2, 225);

		SetVisualPage(quadro);
	
	end;
	
	readkey;
	closeGraph();
	  
End.