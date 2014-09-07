console.log "Ethos inject.coffee: ok"

jquery = require 'jquery'
url = require 'url'



if global?.require
	rpc = require 'node-json-rpc'
	client = new rpc.Client
		port: 7001
		host: '127.0.0.1'
		path: '/'
		strict: false

	rpc = (method,args) ->
		args = args[0] if args.length
		client.call
			jsonrpc: '2.0'
			method: method
			params: args

	window?.winston =
		error: -> rpc 'logError', arguments
		warn: -> rpc 'logWarn', arguments
		info: -> rpc 'logInfo', arguments

	window.eth =
		client: 'ethos'
		keys: ['asdasda']
		getBalance: -> 0
		stateAt: -> 1
		transact: -> null
		fromAscii: (x) -> x.toString()

parseEthQuery = (href) ->
	query = url.parse( href, true ).query
	unless query.dapp
		query.dapp = if query.address
			'etherchain'
		else if query.ammount
			'walleth'
	query

jquery ->
	try
		console.log 'jquery ready.'
		jquery( 'body' ).on 'click', '[href]', (ev) ->
			console.log 'href click'

			href = jquery( this ).attr 'href'
			ethIntent = href.match /^:eth\?(.*)/
			query = parseEthQuery href

			console.log this

			if ethIntent
				follow = window.confirm "Open link in ÐApp: #{ query.dapp }"
				window.location = "/#{query.dapp}" if follow
				ev.preventDefault()
				false
	catch err
		window.winston.error err

console.log "Ethos inject end: ok."