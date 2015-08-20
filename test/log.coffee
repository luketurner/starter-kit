###
  Unit tests for /src/app/log.litcoffee
###

Log = require '../src/app/log.litcoffee'

should = require 'should'
sinon  = require 'sinon'
require 'should-sinon'

oldLogger = null

describe "Log", ->
  before ->
    oldLogger = Log.logger
    Log.logger = log: sinon.spy()
    Log.prefix = "[T] "

  beforeEach -> Log.logger.log.reset()

  after -> Log.logger = oldLogger

  it "should respect current logLevel", ->
    Log.logLevel = 1
    Log.warn "asdf"
    Log.info "asdf"
    Log.logger.log.should.be.calledWith("[T] WARN")
    Log.logger.log.should.not.be.calledWith("[T] info")


  it "should use custom prefixes", ->
    Log.error "asdf"
    Log.logger.log.should.be.calledWith("[T] ERROR")