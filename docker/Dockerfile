FROM ubuntu:trusty

RUN apt-get update

# install mongodb
RUN apt-get install -y mongodb

# install nginx
RUN apt-get install -y nginx

# install openLDAP
RUN apt-get install libsasl2-dev libssl-dev libmysqlclient-dev libpq-dev

# install python
RUN apt-get install -y python python-dev python-pip build-essential libmysqlclient-dev libpq-dev


EXPOSE 8000