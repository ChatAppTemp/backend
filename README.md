# backend

<img height=24 alt="GitHub Workflow Status" src="https://img.shields.io/github/workflow/status/ChatAppTemp/backend/CI?style=for-the-badge"></img>
<img height=24 alt="Dependencies" src="https://img.shields.io/librariesio/github/ChatAppTemp/backend?style=for-the-badge"></img>
<img height=24 alt="Lines of code" src="https://img.shields.io/tokei/lines/github/ChatAppTemp/backend?style=for-the-badge"></img>

Backend for chat app

## run
to run the server you simply install `dmd` and `dub` and then run the following command
```
dub run
```

## config example
heres an example of how your config may look like
```yml
hostname: http://localhost:5000/

host_ip: 0.0.0.0
host_port: 5000

socket_host: 127.0.0.1
socket_port: 5555

mongo_connection: 127.0.0.1
```
