#lang Racket

;; PURPOSE:    To define and test procedures merge, search and least described below.

;; procedure merge merges two sorted lists into one sorted list

(define merge
  (lambda(lst1 lst2)
    (cond
      ((eqv? '() lst1) lst2)
      ((eqv? '() lst2) lst1)
      ((> (car lst1)(car lst2)) (cons (car lst2) (merge lst1 (cdr lst2))))
      ((< (car lst1)(car lst2)) (cons (car lst1) (merge lst2 (cdr lst1))))
      )
   )
  )
  
;; procedure search searches a list for a particular entry and returns the
;; position (starting with 1) the entry was located or "not found" if the
;; entry is not in the list.

(define search
  (lambda(x lst1)
    (cond
      ((eqv? (+ (length lst1) 1) (searchHelper x lst1)) "not found" )
      ((< (searchHelper x lst1) (+ (length lst1) 1)) (searchHelper x lst1) )
      )
  )
)
  
(define searchHelper
  (lambda(x lst1)
    (cond  
      ((eqv? '() lst1) 1)
      ((eqv? x (car lst1)) 1 )
      (else (+ (searchHelper x (cdr lst1)) 1) )
     )
    )
  )

;; procedure least finds the smallest member in a list of numbers.

(define least
  (lambda(x)
    (cond
      ((eqv? '() (cdr x)) (car x))
      ((> (car x) (cadr x)) (least (cdr x)))
      ((< (car x) (cadr x)) (least (cons (car x)(cddr x))))
      )
    )
  )
