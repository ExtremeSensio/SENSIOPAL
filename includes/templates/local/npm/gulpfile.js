var gaze = require('gaze');
var gulp = require('gulp');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var cssnano = require('cssnano');
var babel = require('gulp-babel');

var paths = {
  scripts: {
    src: 'wp-content/linotype/**/*.babel.js'
  },
  styles: {
    src: 'wp-content/linotype/**/*.scss'
  }
}

function compileStyle() {

  return gulp.src( paths.styles.src, { base: './' } )
    .pipe( sourcemaps.init() )
    .pipe( sass() ).on( 'error', sass.logError )
    .pipe( postcss( [ autoprefixer() ] ) )
    .pipe( sourcemaps.write() )
    .pipe( gulp.dest('./') )
  
}

function compileScripts() {

  return gulp.src( paths.scripts.src, { base: './' } )
    .pipe( sourcemaps.init() )
    .pipe( babel() )
    .pipe( gulp.dest('./') )

}

function watchFiles() {
  
  gaze(paths.styles.src, function(err, watcher) {

    this.on('all', function(filepath) {
      compileStyle()
    });

  });

}

var sensiopal = gulp.series( compileStyle, watchFiles );

exports.compileStyle = compileStyle;
exports.compileScripts = compileScripts;
exports.watchFiles = watchFiles;
exports.default = sensiopal;
