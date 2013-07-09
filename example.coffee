# Basic example to try the memoize function.
# Here you get the square of a given number the 
# first time you'll get a delay of 2 seconds then
# you'll get the value immediately as it is stored in cache.

memoize = require './memoization'
readline = require 'readline'

readline = require("readline")
rl = readline.createInterface(
  input: process.stdin
  output: process.stdout
)

slow_fn = (n,callback)->
  resp = n*n
  setTimeout(callback, 2000, resp)

fast_fn = memoize slow_fn


ask = ->
  rl.question "What number do you want to be calculated? (Type a letter to exit) \n", (n) ->
    if isNaN(parseFloat(n))
      rl.close()
    else
      fast_fn n, (val)->
        console.log("Result: "+ val)
        ask()


ask()