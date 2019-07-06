import "regent"

local c = terralib.includec("stdio.h")

task partitions(cards : int[10], subtotal : int) : int
  var m = 0
  -- Hit
  for i = 0, 10 do
    if (cards[i]>0) then
  	  var total = subtotal+i+1
  	  if (total < 21) then
  	    -- Stand
  	    m += 1
  	    -- Hit again
  	    cards[i] -= 1
  	    m += partitions(cards, total)
  	    cards[i] += 1
  	  else
  		  if (total==21) then
  	      -- Stand; hit again is an automatic bust
  	      m += 1
  	      break
  		  end
  	  end
    end
	end
  return m
end

task main()
  var deck = array(4,4,4,4,4,4,4,4,4,16)
  var d=0
  
  for i = 0, 10 do
    -- Dealer showing
    deck[i] -= 1
    var p = 0
    for j = 0, 10 do
      deck[j] -= 1
      p += partitions(deck, j+1)
      deck[j] += 1
    end
		
    c.printf("Dealer showing %i partitions = %i\n",i,p)
    d += p
    deck[i] += 1
  end
  c.printf("Total partitions = %i\n",d)
end
regentlib.start(main)
