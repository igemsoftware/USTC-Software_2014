# docker run --name mysqlex --link biopano:mysql -e MYSQL_ROOT_PASSWORD=SyntheticBiology -d mysql
docker run --name mysqlex -e MYSQL_ROOT_PASSWORD=mysecretpassword -v /srv/biopano/mysql:/var/lib/mysql -d mysql

docker run --name mongoex --link biopano:mongo -d mongo

docker run -d -p 8080 dockerfile/python-runtime

docker run --name nginxex -v /some/nginx.conf:/etc/nginx.conf:ro -d nginx


apt-get install mysql-server libmysqld-dev python python-dev python-pip mongodb git

pip install django MySQL-python django-social-auth dict2xml pymongo djangorestframework

CREATE USER 'master'@'localhost' IDENTIFIED BY 'SyntheticBiology';

CREATE DATABASE IF NOT EXISTS `backend_master` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES ON `backend_master`.* TO 'master'@'localhost';