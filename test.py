from os import path
import json
import requests
base = "http://0.0.0.0:8080/api/"
endpoint = input("endpoint: ")
raw_json = input("body: ")
fpath = path.join(base, endpoint)
res = requests.post(url=fpath, json=json.loads(raw_json))
print(res.json())