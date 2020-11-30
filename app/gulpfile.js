const gulp = require('gulp');
const runSequence = require('run-sequence');
const watch = require('gulp-watch');
const sass = require('gulp-sass');
const sourcemaps = require('gulp-sourcemaps');
const autoprefixer = require('gulp-autoprefixer');
const notify = require('gulp-notify');
const cssnano = require('gulp-cssnano');
const plumber = require('gulp-plumber');
const child_process = require('child_process');

const scssFiles = ['./assets/scss/**/*.scss'];
const scssMain = ['./assets/scss/main.scss'];
const pathStyleDest = './assets/css';

// SASS
gulp.task('style', function () {
  return gulp.src(scssMain)
    .pipe(plumber({errorHandler: notify.onError("Style Build Error: <%= error.message %>")}))
    .pipe(sourcemaps.init())
      .pipe(sass())
      .pipe(autoprefixer('last 4 version'))
    .pipe(sourcemaps.write())
    .on('error', onError)
    .pipe(gulp.dest(pathStyleDest));
});

gulp.task('style-build', function () {
  return gulp.src(scssMain)
    .pipe(plumber({errorHandler: notify.onError("Style Build Error: <%= error.message %>")}))
    .pipe(sass())
    .on('error', onError)
    .pipe(autoprefixer('last 4 version'))
    .pipe(cssnano())
    .pipe(gulp.dest(pathStyleDest));
});

// Watcher
gulp.task('watch', () => {
  runSequence('style');
  gulp.watch(scssFiles, function(){
    runSequence('style', ['notify']);
  });
});

// Build for prod
gulp.task('build', function(callback) {
  runSequence(['style-build'], callback)
});

// Serve static files over HTTP
gulp.task('serve-dev', function(callback) {
   var cmd = child_process.spawn('python',  ['-m', 'SimpleHTTPServer', '80' ], {stdio: 'inherit'});
   cmd.on('close', function (code) {
     console.log('Python SimpleHTTPServer exited with code ' + code);
     callback(code);
   });
});

// Serve static files over HTTPS
gulp.task('serve-prod', function(callback) {
   var cmd = child_process.spawn('http-server',
    '-S -C /etc/letsencrypt/live/mattrichard.me/cert.pem -K /etc/letsencrypt/live/mattrichard.me/privkey.pem -p 443'.split(' '),
    {stdio: 'inherit'});
   cmd.on('close', function (code) {
     console.log('http-server exited with code ' + code);
     callback(code);
   });
});

// Default
gulp.task('default', done => {
  runSequence(['style', 'watch'], done);
});

///////////////////////////////////////////////////////////
// Helpers
function onError(error) {
    console.log(error.toString());
    this.emit('end');
}

gulp.task('notify', function () {
  return gulp.src('')
    .pipe(notify({message: 'DRAKARYS!!!', onLast: true}));
});
