var gulp = require('gulp');
var del = require('del');

var images = ['images/**/*.jpg', 'images/**/*.gif', 'images/**/*.svg'];
var scripts = ['scripts/**/*.js'];
var styles = ['styles/**/*.css'];


gulp.task('clean', del.bind(null, ['dist']));

gulp.task('build', ['images', 'scripts', 'styles']);

gulp.task('default', ['clean'], function() {
  gulp.start('build')
});

gulp.task('images', function() {
  return gulp.src(images)
    .pipe(gulp.dest('dist/img'))
});

gulp.task('scripts', function() {
  return gulp.src(scripts)
    .pipe(gulp.dest('dist/js'))
});

gulp.task('styles', function() {
  return gulp.src(styles)
    .pipe(gulp.dest('dist/css'))
});

gulp.task('watch', function() {
  gulp.watch(images, ['images'])
  gulp.watch(scripts, ['scripts'])
  gulp.watch(styles, ['styles'])
});
