## app/route
#### Unit tests: [`/test/route.litcoffee`](../../test/route.litcoffee)

Utility component that defines a minimal client-side view router.

Before we get into the functions of the router, I want to give a quick primer on views,
because there doesn't seem to be a better place to put it, considering there is no special
`app/view` component. This is a bit of an essay, but it's necessary to understand how this
component works.

### Guide to View Functions

In the `starter-kit` universe, a view is just a function that you call to get some virtual DOM.
For example, using the `virtual-dom` library, you could write a view like this:

>     h = require "virtual-dom/h"
>     titleView = -> h "h1", "Home"

Because views are just functions, you can use all your usual bag of tricks for combining functions
to build more complicated views from simpler ones. For example, a view can be composed of other views,
which is similar to the "partial view" pattern widely used in template libraries:

>     homeView = -> h ".content", [
>       titleView()
>       bodyView()]

Higher-order functions are also useful when dealing with views. For example, most view templating libs
offer "layouts", or generally speaking, the ability to nest views inside others. What makes "layouts"
different from just including partials is that the "child view" is parameterized -- so one layout can
be used with many different child views. In terms of functions, this corresponds to the middleware pattern.
Making a layout view is as simple as defining a view middleware. This example uses a layout where the header
and footer are defined as `partials`, and the child view is passed as a parameter to the middleware.

>     siteLayout = (childView) ->
>       (data) ->
>         h ".container", [
>           headerPartial()
>           childView(data)
>           footerPartial()]

You can reuse `siteLayout()` on different pages, for example `siteLayout(homeView)`, or `siteLayout(contactView)`,
which would return view functions that have the same header and footer but different content. Because layouts are
just middlewares, they can be nested with composition.

`starter-kit` comes with an example of a layout view: [`layout.litcoffee`](../layout.litcoffee).

### View data

You might notice that the middleware presented above accepts a `data` parameter and passes it to the child view.
This is a starter-kit idiom: the `data` object is a generic store for communicating context between the views.

This is a powerful idiom, but you should use it sparingly. If you do have any particular data you want to store,
think very carefully, because it should probably go in [`app/state`](state.litcoffee) instead. the `data` parameter is only for
view middlewares  to pass context to their child views, or similar inter-view communication uses.

In other words, a good general rule is to only use `data` if you are trying to make a reusable partial view
or other view intended to exist communicate up or down the view hierarcy.

For example, the `data` object is used by this component -- `app/route` -- to store variables extracted from the
path (similar to how some routers let you define "/user/:userid" and access the `userid` variable in the view).

### Back to app/route

Let's return to the file at hand. app/route defines a `defroute` function which creates a special type of view,
and the `defmulti` convenience function which allows you to define multiple routes at once and combine them into
a single "routed view".

First, let's set up our module namespace:

    Log           = require './log.litcoffee'
    Events        = require './events.litcoffee'
    someResult    = require './util/someResult.litcoffee'
    Route         = module.exports = {}

Now on to the definitions of `defroute` and `defmulti`.

*__defroute__(re, params...)*: function which creates and returns a routing middleware. (Yes, this is a third-order function)
Accepts a Regexp which is matched against the path, as well as an optional list of parameters,
which are extracted from the Regexp results' capture groups. So, for example:

>     userRoute = Route.defroute(/^user:(\w+)$/, "username")

This returns a *middleware* (NOT a first-order view function). Think that it is returning a `layout`,
so you would have to give it a child view in order to use it as a view function:

>     routedView = userRoute(userView) # routedView() returns null or virtual DOM

The provided route is matched against the `path` property of the view `data` object. This property must
be set by a different component in order for the routing to occur. If the regexp does not match `data.path`,
then the view will return `null`. Otherwise, it will return the virtual DOM of the underlying view.

Because we specified a "username" param, and the regexp has a capture group, whatever was in that capture group
will be added to the view `data` in the `username` property. You may have as many `params` defined as you have
capture groups in your regexp.

Generally speaking, you will not need to call `defroute` directly, because `defmulti` provides a higher level
syntax for defining and combining multiple routes.

    Route.defroute = (re, params...) ->
      (next) ->
        (data) ->
          if data.path? and re.test data.path
            result = re.exec data.path
            if params.length >= result.length
              Log.error "route() has more params than capturing groups. regex: ", re, "params: ", params
            data[p] = result[i+1] for p, i in params when typeof p is "string"
            return next(data)
          null

*__defmulti__(routes...)*: sugar function that accepts any number of route vectors, converts them into views with `defroute`,
and finally combines them such that the first matched route will be used. Returns a view function,
called a "routed view", because it can return different virtual DOM depending on the value of `data.path`.

Route vectors are just arrays where the first element is a regexp and the last element is a view function.
In between, there can be any number of strings, which define parameters that are extracted from the regexp
and added to `data`, as explained in `defroute` above. For example:

>     routedView = Route.defmulti(
>       [/^home$/, homeView]
>       [/^contact$/, contactView]
>       [/^user:(/w+)$, "username", userView])

In this example, routedView is now a view function which is suitable to be passed directly to the app/renderer
component. `homeView` and `contactView` will not receive any special `data` properties, but `userView` will be
able to access `data.username`. For example, if `data.path` is "user:1135", then `data.username` is "1135".

Because the functions returned by `defroute` and `defmulti` are easily composable with regular views, it is easy to
implement more complex routing structures with multiple nested views, different parts of the page being routed
differently, and so forth.

To see an example of `defmulti` in use, check out [`index.litcoffee`](../index.litcoffee)

    Route.defmulti = (routes...) ->
      someResult (@defroute(re, params...)(view) for [re, params..., view] in routes)...