# csv_deltas_2_es
 edit .config with details for your elasticsearch instance
 csv_source="/path/to/upload/$customer"
 $customer is the folder where the source tar.gz file resides 
 inject_all_csv.sh will generate column deltas ( a1-a2,a2-a3,a3-a4 and b1-b2,b2-b3 etc ) 
 in the clustername folder deltas are calculated by exclusion in the if statement " if [[ $column != @(Time|Timestamp|clustername|VMType|srcfile) ]] ", add new excluded columns here
 in the clustername/VMType/ folder deltas are calculated by inclusion in the if statement "if [[ $column == *"Pkts"* ]];", add new excluded columns here 
 mappings.json is the file that elasticsearch_loader  will call in order to inject the csv columns with the correct data types 

 Usage : ./process.sh CLUSTERNAME.tar.gz VERSION CUSTOMERNAME
         ./process.sh MD12902.tar.gz 11-2-1 vaxxbox


