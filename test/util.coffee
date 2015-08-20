###
  Unit tests for functions in /src/app/util directory.
###

should = require 'should'

matches    = require '../src/app/util/matches.litcoffee'
someResult = require '../src/app/util/someResult.litcoffee'

describe "Util", ->
  describe "#matches", ->
    it "should examine all nested properties", ->
      obj1 = a: 1, b: 2, c: 3, d: [i: 1, i: 2]
      obj2 = a: 1, b: 2, c: 3, d: [i: 1, i: 2]
      matches(obj1)(obj2).should.be.true()
      obj2.d[0].i = 3
      matches(obj1)(obj2).should.be.false()

    it "should return false if either object has extra keys", ->
      matches(a: 1)(a: 1, b: 2).should.be.false()
      matches(a: 1, b: 2)(a: 1).should.be.false()

    it "should 'snapshot' the object when called with one argument", ->
      o = a: 1
      m = matches o
      m(o).should.be.true()
      o.b = 2
      m(o).should.be.false()

  describe "#someResult", ->
    it "returns the first truthy result", ->
      nullf = -> null
      maybef = (a) -> if a then a else null
      yesf = -> "yes"

      f = someResult nullf, maybef, yesf
      f(false).should.equal "yes"
      f("other").should.equal "other"

    it "returns null if all functions return a falsy result", ->
      a = -> false
      f = someResult a
      should.equal f(), null