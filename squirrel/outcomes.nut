function partitions(cards, subtotal)
    {
      local m=0;
      // Hit
      for (local i = 0; i < 10; i++) {
	if (cards[i]>0) {
	  local total = subtotal+i+1;
	  if (total < 21) {
	    // Stand
	    m += 1;
	    // Hit again
	    cards[i] -= 1;
	    m += partitions(cards, total);
	    cards[i] += 1;
	  } else if (total==21) {
	    // Stand; hit again is an automatic bust
	    m += 1;
	    break;
	  }
	}
      }
      return m;
    }

local deck = [4,4,4,4,4,4,4,4,4,16];
local d=0;
  
for (local i = 0; i < 10; i++) {
  // Dealer showing
  deck[i] -= 1;
  local p = 0;
  for (local j = 0; j < 10; j++) {
    deck[j] -= 1;
    p += partitions(deck, j+1);
    deck[j] += 1;
  }

  print("Dealer showing "+i+" partitions = "+p+"\n");
  d += p;
  deck[i] += 1;
}
print("Total partitions = "+d+"\n");
