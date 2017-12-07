import gulp from 'gulp';
import del from 'del';

import babel from 'gulp-babel';
import concat from 'gulp-concat';


gulp.task('clean', del.bind(null, ['dist']));

gulp.task('build', ['styles', 'scripts']);

gulp.task('default', ['clean'], () => {
  gulp.start('build')
});

gulp.task('styles', () => {
  return gulp.src('styles/**/*.css')
    .pipe(concat('project.css'))
    .pipe(gulp.dest('dist/css'))
});

gulp.task('scripts', () => {
  return gulp.src('scripts/**/*.js')
    .pipe(babel())
    .pipe(concat('project.js'))
    .pipe(gulp.dest('dist/js'))
});
