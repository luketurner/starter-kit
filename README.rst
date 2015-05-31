Client-side starter kit
=======================

About
-----

Get started on Javascript experiments quickly with the base starter-kit. This kit includes no client-side frameworks or code, only build tooling and the Skeleton css framework.

Supports CoffeeScript and SASS autocompilation and heavily leverages webpack to simplify requiring and using assets.

Includes webpack-dev-server, a dev webserver with automatic recompilation and browser reloading.

Build commands
--------------

First, get dependencies::

  npm i -g bower webpack gulp 
  npm i
  bower i

Then you can use the build scripts::

  gulp             runs dev webserver with livereload
  gulp build-dev   development build
  gulp build       release build

Including assets
----------------

Rely on ``webpack`` for asset inclusion. Instead of using gulp to copy assets like css or images, just ``require`` them from inside your ``src/index.js``. The behavior of ``require`` differs depending on the type of asset required:

===============     ==================
File extension      `require` behavior
===============     ==================
``.js``             Same as node.js, returns the value of ``module.exports`` in the required file
``.coffee``         Transpiles to JS, then as above
``.css``            Run through autoprefixer, all ``@import`` and ``url()`` assets loaded, styles injected into document
``.sass`` ``.scss`` Compiled to CSS, then as above
``.jpg`` ``.png``   Either returns a data URI for <1 MB files, or copies file to `/dist` and returns URL reference to file location.
===============     ==================

Folder and file notes
---------------------

::

/                   misc files
/package.json       template for NPM 
/bower.json         minimal template for Bower package manger
/gulpfile.json      gulp task definitions (copied from webpack docs)
/webpack.config.js  webpack configuration
/test               mocha tests [in progress]
/dist               output folder for distribution
/src                All Javascript source and other assets needed for the application
/src/index.coffee   entry point for the app -- all resources and components are ``require``d here.
/src/index.html     base html document (compiled to dist/index.html)

Package inclusion explanations
------------------------------

:skeleton: CSS sanity framework
:npm: base package manager
:bower: used if needed for additional client-side packages
:gulp: build script helper
:webpack: including js/css/assets
:coffee-loader: transpiles \*.coffee files
:sass-loader: compiles \*.s[ac]ss files
:autoprefixer-loader: applies vendor prefixes to css
:style-loader: loads CSS styles and applies them automatically
:css-loader: traverses ``@import`` and ``url()`` access in css
:webpack-dev-server: provides a development server with livereload