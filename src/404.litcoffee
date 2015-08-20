### 404.litcoffee

Fallback view used when no other matching view is found. Used by the routed view declared in
[`index.litcoffee`](index.litcoffee).

    h = require 'virtual-dom/h'

    module.exports = ->
      h "div", [
        h "h3", "404"
        h "p", "Page not found!"]