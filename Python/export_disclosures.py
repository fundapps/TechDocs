from requests_html import HTMLSession
from datetime import date, timedelta
import sys

s = HTMLSession()

def get_request_verification_token(url):
    r = s.get(url)
    return r.html.xpath('//input[@name="__RequestVerificationToken"]/@value')[0]


def login(url, email, password):
    login_url = f'{url}/login'
    token = get_request_verification_token(login_url)
    data = {'__RequestVerificationToken': token, 'EmailAddress': email, 'Password': password}
    r = s.post(url=login_url, data=data)


def get_disclosures(url, email, password, days):
    today = date.today()
    days_ago = today + timedelta(-days)
    login(url, email, password)
    r = s.get(f'{url}/api/reporting/disclosures-detailed/export?startDate={days_ago}&endDate={today}')
    with open('disclosures.csv', 'w') as output :
        output.write(r.text)


if __name__ == "__main__":
    get_disclosures(f'https://{sys.argv[1]}.fundapps.co', sys.argv[2], sys.argv[3], 31)
