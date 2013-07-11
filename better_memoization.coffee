cache_store = {} # The cache store
default_ttl = 5000 # Default time to live to 5 seconds

cache_store = (callback,key,value) ->
  callback null, value if callback
  cache_store[key] = value

cache_retrieve = (callback,key) ->
  if key == "2" # Data just to simulate when the cache function can be slower than the slow_function
    setTimeout callback, 3000, null, cache_store[key]
  else
    callback null, cache_store[key]

memoize = (slow_fn, opts = {})->
  if typeof slow_fn is "function"
    ->
      # Get the arguments from the function
      slow_fn_callback = arguments[0]
      input = arguments[1]

      ttl = opts.ttl or default_ttl

      sendCallback = (err,value, where_it_comes_from)->
        console.log "From #{where_it_comes_from}"
        slow_fn_callback err, value
        sendCallback = null

      # The first function completed will return the result through the sendCallback 
      # function that is emitted. In both cases the cache will be updated
      process.nextTick ->
        cache_retrieve ((err, value)->
          sendCallback err, value.data, "cache" if sendCallback and value and value.ttl > Date.now()
        ), input
      process.nextTick ->
        slow_fn.apply(this, [((err,value)->
          sendCallback err, value, "slow_function" if sendCallback

          # Refresh the cache, so that this tick isn't useless if the cache response was faster
          cache_store null, input, {data: value, ttl: Date.now() + ttl}
        ), input])

module.exports = memoize