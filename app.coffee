odata = require 'node-odata'
odata.set 'db', 'mongodb://localhost/my-app'
odata.resources.register
  url: 'numbers'
  model:
    number: Number
    code: Number
    lines: Number
    members: Number
    region: String
    title: String


express = odata._express
app = odata._app

app.set 'views', './views'
app.set 'view engine', 'jade'

app.use '/bower_components', express.static "#{__dirname}/bower_components"
app.use '/public', express.static "#{__dirname}/public"

app.get '/', (req, res)->
  res.render 'index'
app.get '/partials/:view', (req, res)->
  res.render "partials/#{req.params.view}"
odata.listen 3000