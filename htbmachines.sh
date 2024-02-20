#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function Crtl_C(){
        echo -e "\n${redColour}[!] Saliendo...${endColour}\n"
        exit 1
}

# Crtl+C
trap crtl_c INT

# Variables
main_url="https://htbmachines.github.io/bundle.js"

# Funciones
function helpPanel(){
        echo -e "\n${redColour}[!] Recuerde descargar o actualizar el archivo primero!${endColour}\n"
        echo -e "\n${yellowColour}[+] Uso:${endColour}\n"
        echo -e "\tu) Descargar o actualizar archivos"
        echo -e "\tm) Buscar por nombre de máquina"
        echo -e "\ti) Buscar por dirección IP"
        echo -e "\td) Filtrar máquinas por dificultad"
        echo -e "\to) Filtrar por Sistema Operativo"
        echo -e "\ts) Buscar máquina por skill"
        echo -e "\ty) Obtener tutorial de la máquina"
        echo -e "\th) Mostrar panel de ayuda\n"
}

function searchMachine(){
        machineName="$1"
        machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
        if [ "$machineName_checker" ]; then
                echo -e "\n${yellowColour}[+]${endColour} Listando propiedades de la máquina ${blueColour}$machineName${endColour}:\n"
                cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'
        else
                echo -e "\n${redColour}[!]${endColour} La máquina proporcionada no existe\n"
                helpPanel
        fi
}

function searchIP(){
        ipAddress="$1"
        machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
        if [ "$machineName" ]; then
                echo -e "\n${yellowColour}[+]${endColour} La máquina correspondiene a la dirección IP ${blueColour}$ipAddress${endColour} es ${blueColour}$machineName${endColour}"
        else
                echo -e "\n${redColour}[!]${endColour} La dirección IP proporcionada no existe\n"
                helpPanel
        fi
        searchMachine $machineName
}

function searchYT(){
        machineName="$1"
        linkYT="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
        if [ $linkYT ]; then
                echo -e "\n${yellowColour}[+]${endColour} El link de la máquina ${blueColour}$machineName${endColour} es $linkYT"
        else
                echo -e "\n${redColour}[!]${endColour} La máquina proporcionada no existe\n"
                helpPanel
        fi
}

function machineDifficulty(){
        difficulty="$1"
        result_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
        if [ "$result_check" ]; then
                echo -e "\n${yellowColour}[+]${endColour} Mostrando máquinas de dificultad ${blueColour}$difficulty${endColour}:\n"
                cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        else
                echo -e "\n${redColour}[!]${endColour} La dificultad proporcionada no existe\n"
                helpPanel
        fi

}

function machineOS(){
        OS="$1"
        OS_result="$(cat bundle.js | grep "so: \"$OS\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
        if [ "$OS_result" ]; then
                echo -e "\n${yellowColour}[+]${endColour} Las máquinas con el sistema operativo ${blueColour}$OS${endCOlour} son:"
                cat bundle.js | grep "so: \"$OS\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
        else
                echo -e "\n${redColour}[!]${endColour} El sistema operativo indicado no existe\n"
                helpPanel
        fi
}

function getOSDiffMachine(){
        difficulty="$1"
        OS="$2"
        checkeado="$(cat bundle.js | grep "so: \"$OS\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
        if [ "$checkeado" ]; then
                echo -e "\n${yellowColour}[+]${endColour} Máquinas encontradas con Sistema Operativo ${blueColour}$OS${endColour} y dificultad ${blueColour}$difficulty${endColour}:\n"
                cat bundle.js | grep "so: \"$OS\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
        else
                echo -e "\n${redColour}[!]${endColour} La dificultad o el Sistema Operativo indicado son erróneos"
                helpPanel
        fi
}

function searchSkill(){
        skill="$1"
        check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name:" | awk 'NF {print $NF}' | tr -d '",' | column)"
        if [ "$check_skill" ]; then
                echo -e "\n${yellowColour}[+]${endColour} Máquinas encontradas con la skill ${blueColour}$skill${endColour}:\n"
                cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name:" | awk 'NF {print $NF}' | tr -d '",' | column
        else
                echo -e "\n${redColour}[!]${endColour} La skill proporcionada no es correcta!"
                helpPanel
        fi
}

function updateFiles(){
        if [ ! -f bundle.js ]; then 
                echo -e "\n${yellowColour}[*]${endColour} Descargando los archivos...\n"
                curl -s $main_url > bundle.js
                js-beautify bundle.js | sponge bundle.js
                echo -e "\n${yellowColour}[+]${endColour} Listo!\n"
        else
                echo -e "\n${yellowColour}[!]${endColour} El archivo existe, buscando actualizaciones...\n"
                curl -s $main_url > bundle_temp.js
                js-beautify bundle_temp.js | sponge bundle_temp.js
                md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
                md5_original_value=$(md5sum bundle.js | awk '{print $1}')

                if [ "$md5_temp_value" == "$md5_original_value" ]; then
                        echo -e "\n${yellowColour}[*]${endColour} No hay actualizaciones\n"
                        rm bundle_temp.js
                else
                        echo -e "\n${yellowColour}[!]${endColour} Hay actualizaciones!\n"
                        rm bundle.js && mv bundle_temp.js bundle.js
                fi
                echo -e "\n${yellowColour}[+]${endColour} Finalizado!\n"
        fi
}

# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:h" arg; do
        case $arg in
                m)machineName="$OPTARG"; let parameter_counter+=1;;
                u)let parameter_counter+=2;;
                i)ipAddress="$OPTARG"; let parameter_counter+=3;;
                d)difficulty="$OPTARG"; chivato_os=1; let parameter_counter+=5;;
                o)OS="$OPTARG"; chivato_difficulty=1; let parameter_counter+=6;;
                s)skill="$OPTARG"; let parameter_counter+=7;;
                y)machineName="$OPTARG"; let parameter_counter+=4;;
                h);;
        esac
done

if [ $parameter_counter -eq 1 ]; then 
        searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
        updateFiles
elif [ $parameter_counter -eq 3 ]; then
        searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
        searchYT $machineName
elif [ $parameter_counter -eq 5 ]; then
        machineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
        machineOS $OS
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
        getOSDiffMachine $difficulty $OS
elif [ $parameter_counter -eq 7 ]; then
        searchSkill "$skill"
else
        helpPanel
fi
