data = {} # The cache store

cache_store = (callback,key,value) ->
  callback(null,value)
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
        # otherwise calculate it, save it and return it with the callback
        if value
          slow_fn_callback(err,value)
        else
          process.nextTick ->
            slow_fn.apply(this, [((err,value)->
              cache_store ((err,value)->
                slow_fn_callback(err,value)
              ),input, value
            ),input])
      ), input

module.exports = memoize