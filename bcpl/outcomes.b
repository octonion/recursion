get "libhdr"

let partitions(cards, subtotal) = valof $(
  let m = 0
	let total = 0
	
  for i = 0 to 9 do $(
    if cards!i > 0 $(
      total := subtotal+i+1
      test (total < 21) then $(
        m := m+1
				cards!i := cards!i-1
        m := m+partitions(cards, total)
				cards!i := cards!i+1
			$)
      else $(
        if total = 21 m := m+1
			  break
			$)
		$)
  $)
  resultis m
$)

let start() = valof $(

  let deck = getvec(10)
	let d=0
	let p=0
	let n=0
	
  for i = 0 to 8 do $( deck!i := 4 $)
  deck!9 := 16
  
  for i = 0 to 9 do $(
    deck!i := deck!i-1
    p := 0
    for j = 0 to 9 do $(
      deck!j := deck!j-1
      n := partitions(deck, j+1)
      deck!j := deck!j+1
      p := p+n
    $)
    writef("Dealer showing %i1, partitions = %i1*n", i, p)
    d := d+p
    deck!i := deck!i+1
  $)
  writef("Total partitions = %i1*n",d)
$)
