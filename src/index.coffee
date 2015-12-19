fs      = require 'fs'
path    = require 'path'
phash   = require 'phash-image'
compare = require 'hamming-distance'

IMAGES_DIR = path.resolve(__dirname, '..', 'images')

images = [
  "#{IMAGES_DIR}/cocoa1.jpg"
  "#{IMAGES_DIR}/cocoa2.jpg"
  "#{IMAGES_DIR}/cocoa3.jpg"
  "#{IMAGES_DIR}/cocoa4.jpg"
  "#{IMAGES_DIR}/cocoa1_small.jpg"
]

promises = []
images.forEach (image) ->
  promises.push phash(image).then　(hash) -> hash

Promise.all promises
.then (hashes) ->
  hashes.map (hash) -> console.log hash

  distance1and1 = compare(hashes[0], hashes[0])
  distance1and2 = compare(hashes[0], hashes[1])
  distance1and3 = compare(hashes[0], hashes[2])
  distance1and4 = compare(hashes[0], hashes[3])
  distance1and1S = compare(hashes[0], hashes[4])

  console.log distance1and1
  console.log distance1and2
  console.log distance1and3
  console.log distance1and4
  console.log distance1and1S
