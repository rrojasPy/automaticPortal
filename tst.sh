#!/bin/bash root

#####################################################################################
##### Data Base   #####
postgresUser="maga"
postgresPass="maga"
postgresDataBase="maga"
#################################################################################


# ## Base de datos ##
# # sudo su postgres psql<<EOF
# # psql -c CREATE DATABASE ${postgresDataBase};
# # psql CREATE user ${postgresUser} with password ${postgresPass};
# # psql GRANT ALL PRIVILEGES ON DATABASE ${postgresDataBase} TO ${postgresUser};
# # psql GRANT ALL ON ALL TABLES IN SCHEMA public to ${postgresUser};
# # psql GRANT ALL ON ALL SEQUENCES IN SCHEMA p dbConublic to ${postgresUser};
# # psql GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${postgresUser}; 

# # EOF
# # read -p "Press any key to continue..."



# # # 1 6 * * 3  sh ~/automaticBackup/cms_backup.sh > ~/BackupLog/LogShell_$(date '+\%Y-\%m-\%d-\%T').txt 2>&1
# # echo -ne '#####                     (33%)\r'
# # sleep 1
# # echo -ne '#############             (66%)\r'
# # sleep 1
# # echo -ne '#######################   (100%)\r'
# # echo -ne '\n'




# touch dbConfig.sql
# echo "
# create database ${postgresDataBase};
# create user ${postgresUser} with password '${postgresPass}';
# GRANT ALL PRIVILEGES ON DATABASE ${postgresDataBase} TO ${postgresUser};
# GRANT ALL ON ALL TABLES IN SCHEMA public to ${postgresUser};
# GRANT ALL ON ALL SEQUENCES IN SCHEMA public to  ${postgresUser};
# GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to ${postgresUser};" > dbConfig.sql


# ## Base de datos ##
# sudo -u postgres psql -f dbConfig.sql



# var= wget -qO- ifconfig.co/ip
# echo "OP"
# echo "$var" 
# echo "OP"
echo "OP"
publicIP=$(wget -qO- ifconfig.co/ip); echo "${publicIP}"
echo "OP"