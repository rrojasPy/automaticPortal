#!/bin/bash root

##### Directorios #####

cd ~
mkdir portalMeta

#######################
# Update
sudo apt-get update -y

#Install python 3
sudo apt-get install python -y
echo "python 3 Instalado" >> ReporteInstalacion.txt

#Install python-pip 3
sudo apt-get install python3-pip -y
echo "python-pip Instalado" >> ReporteInstalacion.txt

#Install paquete libpq
sudo apt-get install libpq-dev -y 

#Install postgres
#Postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
apt-get install postgresql-12
echo "postgress 3 Instalado" >> ReporteInstalacion.txt


## crear base de datos 
## Crear usuario  

## Clonar proyecto
cd $portalMeta
git clone https://gitlab.com/mpoletti-peduca/paraguayeduca-django.git
echo "Clonar gitlab " >> ReporteInstalacion.txt

# Chequeo de rama 
git checkout develop
mkdir /paraguayeduca/env
python3 -m venv /paraguayeduca-django/env

pip3 install -r requirements.txt
sudo nano local_settings.py
python3 manage.py migrate
python3 manage.py collectstatic
python3 manage.py createsuperuser
python3 manage.py runserver 0.0.0.0:8000

# source env/bin/activate "pip3 install -r requirements.txt;
# sudo nano local_settings.py;
# python3 manage.py migrate;
# python3 manage.py collectstatic;
# python3 manage.py createsuperuser;
# python3 manage.py runserver 0.0.0.0:8000;"

### Instalar Guanicorn 
# Instalacion
sudo pip3 install guanicorn
pip install psycopg2-binary

# Conect sguanicorn 
gunicorn --bind 0.0.0.0:8000 TestProject.wsgi:application ## similar to runserver

# Install supervisor 
sudo apt-get install -y supervisor ## This command holds the website after we logout

# Config Supervisor
cd etc/supervisor/conf.d/
sudo touch gunicorn.conf
sudo nano gunicorn.conf
"
   	 [program:gunicorn]
   	 directory=/home/ubuntu/paraguayeduca-django
   	 command=/home/ubuntu/env/bin/gunicorn --workers 3 --bind (como tengas tu venv)                      unix:/home/ubuntu/paraguayeduca-django/app.sock meta.wsgi:application
   	 autostart=true
   	 autorestart=true
   	 stderr_logfile=/var/log/gunicorn/gunicorn.err.log
   	 stdout_logfile=/var/log/gunicorn/gunicorn.out.log

   	 [group:guni]
   	 programs:gunicorn
"

# Conectar fichero de supervisor 
sudo supervisorctl reread

## Crear directorios 
sudo mkdir -p /var/log/gunicorn
sudo supervisorctl reread
sudo supervisorctl update

##  Compruebe si gunicorn se está ejecutando en segundo plano
sudo supervisorctl status

## Cree la configuración de nginx para el sitio de django
sudo vim /etc/nginx/sites-available/django.conf

######################### INSERTAR ###############################################
# " 
# -----django conf
# server{
#     	listen 80;
#     	server_name 18.231.73.102;

#     	location / {
#             	include proxy_params;
#             	proxy_pass http://unix:/home/ubuntu/paraguayeduca-django/app.so$
#     	}
# }

# "


## Test fichero de configuracion 
sudo ln /etc/nginx/sites-available/django.conf /etc/nginx/sites-enabled/
sudo nginx -t

## Restart NGINX server 
sudo service nginx restart
