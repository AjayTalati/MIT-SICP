;;
;; Exercise 2.69
;;
;; [WORKING]
;;

;;
;; First let's import all the prior procedures:
;;
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (make-code-tree left right)
  (list left
	right
	(append (symbols left) (symbols right))
	(+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

;;
;; Procedures for decoding symbols:
;;
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
	((= bit 1) (right-branch branch))
	(else
	   (error "Bad bit -- CHOOSE BRANCH" bit))))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
	'()
	(let ((next-branch 
	                     (choose-branch (car bits) current-branch)))
	      (if (leaf? next-branch)
		        (cons (symbol-leaf next-branch)
			              (decode-1 (cdr bits) tree))
			            (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

;;
;; Define the encoding procedures:
;;
(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else 
	  (element-of-set? x (cdr set)))))
  
(define (encode-symbol symbol tree)

  ;; Version of reverse that runs in O(n) linear time
  (define (reverse items)
    (define (reverse-iter lst1 lst2)
      (if (null? lst1)
	    lst2
	      (reverse-iter (cdr lst1) (cons (car lst1) lst2))))
    (reverse-iter items '()))

  ;; Build up the encoding using constant time "cons", 
  ;; and then reverse the list once done.. should be 
  ;; faster than repeatedly invoking "append".
  (define (encode-symbol-iter working total)
    (if (leaf? working)
	(reverse total)
	(let ((symbols-left (symbols (left-branch working)))
	            (symbols-right (symbols (right-branch working))))
	    (cond ((element-of-set? symbol symbols-left)
		    (encode-symbol-iter (left-branch working) (cons 0 total)))
		  ((element-of-set? symbol symbols-right)
		    (encode-symbol-iter (right-branch working) (cons 1 total)))
		  (else 
		    (error "Bad symbol: ENCODE-SYMBOL" symbol))))))
  (encode-symbol-iter tree '()))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	            (encode (cdr message) tree))))

;;
;; In addition, we require two methods defined in the text for building up leaf-sets:
;;
(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((< (weight x) (weight (car set))) (cons x set))
	(else
	 (cons (car set)
	       (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
	(adjoin-set (make-leaf (car pair)    ;; symbol
			       (cadr pair))  ;; frequency
		    (make-leaf-set (cdr pairs))))))

;;
;; First let's play with "make-leaf-set" to get a sense for how it performs:
;;
(make-leaf-set '((a 8) (b 3)))
;; ==> ((leaf b 3) (leaf a 8))
(make-leaf-set '((a 8) (b 3) (c 100) (d 1)))
;; ==> ((leaf d 1) (leaf b 3) (leaf a 8) (leaf c 100))

;;
;; So "adjoin-set" generates a list of leaves, ordered by frequency, and sorted 
;; in order of increasing frequency (which, indeed, is evident from looking at the 
;; definition of the procedure).
;;

;;
;; To define "generate-huffman-tree", we will go back to our old friend "accumulate":
;;
(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq)
	  (accumulate op init (cdr seq)))))

;; 
;; Let's make sure we have our "linear time" reverse operation available:
;;
(define (reverse items)
  (define (reverse-iter lst1 lst2)
    (if (null? lst1)
	lst2
	(reverse-iter (cdr lst1) (cons (car lst1) lst2))))
  (reverse-iter items '()))

;;
;; With this, we can now define our "successive-merge" procedure:
;;
(define (successive-merge pairs)
  ;; Use as the "lambda" procedure in accumulate:
  (define (successive-merge-lambda a b)
    (if (null? b)
	a
	(make-code-tree a b)))

  ;; Generate an accumulation:
  (accumulate successive-merge-lambda '() (reverse pairs)))

;;
;; And finally generate the Huffman tree:
;;
(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

;;
;; Let's see if we can get it to work:
;;
(define tree1 (generate-huffman-tree '((a 4) (b 2) (c 1) (d 1))))

(encode-symbol 'a tree1)
;; ==> (0)
(encode-symbol 'b tree1)
;; ==> (1 0)
(encode-symbol 'c tree1)
;; ==> (1 1 0)
(encode-symbol 'd tree1)
;; ==> (1 1 1)

;;
;; Not that this encoding is slightly different from that given in the text, 
;; but that's OK. So long as we use the same tree for encoding/decoding, we'll 
;; generate consistent results:
;;
(encode '(a d a b b c) tree1)
;; ==> (0 1 1 10 1 0 1 0 1 1 0)

(decode (encode '(a d a b b c) tree1) tree1)
;; ==> (a d a b b c)