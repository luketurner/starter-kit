## index

This file is the `webpack` entry point, so it's the place to reference any other webpackable assets, including any
CoffeeScript, CSS, etc. that you need.

First, let's tell `webpack` to copy `index.html` into the output directory.

    require 'file?name=[name].[ext]!./index.html'

You could also include something like this here:

>     require './application.scss'

But instead, I think it's better to put the styles in a file related to the component and `require` it from the
component's view. Instead of having one global stylesheet, each component has its own. For example,
`/src/home/view.coffee` could include a line `require './home.scss'`.

`starter-kit` comes with the [Skeleton](http://getskeleton.com/) CSS framework. Skeleton was chosen because it's
lightweight (11 kb), but it includes a fluid grid system, attractive typography, and simple, flat styling. By requiring
the Skeleton CSS here, we cause it to be applied, without needing `<link>` tags in the HTML.

    require '../bower_components/skeleton/css/normalize.css'
    require '../bower_components/skeleton/css/skeleton.css'

Next, it's time to get our application up and running. We'll need some tools:

    Renderer   = require './app/renderer.litcoffee'
    Log        = require './app/log.litcoffee'
    Route      = require './app/route.litcoffee'

These next few lines generate a "root view". The idea of a "root view" is that it is a function which renders virtual
DOM for your entire application. So when the renderer wants to trigger a re-render, all it has to do is call the root
view.

This is just an example view. All the components needed for this root view have been scaffolded out with stub HTML,
to provide a template for the recommended architecture.

This root view, like any complex Web view, uses a layout. Let's `require` that first. Note that `withLayout` is
a middleware function, which means that it is passed a child view as a parameter, and returns a view function.

Read more about layouts in the [`layout`](layout.litcoffee) file.

    withLayout = require './layout.litcoffee'

Now we generate the root view. We use the [`app/route`](app/route.litcoffee) component to define a "routed view", which
is a function whose result depends on the path, and wrap it in the layout by passing it to `withLayout`. We get a single
`rootView` function, but it encapsulates a complex page with a constant header and footer but multiple potential bodies.

    rootView = withLayout Route.defmulti(
      [/^(home)?$/, require './home/view.coffee']
      [/^about$/  , require './about/view.coffee']
      [/.*/       , require './404.coffee'])

Logging setup happens here. Log level 3 means all log emssages are shown, even debug messages.
Change this for production!

    Log.logLevel = 3
    Log.info "Application Started"

Finally, kick off the [`renderer`](app/renderer.litcoffee). This is what draws the application's DOM. Pass it the routed
`rootView` created before.

    Renderer.loop rootView