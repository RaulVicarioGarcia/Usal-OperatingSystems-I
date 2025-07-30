# © 2024 | Raul Vicario García | Salamanca

# La primera linea se conoce como "hasbang" y se configura para indicar al sistema el interprete que se debe de usar como shell. En mi caso es bash.

#!/usr/bin/bash

# ASCII Art del shell script. https://patorjk.com/software/taag/ (Libre uso) Lo pongo en función para evitar cargar el flujo principal, lo mismo con el mostrar ayuda.

  mostrar_titulo() {

  echo -e "\n    ________________________________________________________________________________________ "
  echo "   |  ____________________________________________________________________________________  |"
  echo "   | |                                                                                    | |"
  echo "   | |        ___      ___     _____     ___      ___               ___     _  _          | |"
  echo "   | |       / __|    |_ _|   |_   _|   /   \    / __|             / __|   | || |         | |"
  echo "   | |      | (__      | |      | |     | - |    \__ \      _      \__ \   | __ |         | |"
  echo "   | |       \___|    |___|     |_|     |_|_|    |___/     (_)     |___/   |_||_|         | |"
  echo "   | |                                                                                    | |"
  echo "   | |____________________________________________________________________________________| |"
  echo -e "   |________________________________________________________________________________________|\n"

  echo -e "\nBienvenido a citas.sh, un shell script con la capacidad de gestionar citas de centros sanitarios.\n"
	 
  echo -e "Debes introducir argumentos. Teclea -h para mostrar ayuda.\n"

  }
 
  mostrar_ayuda() {
               
           echo -e "\n   ☆	-h      		Muestra ayuda de uso del programa."
    	   echo "   ☆	-f <pacientes.txt>   	Muestra el contenido completo del fichero de texto en el que se almacenan los datos."
    	   echo "   ☆	-a      		Añade una cita identificando la hora de inicio, de finalización (-fi), el nombre del paciente y la especialidad (-e)."
    	   echo "   ☆	-d <fecha>    		Muestra todas las citas que coincidan en un mismo día."
  	   echo "   ☆	-id <id>     		Muestra una cita según su identificador personal."
   	   echo "   ☆	-n <nombre>       	Muestra una cita según nombre del paciente."
   	   echo -e "   ☆	-i <hora>  		Muestra todas las citas que coincidan en su hora de inicio.\n"
   	         
           exit 0
           
 }

# Introduzco un nombre al archivo de texto donde guardan las citas.

  pacientes="pacientes.txt"

# Introducción del script.
# Busco al menos un argumento. Si no se introduce un argumento sale el mensaje de mostrar ayuda y cierro el programa.

  if [ $# -eq 0 ]

	then
	
	mostrar_titulo
	 
  exit 1
    
  fi


# Procesamiento de argumentos, con el bucle while que continúa mientras haya argumentos.

  while [[ $# -gt 0 ]]

	do

		case "$1" in
    
# Argumento de ayuda. Copio y pego los argumentos de la tabla del enunciado, le añado pequeñas indicaciones y detalles.
    
 -h)

	mostrar_ayuda
                 
        exit 0 ;;
        
# Argumento que se encarga de mostrar el txt.

 -f)

  if [ -z "$2" ] # En el caso de que no introduzcas el nombre del archivo junto a "-f" se ejecuta y sale.
            	
	then
               
		echo -e "\nNo has pasado el nombre del archivo de texto despues del argumento... Se ha producido un error y el script se ha cerrado.\n" >&2
               
                exit 1
                
  elif [ ! -f "$2" ] # En el caso de que no se encuentren coincidencias se ejecuta y sale.
            		
        then
            		
                echo -e "\nEl nombre del archivo que has introducido no es el indicado... Se ha producido un error y el script se ha cerrado.\n" >&2
                
                exit 1
                
  else
        
        	echo -e "\n----------- ☆ ARCHIVO DE TEXTO ☆ ------------\n"   
        
       		cat "$2" # Orden vista en la tercera sesión de prácticas, redirecciona salida.
                	
  fi
            
  shift 2 ;; # Orden vista en la cuarta sesión de prácticas, ignora los dos primeros argumentos procesados y permite continuar.


# Argumento que se encarga de mostrar la cita según el nombre del paciente. 

 -n)
         
  if [ -z "$2" ] # En el caso de que no introduzcas un nombre junto a "-n" se ejecuta y sale. 
	    	 
	then
	    		
	   	echo -e "\nNo has pasado el nombre identificador despues del argumento... Se ha producido un error y el script se ha cerrado.\n" >&2
               
                exit 1
                
  else	
              	
            	identificador="$2"
	   
	   	temp=$(grep -i -n "PACIENTE: $identificador" "$pacientes")

		# Uso el filtro grep de la tercera sesión, ignora diferencias entre mayus y minus.
	   	
	   	echo " "
	   	 
  if [ -z "$temp" ]
	   	 
	then
                    
                echo -e "No has pasado el nombre identificador correcto o bien este no se ha encontrado... Se ha producido un error y el script se ha cerrado.\n" >&2
                
  else
       		echo -e "------------- ☆ COINDICENCIAS ☆ --------------\n"
       		
		echo "$temp" | while IFS=":" read -r lineas c_pacientes # La orden read de la cuarta sesión, cada variable contiene un valor antes de : y después.

	do	  		     # Con IFS ponemos el delimitador. https://unix.stackexchange.com/questions/16192/what-is-the-ifs-variable
        
	        head -n $((lineas + 5)) "$pacientes" | tail -6 # Ir jugando con las líneas, en cada opción es distinto.
          
          echo ""

       done
                
  fi
            
  fi
            
  shift 2 ;;
         
