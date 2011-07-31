;;
;; Exercise 1.37
;;
;; [xx]
;;

;; 
;; Recursive Definition:
;;
(define (cont-frac n d k)
  (define (cont-frac-iter i)
    (cond ((= i k) (/ (n i) (d i)))
	  (else
	   (/ (n i) (+ (d i) (cont-frac-iter (+ i 1)))))))
  (cont-frac-iter 1))

;;
;; Configure numerator and denominator to always return 1.0, as in "phi" example:
;;
(define n (lambda (x) 1.0))
(define d (lambda (x) 1.0))

;; 
;; The following unit tests all assert to true:
;;
(= (/ 1.0 1.0) (cont-frac n d 1))
(= (/ 1.0 2.0) (cont-frac n d 2))
(= (/ 2.0 3.0) (cont-frac n d 3))
(= (/ 3.0 5.0) (cont-frac n d 4))
(= (/ 5.0 8.0) (cont-frac n d 5))
(= (/ 8.0 13.0) (cont-frac n d 6))
(= (/ 13.0 21.0) (cont-frac n d 7))
(= (/ 21.0 34.0) (cont-frac n d 8))
(= (/ 34.0 55.0) (cont-frac n d 9))
(= (/ 55.0 89.0) (cont-frac n d 10))

;;
;; Now let's update the denominator procedure:
;;
(define d (lambda (x) 2.0))

;;
;; The following unit tests all assert to true:
;;
(= (/ 1.0 2.0) (cont-frac n d 1))
(= (/ 2.0 5.0) (cont-frac n d 2))
(= (/ 5.0 12.0) (cont-frac n d 3))
(= (/ 12.0 29.0) (cont-frac n d 4))
(= (/ 29.0 70.0) (cont-frac n d 5))

;;
;; Note the Fibonacci sequence generated in the numerator-to-denominator ratios.
;;

;;
;; Now let's update the denominator to always be 1, and the numerator to always be 2:
;;
(define n (lambda (x) 2.0))
(define d (lambda (x) 1.0))

;;
;; The following unit tests all assert to true:
;;
(= 2.0 (cont-frac n d 1))
(= (/ 2.0 3.0) (cont-frac n d 2))
(= (/ 6.0 5.0) (cont-frac n d 3))
(= (/ 10.0 11.0) (cont-frac n d 4))
(= (/ 22.0 21.0) (cont-frac n d 5))

;;
;; Iterative:
;;
(define (cont-frac n d k)
  (define (term i t)
    (/ (n i) (+ (d i) t)))
  (define (cont-frac-iter i t)
    (cond ((= i 1) (term i t))
	  (else
	   (cont-frac-iter (- i 1) (term i t)))))
  (cont-frac-iter k 0))

    