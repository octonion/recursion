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
        m = m+1;
        /* Hit again */
        cards[i] = cards[i]-1;
        m = m+partitions(cards, total);
        cards[i] = cards[i]+1;
      } else if (total==21) {
        /* Stand; hit again is an automatic bust */
        m = m+1;
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
    deck[i] = deck[i]-1;
    p = 0;
    j = 0;
    while (j < 10) {
      deck[j] = deck[j]-1;
      p = p+partitions(deck, j+1);
      deck[j] = deck[j]+1;
      j++;
    }
    printf("Dealer showing %d partitions = %d*n",i,p);
    d = d+p;
    deck[i] = deck[i]+1;
    i++;
  }
  printf("Total partitions = %d*n",d);
  return(0);
}