# Argumento que se encarga de mostrar la cita según la hora de inicio. 

 -i)

  if [ -z "$2" ] 
	    	 
	then
	    		
		echo -e "\nNo has pasado la hora de inicio despues del argumento... Se ha producido un error y el script se ha cerrado.\n" >&2
               
                exit 1
                
  else	
            	
            	identificador2="$2"
	   
	   	echo ""
	   
	   	temp2=$(grep -i -n "HORA_INICIAL: $identificador2" "$pacientes")
	   	
	   	# Vuelvo a usar el filtro grep de la tercera sesión, ahora además busca según "HORA_INICIAL".
	   	 
  if [ -z "$temp2" ]
	   	 
	then
	   	 
                echo -e "No has pasado la hora de inicio correcta o bien esta no se ha encontrado... Se ha producido un error y el script se ha cerrado.\n" >&2
       		
  else
       		echo -e "------------- ☆ COINDICENCIAS ☆ --------------\n"

 		echo "$temp2" | while IFS=":" read -r lineas2 c_pacientes2

	do

  if (( lineas2 > 3 ))
  
        then

                head -n $((lineas2 + 3)) "$pacientes" | tail -6

        else

       	        head -n 6 "$pacientes"

        fi

        echo ""

        done
                
  fi
            
  fi
            
  shift 2 ;;
        
# Argumento que se encarga de mostrar la cita según su id personal.

 -id)

  if [ -z "$2" ] 
	    	 
	then
	    		
	   	echo -e "\nNo has pasado el id personal despues del argumento... Se ha producido un error y el script se ha cerrado.\n" >&2
               
                exit 1
                
 else	
            	
            	identificador3="$2"
	   
	   	echo ""
	   
	   	temp3=$(grep -i -n "ID: $identificador3" "$pacientes")
	   	 
  if [ -z "$temp3" ]
	   	 
	then
	   	 
                echo -e "No has pasado el id personal correcto o bien este no se ha encontrado... Se ha producido un error y el script se ha cerrado.\n" >&2
       		
  else
       		echo -e "------------- ☆ COINDICENCIAS ☆ --------------\n"
       		
		echo "$temp3" | while IFS=":" read -r lineas3 c_pacientes3
	
	do
                
		head -n "$lineas3" "$pacientes" | tail -6

    echo ""
            
	done
                
  fi
            
  fi
            
  shift 2 ;;            

# Argumento que se encarga de mostrar la cita según su fecha.

 -d)

  if [ -z "$2" ] 
	    	 
	then
	    		
	   	echo -e "\nNo has pasado la fecha despues del argumento... Se ha producido un error y el script se ha cerrado.\n" >&2
               
                exit 1
                
  else	
            	
            	identificador4="$2"
	   
	   	echo ""
	   
	   	temp4=$(grep -i -n "DIA: $identificador4" "$pacientes")
	   	 
  if [ -z "$temp4" ]
	   	 
	then
	   	 
                echo -e "No has pasado la fecha correcta o bien esta no se ha encontrado... Se ha producido un error y el script se ha cerrado.\n" >&2
       		
  else
  
         	echo -e "------------- ☆ COINDICENCIAS ☆ --------------\n"
       		
		      echo "$temp4" | while IFS=":" read -r lineas4 c_pacientes4
	 
	do
                
		head -n $((lineas4 + 1)) "$pacientes" | tail -6

    echo ""

	done
                
  fi
            
  fi
            
  shift 2  ;;            
        
