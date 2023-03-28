import json
from datetime import datetime

# # with open("python api test/output1.txt",'r') as f: #standings
# #     d = json.loads(f.readline())
#     print(d['data']['standings'][0].keys())

# # with open("python api test/output2.txt",'r') as f: #event detail
# #     d = json.loads(f.readline())
#     print(d['data']['event'].keys())

# with open("python api test/output4.txt",'r') as f: #tournament
#     d = json.loads(f.readline())
#     print(d['data']['leagues'][0].keys())

# with open("python api test/output5.txt",'r') as f: #live
#     d = json.loads(f.readline())
#     print(d['data']['schedule']['events'][1].keys())

with open("python api test/output6.txt",'r') as f: #schedule
    d = json.loads(f.readline())
    print(d['data']['schedule']['events'][0].keys())
    print(len(d['data']['schedule']['events']),'matches')
    for i in d['data']['schedule']['events']:
        print(i.keys())
        print(datetime.strptime(i['startTime'],"%Y-%m-%dT%H:%M:%SZ"),i['match']['teams'][0]['name'],"V/S",i['match']['teams'][1]['name'],'in',i['tournament']['split']['name'],i['tournament']['season']['name'])