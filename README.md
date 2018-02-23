docker-tactic
=================

Tactic docker image.
** this is a the development version do not use in production!

TACTIC
------
TACTIC is a dynamic, open-source, web-based platform used for building enterprise solutions. It combines elements of traditional DAM, PAM, CMS and workflow management systems to optimize busy work environments. Read more at [Southpaw Technology web site](http://www.southpawtech.com/tactic/)

Docker Image
------------
This docker image is intended as an easy all in one installation to start experimenting with tactic including a postgresql server and an apache server. For a production server it is better to run tactic, postgresql and apache into different containers
The built image is available on the [Docker index](https://index.docker.io/) as **diegocortassa/tactic**
Dockerfile and source files can be found on [github](https://github.com/diegocortassa/docker-tactic)

Install docker on your host
On a recent ubuntu just use "sudo apt-get update; sudo apt-get install docker.io", (I usually add an alias "alias docker='sudo docker.io'" to my .bashrc)

Download image with:

    $ docker docker pull diegocortassa/tacticdev

Run the container with:

    $ docker run -d -p 80:80 -p 2222:22 diegocortassa/tacticdev

- connect with your browser to http://localhost to use tactic.


For ssh access uncomment ssh section in Dockerfile and supervisord.conf and rebuild image
