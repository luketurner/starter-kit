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
Renderer   = require './app/renderer.litcoffee'
Log        = require './app/log.litcoffee'
Route      = require './app/route.litcoffee'

# Generate root view. Note that this is just an example of
# a root view, which gives you a sense of the power that you
# can achieve -- layouts, routes, and so forth. See notes in
# app/route.coffee for more details on views.
withLayout = require './layout.litcoffee'
rootView = withLayout Route.defmulti(
  [/^(home)?$/, require './home/view.coffee']
  [/^about$/  , require './about/view.coffee']
  [/.*/       , require './404.coffee'])

Log.logLevel = 3 # enable info/debug logging
Log.info "Application Started"

Renderer.loop(rootView) # start renderer infinite loop