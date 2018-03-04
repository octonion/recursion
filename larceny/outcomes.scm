(import (scheme write))

(define (add1 n)
  (+ n 1)
  )

(define (sub1 n)
  (+ n -1)
  )

(define (partitions cards subtotal)
  (define m 0)
  (let player-card ((i 0))
    (if (> (vector-ref cards i) 0)
	(cond
	 ((< (add1 (+ subtotal i)) 21)
	  (set! m (add1 m))
	  (vector-set! cards i (sub1 (vector-ref cards i)))
	  (set! m (+ m (partitions cards (add1 (+ subtotal i)))))
	  (vector-set! cards i (add1 (vector-ref cards i))))
	 ((= (add1 (+ subtotal i)) 21)
	  (set! m (add1 m)))))
    (if (< i 9) (player-card (+ i 1))))
  m)

(define deck (vector 4 4 4 4 4 4 4 4 4 16))

(define d 0)
(define p 0)
(define n 0)

(let dealer-card ((i 0))
  (vector-set! deck i (sub1 (vector-ref deck i)))
  (set! p 0)
  (let player-card ((j 0))
    (vector-set! deck j (sub1 (vector-ref deck j)))
    (set! n (partitions deck (add1 j)))
    (vector-set! deck j (add1 (vector-ref deck j)))
    (set! p (+ p n))
    (if (< j 9) (player-card (+ j 1))))
  (display (list i " " p))
  (newline)
  (set! d (+ d p))
  (vector-set! deck i (add1 (vector-ref deck i)))
  (if (< i 9) (dealer-card (+ i 1))))

(display d)
(newline)
