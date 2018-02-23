############################################################
# Dockerfile to run Tactic Containers 
# Based on Centos 7 image
############################################################

FROM centos:centos7
MAINTAINER Diego Cortassa <diego@cortassa.net>

ENV REFRESHED_AT 2018-02-22

# Setup a minimal env
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV HOME /root

# set a better shell prompt
RUN echo 'export PS1="[\u@docker] \W # "' >> /root/.bash_profile

# Install dependecies
RUN yum -y install httpd postgresql postgresql-server postgresql-contrib python-lxml python-imaging python-crypto python-psycopg2 unzip git ImageMagick; yum clean all
# TODO add ffmpeg

# install supervisord
RUN yum -y install epel-release && \
    yum -y install supervisor && \
    yum clean all
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Ssh server
# Uncomment sshd in supervisord.conf
# Specify root password at container launch with "-e ROOT_PASSWORD=mysupersecurepassword"
#RUN yum -y install openssh-server && \
#    service sshd start && \
#    ssh-keygen -A

# Entry point for launching supervisord when container is started
ADD bootstrap.sh /usr/local/bin/bootstrap.sh

# Patch postgresql-setup not to use systemd and initialize postgresql data files
RUN sed -i -e 's/systemctl show -p Environment "${SERVICE_NAME}.service" |/echo "Environment=PGPORT=5432 PGDATA=\/var\/lib\/pgsql\/data" |/' /usr/bin/postgresql-setup && \
    postgresql-setup initdb

# get and install Tactic
RUN git clone --depth 1 --branch 4.6 https://github.com/Southpaw-TACTIC/TACTIC.git && \
    cp TACTIC/src/install/postgresql/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf && \
    chown postgres:postgres /var/lib/pgsql/data/pg_hba.conf && \
    su postgres -c '/usr/bin/postgres -D /var/lib/pgsql/data -p 5432 2>&1 >/dev/null &' && \
    yes | python TACTIC/src/install/install.py -d && \
    su postgres -c '/usr/bin/pg_ctl stop -D /var/lib/pgsql/data -s -m fast' && \
    cp /home/apache/tactic_data/config/tactic.conf /etc/httpd/conf.d/ && \
    sed -i -e 's/#Require all granted/Require all granted/' /etc/httpd/conf.d/tactic.conf && \
    rm -r TACTIC

EXPOSE 80 22

# Start Tactic stack
CMD ["/usr/local/bin/bootstrap.sh"]
