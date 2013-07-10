data = {} # The cache store

cache_store = (key,value,callback) ->
  callback(null,value)
  data[key] = value

cache_retrieve = (key,callback) ->
  callback(null,data[key])

memoize = (slow_fn)->
  if typeof slow_fn is "function"
    slice = Array::slice
    ->
      args = slice.call(arguments)
      # Get the arguments from the function
      slow_fn_callback = args[1]
      input = args[0]

      cache_retrieve input, (err,value)->
        # If the value has been saved before (cached)
        # then return it with the slow function callback
        # otherwise calculate it, save it and return it with the callback
        if value
          slow_fn_callback(err,value)
        else
          process.nextTick ->
            slow_fn.apply(this, [input,(err,value)->
              cache_store input   , value, (err,value)->
                slow_fn_callback(err,value)
            ])

module.exports = memoize