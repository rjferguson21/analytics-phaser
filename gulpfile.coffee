gulp = require 'gulp'
connect = require 'gulp-connect'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
s3 = require 'gulp-s3'
fs = require 'fs'

aws = JSON.parse(fs.readFileSync('/home/rob/.awscred'))
aws.key = aws.accessKeyId
aws.secret = aws.secretAccessKey
aws.bucket = 'ferguso.com'
aws.region = 'us-east-1'


gulp.task 'connect', ->
  connect.server
    root: 'tmp'
    livereload: true

gulp.task 'default', ['connect', 'coffee', 'jade', 'libs', 'watch']

gulp.task 'coffee', ->
  gulp.src 'app/*.coffee'
    .pipe coffee()
    .pipe gulp.dest 'tmp/js'
    .pipe connect.reload()

gulp.task 'jade', ->
  gulp.src '*.jade'
    .pipe jade()
    .pipe gulp.dest('tmp')

gulp.task 'libs', ->
  gulp.src 'assets/**/*'
    .pipe gulp.dest('tmp/assets')

  gulp.src 'lib/*.js'
    .pipe gulp.dest('tmp/lib')

gulp.task 'watch', ->
  gulp.watch 'app/*.coffee', ['coffee']

gulp.task 'deploy', ->
  gulp.src('./tmp/**')
    .pipe(s3(aws));
