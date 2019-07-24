module main
import os

fn partitions(cards []int, subtotal int) int {
   mut m := 0
	 mut total := 0
   // Hit
   for i := 0; i < 10; i++ {
     if cards[i] > 0 {
       total = subtotal+i+1
    	 if (total < 21) {
	       // Stand
	       m += 1
	       // Hit again
	       cards[i] = cards[i]-1
	       m += partitions(cards, total)
	       cards[i] = cards[i]+1
       } else if total==21 {
	       // Stand; hit again is an automatic bust
	       m += 1
	       break
	     }
	   }
   }
   return m
}

fn main() {

	mut deck := [4,4,4,4,4,4,4,4,4,16]
  mut d := 0
  
  for i := 0; i < 10; i++ {
    // Dealer showing
    deck[i] = deck[i]-1
    mut p := 0
    for j := 0; j < 10; j++ {
      deck[j] = deck[j]-1
      p += partitions(deck, j+1)
      deck[j] = deck[j]+1
    }

    println('Dealer showing $i partitions = $p')
    d += p
    deck[i] = deck[i]+1
  }
  println('Total partitions = $d')
}

