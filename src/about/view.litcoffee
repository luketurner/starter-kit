## about/view

View for sample About component. Based on the configuration in [`index.litcoffee`](../index.litcoffee), this view can be
linked to like so:

>     <a href="#about">about</a>

It's an uncomplicated view, with no dynamic elements. But I think it illustrates the strange elegance of using the
`virtual-dom/hyperscript` DSL in CoffeeScript. For a more complex and commented view, see
[`home/view`](../home/view.litcoffee).

    h = require 'virtual-dom/h'

    module.exports = ->
      h 'div', [
        h 'h3', 'About'
        h 'p', [
          h "code", "starter-kit"
          "is a scaffolded Web microframework. Find the source code on "
          h "a", href: "https://github.com/luketurner/starter-kit.git", "github"]]
