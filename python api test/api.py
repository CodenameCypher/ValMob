import requests
import json

url1 = "https://victorious-bat-gloves.cyclic.app/api/matches/upcoming"

response1 = requests.request("GET", url1)
d = json.loads(response1.text)

print(d)