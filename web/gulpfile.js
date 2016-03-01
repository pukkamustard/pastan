/* jshint node: true */
"use strict";

var gulp = require('gulp');
var elm = require('gulp-elm');
var connect = require('gulp-connect');

var config = {
    dest: 'build'
};

gulp.task('elm', function() {
    return gulp.src('src/Main.elm')
        .pipe(elm())
        .pipe(gulp.dest('build/'))
        .pipe(connect.reload());
});

gulp.task('copy', function() {
    return gulp.src(['src/**/!(*.elm)'])
        .pipe(gulp.dest(config.dest))
        .pipe(connect.reload());
});

gulp.task('build', ['copy', 'elm']);

gulp.task('connect', ['build'], function() {
    connect.server({
        port: 8001,
        debug: true,
        root: config.dest,
        livereload: true
    });
});

gulp.task('watch', ['build'], function() {
    gulp.watch('src/**/!(*.elm)', ['copy']);
    gulp.watch('src/**/*.elm', ['elm']);
});

gulp.task('serve', ['build', 'connect', 'watch']);
gulp.task('default', ['build']);
