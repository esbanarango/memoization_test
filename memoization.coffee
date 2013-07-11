cache_store = {} # The cache store
default_ttl = 5000 # Default time to live to 7 seconds

cache_store = (callback,key,value) ->
  callback(null,value) if callback
  cache_store[key] = value

cache_retrieve = (callback,key) ->
  callback(null,cache_store[key])

memoize = (slow_fn, opts = {})->
  if typeof slow_fn is "function"
    ->
      # Get the arguments from the function
      slow_fn_callback = arguments[0]
      input = arguments[1]

      ttl = opts.ttl or default_ttl

      cache_retrieve ((err,value)->
        # If the value has been saved before (cached)
        # then return it with the slow function callback
        # otherwise calculate it, return it with the callback and save it
        if value and value.ttl > Date.now()
          slow_fn_callback err, value.data
        else
          process.nextTick ->
            slow_fn.apply(this, [((err,value)->
              slow_fn_callback err, value # callback is called as soon as information is ready
              cache_store null, input, {data: value, ttl: Date.now() + ttl}
            ),input])
      ), input

module.exports = memoize