module.exports = class Image

  constructor: (@path) ->
    @width = 0
    @height = 0

  setWidth: (width) ->
    @width = width

  setHeight: (height) ->
    @height = height

