    **WARNING**: This scaffold is about 4 years old, and the libraries it depends on have experienced breaking changes and security issues. And since I no longer recommend using CoffeeScript or Gulp for new projects, this repository is not likely to ever be fixed. Therefore, you **should not use** this project anymore.

Getting started with client-side development
============================================


starter-kit_ is a scaffold for quickly getting started on a new client-side application, like what you might find on yeoman_. 

The starter-kit scaffold has two major parts. The first part is what you might think of as traditional scaffolding: sane, integrated configurations for npm_, bower_, webpack_, and gulp_.

The second part is more unusual, and a lot more interesting: a set of modular and hackable components, written in CoffeeScript, that can be used to jump-start your SPA development. These components live right alongside the rest of your application code, not hidden away inside the ``node_modules`` folder, so that you can easily extend or adjust or replace them as your application evolves.

These components encapsulate powerful patterns, like event emitters, rendering, and routing, that are included in pretty much every client-side framework out there. They provide a middle ground between completely reinventing the wheel, and using a framework where you don't control the code. In writing these components I tried to emphasize clarity, consistency, and generality over being "magic". Instead of packing on the features and edge case support, they were kept lightweight so that developers can easily read and understand the code and modify it themselves to handle their application's specific needs.

For example, the ``app/route`` component, which implements a client-side router, has only about 20 lines of code, and yet it provides all the key features of something like `page.js`_ (300 lines) or react-router_ (over 20 *files*). Of course, ``app/route`` might be missing some feature that is important for your specific application, in which case you can easily extend it or even completely replace it with a more comprehensive 3rd party routing library or your own custom router.

The components are very well-documented in their respective source files. An overview of all the components is available in the Components_ section of this README.

For details about how to include different assets in your application, see the `Using Webpack`_ section. Generally speaking, though, you just use CommonJS-style ``require`` to include HTML, CSS, S[AC]SS, images, fonts, JavaScript, and CoffeeScript. All asset handling is done through webpack_.

The CoffeeScript components in this project were inspired by many sources. Using lightweight components to "roll your own" application-specific framework was an idea inspired by "modular frameworks" like mercury_ and ampersand_. The general architecture of the components, emphasizing event handling, centralized state, and virtual DOM, was modeled after unidirectional data flow architectures like re-frame_ and Flux_. 

.. _ampersand: http://ampersandjs.com/
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

Actually getting started
========================

Check out the repository. If you want the starter CoffeeScript components, stick with the ``master`` branch. If you don't want any source code, because you plan on using your own framework or writing your app from scratch, you can check out the ``build-only`` branch instead.

Next, get dependencies::

  npm i -g bower webpack gulp
  npm i
  bower i

Then you can use the build scripts::

  gulp dev-server  runs dev webserver with livereload
  gulp build-dev   development build with file watcher on /src
  gulp build       release build - produces uglified, production ready code in /dist
  
The "entry point" for the application's compile process is ``src/index.litcoffee``. It is initialized with a simple example application with two views, ``about`` and ``home``. You will probably want to remove the ``src/about`` and ``src/home`` folders after you get a sense of how views and routing work, and update the ``index.litcoffee`` to use your custom views and other components.

You may use whatever file structure you want to organize your code and other assets inside ``/src``. Perhaps you put all your SASS in ``/src/styles``, views in ``/src/views``, etc. However, I recommend that you use the strategy outlined in `Angular Best Practices for App Structure`_. In short, the idea is that you separate your application into logical units, like ``main``, ``editor``, ``detailView``, ``adminLogin``, etc. and make a separate folder for each unit. Then the folder will contain everything the unit needs -- a view, CoffeeScript modules, stylesheets, image assets, etc. This is a kind of domain-driven method in which the file structure represents the logical structure of the application, and each logical component is encapsulated in a single folder instead of spread out among multiple directories.

In the same sense, the ``app`` folder should be left for global, app-level components, which may be referenced and used from anywhere in the application.

.. _Angular best practices for app structure: https://docs.google.com/document/d/1XXMvReO8-Awi1EZXAXS4PzDzdNvV6pGcuaF4Q9821Es/pub

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
    
.. _home/view: src/home/view.litcoffee
.. _about/view: src/about/view.litcoffee
.. _404: src/404.litcoffee
.. _layout: src/layout.litcoffee
.. _app/state: src/app/state.litcoffee
.. _app/events: src/app/events.litcoffee
.. _app/log: src/app/log.litcoffee
.. _app/renderer: src/app/renderer.litcoffee
.. _app/route: src/app/route.litcoffee
.. _app/history: src/app/history.litcoffee
.. _app/util: src/app/util

Using Webpack
=============

``starter-kit`` makes heavy use of webpack_ for including assets. Instead of adding ``script`` and ``link`` tags to your ``index.html``, with webpack you are able to just ``require './code.coffee'`` or ``require './style.scss'``, and the expected thing happens. The filetypes which are enabled in ``starter-kit`` are listed in the table below.

The webpack entry point is defined to be ``src/index.litcoffee``, which means that ``webpack`` will start with ``index.litcoffee`` and recursively include everything. If a file is never required in ``index.litcoffee`` or any other files found in this recursive walk, then it will not be included.

.. list-table::

  * - ``.js`` ``.coffee``
    - Uses CommonJS pattern. Returns the value of ``module.exports`` from the required file.
      CoffeeScript is automatically compiled.
  * - ``.css`` ``.sass`` ``.scss``
    - SCSS/SASS is compiled if applicable. Then the resulting CSS is run through ``autoprefixer``,
      and finally the resulting rules are directly applied to the HTML (no ``link`` elements needed).
      Note that using ``url()`` to reference images and fonts "just works".
  * - ``.png`` ``.jpeg`` ``.gif``
    - returns a Data URI for <300 KB files, otherwise copies the file to ``/dist`` and returns a relative URL
      to the created file.
  * - ``.ttf`` ``.eot`` ``.svg`` ``.woff``
    - Copies the file into ``/dist`` and returns a relative URL to the created file.
