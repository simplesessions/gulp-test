######################
# Requires
######################
gulp              = require 'gulp'
coffee            = require 'gulp-coffee'
concat            = require 'gulp-concat'
jade              = require 'gulp-jade'
notify            = require 'gulp-notify'
postcss           = require 'gulp-postcss'
sourcemaps        = require 'gulp-sourcemaps'
uglify            = require 'gulp-uglify'
gutil             = require 'gulp-util'
autoprefixer      = require 'autoprefixer-core'
mqpacker          = require 'css-mqpacker'
csswring          = require 'csswring'
cssnext           = require 'cssnext'
postcssnested     = require 'postcss-nested'
postcsssimplevars = require 'postcss-simple-vars'
browsersync       = require 'browser-sync'
watchify          = require 'watchify'
browserify        = require 'browserify'
source            = require 'vinyl-source-stream'
imagemin          = require 'gulp-imagemin'
jshint            = require 'gulp-jshint'
stylish           = require 'jshint-stylish'

####################
# Base Paths
####################
paths =
  base:
    root : './'
    src  : './src/'
    dist : './dist/'

paths.src =
  css    : paths.base.src + 'assets/css'
  js     : paths.base.src + 'assets/js'
  images : paths.base.src + 'assets/images'
  html   : paths.base.src + 'html'

paths.dist =
  css    : paths.base.dist + 'assets/css'
  js     : paths.base.dist + 'assets/js'
  images : paths.base.dist + 'assets/images'
  html   : paths.base.dist + ''

######################
# Tasks
######################
gulp.task 'html', ->
  gulp.src "#{paths.src.html}/*.jade"
    .pipe jade()
    .pipe gulp.dest(paths.dist.html)

gulp.task 'css', ->
  processors = [
    autoprefixer  browsers: ['last 1 version']
    cssnext       compress: true
    mqpacker
    csswring
    postcssnested
    postcsssimplevars
  ]

  gulp.src "#{paths.src.css}/*.css"
    .pipe sourcemaps.init()
      .pipe postcss(processors)
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest(paths.dist.css)
    .pipe browsersync.reload({ stream: true })

gulp.task 'js', ->
  gulp.src "#{paths.src.js}/*.js"
    .pipe jshint()
    .pipe jshint.reporter('jshint-stylish')
    .pipe sourcemaps.init()
      .pipe uglify()
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest(paths.dist.js)

  gulp.src "#{paths.src.js}/*.coffee"
    .pipe sourcemaps.init()
      .pipe coffee({ bare: true }).on('error', gutil.log)
      .pipe uglify()
    .pipe sourcemaps.write('maps')
    .pipe gulp.dest(paths.dist.js)

gulp.task 'images', ->
  gulp.src("#{paths.src.images}/**/*.{gif,jpg,png,svg}")
    .pipe imagemin
      progressive: true,
      svgoPlugins: [removeViewBox: false],
      optimizationLevel: 3 # png
    .pipe gulp.dest(paths.dist.images)

gulp.task 'build', ['html', 'css', 'js']

gulp.task 'browsersync', ->
  browsersync.init([paths.dist.html, paths.dist.css, paths.dist.js], {
      server: {
          baseDir: paths.dist.html
      }
  });

gulp.task 'watch', ['browsersync'], ->
  gulp.watch "#{paths.src.html}/**/*.jade", ['html']
  gulp.watch "#{paths.src.css}/**/*.css", ['css']
  gulp.watch "#{paths.src.js}/**/*.js", ['js']
  gulp.watch "#{paths.src.js}/**/*.coffee", ['js']

gulp.task 'default', ['build', 'watch']