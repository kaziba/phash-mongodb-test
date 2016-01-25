_              = require 'lodash'
mongoose       = require 'mongoose'
chalk          = require 'chalk'
Schema         = mongoose.Schema
ObjectId       = Schema.ObjectId
DBBaseProvider = require "./base"

PictSchema = new Schema
  filename: String
  hash: String
  createdAt:
    type: Date
    default: Date.now()
  updatedAt:
    type: Date
    default: Date.now()

  # type:
  #   type: String
  #   enum: ['link', 'image']
  #   default: 'link'
  # url: String # https://pixiv.com/mypage.php, https://amam.png
  # hostName: String  # qiita.com, pixiv.com
  # title: String # ページのタイトル
  # siteUrl: String # サイトのURL(画像でも、それを引用してきたサイトのURLがこれ)
  # siteName: String # サイトのタイトル(名前)
  # description: String
  # siteImage: String
  # isPrivate: # 非公開か
  #   type: Boolean
  #   default: true
  # isArchive:  # アーカイブに収納されたか
  #   type: Boolean
  #   default: false
  # createdAt:
  #   type: Date
  #   default: Date.now()
  # updatedAt:
  #   type: Date
  #   default: Date.now()

PictSchema.index {filename: 1, hash: 1}, {unique: true}
mongoose.model 'Pict', PictSchema
Pict   = mongoose.model 'Pict'

module.exports = class PictProvider extends DBBaseProvider

  constructor: ->
    super()

  findByHash: (params) ->
    console.log chalk.bgBlue 'findByHash'

  upsert: (params) ->
    return new Promise (resolve, reject) ->
      console.log chalk.bgYellow 'upsert'
      console.log params

      pict = params
      Pict.update
        hash: params.hash
      , pict,
        upsert: true
      , (err, numAffected, raw) ->
        console.log chalk.yellow "Result upsert =============> "
        console.log numAffected
        if err then return reject err
        return resolve 'upsert ok'


