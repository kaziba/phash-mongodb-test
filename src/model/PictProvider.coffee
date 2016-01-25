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

PictSchema.index {filename: 1, hash: 1}, {unique: true}
mongoose.model 'Pict', PictSchema
Pict = mongoose.model 'Pict'

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


