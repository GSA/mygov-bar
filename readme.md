MyGov Discovery Bar
===================

The MyGov Discovery Bar allows visitors to government websites to find relevant content across federal agencies.

Implementation
--------------

Federal agencies would place a single line of JavaScript immediately prior to the `</body>` tag of their template. When a user scrolls to the bottom of the page, the script will inject an iframe with the MyGov Bar content. The iframe allows the MyGov Discovery Bar to be "sandboxed", meaning it does not have access to, nor can it manipulate the content within the parent page. Instead, the postMessage API is used share style information between the iframe and the parent page (such as showing or hiding the MyGov Discovery Bar, or setting its width).

Requirements
------------

The MyGov bar is designed to render into a single flat file using Jekyll and relies on the MyGov Discovery API to generate recommendations. Once built (e.g., by pushing to GitHub), the entire project runs client side.

Structure
---------

* `templates` - HTML files as underscore templates (aliased to `_includes/templates`)
* `css` - stylesheets (aliased to `_includes/css`)
* `cs` - coffeescript source files
* `img` - images
* `plugins` - browser extensions
* `mygov-bar.html` - main rendered file, which will be the source of the child iframe
* `mygov-bar.js` - compiled javascript which will be the source of the embed code
* `index.md` - sample page with usage instructions 

Running
-------

The MyGov Discovery Bar renders down to a single flat HTML file (the iframe source) and a single javascript file (the embed code). To run locally for development purposes, install Jekyll, and simply run `jekyll --url http://localhost:4000`.

### Setting up a development environment

1. Install Ruby
2. Install Jekyll (`gem install jekyll`)
3. `jekyll --server --url http://localhost:4000`

Contributing
------------

1. Clone the repository
2. Install [Ruby](http://www.ruby-lang.org/en/downloads/)
3. Install [Jekyll](http://jekyllrb.com/) (`gem install jekyll`)
4. Install [Node](http://nodejs.org/) (e.g., `brew install node`)
5. Install [NPM](https://npmjs.org/) `curl https://npmjs.org/install.sh | sudo sh`
6. Run the command `npm install` from the repository folder
7. (make changes)
8. `grunt`

Grunt Tasks
-----------

```
Available tasks
        concat  Concatenate files. *                                           
        coffee  Compile CoffeeScript files into JavaScript *                   
        uglify  Minify files with UglifyJS. *                                  
         watch  Run predefined tasks whenever watched files change.            
        mincss  Minify CSS files *                                             
         clean  Clean files and folders. *                                     
    coffeelint  Validate files with CoffeeLint *                               
        jekyll  This triggers the jekyll command. *                          
      imagemin  Minify PNG and JPEG images *                                   
       csslint  Lint CSS files with csslint *                                  
        cssmin  Minify CSS files with clean-css. *                             
           jst  Compile underscore templates to JST file *                     
         mocha  Run Mocha unit tests in a headless PhantomJS instance. *       
          sass  Compile Sass to CSS *                                          
          bump  Increment the version number                                   
       default  Alias for "concat", "coffee", "coffeelint", "jst", "sass",     
                "uglify", "mincss", "imagemin", "clean", "bump",               
                "jekyll:build", "mocha" tasks.                                 
        server  Alias for "default", "jekyll" tasks.               
```

Deploying to Static
-------------------

Running the command `grunt` from the repository folder will generate a static site to the `_site` folder. This folder can be safely copied to static hosting such as S3, or can be hosted on a lightweight server with GZIP and high browser-caching such as Nginx. Running `grunt` and pushing the repository to GitHub will also generate the hosted site.

Several Grunt plugins can automate the processes of deploying static sites. Simply search for e.g., `grunt contrib s3`, or `grunt deploy`.

Under the Hood
--------------

The embed code injects an iframe into the parent page. The child page is a single HTML file which contains all the CSS, templates, and javascript necessary to run the bar. The bar is built using the Backbone framework using Backbone views. The bar uses a `page` model to describe the current page, and uses views to describe each tab (e.g., search, tags, feedback related), as well as hidden, mini, and expanded states.

Once a page is loaded, the embed code passes the URL to the child page via a hash, and the MyGov bar will call the discovery API via `/pages/lookup.json?url={XXXX}` to grab the Page object. After the initial call, Backbone uses its standard restful API (e.g., `GET /pages/1.json`, `POST /pages/2.JSON`, etc.).

Last, because the child page cannot resize the parent iframe, the HTML postMessage API is used to pass messages back and forth (with a javascript IE7 fallback uses iframe hashes).

Most setting can be customized via `_config.yml`.