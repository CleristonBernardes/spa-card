express 							= require "express"
config	 							= require "config"
bodyParser 						= require "body-parser"
spa_card					  	= require './presenter/spa_card'
fs					  				= require 'fs'
React 								= require 'react'
ReactDOMServer 				= require 'react-dom/server'
browserify 						= require('browserify')
# global								= require 'react-global'


DOM = React.DOM
body = DOM.body
div = DOM.div
script = DOM.script

global.React = React

hCardComponent = require("#{__dirname}/../front_end/main.js").default


hCardProps = {
	givenName: 'Sammes',
	surname: 'Fairfax',
	email: 'sam.fairfax@fairfaxmedia.com.au',
	phone: '0292822833',
	houseNumber: '100',
	street: 'Harris Street',
	suburb: 'Pyrmont',
	state: 'NSW',
	postcode: '2009',
	country: 'Australia'
}

#
# console.log "React", React.createElement(hCardComponent, hCardProps)
console.log "React", ReactDOM.render(React.createElement(hCardComponent,hCardProps))

# markup = React.renderComponentToString(hCardComponent(hCardProps))



# Here we're using React to render the outer body, so we just use the
    # simpler renderToStaticMarkup function, but you could use any templating
    # language (or just a string) for the outer page template
html = ReactDOMServer.renderToStaticMarkup(body(null,

	# The actual server-side rendering of our component occurs here, and we
	# pass our data in as `props`. This div is the same one that the client
	# will "render" into on the browser from browser.js
	div({id: 'HcardApp', dangerouslySetInnerHTML: {__html:ReactDOMServer.renderToString(React.createElement(hCardComponent,hCardProps))}}),

	# The props should match on the client and server, so we stringify them
	# on the page to be available for access by the code run in browser.js
	# You could use any var name here as long as it's unique
	# script({dangerouslySetInnerHTML: {__html:
	#   'var APP_PROPS = ' + safeStringify(props) + ';'
	# }}),

	# We'll load React from a CDN - you don't have to do this,
	# you can bundle it up or serve it locally if you like
	script({src: '//cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react.min.js'}),
	script({src: '//cdnjs.cloudflare.com/ajax/libs/react/15.4.2/react-dom.min.js'}),

	# Then the browser will fetch and run the browserified bundle consisting
	# of browser.js and all its dependencies.
	# We serve this from the endpoint a few lines down.
  script({src: '/bundle.js'})
))

app = express()
app.use bodyParser.urlencoded { extended: false }
app.use bodyParser.json()
app.use bodyParser.json { type: 'application/vnd.api+json' }
# app.use '/bundle.js', (req, res) ->
#   res.setHeader('content-type', 'application/javascript')
#   browserify("#{__dirname}/../front_end/index.html", {debug: true})
#   # .transform('reactify')
#   .bundle()
#   .pipe(res)

app.use (err, req, res, next) ->
	console.log "err", err
	erro = {"error": "Could not persist the card"}
	handleResponse res, 400, erro

app.get '/', (req, res) ->
	res.setHeader 'Content-Type', 'text/html'
	html = ReactDOMServer.renderToStaticMarkup(body(null,
		div({id: 'HcardApp', dangerouslySetInnerHTML: {__html:ReactDOMServer.renderToString(React.createElement(hCardComponent,hCardProps))}}),
		script({src: 'https://unpkg.com/react@15/dist/react.js'}),
		script({src: 'https://unpkg.com/react-dom@15/dist/react-dom.js'}),
	  script({src: '/bundle.js'})
	))
	res.end html




app.post '/submit', (req, res) ->
	spa_card.save req.body, (err, spa_card) ->
		handleResponse res, 200, spa_card


server = app.listen (config.server.port || 8081), () ->
  console.log "Service running #{config.server.port || 8081}...."

handleResponse = (res, code, exchange) ->
	console.log "exchange", exchange
	res.status(code || 500).json(exchange)
