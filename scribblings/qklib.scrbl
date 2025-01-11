#lang scribble/manual
@require[@for-label[qklib/luhn typed/racket/base]]

@title{QKlib}
@author{Masaya Tojo}

My persional library.

@section{Luhn module}

@defmodule[qklib/luhn]

The @racket[qklib/luhn] module provide checking number and adding check digit functions.

You can use it as follows:

@examples[
(luhn-valid? (list->luhn '(1 4 7 6 3 7))) ; => #t
(luhn->list (luhn-add-check-digit (list->luhn '(1 4 7 6 3))) ; => '(1 4 7 6 3 7)
]

@subsection{Digit Type}

@defidform[#:kind "type" Digit]{Is the type of digit integers between @racket[0] and @racket[9].}

@defproc[(digit? [v Any]) Boolean]{A predicate for for the @racket[Digit] type.}

@subsection{Luhn type}

@defidform[#:kind "type" Luhn]{Is the type of luhn structure.}

@defproc[(luhn-valid? [lfn Luhn]) Boolean]{A predicate for checking digit number.}
@defproc[(luhn-add-check-digit [lfn Luhn]) Lufn]{A procedure for adding check digit.}

@defproc[(list->luhn [lst (Listof Digit)]) Luhn]{A procedure for converting from list to @racket[Luhn].}
@defproc[(luhn->list [lhn Luhn]) (Listof Digit)]{A procedure for converting from @racket[Luhn] to list.}
@defproc[(string->luhn [str String]) (U String False)]{A procedure for converting from @racket[String] to @racket[Luhn].}
@defproc[(luhn->string [lhn Luhn]) String]{A procedure for converting from @racket[Luhn] to @racket[String].}

