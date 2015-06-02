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
Events   = require './app/events.coffee'
Log      = require './app/log.coffee'
Views    = require './app/views.coffee'

# Add needed services to event emitter before we start adding handlers.
# Note that first-added is first-called on the request and last-called on the response.
Events.addService Renderer.service

# Add event handlers for some browser events
# Even if the handlers are noops, this means the browser events will trigger
# all of our services as well.

Events.addHandler "browser:hashchange", ->null
window.onhashchange = () -> Events.emit type: "browser:hashchange"

# Do we need popstate as well as hashchange? should be quite low overhead even if both fire
# Events.addHandler "browser:popstate"  , ->null
# window.onpopstate   = () -> Events.emit type: "browser:popstate"

# Register our views
Views.add /^(home)?$/, require './home/view.coffee'
Views.add /.*/       , require './404.coffee'

Log.info "Application Started"
Renderer.loop()