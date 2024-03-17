program input_Aluno;
uses crt;
var nome,cpf,idade : string;
begin
    clrscr;
    writeln('Insira os dados do aluno');
    writeln('....................');
    write('Nome: ');readln(nome);
    write('Cpf: ');readln(cpf);
    write('Idade: ');readln(idade);

    writeln;    
    writeln('Nome: ', nome);
    writeln('Cpf: ', cpf);
    writeln('Idade: ', idade);
end.