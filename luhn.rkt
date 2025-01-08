#lang typed/racket

(provide Digit
         digit?
         luhn-digits?
         string->digits)

(define-type Digit (U 0 1 2 3 4 5 6 7 8 9))

(define-predicate digit? Digit)

(: luhn-digits? (-> (Listof Digit) Boolean))
(define (luhn-digits? digits)
  (zero? (modulo (luhn-sum digits) 10)))

(: string->digits (-> String (Option (Listof Digit))))
(define (string->digits str)
  (call/cc
   (lambda ([return : (-> False Nothing)])
     (for/list : (Listof Digit)
               ([c : Char (in-string str)])
       (cond [(digit-char->digit c) => identity]
             [else (return #f)])))))

(: digit-char->digit (-> Char (Option Digit)))
(define (digit-char->digit c)
  (let ([n (- (char->integer c) zero-char-code)])
    (if (digit? n)
        n
        #f)))

(: zero-char-code Index)
(define zero-char-code (char->integer #\0))

(: luhn-sum (-> (Listof Digit) Integer))
(define (luhn-sum digits)
  (for/sum ([d : Digit (reverse digits)]
            [scale : Natural (in-cycle '(1 2))])
    (sum-of-digits (* d scale))))

(: sum-of-digits (-> Natural Integer))
(define (sum-of-digits n)
  ;; assert: 0 < n < 19
  (if (< 9 n)
      (- n 9)
      n))
