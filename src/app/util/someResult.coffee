###
  exposes the someResult utility function.

  someResult(funcs...)
    accepts any number of functions as parameters. Returns a function
    which, when called, will call each of the funcs in order and return the
    first non-falsy result.

    fn1 = (a) -> if a is "1" then "fn1 result" else null
    fn2 = (a) -> "fn2 result"
    fn = someResult(fn1, fn2)
    fn("1") returns "fn1 result"
    fn("not 1") returns "fn2 result"
###

module.exports = (funcs...) ->
  (params...) ->
    for fn in funcs
      result = fn(params...)
      return result if result
    null