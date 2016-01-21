express = require 'express'
path = require 'path'
loremipsum = require 'lorem-ipsum'


app = express()


app.set('views', './app/views')
app.set('view engine', 'jade')
app.use express.static(path.join(__dirname, 'public'))


app.get '/', (req,res) ->
  text = loremipsum({count:40, units:"paragraphs", paragraphUpperBound: 10, suffix: "</p><p>"})
  res.render('index', { articletext : text })


app.listen process.env.VCAP_APP_PORT || 3000


module.exports = app