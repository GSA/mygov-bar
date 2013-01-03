fs = require 'fs'
{exec} = require 'child_process'

files = [ 'cs/models/page', 'cs/models/comment', 'cs/models/tag', 'cs/models/search', 'cs/views/mini', 'cs/views/related', 'cs/views/feedback', 'cs/views/hidden', 'cs/views/search', 'cs/views/tags', 'cs/views/expanded', 'cs/router', 'cs/xd', 'cs/crossdomain', 'cs/init' ]

task 'compile', 'compile coffeescript to javascript', ->
  compile()

task 'build', 'compile coffeescript and minify', ->
  build()
  
task 'minify', 'compress javascript and css files', ->
  minify()
  
task 'minify:js', 'compress javascript files', ->
  minifyJS()
  
task 'minify:css', 'compress css files', ->
  minifyCSS()

build = (callback) ->
  compile -> minifyCSS -> minifyJS()

compile = (callback) ->
  exec 'coffee --output _includes/js -c cs/bookmarklet', (err, stdout, stderr) ->
    console.log stdout if stdout
    throw err if err
    exec 'coffee --output _includes/js --join embed --compile cs/xd cs/embed', (err, stdout, stderr) ->
      console.log stdout if stdout
      throw err if err
      exec 'coffee --output _includes/js --join mygovbar --compile ' + files.join(' '), (err, stdout, stderr) ->
        console.log stdout if stdout
        throw err if err
        console.log "compiled coffee files"
        callback?()
    
minify = (callback) ->
  minifyCSS -> minifyJS()
  
minifyCSS = (callback) ->
  exec 'cleancss -o _includes/css/style.min.css _includes/css/style.css', (err, stdout, stderr) ->
    throw err if err
    console.log "css minified"
    callback?()

minifyJS = (callback) ->
  exec 'uglifyjs --overwrite _includes/js/embed.js', (err, stdout, stderr) ->
    throw err if err
    exec 'uglifyjs --no-copyright --overwrite _includes/js/bookmarklet.js', (err, stdout, stderr) ->
      throw err if err
      exec 'uglifyjs --inline-script --overwrite _includes/js/mygovbar.js', (err, stdout, stderr) ->
        throw err if err
        console.log "javascript minified"
        callback?()
