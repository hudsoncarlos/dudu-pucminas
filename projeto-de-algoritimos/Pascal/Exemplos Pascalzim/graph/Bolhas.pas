Program Pascalzim ;
uses graph ;
var driver, modo: integer ;
Begin
  // Inicializa o modo grafico
  driver := Detect;
  initgraph(driver, modo, '');
  
  // Verifica se a inicializacao foi feita com sucesso
  if(graphResult <> grOk) then
  Begin
    writeln('Erro ao inicializar o modo grafico:', GraphErrorMsg(graphResult));
    exit;
  End;
  
  // Desenha circulos até pressionar alguma tecla
  Randomize;
  repeat
    SetColor(Random(GetMaxColor)+1);    
    circle(Random(GetMaxX), Random(GetMaxY), 10);
    delay(5);
  until KeyPressed;
  
  // Fecha o modo grafico
  readkey;
  closegraph;
End.