#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Función para manejar la interrupción Ctrl+C
function ctrl_c(){
    echo -e "\n${redColour}[!] Saliendo...${endColour}\n"
    tput cnorm; exit 1
}

trap ctrl_c INT

# Comprobamos si el usuario es root
if [ $(id -u) -ne 0 ]; then
    echo -e "\n${redColour}[!] Debes ejecutar el script como usuario root...${endColour}\n"
    exit 1
fi

function helpPanel(){
	echo -e "\n${redColour}[+]${endColour} ${grayColour}Uso ./createUser.sh${endColour}\n"
	echo -e "\t${redColour}-u${endColour} ${grayColour}Crea el usuario.${endColour}"
	echo -e "\t${redColour}-h${endColour} ${grayColour}Muestra este panel de ayuda${endColour}\n"
	echo -e "\t\t${yellowColour}Scripter: @abund4nt${endColour}"
}

function createUser(){

	# Solicitamos el nombre de usuario
	echo -ne "\n${redColour}[+]${endColour} ${grayColour}Ingresa el nombre del usuario que deseas crear: ${endColour}\n"
	read username

	# Comprobamos si el usuario ya existe
	if id -u $username >/dev/null 2>&1; then
    	echo -e "\n${redColour}[!] El usuario $username ya existe.${endColour}\n"
    	exit 1	
	fi

	# Solicitamos la contraseña
	echo -ne "${redColour}[+]${endColour} ${grayColour}Ingresa la contraseña para el usuario $username: ${endColour}\n"
	read -s password
	echo -ne "\n${redColour}[+]${endColour} ${grayColour}Confirma la contraseña: ${endColour}\n"
	read -s password_confirmation

	# Comprobamos que las contraseñas coincidan
	if [[ "$password" != "$password_confirmation" ]]; then
    	echo -e "\n${redColour}[!] Las contraseñas no coinciden.${endColour}\n"
    	exit 1
	fi

	# Solicitamos el directorio de inicio
	echo -ne "\n${redColour}[+]${endColour} ${grayColour}Ingresa el nombre del directorio de inicio para el usuario $username: ${endColour}\n"
	read homedir

	# Creamos el usuario
	useradd -m -d /home/$homedir -s /bin/bash $username

	# Asignamos la contraseña al usuario
	echo "$username:$password" | chpasswd

	echo -e "\n${greenColour}[+] Usuario creado con éxito.${endColour}\n"

}

declare -i parameter_counter=0

while getopts "uh" arg; do
       case $arg in
		u) let parameter_counter+=1;;
		h) ;;
       esac
done

if [ $parameter_counter -eq 0 ]; then 
 helpPanel
elif [ $parameter_counter -eq 1 ]; then
 createUser
else
 echo -e "A"
fi
