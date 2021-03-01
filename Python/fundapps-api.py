import requests as req
from requests.auth import HTTPBasicAuth
import xml
from xml.etree import ElementTree
import time

############
# PLEASE POPULATE FOUR VARIABLES BELOW TO TEST, PLEASE USE PYTHON 3.6 OR ABOVE
###########

client_environment  = '' 
api_user            = ''
api_password        = '' # NOTE: please be conscious when sharing this file as this password will allow API access
positions_file      = '' # XML or ZIP file

###########

base_url = f'https://{client_environment}-api.fundapps.co'
auth = HTTPBasicAuth(api_user, api_password)
files = {'file': (positions_file, open(positions_file, 'rb'), 'text/XML')}
r = req.post(f'{base_url}/v1/expost/check', auth=auth, files=files)

if r.status_code == 202:
    print('File accepted.')
    xml_response = ElementTree.fromstring(r.content)
    result_tracking_url = f'{base_url}{xml_response[0].text}'

    r = req.get(result_tracking_url, auth=auth)
    
    while r.status_code == 202:
        print('Upload in progress. Waiting 20 seconds before checking again.')
        time.sleep(20)
        r = req.get(result_tracking_url, auth=auth)
        
    print('Upload complete. Result XML:\n', r.text)
else:
    print(f'Unexpected error response from FundApps API. HTTP Status code:{r.status_code}, reason:{r.reason}')
