fs                   = require 'fs'
path                 = require 'path'
chalk                = require 'chalk'
phash                = require 'phash-image'
compare              = require 'hamming-distance'
cliff                = require 'cliff'
GraphicsMagickClient = require path.resolve 'build', 'lib', 'GraphicsMagickClient'
Image                = require path.resolve 'build', 'data', 'Image'
PictProvider         = require path.resolve 'build', 'model', 'PictProvider'

RESIZE_PX = 16

# IMAGES_DIR     = path.resolve(__dirname, '..', 'images', 'cocoa')
IMAGES_DIR     = path.resolve(__dirname, '..', 'images', 'effected')
RESIZE_DIR     = "#{IMAGES_DIR}/resize"
GRAY_SCALE_DIR = "#{IMAGES_DIR}/grayscale"

pictProvider         = new PictProvider()
graphicsMagickClient = new GraphicsMagickClient()

do ->

  # 画像を配列に格納
  images = fs.readdirSync(IMAGES_DIR).filter (file) -> fs.statSync("#{IMAGES_DIR}/#{file}").isFile()
  console.log images

  fs.existsSync(RESIZE_DIR) or fs.mkdirSync(RESIZE_DIR)
  fs.existsSync(GRAY_SCALE_DIR) or fs.mkdirSync(GRAY_SCALE_DIR)

  # 画像をリサイズ
  promises = images.map (image) ->
    resizeParams =
      source: "#{IMAGES_DIR}/#{image}"
      output: "#{RESIZE_DIR}/#{image}"
      width: RESIZE_PX
      height: RESIZE_PX
    return graphicsMagickClient.resize resizeParams

  Promise.all promises
  .then (resizeResultList) ->

    # 画像のグレースケール
    promises = images.map (image) ->
      typeParams =
        source: "#{RESIZE_DIR}/#{image}"
        output: "#{GRAY_SCALE_DIR}/#{image}"
        type: 'Grayscale'
      return graphicsMagickClient.type typeParams
    Promise.all promises

  .then (typeResultList) ->

    # ハッシュの算出
    promises = images.map (image) -> phash("#{GRAY_SCALE_DIR}/#{image}")
    Promise.all promises

  .then (hashes) ->

    # DBに書き出し
    hashes.forEach (hash, idx) ->
      console.log hash
      params =
        filename: "#{IMAGES_DIR}/#{images[idx]}"
        hash: hash
      pictProvider.upsert params
      .then (result) ->
        console.log chalk.bgCyan result

    # ハッシュ値の出力
    console.log chalk.green "\nhashes ===========> "
    console.log hashes

    # hashesを回して、自分以外のhashと比較して出力する
    hashes.forEach (hash, idx) ->
      console.log chalk.bgBlue "\n#{images[idx]} =========>"
      rows = [['filename', 'distance']]
      hashes.forEach (_hash, _idx) ->
        return if idx is _idx
        distance = compare(hash, _hash)
        result = if distance then distance else "#{distance}".inverse
        rows.push [images[_idx], result]
      console.log cliff.stringifyRows(rows, ['green', 'green'])

  .catch (err) ->
    console.error chalk.red err
