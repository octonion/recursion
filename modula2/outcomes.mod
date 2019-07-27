(* $Source$
 * $State$
 * $Revision$
 *)
 
MODULE outcomes;
FROM InOut IMPORT WriteInt, WriteLn, WriteString;

TYPE
   stack = ARRAY [0..9] OF INTEGER;

VAR
   deck	   : stack;
   i, j, d, p    : INTEGER;

PROCEDURE partitions(VAR cards: stack; subtotal: INTEGER): INTEGER;
VAR
  i, total, m : INTEGER;
BEGIN
   m := 0;
   (* Hit *)
   FOR i := 0 TO 9 DO
     IF (cards[i]>0) THEN
       total := subtotal+i+1;
       IF (total < 21) THEN
         (* Stand *)
	 m := m+1;
	 (* Hit again *)
	 cards[i] := cards[i]-1;
	 m := m+partitions(cards, total);
	 cards[i] := cards[i]+1
       ELSIF (total=21) THEN
         (* Stand; hit again is an automatic bust *)
	 m := m+1;
	 (* BREAK; *)
       END;
     END;
   END;
   RETURN(m)
END partitions;
    
BEGIN
   d := 0;

   FOR i := 0 TO 8 DO
     deck[i] := 4;
   END;
   deck[9] := 16;

   FOR i := 0 TO 9 DO
      (* Dealer showing *)
      deck[i] := deck[i]-1;
      p := 0;
      FOR j := 0 TO 9 DO
	 deck[j] := deck[j]-1;
	 p := p+partitions(deck, j+1);
	 deck[j] := deck[j]+1;
      END;
      d := d+p;
      deck[i] := deck[i]+1;
      WriteString("Dealer showing ");
      WriteInt(i,1);
      WriteString(" partitions = ");
      WriteInt(p,1);
      WriteLn;
   END;
   WriteString("Total partitions = ");
   WriteInt(d,1);
	 WriteLn;
END outcomes.
