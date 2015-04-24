gulp          = require 'gulp'
coffee        = require 'gulp-coffee'
concat        = require 'gulp-concat'
jade          = require 'gulp-jade'
notify        = require 'gulp-notify'
postcss       = require 'gulp-postcss'
sourcemaps    = require 'gulp-sourcemaps'
uglify        = require 'gulp-uglify'
gutil         = require 'gulp-util'
autoprefixer  = require 'autoprefixer-core'
mqpacker      = require 'css-mqpacker'
csswring      = require 'csswring'
cssnext       = require 'cssnext'
postcssnested = require 'postcss-nested'

gulp.task 'html', ->
  gulp.src './src/html/*.jade'
    .pipe jade()
    .pipe gulp.dest('./dist/html')

gulp.task 'css', ->
  processors = [
    autoprefixer  browsers: ['last 1 version']
    cssnext       compress: true
    mqpacker
    csswring
    postcssnested
  ]

  gulp.src './src/css/*.css'
    .pipe sourcemaps.init()
      .pipe postcss(processors)
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest('./dist/css')

gulp.task 'js', ->
  gulp.src './src/js/*.js'
    .pipe sourcemaps.init()
      .pipe uglify()
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest('./dist/js')

  gulp.src './src/js/*.coffee'
    .pipe sourcemaps.init()
      .pipe coffee({ bare: true }).on('error', gutil.log)
      .pipe uglify()
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest('./dist/js')

gulp.task 'default', ['html', 'css', 'js']