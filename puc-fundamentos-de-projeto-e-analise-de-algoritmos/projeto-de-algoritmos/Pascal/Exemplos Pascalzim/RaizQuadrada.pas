// ----------------------------------------------------- //
// Autor: Raphael Augusto                                //
// Nome: raizQuadrada                                    //
// Descri��o: Implementa��o da raiz quadrada baseada no  //
// M�todo de Newton                                      //
// ----------------------------------------------------- //
Program raizQuadrada ;
var num : real;	    

//----------------------------------------------
// Calcula a raiz de x
//----------------------------------------------
Function raiz(x : real) : real;
var y : real;	    
begin
	y := x/2;
	
	if x >= 0 then
	begin
		while abs(y * y - x) > 0.0001 do
			y := (y * y + x)/(2 * y);

		raiz := y;
	end
	else
	begin       
		writeln('Erro: N�o existe valor real.');
		exit();		
	end;
end;
	
//----------------------------------------------
// Programa principal
//----------------------------------------------
Begin
		write('Entre com um numero: ');
		read(num);
	  write('A raiz do numero = ', raiz(num));	  
End.