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