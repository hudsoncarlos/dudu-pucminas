// ------------------------------------------------------------------------- //
// Programa: testeComplexo                                                   //
// Autor: Raphael Augusto                                                    //
// Vers�o: 1.8v                                                              //
// ------------------------------------------------------------------------- //

Program testeComplexo ;
uses Complexo;
var
	z1, z2 : TComplexo;
	
Begin      

	// 8 - 2i	
	z1 := novoComplexo(8, -2);
	mostrarComplexo(z1);
	writeln;

	// 4 - 2i	
	z2 := novoComplexo(4, -2);
	mostrarComplexo(z2);
	writeln;
	
	{produto do cojugado do n�mero complexo}
	writeln(produtoConjugadoComplexo(z1)); {68}
	writeln(produtoConjugadoComplexo(z2)); {20}

	{cojugado do n�mero complexo}
	mostrarComplexo(conjugadoComplexo(z1)); writeln; {8 + 2i}
	mostrarComplexo(conjugadoComplexo(z2)); writeln; {4 + 2i}
	
	{m�dulo do n�mero complexo}
	writeln(moduloComplexo(z1)); {8.24621}
	writeln(moduloComplexo(z2)); {4.47213}

	{argumento do n�mero complexo}
	writeln(argumentoComplexo(z1)); {-0.2449}
	writeln(argumentoComplexo(z2)); {0.46364}

	{argumento do n�mero complexo}
	mostrarComplexo(opostoComplexo(z1)); writeln; {-8 + 2i}
	mostrarComplexo(opostoComplexo(z2)); writeln; {-4 + 2i}

	{igualdade dos n�meros complexos}
	writeln(igualComplexo(z1, z2)); {false}

	{soma dois n�meros complexos}
	mostrarComplexo(somarComplexo(z1, z2)); writeln; {12 - 4i}

	{subtrai dois n�meros complexos}
	mostrarComplexo(subtrairComplexo(z1, z2)); writeln; {4}

	{multiplica dois n�meros complexos}
	mostrarComplexo(multiplicarComplexo(z1, z2)); writeln; {28 - 24i}

	{divide dois n�meros complexos}
	mostrarComplexo(dividirComplexo(z1, z2)); writeln; {1.8 + 0.4i}

	{exponencial do n�mero complexo}
	mostrarComplexo(expComplexo(z1)); writeln; {-1240.516 - 2710.577i}
	mostrarComplexo(expComplexo(z2)); writeln; {-22.720 - 49.645i}

	{logaritmo do n�mero complexo}
	mostrarComplexo(lnComplexo(z1)); writeln; {2.109 - 0.244i}
	mostrarComplexo(lnComplexo(z2)); writeln; {1.497 - 0.463i}

	{pot�ncia do n�mero complexo}
	mostrarComplexo(potenciaComplexo(z1, z2)); writeln; {1325.817 + 2503.509i}

	{raiz do n�mero complexo}
	mostrarComplexo(raizComplexo(z1, z2)); writeln; {1.542 + 0.252i}

	{seno do n�mero complexo}
	mostrarComplexo(senComplexo(z1)); writeln; {3.722 + 0.527i}
	mostrarComplexo(senComplexo(z2)); writeln; {-2.847 + 2.371i}

	{cosseno do n�mero complexo}
	mostrarComplexo(cosComplexo(z1)); writeln; {-0.547 + 3.588i}
	mostrarComplexo(cosComplexo(z2)); writeln; {-2.459 - 2.744i}

	{tangente do n�mero complexo}
	mostrarComplexo(tanComplexo(z1)); writeln; {-0.010 - 1.035i}
	mostrarComplexo(tanComplexo(z2)); writeln; {0.036 - 1.004i}

	readkey;
End.