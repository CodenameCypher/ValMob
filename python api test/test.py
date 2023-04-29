import requests
from bs4 import BeautifulSoup as bs

def scarpeInfo(url):
    response = bs(requests.get(url).text, "html.parser")

    list1 = response.find_all('div', {'class':"text-of"})
    list2 = response.find_all('div', {'class':"ge-text-light"})
    
    for i in list1:
        print(i)

    print("----------------------------------------------------")


scarpeInfo("https://www.vlr.gg/184482/t1-vs-detonation-focusme-champions-tour-2023-pacific-league-w6")

