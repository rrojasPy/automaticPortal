#!/bin/bash 

##### Directorios #####

dir=$PWD

#####################postgres meta meta##

function restor () {
read -p "Ingrese nombre de la base de datos : " DataBase
read -p "Ingrese User de la base de datos ${DataBase} : " UserDataBase
echo "Datos ingresados : DataBase: ${Database} | User: ${UserDataBase}"
touch ~/dbConfig.sql
echo "
GRANT ALL PRIVILEGES ON DATABASE ${DataBase} TO ${UserDataBase};
GRANT ALL ON ALL TABLES IN SCHEMA public to ${UserDataBase};
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to  ${UserDataBase};
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${UserDataBase};" > ~/$DirTemp/dbConfig.sql
sudo -u postgres psql -f ~/dbConfig.sql
#sudo rm ~/dbConfig.sql

    if [ $1 = "cms" ]
    then
        echo "Restaurando CMS"
        tar -xzvf $dirBackupCms
        dirBackup=$(find $dir -name "*cmd.backup"  -and -name "*cmd*")
        # echo "dirBAC -> : ${dirBackup}" 
        auxDir=$(dirname $dirBackup)
        # echo "aux : ${auxDir}" 
        pg_restore -h localhost -d $DataBase -U $UserDataBase -v $dirBackup
  
    else
        echo "Restaurando Moodle"
        tar -xzvf $dirBackupMoodle
        dirBackup=$(find $dir -name "*cmd.backup"  -and -name "*moodle*")
        auxDir=$(dirname $dirBackup)
        pg_restore -h localhost -d $DataBase -U $UserDataBase -v $dirBackup
    fi 
}

## Detectar archivos de restauracion 
echo "Inicio" 
ficheros=`find -name "*_cms.tar.gz*" -or -name "*_moodle.tar.gz*"`
echo "Se encontraron ${#ficheros[*]} archivos de restauracion"
echo ${ficheros[*]}

if [ ${#ficheros[*]} -gt 2 ]
then 
    echo "Dejar solo las ultimas dos backup"

else
    dirBackupCms=$(find "$PWD" -name "*tar.gz" -and -name "*cms*")
    dirBackupMoodle=$(find "$PWD" -name "*tar.gz" -and -name "*moodle*")
    echo "cmc : ${dirBackupCms} "
fi

read -p "Seleccione ->
Restore Moodle = [m] 
Restore Cms    = [c]
Restore Ambos  = [a]: " orde

echo -n "Restaurando CMS"
#restor "cms"

case $orde in
    m|M)
        echo -n "Restaurando Moodle"
        restor "moodle"
        ;;

    c|C)
        echo -n "Restaurando CMS"
        restor "cms"
        ;;

    a|A)
        echo -n "Restaurando CMS y Moodle"
        restor "moodle"
        restor "cms"
        ;;

    *)
        echo -n "Saliendo del script"
        exit
        ;;
esac
