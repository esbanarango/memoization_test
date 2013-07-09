memoization_test
=======
Memoize a slow with callback in its arguments.



Installation
------------
    npm install memoize_test

Usage
-----

The input of memoize is slow_function and the output is a faster function
```javascript
fast_function = memoize(slow_function); // runs faster than slow_function by using cache functions
```