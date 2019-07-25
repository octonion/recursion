partitions(cards, subtotal)
{
  auto i, m, total;
      
  m = 0;
  /* Hit */
  i = 0;
  while (i < 10) {
    if (cards[i]>0) {
      total = subtotal+i+1;
      if (total < 21) {
        /* Stand */
        m++;
        /* Hit again */
        cards[i]--;
        m = m+partitions(cards, total);
        cards[i]++;
      } else if (total==21) {
        /* Stand; hit again is an automatic bust */
        m++;
        i++;
        break;
      }
    }
    i++;
  }
  return(m);
}

main()
{
  auto d, i, j, p, deck[10];
  
  i = 0;
  while (i < 9) {
    deck[i++] = 4;
  }
  deck[9] = 16;

  d = 0;
  i = 0;
  while (i < 10) {
    /* Dealer showing */
    deck[i]--;
    p = 0;
    j = 0;
    while (j < 10) {
      deck[j]--;
      p = p+partitions(deck, j+1);
      deck[j]++;
      j++;
    }
    printf("Dealer showing %d partitions = %d*n",i,p);
    d = d+p;
    deck[i]++;
    i++;
  }
  printf("Total partitions = %d*n",d);
  return(0);
}
