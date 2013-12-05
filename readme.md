# Puppet Git Deploy

A puppet module to enable [Heroku](http://heroku.com)-style, git push-based deployment of web apps and workers.

## PRE-ALPHA

This module is PRE-ALPHA.  Use at your own risk.

## Puppet Usage

```
# Configure up gitdeploy
class { 'gitdeploy':
    bareReposDir => "/var/git",
    webroot      => "/var/www",
    owner        => "root",
    group        => "root",
}

# Create a bare git repo at ${bareReposDir}/rad-app.git
# On each push deploy the app to ${webroot}/rad-app
gitdeploy::repo { 'rad-app':}
```

## App Preparation

### Setup Makefile and Procfile

Gitdeploy replies on Makefile's and Procfile's to build and run apps respectively.  Just commit a `Makefile` or `Procfile` in your app repo.

Example Makefile

```
install:
	mvn clean install -P uberjar
```

Example Procfile

```
web: java $JAVA_OPTS -jar target/api-0.1.05.jar server src/main/resources/prod.yml
```

### Setup Git remote

```bash
$ git remote add <remote-name> ssh://<instance-url>/var/git/rad-app.git
```

### Deploy

Run this command...

```bash
$ git push <remote-name> master:master
```

This will push your changes to the bar git repo created by the `gitdeploy`.  These changes will be deployed to the webroot. If your app has a `Makefile`, `make install`.
If your app has a `Procfile`, then `foreman` will export an upstart config and run it.
