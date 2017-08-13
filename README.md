# Fexr
[Fexr](https://fexr.org) is a free JSON api that serve you the latest and historical exchange rates

[![Build Status](https://travis-ci.org/Schultzer/fexr.svg?branch=master)](https://travis-ci.org/Schultzer/fexr)

## API

[latest?base=DKK&symbols=EUR,USD,JPY](https://fexr.org/api/v1/latest?base=DKK&symbols=EUR,USD,JPY)
```json
{"rates":{"USD":0.1576,"JPY":17.237,"EUR":0.1335},"date":"2017-08-13","base":"DKK"}
```

[latest?symbols=EUR,USD,JPY](https://fexr.org/api/v1/latest?symbols=EUR,USD,JPY)
```json
{"rates":{"JPY":109.05,"EUR":0.8453},"date":"2017-08-13","base":"USD"}
```

[2010-08-06?base=DKK&symbols=EUR,USD,JPY](https://fexr.org/api/v1/2010-08-06?base=DKK&symbols=EUR,USD,JPY)
```json
{"rates":{"USD":0.17682245277104564,"JPY":15.220867834677849,"EUR":0.13420037507078997},"date":"2010-08-06","base":"DKK"}
```

## LICENSE

(The MIT License)

Copyright (c) 2017 Benjamin Schultzer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
