(define (add1 n)
  (+ n 1)
  )

(define (sub1 n)
  (+ n -1)
  )

(define (partitions cards subtotal)
  (define m 0)
  (do ((i 0 (1+ i)))
      ((> i 9))
    (if (> (vector-ref cards i) 0)
	  (cond
	   ((< (add1 (+ subtotal i)) 21)
	    (set! m (add1 m))
	    (vector-set! cards i (sub1 (vector-ref cards i)))
	    (set! m (+ m (partitions cards (add1 (+ subtotal i)))))
	    (vector-set! cards i (add1 (vector-ref cards i))))
	   ((= (add1 (+ subtotal i)) 21)
	    (set! m (add1 m))))))
m)

(define deck (vector 4 4 4 4 4 4 4 4 4 16))

(define d 0)
(define p 0)
(define n 0)

(do ((i 0 (1+ i)))
    ((> i 9))
  (vector-set! deck i (sub1 (vector-ref deck i)))
  (set! p 0)
  (do ((j 0 (1+ j)))
      ((> j 9))
    (vector-set! deck j (sub1 (vector-ref deck j)))
    (set! n (partitions deck (add1 j)))
    (vector-set! deck j (add1 (vector-ref deck j)))
    (set! p (+ p n)))
  (display (list i p))
  (newline)
  (set! d (+ d p))
  (vector-set! deck i (add1 (vector-ref deck i))))

(display d)
(newline)
