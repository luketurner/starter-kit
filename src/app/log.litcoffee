## app/log

A simple, convenient logging utility. Supports 4 log levels: 0-error, 1-warn, 2-info, 3-debug.

By default, only errors are logged. change `Log.logLevel` to adjust.

    Log = module.exports = {}

Set public properties, which can be used to configure the logger:

    Log.logLevel = 0 # only log errors by default.
    Log.prefix   = "[app-log] "
    Log.logger   = console

*__error__(params...)*

*__warn__(params...)*

*__info__(params...)*

*__debug__(params...)*

Logging functions. Each one can be passed any arguments,
and will try to log them at the log level for that particular
function.

>     Log.info "re-render triggered"

    Log.error = (msgs...) -> @_log(0, msgs)
    Log.warn  = (msgs...) -> @_log(1, msgs)
    Log.info  = (msgs...) -> @_log(2, msgs)
    Log.debug = (msgs...) -> @_log(3, msgs)

Hidden function wrapped by public methods

    Log._log = (level, msgs) ->
      return if level > @logLevel
      @logger.log.apply(@logger, ["#{@prefix}#{levelNames[level]}"].concat(msgs))

Private variable declaration -- log levels are not configurable for now.

    levelNames = ["ERROR", "WARN", "info", "debug"]
