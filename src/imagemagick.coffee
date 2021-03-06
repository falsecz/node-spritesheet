exec          = require( 'child_process' ).exec
async         = require( 'async' )

class ImageMagick

  identify: ( filepath, callback ) ->
    @exec "identify #{ filepath }", ( error, stdout, stderr ) ->
      if error or stderr
        throw "Error in identify (#{ filepath }): #{ error || stderr }"

      parts = stdout.split " "
      dims = parts[ 2 ].split "x"
      w = parseInt dims[ 0 ]
      h = parseInt dims[ 1 ]
      filename = filepath.split( '/' ).pop()
      name = filename.split( '.' ).shift()

      image =
        width: w
        height: h
        filename: filename
        name: name
        path: filepath

      callback image

  composite: ( filepath, images, width, height, callback ) ->
    # console.log 'Writing images to sprite sheet...'
    console.log cmd = "convert -size #{ width }x#{ height } xc:none  -alpha transparent #{ filepath }"
    @exec cmd, ( error, stdout, stderr ) =>
      if error or stderr
        throw "Error in creating canvas (#{ filepath }): #{ error || stderr }"

      compose = ( image, next ) =>
        # console.log "  Composing #{ image.path }"
        @composeImage filepath, image, next

      async.forEachSeries images, compose, callback

  exec: ( command, callback ) ->
    #console.log "Exec: #{ command }"
    exec command, callback

  composeImage: ( filepath, image, callback ) ->
    exec "composite -geometry +#{ image.cssx }+#{ image.cssy } #{ image.path } #{ filepath } #{ filepath }.tmp && mv #{ filepath }.tmp #{ filepath }", ( error, stdout, stderr ) ->
      if error or stderr
        throw "Error in composite (#{ filepath }): #{ error || stderr }"

      callback()

module.exports = new ImageMagick()
