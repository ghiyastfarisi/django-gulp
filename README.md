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
