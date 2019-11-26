#include <stdio.h>

int partitions_(int *, int *);
int main(void)
{

  int deck[] = {4,4,4,4,4,4,4,4,4,16};
  int d=0;
  
  for (int i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] -= 1;
    int p = 0;
    for (int j = 0; j < 10; j++) {
      deck[j] -= 1;
			int k = j+1;
      p += partitions_(deck, &k);
      deck[j] += 1;
    }

    printf("Dealer showing %i partitions = %i\n",i,p);
    d += p;
    deck[i] += 1;
  }
  printf("Total partitions = %i\n",d);

  return 0;
}
