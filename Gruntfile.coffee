module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    
    watch:
      cs:
        files: ["_cs/*", "_cs/app/*", "_cs/app/*/*"]
        tasks: ['concat', 'coffee']
        options:
          interrupt: true
          forceWatchMethod: 'old'
      css:
        files: "css/style.css"
        tasks: "mincss"
        options:
          interrupt: true
          forceWatchMethod: 'old'
      jst:
        files: "_templates/*._"
        tasks: "jst"
        options:
          interrupt: true
          forceWatchMethod: 'old'
      test:
        files: "test/*.coffee"
        tasks: "coffee:test"
        options:
          interrupt: true
          forceWatchMethod: 'old'                 
    
    uglify:
      app:
        files:
          "_includes/js/mygovbar.js": "_includes/js/mygovbar.js"
          "_includes/js/templates.js": "_includes/js/templates.js"
      embed:
        files:
          "_includes/js/embed.js": "_includes/js/embed.js"
      bookmarklet:
        files: 
          "_includes/js/bookmarklet.js": "_includes/js/bookmarklet.js"
      widget:
        files:
          "_includes/js/related-widget.js": "_includes/js/related-widget.js"

    concat:
      coffee:
        src: ["_cs/lib/*", "_cs/app/models/*", "_cs/app/views/*", "_cs/app/crossdomain.coffee", "_cs/app/router.coffee", "_cs/app/init.coffee"]
        dest: "_app.coffee"
      embed: 
        src: ["_cs/lib/xd.coffee", "_cs/embed.coffee"]
        dest: "_embed.coffee"

    coffee:
      app:
        files: 
          "_includes/js/mygovbar.js": "_app.coffee"
      embed:
        files:  
          "_includes/js/embed.js": "_embed.coffee"
      bookmarklet: 
        files:
          "_includes/js/bookmarklet.js": "_cs/bookmarklet.coffee"
      widget:
        files:
          "_includes/js/related-widget.js": "_cs/related-widget.coffee"
      test:
        files:
          "test/embed.js": "test/embed.coffee"
          
    coffeelint:
      app: ["_cs/app/*.coffee", "_cs/app/*/*.coffee" ]
      embed: "_cs/embed.cofee"
      bookmarklet: "_cs/bookmarklet.coffee"
    
    coffeelintOptions:
      max_line_length:
        level: "ignore"
        
    mincss:
      compress:
        files:
          "css/style.min.css": ["css/style.css"]
    clean:
      cs: ["_app.coffee", "_embed.coffee"]
      dsstore: "**/.DS_Store"
    
    jekyll:
      server:
        url: "http://localhost:4000"
        server: true
        auto: true
      build:
        server: false
        auto: false
        
    imagemin:
      img: 
       files:
         "img/star.png": "img/star.png"
         "img/delete.png": "img/delete.png"
         "img/sprite.png": "img/sprite.png"
         "img/sprite-2x.png": "img/sprite-2x.png"
         "img/logo.png": "img/logo.png"
    
    csslint:
      css:
        src: "css/style.css"
        rules:
          "ids": false
          
    less:
      app:
        files:
          "css/style.css": "css/style.less"
      
    jst:
      app:
        options:
          processName: (filename) ->
            filename.replace('_templates/', '').replace('._', '')
        files:
          "_includes/js/templates.js": "_templates/*._"
    
    mocha:
      embed:
        src: "_test/embed.html"
        options:
          run: true
                 
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-mincss'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jekyll'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-css'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-jst'
  grunt.loadNpmTasks 'grunt-mocha'

  grunt.registerTask 'default', ['concat', 'coffee', 'coffeelint', 'jst', 'uglify', 'mincss', 'imagemin', 'clean', 'jekyll:build', 'mocha' ]
  grunt.registerTask 'server', ['default', 'jekyll']
