import os, shutil, boto3, requests

project_name = raw_input("please enter the project name you want to delete: ")


sites_available_file = "/etc/nginx/sites-available/"+project_name+".devam.pro.conf"
sites_enabled_file = "/etc/nginx/sites-enabled/"+project_name+".devam.pro.conf"
project_dir = "/var/www/"+project_name+".devam.pro"


domain = project_name+".devam.pro."


if os.path.exists(sites_available_file) is True:
    os.remove(sites_available_file)
    print "Deleted File: " + sites_available_file

else:
    print "Not Exists File: " + sites_available_file

if os.path.exists(sites_enabled_file) is True:
    os.remove(sites_enabled_file)
    print "Deleted File:" + sites_enabled_file

else:
    print "Not Exists File: " + sites_enabled_file


if os.path.exists(project_dir) is True:
    shutil.rmtree(project_dir)
    print "Deleted Dir:" + project_dir

else:
    print "Not Exists Dir: " + project_dir

def get_public_ip():
    r = requests.get('http://icanhazip.com')
    return r.text.rstrip()

record_list = []
srv_ip = get_public_ip()
client = boto3.client('route53')
record_sets = client.list_resource_record_sets(HostedZoneId='Z3I2KNYQZHGO1Y')

for item in record_sets['ResourceRecordSets']:
    if item['Type'] == 'A':
        record_list.append(item['Name'])
    else:
        pass


if domain in record_list:
    print ("Domain Found in Route53. Deleting.... " + domain)

    deleter53record = client.change_resource_record_sets(
        HostedZoneId='Z3I2KNYQZHGO1Y',
        ChangeBatch= {
            'Changes': [
                {
                    'Action': 'DELETE',
                    'ResourceRecordSet': {
                        'Name': domain,
                        'Type': 'A',
                        'TTL': 300,
                        'ResourceRecords': [{'Value': srv_ip}]
                        # 'ResourceRecords': [{'Value': '54.82.251.210'}]
                    }
                }]
        }
    )

    print ("Record Deleted")


else:
    print ("Domain not Found in Route53. Nothing to Do ")


print("Deleted everything associated with Project : "+ project_name)

