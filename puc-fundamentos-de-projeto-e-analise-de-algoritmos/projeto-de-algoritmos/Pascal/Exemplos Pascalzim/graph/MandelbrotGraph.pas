// ------------------------------------------------------------------------- //
//                                                                           //
// Program: juliaGraph                                                       //
// Versão: 1.0v                                                              //
// Autor: Raphael Augusto                                                    //
// Licença: General Public License(GPL)                                      //
//                                                                           //
// ------------------------------------------------------------------------- //
Program mandelbrotGraph ;
uses Complexo, graph;
Const
	VAL_ESCAPE = 16;
	CORES : array[0..8] of byte = (12, 14, 10, 11, 3, 9, 1, 5, 13);
	
var
	driver, modo : integer;
				  i, j : word;
					c, z : TComplexo;
		    escape : integer;
		 		  zoom : real;
				 	x, y : real;
					    
procedure iniciar();
begin

  // Inicializa o modo gráfico
  driver := VGA;
  modo := GM_800x600  ; {GM_800x600}
  initgraph(driver, modo, '');

  // Verifica se a inicializacao foi feita com sucesso
  if(graphResult <> grOk) then
  Begin
    writeln('Erro ao inicializar o modo grafico:', GraphErrorMsg(graphResult));
    exit;
  End;

end;

Begin

	iniciar();
	
	zoom :=  0.004; {0.004}
	x :=  -2; {2}                 
	y := -1.2; {1.2}

	for i := 0 to GetMaxX do	
	for j := 0 to GetMaxY do
	begin
	
		z := novoComplexo(0, 0);
		c := novoComplexo(i * zoom + x, j * zoom + y);

		escape := 0;
		
		while (escape < VAL_ESCAPE) and (z.parteReal * z.parteReal + z.parteImag * z.parteImag < 4) do
		begin
		
		  // z[n] = z[n - 1]^2 + c
      z := somarComplexo(multiplicarComplexo(z, z), c);
			escape := escape + 1;
			
		end;	

		if escape = VAL_ESCAPE then
			PutPixel(i, j, 0)
		else
			PutPixel(i, j, CORES[(escape {+ random(3) - 1}) mod 9]);			

	end;	
	
	// Desenha os eixos 		
	setColor(white);
	line(0, -round(y/zoom), getMaxX, -round(y/zoom));			
	line(-round(x/zoom), 0, -round(x/zoom), getMaxY);			

	readkey;
	closeGraph();	  

End.