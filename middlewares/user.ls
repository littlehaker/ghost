module.exports = {
  login: (req, res, next) ->
    if req.user
      next()
    else
      req.session.redirect = req.path
      res.redirect "/login"
}