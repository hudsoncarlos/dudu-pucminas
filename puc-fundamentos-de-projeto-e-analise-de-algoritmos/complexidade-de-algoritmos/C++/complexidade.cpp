#include <iostream>
#include <locale.h>

using namespace std;

int main(){
    setlocale(LC_ALL, "Portuguese");

    /*
    * https://www.youtube.com/watch?v=zXBaLEGv0iM&ab_channel=Pontoev%C3%ADrgula
    *   3 Passos para calcular a complexidade:
    *       1 - Levar em consideração apenas as repetições do código.
    *       2 - Verificar a complexidade das funções/metodos próprios da linguagem (se utilizado)
    *       3 - Ignorar as constantes e utilizar o termpo de maior grau.
    */

    cout<<"Olá Mundo!";
    return 0;
}

/*
*   3 Passos para calcular a complexidade:
*       1 - Levar em consideração apenas as repetições do código.
*       2 - Verificar a complexidade das funções/metodos próprios da linguagem (se utilizado)
*       3 - Ignorar as constantes e utilizar o termpo de maior grau.
*   
*   exemplo_1 ---> O(N)
*/
bool exemplo_1(vector<int> vet, int x) {
    
    int tamanho = vet.size(); // O(1)
    
    for (int i = 0; i < tamanho; i++) // O(N)
    {
        if (vet[i] == x) // O(1)
        {
            return true; // O(1)
        }
    }

    return false; // O(1)

    // R: O(N)
}

/*
*   3 Passos para calcular a complexidade:
*       1 - Levar em consideração apenas as repetições do código.
*       2 - Verificar a complexidade das funções/metodos próprios da linguagem (se utilizado)
*       3 - Ignorar as constantes e utilizar o termpo de maior grau.
*
*   exemplo_2 ---> O(N^2)
*/
bool exemplo_2(vector<int> vet, int x) {

    int tamanho = vet.size(); // O(1)

    for (int i = 0; i < tamanho; i++) // O(N)
    {
        for (int j = 0; j < tamanho; j++) // O(N)
        {
            if (i != j && vet[i] == vet[j]) // O(1)
            {
                return true; // O(1)
            }
        }
    }

    return false; // O(1)

    // R: O(N) * O(N) = O(N^2) 
    // 
    // Complexidade quadrática.
}

/*
*   3 Passos para calcular a complexidade:
*       1 - Levar em consideração apenas as repetições do código.
*       2 - Verificar a complexidade das funções/metodos próprios da linguagem (se utilizado)
*       3 - Ignorar as constantes e utilizar o termpo de maior grau.
*
*   exemplo_2 ---> O(N^2)
*/
bool exemplo_3(vector<int> vet, int x) {

    int tamanho = vet.size(); // O(1)

    for (int i = 0; i < tamanho; i++) // O(N)
    {
        for (int j = 0; j < tamanho; j++) // O(N)
        {
            if (i != j && vet[i] == vet[j]) // O(1)
            {
                return true; // O(1)
            }
        }
    }

    return false; // O(1)

    // R: O(N) * O(N) = O(N^2) 
    // 
    // Complexidade quadrática.
}

