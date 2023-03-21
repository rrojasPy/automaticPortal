# Instalación Automática del wagtail-Django y moodle
 
El repositorio está conformado por 3 archivos principales
* **moodle.sh :** Script para instalar moodle.
* **wagtail.sh :** Script para instalar  cms en una maquina local.
* **wagtail_server.sh :** Script para instalar  cms en un servidor.
* **autoSend.py :** Script para Enviar mensajes  whatsapp.

## Instalación
 
1. Permisos
```bash
sudo chmod +x wagtail.sh
sudo chmod +x wagtail_server.sh
sudo chmod +x moodle.sh
```
2. Consideraciones
* Se requieren credenciales gitlab para clon del proyecto.
* Antes de ejecutar el script, se pueden modificar la contraseña indicar el nombre, usuario y contraseña de la base de datos en la cabecera del script. Por defecto están configurados como meta todos los campos.
 
* Clon actual es de la rama develop.
 
3. Ejecutar script
sudo chmod +x wagtail.sh
```bash
./wagtail.sh
```
o
```bash
./wagtail_server.sh
```
4. Posterior a la instalación
* restore base de datos
Descargar el/los archivos tar.gz en el mismo lugar del script del restore
```bash
./restoreBackup.sh
```
*e.g.*
 
 
* Configuracion Local
En la versión actual de develop hay que hacer las siguientes configuraciones si actualizan su local:
- Crear en el wagtail 3 info pages con los datos necesarios para poblar las páginas de quiero enseñar, quiero informarme y quiero aprender, si eso no está creado esas páginas no van a poder cargar (no debería afectar el resto del sistema) en el campo name tienen que tener los siguientes nombres want_to_find_out, want_to_learn y want_to_teach
- En el admin de django /admin: hay que modificar la entides interest y actualizar el campo key, por ejemplo puede decir algo como teach, learn e inform
