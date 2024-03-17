program MaxMin;

const
  n = 10;
  DIRETORIO_DADOS = '.\Dados\vetor.txt';

type
  Vetor = array [1..n] of integer;

var
  A: Vetor;
  arq: file of integer;
  i, numero, maxi: integer;

function Max(var A: Vetor): integer;
var
  i, Temp: integer;
  
begin
  Temp := A[1];

  for i := 2 to n do 
    if Temp < A[i] then 
      Temp := A[i];

  max := Temp
end; { Max }

begin
	assign(arq, DIRETORIO_DADOS);
	reset(arq);

  writeln('Vetor a ser pesquisado:');
  writeln;

  for i := 1 to n do begin   
		readln(arq, numero);    
    A[i] := numero;
    writeln(A[i]: 10)
  end;

  maxi := Max(A);

  writeln;
  writeln;
  writeln('Chave de maior valor = ', maxi);

  close(arq)
end. { MaxMin }