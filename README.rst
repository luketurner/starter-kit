Getting started with client-side development
============================================

starter-kit_ is a scaffold for a client-side application, like you might find on yeoman_. 

The starter-kit scaffold has two major parts. The first part is what you might think of as traditional scaffolding: sane, integrated configurations for npm_, bower_, webpack_, and gulp_. If that's all you want, check out the build-only_ branch.

The second part is more unusual, and a lot more interesting: a set of modular and hackable components, written in CoffeeScript, that can be used to jump-start your SPA development. These components are not hidden away in a dozen different packages in your ``node_modules`` folder -- they live right alongside the rest of your application code, so that you can extend or adjust or replace them as your application evolves.

These components encapsulate powerful patterns, like event emitters, rendering, and routing, that are included in pretty much every client-side framework out there. They provide a middle ground between completely reinventing the wheel, and using a framework where you don't control the code. In writing these components I tried to emphasize clarity, elegance, and generality over being "magic". Instead of packing on the features and edge case support, they were kept lightweight so that developers can easily read the component code directly and modify it themselves to handle their application's specific needs.

For example, the ``app/route`` component, which implements a client-side router, has only about 20 lines of code, and yet it provides all the key features of something like `page.js`_ (300 lines) or react-router_ (which is enormous). Of course, it might be missing some feature that is important for your specific application, in which case you can easily extend it or even completely replace it with a more comprehensive 3rd party routing library or your own custom router.

The components are summarized in the Components_ section.
For details about how to include js/coffee/css/jpeg/etc. files in your application, see `Using Webpack`_

CoffeeScript components inspired by mercury_, re-frame_, Backbone_, and Flux_.

.. _Backbone: http://backbonejs.org/
.. _mercury: https://github.com/Raynos/mercury
.. _re-frame: https://github.com/Day8/re-frame
.. _flux: https://facebook.github.io/flux/
.. _starter-kit: https://github.com/luketurner/starter-kit
.. _build-only: https://github.com/luketurner/starter-kit/tree/build-only
.. _yeoman: http://yeoman.io/
.. _npm: https://www.npmjs.com/
.. _bower: http://bower.io/
.. _webpack: https://webpack.github.io/
.. _gulp: http://gulpjs.com/
.. _react-router: https://github.com/rackt/react-router
.. _page.js: https://visionmedia.github.io/page.js/

Getting started
===============

First, get dependencies::

  npm i -g bower webpack gulp
  npm i
  bower i

Then you can use the build scripts::

  gulp [server]    runs dev webserver with livereload
  gulp build-dev   development build
  gulp build       release build

Components
==========

The table below is a high-level overview of the scaffolded components defined in ``starter-kit``. Each component is documented in much greater detail in the source file itself. If you want to understand a component, your best bet is to read the source! Many of the files have twice as many lines of comment as lines of code.

There are also other source files outside of ``app``, like `home/view`_, `about/view`_, `404`_, and `layout`_, which are just examples that show you how to use the ``app/*`` components.

.. list-table::

  * - `app/state`_
    - Globally accessible, centralized data store for all mutable application state. The state should
      contain all information needed to render the application's primary view.
  * - `app/events`_
    - Singleton event emitter which serves as foundational component for "wiring" the application. 
      Allows other components to extend event behavior by registering middleware functions 
      which are executed for every event.
  * - `app/log`_
    - Simple logging utility that wraps ``console.log``, adding log levels and consistent output formatting.
  * - `app/renderer`_
    - Registers a renderer service that will re-render the view when event handlers cause state changes. Batches
      render updates using requestAnimationFrame.
  * - `app/route`_
    - Ultra-lightweight client-side routing that works by combining multiple view functions into a so-called
      "routed view", which will return different VDOM depending on the current path.
  * - `app/history`_
    - Optional history component that provides undo/redo functionality for ``app/state``. Includes the ability to
      persist ``app/state`` and the undo history to localStorage so you can undo across sessions.
  * - `app/util`_
    - Various utility functions that can be individually required if needed.
    
.. _home/view: https://github.com/luketurner/starter-kit/blob/master/src/home/view.coffee
.. _about/view: https://github.com/luketurner/starter-kit/blob/master/src/about/view.coffee
.. _404: https://github.com/luketurner/starter-kit/blob/master/src/404.coffee
.. _layout: https://github.com/luketurner/starter-kit/blob/master/src/layout.coffee
.. _app/state: https://github.com/luketurner/starter-kit/blob/master/src/app/state.coffee
.. _app/events: https://github.com/luketurner/starter-kit/blob/master/src/app/events.coffee
.. _app/log: https://github.com/luketurner/starter-kit/blob/master/src/app/log.coffee
.. _app/renderer: https://github.com/luketurner/starter-kit/blob/master/src/app/renderer.coffee
.. _app/route: https://github.com/luketurner/starter-kit/blob/master/src/app/route.coffee
.. _app/history: https://github.com/luketurner/starter-kit/blob/master/src/app/history.coffee
.. _app/util: https://github.com/luketurner/starter-kit/blob/master/src/app/util

Using Webpack
=============

``starter-kit`` makes heavy use of webpack_ for including assets. Instead of adding ``script`` and ``link`` tags to your ``index.html``, with webpack you are able to just ``require './code.coffee'`` or ``require './style.scss'``, and the expected thing happens. The filetypes which are enabled in ``starter-kit`` are listed in the table below.

The webpack entry point is defined to be ``src/index.coffee``, which means that ``webpack`` will start with ``index.coffee`` and recursively include everything. If a file is never required in ``index.coffee`` or any other files found in this recursive walk, then it will not be included.

.. list-table::

  * - ``.js`` ``.coffee``
    - similar to node.js. Returns the value of ``module.exports`` from the required file.
      CoffeeScript is automatically compiled.
  * - ``.css`` ``.sass`` ``.scss``
    - SCSS/SASS is compiled if applicable. Then the resulting CSS is run through ``autoprefixer``,
      and finally the resulting rules are directly applied to the HTML (no ``link`` elements needed).
      Note that using ``url()`` to reference images and fonts "just works".
  * - ``.png`` ``.jpeg`` ``.gif``
    - returns a Data URI for <1 MB files, otherwise copies the file to ``/dist`` and returns a relative URL
      to the ceated file.
  * - ``.ttf`` ``.eot`` ``.svg`` ``.woff``
    - Copies the file into ``/dist`` and returns a relative URL to the created file.
