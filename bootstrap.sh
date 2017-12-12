#!/usr/bin/env bash

#
# Bootstrap.sh
#
# A bash shell script for setting up a project with Django and gulp.
#
# To use this script copy it to the directory where you want to create
# your project and run it.
#

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update

sudo apt-get install nodejs
sudo apt-get install yarn
sudo apt-get install python3.6

wget https://bootstrap.pypa.io/get-pip.py
sudo python3.6 get-pip.py
rm get-pip.py

pip3.6 install --user pipenv


# ------------------------------------
# Set up the basic directory structure
# ------------------------------------

mkdir frontend backend

cd frontend

mkdir images scripts styles templates

cd ..

# -----------------------------
# Set up the Django environment
# -----------------------------

cd backend

pipenv --python 3.6
pipenv install django

django-admin startproject project .

# The first command executed by pipenv will create the virtual environment
# for the project. pipenv will use the WORKON_HOME environment variable if
# you have it set so the new environment will be added to you existing ones.

# The name of the environment is taken from the name of the parent directory
# and a hash of the path. That means if you end up using this layout in several
# projects you are going to end up with a set of environments all with similar
# name - which is a little awkward. It also means that you cannot move a
# project once the environment is created, unless you rebuild it.


# --------------------------
# Update the django settings
# --------------------------

# Django is agnostic on where the templates, stylesheets and scripts live so
# we are going to put everything in the frontend directory where it can be
# managed with gulp.

# First add paths for the main parts of the project.

cd project

sed -rin '/^BASE_DIR.*/a \
\
# Root directory for the project\
PROJECT_DIR = os.path.abspath(os.path.join(BASE_DIR, ".."))\
\
# Root directory for all the frontend files\
FRONTEND_DIR = os.path.abspath(os.path.join(PROJECT_DIR, "frontend"))' settings.py

# All the templates will be stored in the frontend.

# Add the frontend templates directory to the list of directories Django will
# search. Django will look there before searching the templates directory in
# any app. We still want to leave APP_DIRS set to True since we will want to
# pick up templates from Django or any third-party packages.

sed -rin "s/(DIRS': \[)(\],)/\1os.path.join(FRONTEND_DIR, 'templates')\2/" settings.py

# Now set the directories for static files. All the static files will be
# managed by gulp with the generated/processed results put in a directory
# named 'dist' in the frontend. For production all the static files (from
# gulp and Django) will be collected into a directory named 'assets' in
# the project root.

sed -rin '/^STATIC_URL.*/a \
\
# Directory where collectstatic puts all the files it finds.\
STATIC_ROOT = os.path.abspath(os.path.join(PROJECT_DIR, "assets"))\
\
# Directory where the various gulp tasks will put processed files\
STATICFILES_DIRS = (\
    os.path.join(FRONTEND_DIR, "dist"),\
)' settings.py

# Add a simple view

cat << EOF > views.py
from django.views.generic import TemplateView


class IndexView (TemplateView):
    template_name = "project/index.html"

EOF

# Now update (overwrite) urls.py so the page it displayed:

cat << EOF > urls.py
from django.contrib import admin
from django.urls import path

from .views import IndexView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', IndexView.as_view()),
]

EOF

cd ../..


# -----------------------
# Create the gulp project
# -----------------------

cd frontend

# Create a package.json. The -y option accepts the defaults for the project
# description - you can update these later.

yarn init -y

# Install gulp

yarn global add gulp-cli
yarn add --dev gulp
yarn add --dev gulp-concat

# You will get a deprecation warning for graceful-fs. This can safely be ignored,
# see the link to Gulp issue 1517 below in Resources. Now add all the modules we
# will need to get the basic Django project up and running.

# Install other things we need

yarn add --dev del

# Create a gulpfile

cat << EOF > gulpfile.js
var gulp = require('gulp');
var del = require('del');

var concat = require('gulp-concat');


gulp.task('clean', del.bind(null, ['dist']));

gulp.task('build', ['styles', 'scripts']);

gulp.task('default', ['clean'], function() {
  gulp.start('build')
});

gulp.task('styles', function() {
  return gulp.src('styles/**/*.css')
    .pipe(concat('project.css'))
    .pipe(gulp.dest('dist/css'))
});

gulp.task('scripts', function() {
  return gulp.src('scripts/**/*.js')
    .pipe(concat('project.js'))
    .pipe(gulp.dest('dist/js'))
});
EOF

# ----------------------------------
# Add the frontend assets for Django
# ----------------------------------

mkdir templates/project

cat << 'EOF' > templates/project/index.html
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

cat << 'EOF' > styles/project.css
#content {
    margin: auto;
    width: 100px;
    padding: 1em;
    border: thin solid black;
    text-align: center;
}
EOF

cat << 'EOF' > scripts/project.js
"use strict";

jQuery(function ($) {
  $("#content")
    .mouseover(function () {
      $("#content").css("color", "red");
    })
    .mouseout(function () {
      $("#content").css("color", "black");
    });
});
EOF

# We're done.