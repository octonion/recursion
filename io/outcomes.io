partitions := method(cards, subtotal,
result := 0;
// Hit
//cards asString println;
for(i,0,9,
    if(cards at(i)>0) then(
      total := subtotal+i+1;
      if(total<21) then(
        // Stand
        result := result+1;
        // Hit again
        cards atPut(i, (cards at(i))-1);
        result := result+partitions(cards, total);
        cards atPut(i, (cards at(i))+1);
      ) elseif(total==21) then(
        // Stand; hit again is an automatic bust
        result := result+1;
        break;
      );
    );
  );
  result;
);

deck := list(4,4,4,4,4,4,4,4,4,16);

d := 0;

for(i,0,9,
    // Dealer showing
    deck atPut(i,(deck at(i))-1);
    p := 0;
    for(j,0,9,
        deck atPut(j,(deck at(j))-1)
        p := p+partitions(deck, j+1)
	deck atPut(j,(deck at(j))+1)
    )
    list("Dealer showing ",i asString," partitions = ",p asString) join println;
    d := d+p;
    deck atPut(i,(deck at(i))+1);
)

list("Total partitions = ",d asString) join println;
