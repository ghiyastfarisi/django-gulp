# Introduction

This is a reference project that shows you how to set up a Django project 
where all the tasks for handling the frontend files are performed by gulp.

# Motivation

While there is a lot of information on using gulp and Django together it is
often out of date and is not aimed at someone learning gulp (and Django) 
for the first time. That makes the process of learning to set up a project
sometimes problematic and always time-consuming. The goal here is to provide 
a workspace where you can see all the steps needed to get started. Armed 
with this knowledge you can then experiment to see what it takes to create 
a full production set up.

# Getting Started

Copy the bash script, bootstrap.sh, to the directory where you want to setup 
your project and run it. The script generates all the files you see in the 
frontend and backend directories to create a working Django project.

The script is quite verbose - it's just a wrapper for all the shell commands
needed to set things up. You will also be prompted for input, first for your
password so nodejs, yarn and python3.6 can be installed. After that there 
are several prompts for the data to setup the package.json file needed by
yarn and gulp. The prompts are just for descriptive data so you can just hit 
return to use the defaults. It won't affect the way the project is set up.

Once the script finishes. Run the following:

```bash
cd frontend
gulp
```

This compiles the javascript and css and copies the files to the dist directory
where Django can find them. Next start Django:

```bash
cd ../backend
pipenv shell
python manage.py migrate
python manage.py runserver
```

Now point your browser to http://127.0.0.1:8000/ where you can see the fruit 
of your labours.

# Environment &amp; versions

The boostrap.sh script assumes you are using the bash shell on Linux. It should 
work on other operating systems but you will need to check the options for the 
sed commands and change them to match your environment.

The script also assumes you want to use python3.6 but it is trivial to change it 
for another version.

# Resources:

* Everything you want to know about yarn: https://yarnpkg.com/
* And the same for pipenv, https://docs.pipenv.org/
* Getting started with Babel: https://babeljs.io/docs/setup/
* Getting started with Gulp: https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md
* What the del module does: https://www.npmjs.com/package/del
* A quick note on how babel changed the way it is distributed from v5 to v6: https://stackoverflow.com/questions/32544685/babel-vs-babel-core-vs-babel-runtime
* A short note on the deprecation warning for graceful-fs: https://github.com/gulpjs/gulp/issues/1571
* A slightly confusing discussion on why the failure to load @babel/register is not an issue: https://github.com/gulpjs/gulp/issues/1631

# Further Reading

There is a brief but useful introduction to using gulp in a Django project from
Marco Louro at Lincoln Loop: https://lincolnloop.com/blog/integrating-front-end-tools-your-django-project/ 
It is starting to show it's age but the associated gist has a lot of
useful features.

Herson Leite took that and modernised it to create a django project template
called Frango, https://github.com/hersonls/frango/tree/master/frontend. Again
this is useful for reference.













This is the manifest used by npm. It's just human-readable JSON so you can 
skip any of the questions presented and simply edit the file later.

## 8. Install babel

```bash
yarn global add babel-cli
yarn add --dev babel-core
yarn add --dev babel-preset-env
```

Babel changed the way it is packaged in v6. See the link in Resources below 
for more information.

babel-preset-env supports all the additions to javascript from 2015 onwards. 
To use it create babel config file.

```bash
cat << EOF > .babelrc
{
  "presets": ["env"]
}
EOF
```

## 9. Install gulp

```bash
yarn global add gulp-cli
yarn add --dev gulp
yarn add --dev gulp-babel
```

You will get a deprecation warning for graceful-fs. This can safely be ignored,
see the link to Gulp issue 1517 below in Resources. Now add all the modules we 
will need to get the basic Django project up and running.

```bash
yarn add --dev gulp-concat
```

This is a bit bare right now but there will be plenty more once we start adding 
features.

## 10. Install other things we need

For cleaning the generated and temporary files and folders we will use del:

```bash
yarn add --dev del
```

## 11. Create a gulpfile

```bash
cat << EOF > gulpfile.babel.js
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
EOF
```

This is just a bare-bones file that does not do anything useful other than
clean up and copy the basic javascript and stylesheets to the location where
Django will find them. We will add the other tasks later.

The typical name for a gulp file is gulpfile.js. This form tells gulp to
transpile the code using babel before running it.

## 12. Add the frontend assets for Django

First the template - we are using jQuery to add some minimal behaviour to show
that Django is pulling the files from the frontend.

```bash
mkdir templates/project

cat << EOF > templates/project/index.html
{% load static %}
<!doctype html>
<html lang="en">
  <head>
    <title>{{ title }}</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="{% static 'css/project.css' %}">
  </head>
  <body>
    <div id="content">This actually works!</div>
    <script src="https://code.jquery.com/jquery-3.2.1.js" integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE=" crossorigin="anonymous"></script>
    <script src="{% static 'js/project.js' %}"></script>
  </body>
</html>
EOF
```
Now the stylesheet:

```bash
cat << EOF > styles/project.css
#content {
    margin: auto;
    width: 100px;
    padding: 1em;
    border: thin solid black;
    text-align: center;
}
EOF
```
Finally some trivial animation:

```bash
cat << EOF > scripts/project.js
"use strict";

jQuery(function ($) {
  $("#content")
    .mouseover(function () {
      $("#content").css("color", "red");
    })
    .mouseout(function () {
      $("#content").css("color", "black");
    });
});```
EOF
```

## 13. Time to see if it all works.

```bash
gulp
```

```text
[09:19:15] Failed to load external module @babel/register
[09:19:15] Requiring external module babel-register
[09:19:16] Using gulpfile ~/Development/papyrus/frontend/gulpfile.babel.js
[09:19:16] Starting 'clean'...
[09:19:16] Finished 'clean' after 7 ms
[09:19:16] Starting 'default'...
[09:19:16] Starting 'build'...
[09:19:16] Finished 'build' after 21 μs
[09:19:16] Finished 'default' after 758 μs
```

Uh oh, that looks like an error but is it not really - after the load failure,
gulp falls back to the babel-register module which was included in babel-core.

Now head over to the backend and run the django server.

```bash
cd ../backend
pipenv shell
python manage.py runserver
```

Now open a browser and point to http://127.0.0.1:8000/

NOTE: If you want to make changes to prove that it's not all smoke and 
mirrors remember you have to run the gulp command each time to pick up 
the changes in  the 'dist' directory. Repeatedly running this will get 
old pretty soon but we will be updating the project to use Browsersync 
so any changes will be immediately visible.
