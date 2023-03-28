import requests
import json

url1 = "https://valorant-esports.p.rapidapi.com/standings/105590700081272455%252C105796322462986721%252C106027215534896262%252C107766270575498259"
url2 = "https://valorant-esports.p.rapidapi.com/event/106994073510344698"
url3 = "https://valorant-esports.p.rapidapi.com/vods"
url4 = "https://valorant-esports.p.rapidapi.com/tournaments"
url5 = "https://valorant-esports.p.rapidapi.com/live"
url6 = "https://valorant-esports.p.rapidapi.com/schedule"
url7 = "https://valorant-esports.p.rapidapi.com/leagues"

headers = {
	"X-RapidAPI-Key": "5922d83798msh327ff1179b7a77fp1b4486jsnfdb138ba815c",
	"X-RapidAPI-Host": "valorant-esports.p.rapidapi.com"
}

response1 = requests.request("GET", url1, headers=headers)
response2 = requests.request("GET", url2, headers=headers)
response3 = requests.request("GET", url3, headers=headers)
response4 = requests.request("GET", url4, headers=headers)
response5 = requests.request("GET", url5, headers=headers)
response6 = requests.request("GET", url6, headers=headers)
response7 = requests.request("GET", url7, headers=headers)

with open('output1.txt','w') as f:
    f.write(response1.text)
with open('output2.txt','w') as f:
    f.write(response2.text)
with open('output3.txt','w') as f:
    f.write(response3.text)
with open('output4.txt','w') as f:
    f.write(response4.text)
with open('output5.txt','w') as f:
    f.write(response5.text)
with open('output6.txt','w') as f:
    f.write(response6.text)
with open('output7.txt','w') as f:
    f.write(response7.text)