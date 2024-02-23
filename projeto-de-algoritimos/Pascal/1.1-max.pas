program maxmin;

const
  n = 10;

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
  reset(arq, 'C:\\Users\\duduwindows\\source\\repos\\dudu-pucminas\\projeto-de-algoritimos\\Pascal\\vetor.txt');
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
end. { maxmin }