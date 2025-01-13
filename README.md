# Luhn

This package provide checking number and adding check digit
functions.

You can use it as follows:

```
> (luhn-valid? (list->luhn '(1 4 7 6 3 7)))
#t

> (luhn->list (luhn-add-check-digit (list->luhn '(1 4 7 6 3))))
'(1 4 7 6 3 7)
```

## References

### Digit Type

```racket
Digit
```

Is the type of digit integers between `0` and `9`.

```racket
(digit? v) -> Boolean
  v : Any            
```

A predicate for for the `Digit` type.

### Luhn type

```racket
Luhn
```

Is the type of luhn structure.

```racket
(luhn-valid? lfn) -> Boolean
  lfn : Luhn                
```

A predicate for checking digit number.

```racket
(luhn-add-check-digit lfn) -> Lufn
  lfn : Luhn                      
```

A procedure for adding check digit.

```racket
(list->luhn lst) -> Luhn
  lst : (Listof Digit)  
```

A procedure for converting from list to `Luhn`.

```racket
(luhn->list lhn) -> (Listof Digit)
  lhn : Luhn                      
```

A procedure for converting from `Luhn` to list.

```racket
(string->luhn str) -> (U String False)
  str : String                        
```

A procedure for converting from `String` to `Luhn`.

```racket
(luhn->string lhn) -> String
  lhn : Luhn                
```

A procedure for converting from `Luhn` to `String`.

## License

See LICENSE file.
