Client-side starter kit
=======================

About
-----

Get started on Javascript experiments quickly with the base starter-kit. This kit includes full build tooling so you can get started fast. It also includes a "scaffolded" Javascript framework based on unidirectional data flow and virtual DOM. Unlike most JS frameworks which are written as black boxes and quickly become bloated in an attempt to support every possible usage, a "scaffolded" framework is meant to be readable, usable, and most importantly, *hackable*, so that developers understand what's gonig on and they can customize the code for their needs without the overhead of features they won't use or integrated libraries they don't want.

Supports CoffeeScript and SASS autocompilation and heavily leverages webpack to simplify requiring and using assets.

Includes webpack-dev-server, a dev webserver with automatic recompilation and browser reloading.

The repository includes different branches depending on how much scaffolded code you want. Currently, the options are are::

  master      Contains all scaffolding and build tooling; the complete package.
  build-only  Contains no scaffolded code, only build tooling. Good for getting up-and-running fast with any framework or libraries you want.

To pick which branch you want::

  git clone https://github.com/luketurner/starter-kit.git
  git checkout <branch_name>

Build commands
--------------

First, get dependencies::

  npm i -g webpack gulp
  npm i
  bower i

Then you can use the build scripts::

  gulp             runs dev webserver with livereload
  gulp build-dev   development build
  gulp build       release build

Including assets
----------------

Rely on ``webpack`` for asset inclusion. Instead of using gulp to copy assets like css or images, just ``require`` them from inside your ``src/index.js``. The behavior of ``require`` differs depending on the type of asset required:

=================== ==================
File extension      `require` behavior
=================== ==================
``.js``             Same as node.js, returns the value of ``module.exports`` in the required file
``.coffee``         Transpiles to JS, then as above
``.css``            Run through autoprefixer, all ``@import`` and ``url()`` assets loaded, styles injected into document
``.sass`` ``.scss`` Compiled to CSS, then as above
``.jpg`` ``.png``   Either returns a data URI for <1 MB files, or copies file to `/dist` and returns URL reference to file location.
=================== ==================

Folder and file notes
---------------------

::

/                   misc files
/package.json       template for NPM 
/gulpfile.json      gulp task definitions (copied from webpack docs)
/webpack.config.js  webpack configuration
/dist               output folder for distribution
/src                All Javascript source and other assets needed for the application
/src/index.coffee   entry point for the app -- all resources and components are ``require``d here.
/src/index.html     base html document (compiled to dist/index.html)

Packages
--------

::

                npm | base package manager
               gulp | build script helper
            webpack | including js/css/assets
      coffee-loader | transpiles \*.coffee files
        sass-loader | compiles \*.s[ac]ss files
autoprefixer-loader | applies vendor prefixes to css
       style-loader | loads CSS styles and applies them automatically
         css-loader | traverses ``@import`` and ``url()`` access in css
 webpack-dev-server | provides a development server with livereload