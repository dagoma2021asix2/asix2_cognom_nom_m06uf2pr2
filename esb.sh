#!/bin/bash

#Fes un arxiu de guió de l'interpret d'ordres bash shell que pugui executar qualsevol usuari del sistema 
#i que tingui les següents caracterísitiques:

#    Podem passar 1 o 3 paràmetres al programa
#    El primer paràmetre ha de ser -r o -e
#    El segon paràmetre ha de ser una extensió de fitxer
#    El tercer paràmetre ha de ser una carpeta
#    Si el primer paràmetre val -r llavors NO hem de passar el segon i tercer paràmetres. 
        #Si amb l'opció -r  passem més d'un paràmetre, el programa finalizarà la seva execució 
        #assignant el valor 1 com a codi de retorn.
#    Si el primer paràmetre val -e llavors SÍ hem de passar el segon i tercer paràmetres. 
        #Si amb l'opció -e  no passem un segon i tercer paràmetres, el programa finalizarà la seva 
        #execució assignant el valor 2 com a codi de retorn.
#    Si el primer paràmetre NO val -e o -r llavors,  el programa finalizarà la seva execució 
        #assignant el valor 3 com a codi de retorn.

#Si escollim l'opció -e amb l'extensió i carpeta llavors, tots els arxiu que tingui la extensió indicada 
#dins de la carpeta escollida seran moguts a una carpeta de nom paperera dins del directori personal de 
#l'usuari. Si la carpeta paperera no existeix, l'arxiu de guió crearà la carpeta sense haver de 
#donar cap avís a l'usuari. Si no hi ha cap fitxer amb l'extensió indicada llavors el programa 
#enviarà a l'usuari el missatge "Els fitxers amb l'extensió indicada no existeixen", no farà res més, 
#i finalitzarà de manera normal. Si la carpeta indicada no existeix, llavors el programa enviarà a 
#l'usuari el missatge  "La carpeta indicada no existeix" , no farà res més, i finalitzarà de manera normal.

#Si escollim l'opció -r, llavors el programa esborrarà tots els arxius de la paperera 
#(però, no esborrarà la carpeta). Si escollim l'opció -r i la paperera no existeix, llavors 
#el programa enviarà a l'usuari el missatge "La paperera encara no existeix", no farà res més i 
#finalitzarà de manera normal.

#Un cop finalitzat el programa, s'eviarà al sistema el codi de retorn 0. El nom de l'arxiu de guió serà esb.sh.

case $1 in 
  -e) if (( $# != 3 )) 
      then
        echo "Nombre de paràmetres incorrecte"
        echo "L'opció -e necessita 3 paràmetres"
        echo "La primera opció és -e"
        echo "La segona opció és l'extensió dels fitxers a enviar a la paperera"
        echo "La tercera opció és el directori a on es troben els fitxers a enviar a la paperera"
        exit 2
      fi
      if [[ ! -d ~/paperera ]]
      then
        mkdir ~/paperera
      fi
      if [[ ! -d $3 ]]
      then
        echo "La carpeta no existeix"
      else
        if (( $(ls -A $3/*.$2 2> /dev/null | wc -l) != 0 ))
        # 2> /dev/null és per redireccionar avisos extres del bash.
        then
          mv $3/*.$2 ~/paperera
          echo "Els fitxers amb extensió $2 de la carpeta $3 s'han enviat a la paperera"
        else
          echo "Els fitxers amb l'extensió indicada no existeixen"
        fi
      fi		 
	 
  -r) if (( $# != 1 )) 
    then
      echo "Nombre de paràmetres incorrecte"
      exit 1
    fi
    if [[ ! -d ~/paperera ]]
    then
      echo "La paperera encara no existeix"
    else
      if (( $(ls -A ~/paperera | wc -l) != 0 ))
      #Si el numero de fitxers a la paperera es diferent a 0 doncs es buida.
      then
        #Buida la paperera però no esborra el directori paperera
        rm ~/paperera/* 
        echo "Paperera buida"
      else
        echo "La paperera ja està buida"
      fi
    fi
esac
exit 0
