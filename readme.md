Memoization Test
=======
Memoize a slow function with callback in its arguments.

**Note.** The callback on the function must be the first argument.


Installation
------------
    npm install memoize_test


Usage
-----

The input of memoize is slow_function and the output is a faster function.
```javascript
memoize = require('memoize_test')

fast_function = memoize(slow_function); // runs faster than slow_function by using cache functions
```

Usage
-----

Different case
-----

We can also assume that sometimes the cache function can be slower than the _slow_function_.In this situation both the  _cache_retrieve_ and _slow_fn_ will be called and the first being completed will be used. To see a solution for this case, take a look at [better_memoization.coffee](https://github.com/esbanarango/memoization_test/blob/master/better_memoization.coffee) 