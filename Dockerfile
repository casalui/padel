FROM ubuntu

# File Author / Maintainer
MAINTAINER rmuktader

# Update the repository sources list

ENV ROOT_PATH /opt/app
ENV APP_PATH /opt/app/padel
# Install and run apache
#RUN apt-get install -y apache2 mysql-server mysql-client libapache2-mod-wsgi && apt-get clean
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y libapache2-mod-wsgi
RUN apt-get install -y python-virtualenv
RUN apt-get install -y python-pip
RUN apt-get install -y vim
RUN apt-get clean
RUN   echo "ServerName localhost" >> /etc/apache2/apache2.conf

#Python executable path

RUN echo "WSGIPythonHome /usr/" >> /etc/apache2/apache2.conf
#Python project path
RUN echo "WSGIPythonPath $ROOT_PATH/" >> /etc/apache2/apache2.conf

RUN echo "<VirtualHost *:80>\n\
    ServerName www.prueba.com\n\
    DocumentRoot $APP_PATH/\n\
    WSGIScriptAlias / $APP_PATH/wsgi.py\n\
    <Directory $APP_PATH/>\n\
        <IfVersion < 2.4>\n\
            Order allow,deny\n\
            Allow from all\n\
        </IfVersion>\n\
        <IfVersion >= 2.4>\n\
            Require all granted\n\
        </IfVersion>\n\
     </Directory>\n\
</VirtualHost>\n\
" >> /etc/apache2/sites-available/000-default.conf
COPY requirements.txt $ROOT_PATH/
WORKDIR $ROOT_PATH/
RUN pip install -r requirements.txt



EXPOSE 80
#CMD apachectl -D FOREGROUND
#CMD python manage.py runserver 0.0.0.0:8000
