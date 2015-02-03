({
  baseUrl:      'lib',
  paths: {
    backbone:   'backbone.min.js',
    jquery:     'jquery.min.js',
    underscore: 'underscore.min.js'
  },
  name:         'almond',
  include:      'readium',
  out:          'dist/readium.min.js',
  optimize:     'uglify2',
  wrapShim:     true,
  wrap:         true
})
