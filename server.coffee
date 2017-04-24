express 		= require "express"
config	 		= require "config"
bodyParser 	= require "body-parser"

console.log "config", config
app = express()


server = app.listen (config.server.PORT || 8081), () ->
  console.log "Service running 8081...."


function handleResponse(res, code, exchange) {
  res.status(code || 500).json(exchange);
