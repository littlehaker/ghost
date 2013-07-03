# prelude
prelude = require 'prelude-ls'
global <<< prelude

express = require 'express.io'
# 这里修改了express-resource的源码，将express指向express.io
require 'express-resource'

http = require 'http'

load = require 'express-load'

app = express!

app.http!.io!

load 'config', {extlist: ['.ls']}
  .then 'models'
  .then 'middlewares'
  .then 'initializers'
  .then 'controllers'
  .then 'routes'
  .into app


app.listen app.config.server.port

exports.app = app