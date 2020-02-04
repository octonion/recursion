package outcomes

import "core:fmt"

partitions :: proc(cards: []int, subtotal: int) -> int {
    m := 0;
    // Hit
    for i:=0; i < 10; i += 1 {
        if (cards[i]>0) {
            total := subtotal+i+1;
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

main :: proc() {
	deck := []int{4,4,4,4,4,4,4,4,4,16};
	d := 0;

	for i:=0; i < 10; i += 1 {
		// Dealer showing
		deck[i] += -1;
		p := 0;
		for j:=0; j < 10; j += 1 {
			deck[j] += -1;
			p += partitions(deck, j+1);
			deck[j] += 1;
		}
		fmt.println("Dealer showing ", i," partitions =",p);
		d += p;
		deck[i] += 1;
	}
	fmt.println("Total partitions =",d);
}
