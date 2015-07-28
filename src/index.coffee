###
  Application entry point.
  Wires up everything else. Everything required here,
  or required by anything required here, will be packaged
  up and included in the application.
###

# Require CSS and other assets
require '../bower_components/skeleton/css/normalize.css'
require '../bower_components/skeleton/css/skeleton.css'

# Require index.html
require 'file?name=[name].[ext]!./index.html'

# Require application components
Renderer = require './app/renderer.coffee'
Log      = require './app/log.coffee'
Views    = require './app/views.coffee'

# Register our views
Views.add /^(home)?$/, require './home/view.coffee'
Views.add /.*/       , require './404.coffee'

Log.logLevel = 3 # enable info/debug logging
Log.info "Application Started"

Renderer.loop() # start renderer infinite loop