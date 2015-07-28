###
  Drop-in replacement for lodash.matches function, which uses
  comparison of serialized JSON instead of however lodash does it.
  This might be slower, but it is also more comprehensive. For example:

  obj1 = { a: 1 }
  obj2 = { a: 1, b: 2 }
  _.matches(obj1)(obj2) # true
  matches(obj1)(obj2) # false

###

module.exports = (o1) ->
  s1 = JSON.stringify(o1)
  (o2) ->
    s1 == JSON.stringify(o2)
