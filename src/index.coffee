###
  Application entry point.
  Purpose is to wire up everything else.
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

Log.info "Application Started"
Renderer.loop()