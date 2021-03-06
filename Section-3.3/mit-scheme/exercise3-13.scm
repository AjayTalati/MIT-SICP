;;
;; Exercise 3.13
;;
;; Consider the following "make-cycle" procedure, which uses the "last-pair" procedure
;; defined in Exercise 3.12:
;;
;; (define (make-cycle x)
;;  (set-cdr! (last-pair x) x)
;;  x)
;;
;; Draw a box-and-pointer diagram that shows the structure z created by
;;
;; (define z (make-cycle (list 'a 'b 'c)))
;;
;; What happens if we try to compute (last-pair z)?
;;

;;
;; If we were to simply evaluate an expression like (define z (list 'a 'b 'c)), 
;; the corresponding box-and-pointer diagram would look like:
;;
       --- ---       --- ---       --- --- 
z --> | * | * | --> | * | * | --> | * | / |  
       --- ---       --- ---       --- ---
        |             |             |
        v             v             v
       ---           ---           --- 
      | a |         | b |         | c |
       ---           ---           ---

;;
;; Note that the "cdr" of the last pair is nil, or "/" in the diagram.
;;

;;
;; We desire instead the box-and-pointer diagram for (define z (make-cycle (list 'a 'b 'c))), 
;; where the "make-cycle" procedure is defined as:
;;
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

;; 
;; The corresponding box-and-pointer diagram will look like:
;;

         --------------------------------
        |                                |
        v                                |
       --- ---       --- ---       --- ---
z --> | * | * | --> | * | * | --> | * | * |
       --- ---       --- ---       --- ---
        |             |             |
        v             v             v
       ---           ---           ---
      | a |         | b |         | c |
       ---           ---           ---

;;
;; What happens if we try to evaluate (last-pair z)? 
;;

;;
;; The "last-pair" procedure is defined as:
;;
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

;;
;; The "last-pair" procedure iteratively tranverse the list structure, 
;; looking for the "last pair" in the list structure so that it can 
;; return it. It decides whether a particle node in the list is the 
;; "last pair" by testing the "cdr" element of that pair. If the result
;; is null, the prcedure halts and retursn that element.
;;
;; With the way we have defined z above, as a circular list, there is 
;; no "last pair" (i.e., there is no node in the last whose "cdr" element 
;; is nil), and hence invoking (last-pair z) initiates a computational
;; process which never termintes. The processor gets stuck in an infinite 
;; loop.
;;