# Basic example to try the memoize function.
# Here you get the square of a given number the 
# first time you'll get a delay of ~3 seconds then
# you'll get the value immediately as it is stored in cache.

better_memoization = require './better_memoization'
readline = require 'readline'
rl = readline.createInterface(
  input: process.stdin
  output: process.stdout
)

slow_fn = (callback,n)->
  resp = n*n
  setTimeout(callback, 2000, null,resp)

fast_fn = better_memoization slow_fn

ask = ->
  rl.question "What number do you want to be calculated? (Type a letter to exit) \n", (n) ->
    if isNaN(parseFloat(n))
      rl.close()
    else
      fast_fn ((err, val)->
        throw err  if err
        console.log("Result: "+ val)
      ),n
      ask()


ask()