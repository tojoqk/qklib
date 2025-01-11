#lang typed/racket

(module+ test
  (require typed/rackunit))

(provide Digit
         digit?
         Luhn
         luhn-valid?
         luhn-add-check-digit
         luhn->string
         luhn->list
         list->luhn
         string->luhn)

(define-type Digit (U 0 1 2 3 4 5 6 7 8 9))
(define-predicate digit? Digit)

(struct luhn ([rev-digits : (Listof Digit)])
  #:type-name Luhn)

(module+ test
  (check-true (digit? 0))
  (check-true (digit? 5))
  (check-true (digit? 9))
  (check-false (digit? -1))
  (check-false (digit? 10))
  (check-false (digit? 'symbol)))

(: luhn-valid? (-> Luhn Boolean))
(define (luhn-valid? l)
  (zero? (modulo (luhn-sum l) 10)))

(module+ test
  (check-true (luhn-valid? (list->luhn '(2 0 2 5 0 1 1 1 0))))
  (check-false (luhn-valid? (list->luhn '(2 0 2 5 1 0 1 1 0))))
  (check-true (luhn-valid? (list->luhn '(1 4 7 6 3 7))))
  (check-false (luhn-valid? (list->luhn '(1 4 7 9 3 7))))
  (check-true (luhn-valid? (list->luhn '(0 1 4 7 6 3 7))))
  (check-true (luhn-valid? (list->luhn '(6 3 9 7 0 9 6 2 5))))
  (check-true (luhn-valid? (list->luhn '(6 3 9 7 9 0 6 2 5)))))

(: luhn-add-check-digit (-> Luhn Luhn))
(define (luhn-add-check-digit l)
  (luhn (cons (calculate-check-digit l)
              (luhn-rev-digits l))))

(module+ test
  (check-equal? (luhn->list
                 (luhn-add-check-digit
                  (list->luhn '(2 0 2 5 0 1 1 1))))
                '(2 0 2 5 0 1 1 1 0))
  (check-equal? (luhn->list
                 (luhn-add-check-digit
                  (list->luhn '(1 4 7 6 3))))
                '(1 4 7 6 3 7))

  (for ([i 100])
    (let ([random-digits
           (for/list : (Listof Digit)
                     ([i 10])
             (assert (random 10) digit?))])
      (check-true
       (luhn-valid?
        (luhn-add-check-digit (list->luhn random-digits)))))))

(: list->luhn (-> (Listof Digit) Luhn))
(define (list->luhn lst)
  (luhn
   (for/fold ([rev-digits : (Listof Digit) '()])
             ([digit : Digit (in-list lst)])
     (cons digit rev-digits))))

(module+ test
  (let ([random-digits
         (for/list : (Listof Digit)
                   ([i 10])
           (assert (random 10) digit?))])
    (check-equal? (luhn->list (list->luhn random-digits))
                  random-digits)
    (check-equal? (luhn-rev-digits (list->luhn random-digits))
                  (reverse random-digits))))

(: luhn->list (-> Luhn (Listof Digit)))
(define (luhn->list l)
  (reverse (luhn-rev-digits l)))

(: luhn->string (-> Luhn String))
(define (luhn->string l)
  (define out (open-output-string))
  (for ([d : Digit (luhn->list l)])
    (write-char (digit->digit-char d) out))
  (get-output-string out))

(module+ test
  (check-equal? (luhn->string (list->luhn '(1 4 7 6 3 7)))
                "147637"))

(: string->luhn (-> String (Option Luhn)))
(define (string->luhn str)
  (call/cc
   (lambda ([return : (-> False Nothing)])
     (luhn
      (for/fold ([rev : (Listof Digit) '()])
                ([c (in-string str)])
        (cond [(digit-char->digit c) => (lambda (d) (cons d rev))]
              [else (return #f)]))))))

(module+ test
  (check-true (luhn? (string->luhn "147637")))
  (check-equal? (luhn->list (assert (string->luhn "147637")))
                '(1 4 7 6 3 7))
  (check-false (string->luhn "147A637")))

(: calculate-check-digit (-> Luhn Digit))
(define (calculate-check-digit l)
  (let ([sum (luhn-sum l '(2 1))])
    (assert (modulo (- 10 (modulo sum 10)) 10)
            digit?)))

(: digit-char->digit (-> Char (Option Digit)))
(define (digit-char->digit c)
  (let ([n (- (char->integer c) zero-char-code)])
    (if (digit? n)
        n
        #f)))

(module+ test
  (check-eqv? (digit-char->digit #\0) 0)
  (check-eqv? (digit-char->digit #\5) 5)
  (check-eqv? (digit-char->digit #\9) 9)
  (check-false (digit-char->digit #\a)))

(: digit->digit-char (-> Digit Char))
(define (digit->digit-char d)
  (integer->char (+ d zero-char-code)))

(module+ test
  (check-eqv? (digit->digit-char 0) #\0)
  (check-eqv? (digit->digit-char 5) #\5)
  (check-eqv? (digit->digit-char 9) #\9))

(: zero-char-code Index)
(define zero-char-code (char->integer #\0))

(: luhn-sum (->* (Luhn) ((Listof (U 1 2))) Integer))
(define (luhn-sum l [scale-list '(1 2)])
  (for/sum ([d : Digit (luhn-rev-digits l)]
            [scale : Natural (in-cycle scale-list)])
    (sum-of-digits (* d scale))))

(module+ test
  (check-eqv? (luhn-sum (list->luhn '(1 4 7 6 3 7)))
              30))

(: sum-of-digits (-> Natural Natural))
(define (sum-of-digits n)
  (define-values (q r) (quotient/remainder n 10))
  (if (< q 10)
      (+ q r)
      (+ r (sum-of-digits q))))

(module+ test
  (check-eqv? (sum-of-digits 8)
              (+ 8))
  (check-eqv? (sum-of-digits 12)
              (+ 1 2))
  (check-eqv? (sum-of-digits 19)
              (+ 1 9))

  (for ([n : Natural (in-range 0 20)])
    (check-eqv? (sum-of-digits n)
                (+ (quotient n 10)
                   (modulo n 10)))))
