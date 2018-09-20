
import requests as req
from requests.auth import HTTPBasicAuth
import xml
from xml.etree import ElementTree
import time

############
# PLEASE POPULATE FOUR VARIABLES BELOW TO TEST
###########

client_environment = 'master-staging' 
api_user = ''
api_password = '' #NOTE: please be conscious when sharing this file as this password will allow API access
positions_file = 'Equities_Multilevel.zip' # XML or ZIP file


base_url = 'https://{}-api.fundapps.co'.format(client_environment)
auth=HTTPBasicAuth(api_user, api_password)
files = {'file': (positions_file, open(positions_file, 'rb'), 'text/XML')}
r = req.post('{}/v1/expost/check'.format(base_url), auth=auth, files=files)

if r.status_code == 202:
    print('File accepted.')
    xml_response = ElementTree.fromstring(r.content)
    result_tracking_url = xml_response[0].text
    r = req.get('{}{}'.format(base_url, result_tracking_url), auth=auth)
    print(r.status_code)
    while r.status_code == 202:
        print('Upload in progress. Waiting 20 seconds before checking again.')
        time.sleep(20)
        r = req.get('{}{}'.format(base_url, result_tracking_url), auth=auth)
        
    print('Upload complete. Result XML:')
    print(r.text)
else:
    print('Unexpected response from FundApps API. HTTP Status code:{}, reason:{}'.format(r.status_code, r.reason))