# Argumento que se encarga de añadir una cita pasandole hora de inicio, de finalización y nombre.
 
 -a)
	             
  p_nombre="" # Creo las variables y las inicio a nada, si nos las inicializo así pueden conseguir valores basura y estropear el código.
  hora_final=""
  hora_inicio=""
  especialidad="" # Especialidad indicada en ampliación.
	    
  while [[ $# -gt 0 ]]
	    
	do
	    
		case "$1" in
	    		
	    		-a) shift ;; # ¡IMPORTANTISIMO! debe reconocer el argumento "-a" pero lo debe ignorar puesto que no hay que asignarle nada.
	    		
	    		-n) p_nombre="$2";
	    		
	    			shift 2 ;;
	    			
	    		-fi) hora_final="$2";	
	    		
	    			shift 2 ;;
	    		
	    		-i) hora_inicio="$2";
	    		
	    			shift 2 ;;
	    			
	    		-e) especialidad="$2";
	    		
	    			shift 2 ;;
	    			
	    		-f) pacientes="$2";
	    		
	    			shift 2 ;;
	    			
	    		*) break ;; # En el caso de que se pase cualquier otra cosa por teclado.
	    			
	esac
	    
  done

# Esto es un debug que puse porque no me estaba cogiendo los argumentos el programa y me dí cuenta del fallo.

# echo "Nombre del Paciente: $p_nombre"
# echo "Hora de Inicio: $hora_inicio"
# echo "Hora de Finalización: $hora_final"
# echo "Archivo de Pacientes: $pacientes"
  
  if [ -z "$p_nombre" ] || [ -z "$hora_inicio" ] || [ -z "$hora_final" ]
		
	then
	
		echo -e "\nNo has pasado por teclado los datos necesarios... Se ha producido un error y el script se ha cerrado.\n" >&2
		   				 
    		exit 1
    		
  fi 
  
  if ! [[ "$hora_inicio" =~ ^[0-9]+$ ]] || ! [[ "$hora_final" =~ ^[0-9]+$ ]]

# La expresión usada para la validación de enteros: https://unix.stackexchange.com/questions/445227/meaning-of-0-9, pero básicamente comprueba 0-9 que sea cualquier número, + 1 o más y el =~ de comparación   

	then
    
    		echo -e "\nLas horas introducidas deben ser cantidades enteras y positivas... Se ha producido un error y el script se ha cerrado.\n" >&2
    
    		exit 1
    
  fi
			
  if [ "$hora_inicio" -lt 7 ] || [ "$hora_inicio" -gt 21 ] || [ "$hora_final" -lt 7 ] || [ "$hora_final" -gt 21 ]      
               
        then
               
 		echo -e "\nLas horas introducidas obligatoriamente deben ser enteros entre 7 y 21... Se ha producido un error y el script se ha cerrado.\n" >&2
 		
		exit 1
              			  
  fi
  
  if [ "$hora_final" -lt "$hora_inicio" ] # Esta ampliación la introduzco yo, obviamente la hora final no puede darse antes que la de inicio.
  	
  	then
  		
  		echo -e "\nLa hora de inicio no puede darse antes que la hora final... Se ha producido un error y el script se ha cerrado.\n" >&2
 		
		exit 1
              			  
  fi 	

  if grep "PACIENTE: $p_nombre" "$pacientes" >/dev/null
    
    	then
    
  if grep "ESPECIALIDAD: $especialidad" "$pacientes" >/dev/null

	then
        
  if grep "HORA_INICIAL: $hora_inicio" "$pacientes" >/dev/null

	then
            
     		echo -e "No se permiten duplicados... Se ha producido un error y el script se ha cerrado.\n" >&2
      
           	exit 1
      
fi
    
fi

fi
	
            {
            
                echo "PACIENTE: $p_nombre"
                
                echo "ESPECIALIDAD: $especialidad" # Especialidad de la visita.
                
                echo "HORA_INICIAL: $hora_inicio"
                
                echo "HORA_FINAL: $hora_final"
                
                echo ""
                
            } | tee -a "$pacientes" >/dev/null # El agujero negro de la segunda sesión y con el tee de la tercera sesión que nos viene genial y cumple su función al dedillo. 

                echo -e "Cargando..." 
            
                echo -e "\nLa cita ha sido añadida correctamente y sin errores.\n" 
            
 ;;
		                
# Argumento inválido. Cuando el argumento pasado es erróneo. Redireccionamos error con >&2 para que salga por la salida de errores. 

*)
     
            echo -e "\nEl argumento introducido no existe entre las opciones del shell script... Se ha producido un error y el script se ha cerrado.\n">&2
            
            exit 1
            
            ;;
            
  esac
    
  done
