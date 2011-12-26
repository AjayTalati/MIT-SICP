
(defun mul-interval (x y)
  ;;
  ;; CASE I:
  ;;
  ;;   0  x x
  ;; --+-------
  ;;   0  y y 
  ;;
  (cond ((and (> (lower-bound x) 0) (> (lower-bound y) 0))
	 (make-interval 
	  (* (lower-bound x) (lower-bound y))
	  (* (upper-bound x) (upper-bound y))))

	;;
	;; CASE II:
	;; 
	;;   x x  0
	;; -------+--
	;;   y y  0 
	;;
	((and (< (upper-bound x) 0) (< (upper-bound y) 0))
	 (make-interval 
	  (* (upper-bound x) (upper-bound y))
	  (* (lower-bound x) (lower-bound y))))

	;;
	;; CASE III:
	;;    
	;;        0  x x
	;; -------+------- 
	;;   y y  0
	;;
	((and (> (lower-bound x) 0) (< (upper-bound y) 0))
	 (make-interval
	  (* (upper-bound x) (lower-bound y))
	  (* (lower-bound x) (upper-bound y))))

	;;
	;; CASE IV:
	;;
	;;   x x  0 
	;; -------+-------
	;;        0  y y
	;;
	((and (< (upper-bound x) 0) (> (lower-bound y) 0))
	 (make-interval (* (upper-bound y) (lower-bound x)) (* (lower-bound y) (upper-bound x))))


	;;
	;; CASE V:
	;;
	;;   x  0    x
	;; -----+-------
	;;      0  y y
	;;
	((and (< (lower-bound x) 0) (> (upper-bound x) 0) (> (lower-bound y) 0))
	 (make-interval
	  (* (lower-bound x) (upper-bound y))
	  (* (upper-bound x) (upper-bound y))))

	;;
	;; CASE VI:
	;; 
	;;   x   0     x
	;; ------+--------
	;;  y y  0
	;;
	((and (< (lower-bound x) 0) (> (upper-bound x) 0) (< (upper-bound y) 0))
	 (make-interval
	  (* (upper-bound x) (lower-bound y))
	  (* (lower-bound x) (lower-bound y))))

	;;
	;; CASE VII:
	;;
	;;       0  x x 
	;; ------+-------
	;;   y   0  y
	;;
	((and (< (lower-bound y) 0) (> (upper-bound y) 0) (> (lower-bound x) 0))
	 (make-interval
	  (* (lower-bound y) (upper-bound x))
	  (* (upper-bound x) (upper-bound y))))

	;;
	;; CASE VIII:
	;;
	;;   x x  0
	;; -------+-----
	;;  y     0  y
	;; 
	((and (< (lower-bound y) 0) (> (upper-bound y) 0) (< (upper-bound x) 0))
	 (make-interval
	  (* (upper-bound y) (lower-bound x))
	  (* (lower-bound x) (lower-bound y))))

	;;
	;; CASE IX:
	;;
	;; Everything else!
	;;
	(t
	 (let ((p1 (* (lower-bound x) (lower-bound y)))
	       (p2 (* (lower-bound x) (upper-bound y)))
	       (p3 (* (upper-bound x) (lower-bound y)))
	       (p4 (* (upper-bound x) (upper-bound y))))
	   (make-interval (min p1 p2 p3 p4)
			  (max p1 p2 p3 p4))))))

;;
;; For the sake of reference and comparison, let's define the old multiplication
;; scheme, so that we can compare if the answers agree between the two versions:
;;
(defun mul-interval-old (x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
	(p2 (* (lower-bound x) (upper-bound y)))
	(p3 (* (upper-bound x) (lower-bound y)))
	(p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
		   (max p1 p2 p3 p4))))

;;
;; Define also the constructors and selectors, so we can work with intervals.
;;
;; Add (simple) type-checking to constructor, to make sure we are working with
;; a valid range:
;;
(defun make-interval (a b)
  (cond ((< a b) (cons a b))
	(t 
	 (princ "error constructing interval!"))))
(defun lower-bound (x) (car x))
(defun upper-bound (x) (cdr x))

;; 
;; Case I Tests:
;;
(setq p1 (make-interval 3 4))
(setq p2 (make-interval 5 6))

(mul-interval p1 p2)
;; ==> (15 . 24)
(equal (mul-interval p1 p2) (mul-interval-old p1 p2))
;; ==> t

;; 
;; Case II Tests:
;;
(setq q1 (make-interval -10 -8))
(setq q2 (make-interval -4 -3))

(mul-interval q1 q2)
;; ==> (24 . 40)
(equal (mul-interval q1 q2) (mul-interval-old q1 q2))
;; ==> t

;;
;; Case III Tests:
;;
(mul-interval p1 q1)
;; ==> (-40 . -24)
(mul-interval p1 p2)
;; ==> (-16 . -9)
(mul-interval p2 q1)
;; ==> (-60 . -40)
(mul-interval p2 q2)
;; ==> (-24 . -15)

(equal (mul-interval p1 q1) (mul-interval-old p1 q1))
;; ==> t
(equal (mul-interval p1 q2) (mul-interval-old p1 q2))
;; ==> t
(equal (mul-interval p2 q1) (mul-interval-old p2 q1))
;; ==> t
(equal (mul-interval p2 q2) (mul-interval-old p2 q2))
;; ==> t

;;
;; Case IV Tests:
;;
(mul-interval q1 p1)
;; ==> (-40 . 24)
(mul-interval q1 p2)
;; ==> (-60 . -40)
(mul-interval q2 p1)
;; ==> (-16 . -9)
(mul-interval q2 p2)
;; ==> (-24 . -15)

(equal (mul-interval q1 p1) (mul-interval-old q1 p1))
;; ==> t
(equal (mul-interval q1 p2) (mul-interval-old q1 p2))
;; ==> t
(equal (mul-interval q2 p1) (mul-interval-old q2 p1))
;; ==> t
(equal (mul-interval q2 p2) (mul-interval-old q2 p2))
;; ==> t

;;
;; Case V Tests:
;;
(setq r1 (make-interval -2 5))
(mul-interval r1 p1)
;; ==> (-8 . 20)
(mul-interval r1 p2)
;; ==> (-12 . 30)

(equal (mul-interval r1 p1) (mul-interval-old r1 p1))
;; ==> t
(equal (mul-interval r1 p2) (mul-interval-old r1 p2))
;; ==> t

;;
;; Case VII Tests:
;;
(mul-interval p1 r1)
;; ==> (-8 . 20)
(mul-interval p2 r1)
;; ==> (-12 . 30)

(equal (mul-interval p1 r1) (mul-interval-old p1 r1))
;; ==> t
(equal (mul-interval p2 r1) (mul-interval-old p2 r1))
;; ==> t

(mul-interval q1 r1)
;; ==> (-50 . 20)
(mul-interval q2 r1)
;; ==> (-20 . 8)

(equal (mul-interval q1 r1) (mul-interval-old q1 r1))
;; ==> t
(equal (mul-interval q2 r1) (mul-interval-old q2 r1))
;; ==> t