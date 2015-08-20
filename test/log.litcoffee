## test/log
#### Unit tests for [`/src/app/log.litcoffee`](../src/app/log.litcoffee)

    Log = require '../src/app/log.litcoffee'

`should` is used for BDD-style test writing, and `sinon` is used for mocking `console.log` to ensure that correct things
are printed.

    should    = require 'should'
    sinon     = require 'sinon'
    oldLogger = null
    require 'should-sinon'

    describe "Log", ->

Replace the `Log.logger`, which is usually `console.log`, with a mock. Also adjust the prefix so we can test whether
prefix adjustment is respected.

      before ->
        oldLogger = Log.logger
        Log.logger = log: sinon.spy()
        Log.prefix = "[T] "

      beforeEach -> Log.logger.log.reset()

Reset `Log.logger` so it can be used by other tests.

      after -> Log.logger = oldLogger

### Tests

      it "should respect current logLevel", ->
        Log.logLevel = 1
        Log.warn "asdf"
        Log.info "asdf"
        Log.logger.log.should.be.calledWith("[T] WARN")
        Log.logger.log.should.not.be.calledWith("[T] info")

      it "should use custom prefixes", ->
        Log.error "asdf"
        Log.logger.log.should.be.calledWith("[T] ERROR")