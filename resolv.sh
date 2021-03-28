#!/bin/bash

#4- Fes un arxiu de guió de l'interpret d'ordres bash shell per l'usuari root que copiï el fitxer 
#resolv.conf que es troba a /etc  dins d'una carpeta del directori personal de root, el nom de la qual, 
#has de passar com a paràmetre. Si la carpeta no existeix, l'arxiu de guió ha d'enviar un missatge a root, 
#avisant-lo de que la carpeta no existeix, i preguntar-li si està segur de crear la carpeta. 
#En el cas de que l'usuari root confirmi  la creació de la carpeta, l'arxiu de guió haurà de crear-la i 
#continuarà la seva execució. En el cas de que l'usuari root no  ho confirmi, l'arxiu de guió deixarà 
#d'executar-se, i tornarà a l'interpret d'ordres, assignant el valor 1 com a codi de retorn. 
#Si l'arxiu de guió continua la seva execució, llavors farà una còpia de seguretat de resolv.conf 
#amb el nom resolv.conf.backup.data a on data és el any, mes, dia, hora i minut de la realització de la 
#còpia de seguretat (7). A continuació, el fitxer serà comprimit i s'btindrà el fitxer 
#resolv.conf.backup.data.gz, i l'original resolv.conf.backup.data serà esborrat i també la còpia 
#de resolv.conf que hi ha dins de la carpeta de l'usuari. L'arxiu de guió ha de finalitzar assignant 
#el valor 0 com a codi de retorn si ha arribar al final amb èxit. El nom de l'arxiu de guió serà resolv.sh.

#comprovant de que ha sigut executat com a root
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9
fi

#comprovant de que hi ha un parametre 
if (( $# != 1 ))
then
	echo "El programa requereix d'un parametre (directori desti) per poder fer la copia de seguretat."
	exit 2
fi

#get full path of resolv.conf
resolv="/etc/resolv.conf"
#save arg1 which will be folder name
arg1=$1
#create destination folder as a variable
destination="/root/$arg1"
echo $destination
#check if folder exists
#[ -d $destination ] && echo "Directory /path/to/dir exists."

#si el desti existeix la copia es fa correctamnnt
if [ -d "$destination" ]; then

  echo "Es copiara el fitxer resolv.conf..."
  cp $resolv "$destination/resolv.conf"
  echo "Copiat correctament!"

#si no existeix es pregunta si es vol crear la ruta
elif [ ! -d "$destination" ]; then

  #echo "El directori especificat no existeix, vols crearlo?[y/n]"
  read -p "El directori especificat no existeix, vols crearlo?[y/n]" input
  option=${input,,}
  echo $option

  if [[ $option != "s" ]] && [[ $option != "S" ]]
	then
		echo "No s'ha creat el subdirectori"
		exit 1
	else
		mkdir /root/$arg1
	fi

fi

nom_backup=/root/$arg1/resolv.conf.backup.$(date +"%Y%m%d%H%M")
cp /etc/resolv.conf $nom_backup 
gzip $nom_backup
if [[ -e $nom_backup ]]; then rm $nom_backup; fi
exit 0
