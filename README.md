# Readium.js dist

A compiled and distribution ready version of Readium.js.

## Sandbox

Play around with `ReadiumSDK` at `sandbox-dev.html` and `sandbox-prod.html`.

## Dist

`dist/readium.js` is a requirejs-free version of Readium.js.
`dist/readium.min.js` contains the final files you would need to run Readium
together with its vendor assets.

## To contribute

Run this:

```
./build.js
```

and it will walk you through the steps to compile it.

Make sure you have Node and npm installed.

## Notes

On the compiled version, Chrome's console will throw an Exception on `Discontiguous selection is not supported.`.
According to [this bug report](https://code.google.com/p/rangy/issues/detail?id=208), it's a test 
in [Rangy](https://github.com/timdown/rangy) (one of Readium's components) and can be safely disregarded. 
It has already been submitted to Chrome's [bugtracker](https://code.google.com/p/chromium/issues/detail?id=353069#c4).

The warning is also supposed to be fixed on the latest Rangy but ReadiumJS is hooked to an old version.
