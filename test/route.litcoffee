## test/route
##### Unit tests for [`/src/app/route.litcoffee`](../src/app/route.litcoffee)

    Route = require '../src/app/route.litcoffee'

Use `should` for BDD-style assertions.

    should = require 'should'
    h      = require 'virtual-dom/h'

### Tests

    describe "Route", ->
      describe "#defroute", ->
        it "should return a routed view", ->
          router = Route.defroute /^test$/
          routedView = router -> true
          should.exist routedView path: "test"
          should.not.exist routedView path: "asdf"

        it "should pass capture groups to views", ->
          router = Route.defroute /^msg:(.+)$/, "message"
          routedView = router (d) -> d.message
          should.not.exist routedView path: "asdf"
          routedView(path: "msg:a message").should.equal "a message"

      describe "#defmulti", ->
        it "should return a multiple routed view", ->
          routedView = Route.defmulti(
            [/^1$/, -> 1]
            [/^2$/, -> 2]
            [/^(\w+):(\w+)$/, "fst", "snd", (d) -> d.snd + ":" + d.fst])

          should.not.exist routedView path: ""
          routedView(path: "1").should.equal 1
          routedView(path: "2").should.equal 2
          vdom = routedView(path: "two:one").should.equal "one:two"
