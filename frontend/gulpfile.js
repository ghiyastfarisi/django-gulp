var gulp = require('gulp');
var del = require('del');


gulp.task('clean', del.bind(null, ['dist']));

gulp.task('build', ['styles', 'scripts']);

gulp.task('default', ['clean'], function() {
  gulp.start('build')
});

gulp.task('styles', function() {
  return gulp.src('styles/**/*.css')
    .pipe(gulp.dest('dist/css'))
});

gulp.task('scripts', function() {
  return gulp.src('scripts/**/*.js')
    .pipe(gulp.dest('dist/js'))
});
