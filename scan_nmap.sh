#!/bin/bash
function ftp()
{
	if [ "$3" == "ftp" ]
	then
		echo $1
	fi
}

function ssh()
{
	if [ "$3" == "ssh" ]
	then
		echo "$1 $2 $3 $4"
	fi
}
function samba()
{
	if [ "$3" == "netbios-ssn" ]
	then
		echo "$1 $2 $3 $4"
	fi
}
function http()
{
	if [ "$3" == "http" ]
	then
		echo "$1 $2 $3 $4"
	fi
}

rcp()
{
	if [[ "$3" == "*rpc*" ]]
	then
		echo "$1 $2 $3 $4"
	fi
}

clear
lista_servicios=(ftp ssh samba http rcp)
ip=$1
ruta_drop_files=$2
#echo -n "Dime una ip "
#read ip
#nmap -T5 -sC -sV $ip > nmap.txt

if [ -f ports.txt ]
then
	rm ports.txt
fi
if [ -f nmap.txt ]
then
	rm nmap.txt
fi
touch $ruta_drop_files/ports.txt $ruta_drop_files/nmap.txt

#Captura de puertos
#Si se te ocurre un metodo mas optimo que es lo mas probable puedes contactar conmigo
while read line
do
	echo $line >> nmap.txt
	case $line in
		[0-9]/tcp*)
			echo $line >> ports.txt;;
		[0-9][0-9]/tcp*)
			echo $line >> ports.txt;;
		[0-9][0-9]/tcp*)
			echo $line >> ports.txt;;
		[0-9][0-9][0-9]/tcp*)
			echo $line >> ports.txt;;
		[0-9][0-9][0-9][0-9]/tcp* )
			echo $line >> ports.txt;;
		[0-9][0-9][0-9][0-9][0-9]/tcp* )
			echo $line >> ports.txt;;
	esac
done <<< $(nmap -sC -T5 -sV $ip)

while read line
do
	puerto=$(echo $line | cut -d ' ' -f 1)
	estado=$(echo $line | cut -d ' ' -f 2)
	servicio=$(echo $line | cut -d ' ' -f 3)
	version=$(echo $line | cut -d ' ' -f 4-9)
	for i in ${lista_servicios[@]}
	do
		$i $puerto $estado $servicio $version
	done

done < ports.txt
