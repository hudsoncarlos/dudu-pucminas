#include <stdio.h>
#define N 10

typedef int TipoVetor[N];
TipoVetor A;
FILE *arq;
int i, Maxi;

int Max(TipoVetor A)
{ int i, Temp;
  Temp = A[0];
  for (i = 1; i < N; i++) if (Temp < A[i]) Temp = A[i];
  return Temp;
}

int main()
{
  arq = fopen("vetor.txt","r");
  printf("Vetor a ser pesquisado:\n\n");
  for (i = 1; i <= N; i++) 
		{ fscanf(arq, "%d", &A[i-1]);
    	printf("%10d\n", A[i-1]); 
		}
  Maxi = Max(A);
  printf("\nChave de maior valor = %d\n", Maxi);
  fclose(arq);
  return(0);
}