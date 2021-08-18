#!/bin/bash
#set -x
#title          :crnew.sh
#description
#author         :Marian Maxim
#date           :2021-08-18
#version: 1     :1.3.(3)-release
clustername=$1
version=$2
customer=$3 
. .config
EXECDATE=$(date +%s)

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo 'one or more variables are undefined'
  echo "USAGE : ./SCRIPTNAME CLUSTER_NAME VERVERSION CUSTOMER"
  exit 1
fi
mkdir /tmp/$version.$customer.$EXECDATE/ 
cp * /tmp/$version.$customer.$EXECDATE/ 
mv /tmp/$version.$customer.$EXECDATE ./$version.$customer.$EXECDATE
cd ./$version.$customer.$EXECDATE/
mv $csv_source/$clustername.tar.gz . 
tar -xvf $clustername.tar.gz   
sleep 10 
#echo "Finished extraction for clustername $clustername  "  
rm -Rf ./$clustername/*/mpstat* 
rm -Rf ./$clustername/*mpstat*
./inject_all_csv.sh 



#echo "injection finished, generated cs.ok files "
DATE_INDEX=$(date +%m-%d-%Y)
#echo "pushing data to elasticsearch"

sleep 5
elasticsearch_loader --es-host https://$es_host:9200 --index-settings-file ./mappings.json --use-ssl --ca-certs "$es_cert" --http-auth "$es_user:$es_pass" --index $es_index-$DATE_INDEX csv ./$clustername/*.csv.ok && elasticsearch_loader --es-host https://$es_host:9200 --index-settings-file ./mappings.json --use-ssl --ca-certs "/$es_cert" --http-auth "$es_user:$es_pass" --index $es_index-$DATE_INDEX csv ./$clustername/*/*.csv.ok

cd ../
mv ./$version.$customer.$EXECDATE ../archive/
