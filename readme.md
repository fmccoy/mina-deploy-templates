Mina Deploy Templates
=====================

This is a custom configuration of Mina, that adds tasks for apache, composer, grunt, and bower plus environments for Laravel and WordPress. 

WordPress Environment
=====================

Installation/Deployment
-----------------------
Setup Mina

    mina setup

Setup WordPress
  
    mina wp:setup

Edit "shared/vhost" to reflect app_name

    mina wp:deploy

Edit "shared/database.php" to connect to database

    mina wp:activate

Enjoy WordPress installation!


Tasks
=====

Apache
------
Restart Apache:

    mina apache:restart

Reload Apache:

    mina apache:reload

Enable Site:

    mina apache:ensite

Disable Site:

    mina apache:dissite

Composer
--------
Install:

    mina composer:install

Update:

    mina composer:update

Validate:

    mina composer:validate

Self Update:

    mina composer:selfupdate
