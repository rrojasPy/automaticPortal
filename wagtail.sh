#!/bin/bash 

#####################################################################################
##### Data Base   #####
postgresUser="meta"
postgresPass="meta"
postgresDataBase="meta"

publicIP=$(wget -qO- ifconfig.co/ip)
##### Directorios #####

DirTemp="temporal"

#####################################################################################


echo "#### INSTALANDO DEPENDENCIAS "
##################
## Dependencias ##

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

# Install  python 3 venv
sudo apt-get install python3-venv -y


#Install postgres
#Postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
sudo apt-get install postgresql-12
echo "postgress 3 Instalado" >> ReporteInstalacion.txt

#######################################################################################################################################

mkdir ~/$DirTemp

## Base de datos ##
# Crear usuario, Base de Datos y establecer permisos
echo "#### Creado Base de Datos"
touch ~/$DirTemp/dbConfig.sql
echo "
create database ${postgresDataBase};
create user ${postgresUser} with password '${postgresPass}';
GRANT ALL PRIVILEGES ON DATABASE ${postgresDataBase} TO ${postgresUser};
GRANT ALL ON ALL TABLES IN SCHEMA public to ${postgresUser};
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to  ${postgresUser};
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${postgresUser};" > ~/$DirTemp/dbConfig.sql

sudo -u postgres psql -f ~/$DirTemp/dbConfig.sql
rm -r ~/$DirTemp
echo "Crear Data Base:${postgresDataBase}, " >> ReporteInstalacion.txt

echo "#### Clonando Proyeto"
## Clonar proyecto
cd ~/
git clone --branch develop https://gitlab.com/mpoletti-peduca/paraguayeduca-django.git 
echo "Clonar gitlab " >> ReporteInstalacion.txt

mkdir env
python3 -m venv ~/env
source ~/env/bin/activate 
# Chequeo de rama 
cd ~/paraguayeduca-django/
git checkout develop

sudo apt update
sudo apt upgrade -y
pip install --upgrade pip
pip3 install --upgrade setuptools
pip3 install -r ~/paraguayeduca-django/requirements.txt
echo "Requerimientos instalados " >> ReporteInstalacion.txt

echo "#### Configurando Local Settings"
##Configurar local_settings.py
touch ~/paraguayeduca-django/meta/local_settings.py

echo "import os
from meta.settings import SITE_ROOT

DEBUG = True
TIMEZONE_OFFSET = -4

PASS_SECRET = ''
WEBSERVICE_TOKEN = ''
TOKEN_USERKEY = ''
MOODLE_URL = ''

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '${postgresDataBase}',
        'USER': '${postgresUser}',
        'PASSWORD': '${postgresPass}',
        'HOST': 'localhost',
        'PORT': '',
    }
}
" > ~/paraguayeduca-django/meta/local_settings.py

echo "Local_setting Generado" >> ReporteInstalacion.txt

## Poblar base de datos 
python ~/paraguayeduca-django/manage.py migrate
python ~/paraguayeduca-django/manage.py createsuperuser 
python ~/paraguayeduca-django/manage.py runserver localhost:8000