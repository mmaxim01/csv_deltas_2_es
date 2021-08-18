#!/bin/bash
set -x
#cd to where new cluster data are gathered
clustername=$1
version=$2


rm -Rf ./$cluster/mpstat*
rm -Rf ./$cluster/*/mpstat*

###get folders to process
folders_to_process=$(ls -lrt . |grep -v "done" | grep "^d" | awk '{print $9}')

###check folder list in the cluster  if the folder hasn't  already been processed get list of folders representing VM Names
for i in $folders_to_process; do
   if [ ! -f $i/processed.ok ]; then
        vm_name=$(ls -lrt $folders_to_process | grep "^d" | awk '{print $9}')
#        echo $vm_name

###get csv fils in the cluster folder for each csv file in the cluster folder get the filepath and process the file then make it ready for processing
        cluster_stats=$(ls -lrt $i | grep csv | awk '{print $9}')
        for h in $cluster_stats; do
                file_h_path=$(echo "$i/$h")
                #echo " File to process is $file_h_path "
                sed "s/$/,$i/" $file_h_path > $file_h_path.done
                sed -i "1s/$i/clustername/" $file_h_path.done
		orig_file=$(echo $file_h_path | cut -d'/' -f2)
		sed "s/$/,$orig_file/g" $file_h_path.done > $file_h_path.done.1
		rm -Rf $file_h_path.done
		sed -i  "1s/$orig_file/srcfile/g" $file_h_path.done.1 
		sed -i  "1s/,000_/000_/g" $file_h_path.done.1
		sed -i  "1s/,500_/500_/g" $file_h_path.done.1
		mv $file_h_path.done.1 $file_h_path.done
		sed -i "1!b;s/ /_/g" $file_h_path.done
                for column in `cat $file_h_path.done  | head -1 |  tr -s ',' '\n' `; do
                       if [[ $column != @(Time|Timestamp|clustername|VMType|srcfile) ]]; then
                        python column_delta.py $file_h_path.done $column
			sed -i 's/\([^,]*\),\(.*\)/\2/' $file_h_path.done 
			rm $file_h_path.done_backup
                       fi
                done
		sed -i '2d' $file_h_path.done
		sed -i "s/^ *//" $file_h_path.done
                mv $file_h_path.done $file_h_path.ok
        done
###finished processing csv files in the cluster folder



###Processing for each VM Folder in the cluster folder
        for j in $vm_name; do
#               ls -lrt $i/$j
                #echo "Processing $i for VM type $j"
#Get csv list from VM Folders
                for k in `ls -lrt $i/$j | grep csv | awk '{print $9}'`; do
                        file_k_path=$(echo "$i/$j/$k")
                        #echo "inject $i in last column of file $k path is $file_k_path"
                        sed "s/$/,$i/" $file_k_path > $file_k_path.1
                        #echo "inject $j in last column for file $k path is $file_k_path"
                        sed "s/$/,$j/" $file_k_path.1 > $file_k_path.done
                        sed -i "1s/$i/clustername/" $file_k_path.done
                        sed -i "1s/$j/VMType/" $file_k_path.done
			sed -i "1s/Sample/Sample,/" $file_k_path.done
			sed -i "1s/Sample,,/Sample,/" $file_k_path.done
			sed -i '1!b;s/ /_/g' $file_k_path.done
                        rm $file_k_path.1
			orig_file2=$(echo $file_k_path | cut -d'/' -f3)
			sed -i "s/$/,$orig_file2/" $file_k_path.done
			sed -i "1s/$orig_file2/srcfile/" $file_k_path.done
                        sed -i  "1s/,000_/000_/g" $file_k_path.done
                        sed -i  "1s/,500_/500_/g" $file_k_path.done

###Calculate deltas for columns containing Pkts as string  in VM Folders
                        for column in `cat $file_k_path.done  | head -1 |  tr -s ',' '\n' `; do
                                if [[ $column == *"Pkts"* ]]; then
                                python column_delta.py $file_k_path.done $column 
				sed -i 's/\([^,]*\),\(.*\)/\2/' $file_k_path.done
                                rm $file_k_path.done_backup
                                fi
                        done
			sed -i '2d' $file_k_path.done
			sed -i "s/^ *//" $file_k_path.done
                        mv $file_k_path.done $file_k_path.ok
### finished for columns
                        #echo "Injection done for File $k in VMName $j on cluster $i"
                done
        #echo " Finished injections for VMName $j"
        done
        #echo " Finished csv injection for Cluster $i"
        #echo "This cluster has been processed" > $i/processed.ok
   fi
done

