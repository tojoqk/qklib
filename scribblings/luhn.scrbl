#lang scribble/manual
@require[@for-label[luhn/main typed/racket/base]]

@title{Luhn}
@author{Masaya Tojo}

@defmodule[luhn]

The @racket[luhn] module provides functions for validating numbers and
adding check digits using the Luhn Algorithm.

You can use it as follows:

@racketinput[
(luhn-valid? (list->luhn '(1 4 7 6 3 7)))
]
@racketresult[
#t
]

@racketinput[
(luhn->list (luhn-add-check-digit (list->luhn '(1 4 7 6 3))))
]
@racketresult[
'(1 4 7 6 3 7)
]


@section{Digit Type}

@defidform[#:kind "type" Digit]{Is the type of digit integers between @racket[0] and @racket[9].}

@defproc[(digit? [v Any]) Boolean]{A predicate for for the @racket[Digit] type.}

@section{Luhn type}

@defidform[#:kind "type" Luhn]{Is the type of luhn structure.}

@defproc[(luhn-valid? [lfn Luhn]) Boolean]{A predicate for checking digit number.}
@defproc[(luhn-add-check-digit [lfn Luhn]) Lufn]{A procedure for adding check digit.}

@defproc[(list->luhn [lst (Listof Digit)]) Luhn]{A procedure for converting from list to @racket[Luhn].}
@defproc[(luhn->list [lhn Luhn]) (Listof Digit)]{A procedure for converting from @racket[Luhn] to list.}
@defproc[(string->luhn [str String]) (U String False)]{A procedure for converting from @racket[String] to @racket[Luhn].}
@defproc[(luhn->string [lhn Luhn]) String]{A procedure for converting from @racket[Luhn] to @racket[String].}

