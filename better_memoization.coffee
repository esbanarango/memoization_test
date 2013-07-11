events = require "events"

data = {} # The cache store
default_ttl = 5000 # Default time to live to 7 seconds

cache_store = (callback,key,value) ->
  callback(null,value) if callback
  data[key] = value

cache_retrieve = (callback,key) ->
  if key == "2" # Data just to simulate when the cache function can be slower than the slow_function
    setTimeout(callback, 3000, null,data[key])
  else
    callback(null,data[key])

memoize = (slow_fn, opts = {})->
  if typeof slow_fn is "function"
    slice = Array::slice
    ->

      # Get the arguments from the function
      args = slice.call(arguments)
      slow_fn_callback = args[0]
      input = args[1]

      ttl = opts.ttl || default_ttl

      # Create the listenr
      eventEmitter = new events.EventEmitter()

      sendCallback = sendCallback = (err,value, where_it_comes_from)->
        console.log "From #{where_it_comes_from}"
        slow_fn_callback(err,value)

      eventEmitter.on "completed", sendCallback

      # The first function completed will return the result through the sendCallback 
      # function that is emitted. In both cases the cache will be updated
      process.nextTick ->
        cache_retrieve ((err,value)->
          if (value && value.ttl > Date.now())
            eventEmitter.emit "completed", err, value.value, "cache"
            eventEmitter.removeAllListeners "completed"

        ), input
      process.nextTick ->
          slow_fn.apply(this, [((err,value)->
                  eventEmitter.emit "completed", err,value, "slow_function"
                  eventEmitter.removeAllListeners "completed"
                  cache_store null,input, {value: value, ttl: Date.now() + ttl}
          ), input])

module.exports = memoize