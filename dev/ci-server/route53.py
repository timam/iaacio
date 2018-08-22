import os, boto3, requests
gimme_origin = os.environ['GIT_BRANCH']
branch = gimme_origin.replace('origin/', '')

project_dir = "/var/www/swin-"+branch+".devam.pro"

if os.path.exists(project_dir) is True:
    print("Record Already Exists")
    pass

else:

    def get_public_ip():
        r = requests.get('http://icanhazip.com')
        return r.text.rstrip()

    domain = "swin-"+branch+".devam.pro."
    print(domain)

    srv_ip = get_public_ip()

    record_list = []

    client = boto3.client('route53')

    record_sets = client.list_resource_record_sets(HostedZoneId='Z3PSQFN2TU2VPE')

    for item in record_sets['ResourceRecordSets']:
        if item['Type'] == 'A':
            record_list.append(item['Name'])
        else:
            pass

    if domain in record_list:
        print("Record already in Route53, Nothing to do")
    else:
        print("Record Not Found in Route53! Adding...")

        response = client.change_resource_record_sets( HostedZoneId = 'Z3PSQFN2TU2VPE',
                                                       ChangeBatch = {
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