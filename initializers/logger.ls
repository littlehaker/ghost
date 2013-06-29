require! 'winston'

module.exports = (app) ->
  levels = {
    debug: 0
    info: 1
    warn: 2
    error: 3
  }
  app.logger = global.logger = new winston.Logger {
    transports: [
      new winston.transports.Console {
        levels: levels
        colorize: {
          debug: 'blue'
          info: 'green'
          warn: 'yellow'
          error: 'red'
        }
        level: app.config.logger.level
      }
    ]
  }

  for level, v of levels
    global[level] = logger[level]  