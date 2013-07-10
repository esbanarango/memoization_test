data = {} # The cache store

cache_store = (callback,key,value) ->
  callback(null,value) if callback
  data[key] = value

cache_retrieve = (callback,key) ->
  callback(null,data[key])

memoize = (slow_fn)->
  if typeof slow_fn is "function"
    slice = Array::slice
    ->
      args = slice.call(arguments)
      # Get the arguments from the function
      slow_fn_callback = args[0]
      input = args[1]

      cache_retrieve ((err,value)->
        # If the value has been saved before (cached)
        # then return it with the slow function callback
        # otherwise calculate it, return it with the callback and save it
        if value
          slow_fn_callback(err,value)
        else
          process.nextTick ->
            slow_fn.apply(this, [((err,value)->
              slow_fn_callback(err,value) # callback is called as soon as information is ready
              cache_store null,input, value
            ),input])
      ), input

module.exports = memoize