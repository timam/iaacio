import boto3, requests

def get_public_ip():
    r = requests.get('http://icanhazip.com')
    return r.text.rstrip()

domain = "test.timam.io."
srv_ip = get_public_ip()


record_list = []

client = boto3.client('route53')

record_sets = client.list_resource_record_sets(HostedZoneId='Z3I2KNYQZHGO1Y')

for item in record_sets['ResourceRecordSets']:
    if item['Type'] == 'A':
        record_list.append(item['Name'])
    else:
        pass



if domain in record_list:
    print("Record already in Route53, Nothing to do")
else:
    print("Record Not Found in Route53! Adding...")


    response = client.change_resource_record_sets(
        HostedZoneId='Z3I2KNYQZHGO1Y',
        ChangeBatch= {
            'Changes': [
                {
                    'Action': 'CREATE',
                    'ResourceRecordSet': {
                        'Name': domain,
                        'Type': 'A',
                        'TTL': 300,
                        'ResourceRecords': [{'Value': srv_ip}]
                    }
                }]
        })

