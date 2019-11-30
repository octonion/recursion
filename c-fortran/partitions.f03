recursive integer function partitions(cards,subtotal) result(m)
  integer :: total
  integer, dimension(1:10) :: cards
  integer :: subtotal

  m = 0
  ! Hit
  do i = 1, 10
     if (cards(i)>0) then
        total = subtotal+i
        if (total < 21) then
           ! Stand
           m = m+1
           ! Hit again
           cards(i) = cards(i)-1
           m = m+partitions(cards, total)
           cards(i) = cards(i)+1
        else if (total==21) then
           ! Stand; hit again is an automatic bust
           m = m+1
           exit
        end if
     end if
  end do
end function partitions
