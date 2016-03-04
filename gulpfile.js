var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var elm = require('gulp-elm');
var connect = require('gulp-connect');
var shell = require('gulp-shell');

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
        .pipe(connect.reload());
});

gulp.task('elm-live', shell.task([
    'elm-live client-src/Main.elm --output client/Main.js'
]));

gulp.task('client:copy', function() {
    return gulp.src(['client-src/**/!(*.elm|*.scss)'])
        .pipe(gulp.dest('client/'))
        .pipe(connect.reload());
});

gulp.task('watch', function() {
    // gulp.watch('client-src/**/*.elm', ['client:elm']);
    gulp.watch('client-src/**/!(*.elm|*.scss)', ['client:copy']);
});

// gulp.task('connect', ['client'], function() {
//     connect.server({
//         port: 8339,
//         root: 'client/',
//         livereload: true
//     });
// });

gulp.task('serve', ['client:copy', 'watch', 'nodemon', 'elm-live']);
gulp.task('build', ['client:elm', 'client:copy']);
