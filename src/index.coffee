fs                   = require 'fs'
path                 = require 'path'
chalk                = require 'chalk'
phash                = require 'phash-image'
compare              = require 'hamming-distance'
GraphicsMagickClient = require path.resolve 'build', 'lib', 'GraphicsMagickClient'
Image                = require path.resolve 'build', 'data', 'Image'
PictProvider         = require path.resolve 'build', 'model', 'PictProvider'

IMAGES_DIR = path.resolve(__dirname, '..', 'images')


pictProvider = new PictProvider()



###
初期処理
###
# 画像を配列に格納
images = [
  "#{IMAGES_DIR}/cocoa1.jpg"
  "#{IMAGES_DIR}/cocoa2.jpg"
  "#{IMAGES_DIR}/cocoa3.jpg"
  "#{IMAGES_DIR}/cocoa4.jpg"
  "#{IMAGES_DIR}/cocoa1_small.jpg"
]
console.log images


graphicsMagickClient = new GraphicsMagickClient()

# 画像をリサイズ
promises = images.map (image) ->
  resizeParams =
    source: image
    output: "#{image}_resized.jpg" # とりあえず
    width: 16
    height: 16
  return graphicsMagickClient.resize resizeParams

Promise.all promises
.then (resizeResultList) ->

  console.log chalk.inverse resizeResultList

  # 画像のグレースケール
  promises = images.map (image) ->
    typeParams =
      source: "#{image}_resized.jpg" # とりあえず
      output: "#{image}_grayscaled.jpg" # とりあえず
      type: 'Grayscale'
    return graphicsMagickClient.type typeParams
  Promise.all promises

.then (typeResultList) ->
  console.log chalk.inverse typeResultList

  # ハッシュの算出
  promises = images.map (image) -> phash("#{image}_grayscaled.jpg")
  Promise.all promises

.then (hashes) ->

  # DBに書き出し
  hashes.forEach (hash, idx) ->
    console.log hash
    params =
      filename: images[idx]
      hash: hash
    pictProvider.upsert params
    .then (result) ->
      return
      console.log chalk.bgCyan result

  # 出力
  console.log chalk.green "hashes ===========> "
  console.log hashes

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

.catch (err) ->
  console.error chalk.red err
