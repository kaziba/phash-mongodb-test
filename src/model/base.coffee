configs  = require('konfig')()
mongoose = require 'mongoose'
uri      = process.env.MONGODB_URI || configs.app.MONGODB_URI
db       = mongoose.connect uri

module.exports = class DBBaseProvider

  constructor: ->
