Log    = require '../src/app/log.coffee'
Events = require '../src/app/events.litcoffee'
should = require 'should'
sinon  = require 'sinon'
require 'should-sinon'

oldLogger = null
oldError = null

describe "Events", ->
  before ->
    oldLogger = Log.logger
    oldError = Log.error
    Log.logger = log: sinon.spy() # stop Log calls from displaying in console
    sinon.spy Log, "error"

  beforeEach ->
    Log.logger.log.reset()
    Log.error.reset()

  after ->
    Log.logger = oldLogger
    Log.error = oldError

  it "should call registered handlers when event is emitted", ->

    Events.addHandler "test:key", (d) ->
      d.type.should.equal "test:key"
    Events.addHandler "test:key1", (d) ->
      d.type.should.equal "test:key1"

    Events.emit notType: "no event type"
    Events.emit type: "invalid:key"
    Events.emit type: "test:key"
    Events.emit type: "test:key1"

    Log.error.should.be.calledWith "no handlers for event type"
    Log.error.should.be.calledWith "no type property in event data"
    Log.error.should.be.calledTwice()

  it "should call middlewares in order", ->

    Events.addService (next) ->
      (data) ->
        data.should.have.property "path"
        next(data)

    Events.addService (next) ->
      (data) ->
        data.path = "a-path"
        next(data)

    Events.addService (next) ->
      (data) ->
        data.should.not.have.property "path"
        next(data)
        data.should.have.property "path"

    Events.emit type: "test:key"

  it "should call middlewares even on handlers added later", ->
    Events.addHandler "test:later", (d) ->
      d.should.have.property "path"

    Events.emit type: "test:later"