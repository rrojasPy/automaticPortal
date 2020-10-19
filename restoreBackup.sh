#!/bin/bash 

##### Directorios #####

dir=$PWD

#####################postgres meta meta##

function restor () {
read -p "Ingrese nombre de la base de datos : " DataBases
read -p "Ingrese User de la base de datos ${DataBases} : " UserDataBase
echo "Datos ingresados ->  DataBase: ${Databases} | User: ${UserDataBase}"
read -p "Desea hacer drop de la base de datos  ${DataBases} [s]/[n] : " dropUser

if [ $dropUser = 'S' ] || [ $dropUser = 's' ] || [ $dropUser = 'Y' ] || [ $dropUser = 'y' ]
    then
echo "
DROP DATABASE ${DataBases};
CREATE DATABASE ${DataBases};" > ~/dbConfig.sql
else
    auxDrop=" "
fi
touch ~/dbConfig.sql
echo "
GRANT ALL PRIVILEGES ON DATABASE ${DataBases} TO ${UserDataBase};
GRANT ALL ON ALL TABLES IN SCHEMA public to ${UserDataBase};
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to  ${UserDataBase};
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${UserDataBase};" >> ~/dbConfig.sql
sudo -u postgres psql -f ~/dbConfig.sql
sudo rm ~/dbConfig.sql

    if [ $1 = "cms" ]
    then
        echo "Restaurando CMS"
        tar -xzvf $dirBackupCms
        dirBackup=$(find $dir -name "*cmd.backup"  -and -name "*cmd*")
        echo "dirBAC -> : ${dirBackup}" 
        auxDir=$(dirname $dirBackup)
        echo "ANTES ---->> :${DataBases} ---> ${UserDataBase}  ${dirBackup} " 
        pg_restore -h localhost -d $DataBases -U $UserDataBase -v $dirBackup
  
        read -p "Desea restabler carpeta Media? [s]/[n] : " opMedia

        if [ $opMedia = "S" ] || [ $opMedia = "s" ]
            then
            dirMedia=$(find $dir -name "*media")
            cp -r $dirMedia ~/paraguayeduca-django
            #chmod -777 ~/paraguayeduca-django/media
            echo "Se ha restaurado la carpeta media "
    
        fi
        read -p "Desea eliminar los archivos de restauracion? [s]/[n] : " opBorrar

        if [ $opBorrar= "S" ] || [ $opBorrar = "s" ]
            then
            sudo rm -r $dirBackupCms
            dirHome=$(find $dir -name "*home" )
            sudo rm -r $dirHome
            echo "Se ha elimindo  -> ${ficheros[*]} "
        fi

    else
        echo "Restaurando Moodle"
        tar -xzvf $dirBackupMoodle
        dirBackup=$(find $dir -name "*cmd.backup"  -and -name "*moodle*")
        auxDir=$(dirname $dirBackup)
        pg_restore -h localhost -d $DataBase -U $UserDataBase -v $dirBackup
    fi 

    echo "Se ha finalizado la restauracion del restore -> ${ficheros[*]} "
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

case $orde in
    m|M)
        echo -n "Restaurando Moodle-> "
        restor "moodle"
        ;;

    c|C)
        echo -n "Restaurando CMS -> "
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
