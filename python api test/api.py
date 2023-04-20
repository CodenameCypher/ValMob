import requests
import json

url1 = "https://flagcdn.com/en/codes.json"

response1 = requests.request("GET", url1)
d = json.loads(response1.text)

newDict = {}

for key, value in d.items():
    newDict[value] = key

with open('output1.txt','w') as f:
    f.write(str(newDict))