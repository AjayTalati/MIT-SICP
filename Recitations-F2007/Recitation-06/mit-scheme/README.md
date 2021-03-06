Recitation 6
============ 

Contains worked solutions expressed in the MIT Scheme dialect.

Core code that is used throughout these examples:

**Data Structures**

```scheme
(define (make-units C L H)
 (list C L H))
(define get-units-C car)
(define get-units-L cadr)
(define get-units-H caddr)

(define (make-class number units)
 (list number units))
(define get-class-number car)
(define get-class-units cadr)

(define (get-class-total-units class)
 (let ((units (get-class-units class)))
  (+ 
   (get-units-C units)
   (get-units-L units)
   (get-units-H units))))

;;
;; Change the definition of this procedure, so we can use
;; non-integer class "numbers" as well (i.e., CALC101 for 
;; an example calculus class).
;;
;; Handout uses "=" for comparison, we will use "equal?".
;;
(define (same-class? c1 c2)
 (equal? (get-class-number c1) (get-class-number c2)))
```

**HOPs**
```scheme
(define (make-student number schedule-checker)
 (list number (list) schedule-checker))
(define get-student-number car)
(define get-student-schedule cadr)
(define get-student-checker caddr)

(define (update-student-schedule student schedule)
 (if ((get-student-checker student) schedule)
     (list (get-student-number student)
           schedule
           (get-student-checker student))
     (error "invalid schedule")))
```
