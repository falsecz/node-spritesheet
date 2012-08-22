fs = require 'fs'
util = require 'util'
SpriteBuilder = require('./node-spritesheet').Builder

config =
	imageDestination: '/Users/bender/Develop/sbks/fg/dist/img/'

files = fs.readdirSync config.imageDestination

sourceImages = []
for file in files
	if file.match /.png$/
		sourceImages.push config.imageDestination + "/" + file


outputImages = []
cfg = 
	outputImage: "sprite.png"
	outputCss: "sprite.css"
	outputDirectory: config.imageDestination
	selector: ".im"
	verbose: yes
		
# util.log util.inspect cfg
sb = new SpriteBuilder(sourceImages, outputImages, cfg)
sb.build () ->
	util.log 'Sprites built'
	util.log 'Compiling sources'
