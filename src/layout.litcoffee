## layout

Provides an example of a "layout view", which is just a middleware function. See the comments in the
`src/app/route.litcoffee` component for an extensive explanation of views.

This particular layout would be written like so if we were using a more traditional templating lagnuage like Handlebars:

>     <div class="container">
>       <nav class="row">
>         Links within the app:
>         <a href="#home">Home</a>,
>         <a href="#about">About</a>,
>         and here's <a href="#nowhere">a broken link</a>
>       </nav>
>       <div id="content">
>         {{ innerView() }}
>       </div>
>       <footer class="row">
>         ~ example footer ~
>       </footer>
>     </div>

Notice that although the `virtual-dom` version below is a little harder to read than the familiar HTML above, it's a
fair bit more compact.

    h = require 'virtual-dom/h'

    module.exports = (innerView) ->
      (viewData) -> h ".container", [
        h "nav.row", [
          "Links within the app: "
          h "a", href: "#home", "Home"
          ", "
          h "a", href: "#about", "About"
          ", and here's "
          h "a", href: "#nowhere", "a broken link"]
        h "#content", innerView(viewData)
        h "footer.row", "~ example footer ~"]