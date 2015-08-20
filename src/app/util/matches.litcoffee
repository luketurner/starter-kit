*__matches__(obj1)(obj2)*: Drop-in replacement for `lodash.matches` function. This replacement uses comparison of
serialized JSON, which may be slower but is more effective. Our method emulates `lodash` by currying the function.

>     obj1 = { a: 1 }
>     obj2 = { a: 1, b: 2 }
>     _.matches(obj1)(obj2) # lodash method returns true
>     matches(obj1)(obj2) # our method returns false

    module.exports = (o1) ->
      s1 = JSON.stringify(o1)
      (o2) ->
        s1 == JSON.stringify(o2)