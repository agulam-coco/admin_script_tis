import sys
import json
import pprint

json = json.loads(sys.argv[1])   
json = json['blockdevices']
4
for disk in json:
    
    if disk["type"] == 'disk':

        #every partition in the disk
        for child in disk["children"]:
            #get the child with the size in gigabytes 
            size = child['size'][-1] 

            if child['fstype'] == 'ntfs' and child['label'] == None and size == "G" :
                print(child['name'])
                
        