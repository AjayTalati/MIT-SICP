;;
;; Exercise 2.18
;;
;; Define a procedure "reverse" that takes a list as argument and returns a list of the 
;; same elements in reverse order:
;;
;; (reverse (list 1 4 9 16 25))
;; ==> (25 16 9 4 1)
;;

;;
;; Implement the reverse procedure using "append":
;;
(define (reverse original)
  (if (null? original)
      '()
      (append (reverse (cdr original)) (list (car original)))))

;;
;; Run a unit test:
;;
(reverse (list 1 4 9 16 25))
;; ==> (25 16 9 4 1)

;;
;; Let's try a few more unit tests:
;;
(reverse '())
;; ==> ()
(reverse (list 1))
;; ==> (1)
(reverse (list 1 2))
;; ==> (2 1)
(reverse (list 1 2 3))
;; ==> (3 2 1)

;;
;; As an addendum, it's worth pointing out that we can define a "reverse" procedure 
;; that runs in linear time:
;;
(define (reverse original)
  (define (reverse-iter lst1 lst2)
    (if (null? lst1)
	lst2
	(reverse-iter (cdr lst1) (cons (car lst1) lst2))))
  (reverse-iter original '()))

;;
;; Unit test:
;;
(reverse (list 1 2 3))
;; ==> (3 2 1)