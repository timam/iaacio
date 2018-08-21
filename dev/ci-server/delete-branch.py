import os, shutil

branch_name = raw_input("please enter the branch name you want to delete: ")

sites_available_file = "/etc/nginx/sites-available/swin-"+branch_name+"devam.pro.conf"
sites_enabled_file = "/etc/nginx/sites-enabled/swin-"+branch_name+"devam.pro.conf"
project_dir = "/var/www/swin-"+branch_name+".devam.pro"
domain = "swin-"+branch_name+".devam.pro."


os.delete(sites_available_file)
os.delete(sites_enabled_file)
shutil.rmtree(project_dir)

deleter53record = client.change_resource_record_sets(
    HostedZoneId='Z3I2KNYQZHGO1Y',
    ChangeBatch= {
        'Changes': [
            {
                'Action': 'delete',
                'ResourceRecordSet': {
                    'Name': domain,
                    'Type': 'A',
                    'TTL': 300,
                    'ResourceRecords': [{'Value': srv_ip}]
                }
            }]
    }
)