module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    
    watch:
      cs:
        files: ["cs/*", "cs/app/*", "cs/app/*/*"]
        tasks: ['concat', 'coffee']
      css:
        files: "css/*"
        tasks: ["mincss", "imagemin"]
        
    uglify:
      options:
        banner: '/*! <%= pkg.name %> — <%= pkg.version %> — <%= grunt.template.today("yyyy-mm-dd H:s") %> */\n'
      app:
        files:
          "_includes/js/mygovbar.js": "_includes/js/mygovbar.js"
      embed:
        files:
          "_includes/js/embed.js": "_includes/js/embed.js"
      bookmarklet:
        files: 
          "_includes/js/bookmarklet.js": "_includes/js/bookmarklet.js"
          
    concat:
      app:
        src: ["cs/lib/*", "cs/app/models/*", "cs/app/views/*", "cs/app/crossdomain.coffee", "cs/app/router.coffee", "cs/app/init.coffee"]
        dest: "_app.coffee"
      embed: 
        src: ["cs/lib/xd.coffee", "cs/embed.coffee"]
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
          "_includes/js/bookmarklet.js": "cs/bookmarklet.coffee"
          
    coffeelint:
      app: ["cs/app/*.coffee", "cs/app/*/*.coffee" ]
      embed: "cs/embed.cofee"
      bookmarklet: "cs/bookmarklet.coffee"
      
    mincss:
      compress:
        files:
          "_includes/css/style.css": ["css/*.css"]
    clean:
      cs: ["_app.coffee", "_embed.coffee"]
      dsstore: "**/.DS_Store"
    
    jekyll:
      server:
        url: "http://localhost:4000"
        server: true
        auto: true
      watch:
        url: "http://localhost:4000"
        server: true
        
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
    
    less:
      app:
        files:
          "css/style.css": "css/style.less"
      
    jst:
      app:
        options:
          processName: (filename) ->
            filename.replace('_includes/templates/', '').replace('._', '')
        files:
          "_includes/js/templates.js": "_includes/templates/*._"
         
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

  grunt.registerTask 'default', ['concat', 'coffee', 'uglify', 'mincss', 'imagemin', 'clean']
  grunt.registerTask 'server', ['default', 'jekyll']
