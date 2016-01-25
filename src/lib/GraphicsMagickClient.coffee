fs   = require 'fs'
gm   = require 'gm'
path = require 'path'

module.exports = class GraphicsMagickClient
  constructor: ->

  getImgSize: (source) ->
    return new Promise (resolve, reject) ->
      gm source
      .size (err, values) ->
        if err then return reject err
        return resolve values

  composite: (params) ->
    return new Promise (resolve, reject) ->
      gm params.source
      .composite params.input
      .geometry "+#{params.coordinate.x}+#{params.coordinate.y}"
      .write params.output, (err) ->
        if err then return reject err
        return resolve 'Fin composite'

  resize: (params) ->
    return new Promise (resolve, reject) ->
      gm params.source
      .resize params.width, params.height
      .autoOrient()
      .write params.output, (err) ->
        if err then return reject err
        return resolve 'Fin resize'

  type: (params) ->
    return new Promise (resolve, reject) ->
      gm params.source
      .type params.type
      .write params.output, (err) ->
        if err then return reject err
        return resolve 'Fin type'