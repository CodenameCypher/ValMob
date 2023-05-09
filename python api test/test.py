import json
import requests

url = "https://vlrggapi.vercel.app/match/results"

response = requests.get(url)

json  = json.loads(response.text)

for i in json['data']['segments']:
    # print(i.keys())
    print(i['team1'] + " " + i['score1'] + " V/S " + i['score2'] + " " + i['team2'] + " - " + i['time_completed'])