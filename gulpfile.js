var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var elm = require('gulp-elm');
var shell = require('gulp-shell');
var livereload = require('gulp-livereload');

gulp.task('nodemon', function() {
  nodemon({
    script: 'server/index.js',
    ext: 'js',
    ignore: 'client/**/*.*',
  });
});

gulp.task('client:elm', function() {
  return gulp.src('client-src/Main.elm')
    .pipe(elm())
    .pipe(gulp.dest('client/'))
    .pipe(livereload());
});

gulp.task('elm-live', shell.task([
  'elm-live client-src/Main.elm --output client/Main.js'
]));

gulp.task('client:copy', function() {
  return gulp.src(['client-src/**/!(*.elm|*.scss)'])
    .pipe(gulp.dest('client/'))
    .pipe(livereload());
});

gulp.task('watch', function() {
  livereload.listen();
  gulp.watch('client-src/**/*.elm', ['client:elm']);
  gulp.watch('client-src/**/!(*.elm|*.scss)', ['client:copy']);
});

gulp.task('serve', ['client:copy', 'client:elm', 'watch', 'nodemon']);
gulp.task('build', ['client:elm', 'client:copy']);
