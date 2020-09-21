#!/bin/bash root

##### Directorios #####

# Directorio de Backup
dirBackup="Backup/Comprimido/"



#######################


DataBase= meta
UserDataBase= postgres

"
GRANT ALL PRIVILEGES ON DATABASE meta TO meta;
GRANT ALL ON ALL TABLES IN SCHEMA public to meta;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to meta;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to meta;
"

pg_restore -h localhost -d $DataBase -U $UserDataBase -v $dirBackup


#pg_restore -h localhost -d (USER) -U postgres -v /directorioDondeestasuBackup/meta.backup

