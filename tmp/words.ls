fs = require 'fs'
global <<< require 'prelude-ls'
require! 'restler'

err, buf <- fs.readFile './words.txt'
content = buf.toString!
(content.split ' ') |> each (line)->
  line = line.trim!
  if line isnt ''
    words = line.replace '——', ','
    console.log words
    restler.get "http://localhost:8080/words/create?words=#words" .on 'complete', (data) ->
      console.log data