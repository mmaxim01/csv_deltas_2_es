# csv_deltas_2_es
 <p>
 edit .config with details for your elasticsearch instance
 </p>
 <p>
 csv_source="/path/to/upload/$customer"  where  $customer is the folder where the source tar.gz file resides 
 </p>
 <p>
 inject_all_csv.sh will generate column deltas ( a1-a2,a2-a3,a3-a4 and b1-b2,b2-b3 etc ) 
 </p>
 <p>
 in the clustername folder deltas are calculated by exclusion in the if statement " if [[ $column != @(Time|Timestamp|clustername|VMType|srcfile) ]] ", add new excluded columns here
  </p>
 <p>
 in the clustername/VMType/ folder deltas are calculated by inclusion in the if statement "if [[ $column == *"Pkts"* ]];", add new excluded columns here 
  </p>
 <p>
 mappings.json is the file that elasticsearch_loader  will call in order to inject the csv columns with the correct data types 
 </p>
 <p>
 Usage : ./process.sh CLUSTERNAME.tar.gz VERSION CUSTOMERNAME
  </p>
 <p>
         ./process.sh MD12902.tar.gz 11-2-1 vaxxbox
  </p>


