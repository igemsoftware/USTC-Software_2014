from yaml import dump
import yaml

config_src = {
    "role": "collector",
    #"role": "server",

    "server": "monitor.biopano.org",
    "port": 27926,

    'json': "/srv/monitor-website/status.json",


    "id": 1,
    "location": "US South Center",
    "dc": "Microsoft Azure",
    "node": "1",
    ######
    #"id": 2,
    #"location": "PRC Anhui",
    #"dc": "USTCNIC",
    #"node": "1",
    ######
    #"id": 3,
    #"location": "PRC Beijing",
    #"dc": "Aliyun",
    #"node": "1",

}


def create_setting():
    config_file = open('config.yaml', 'w')
    dump(config_src, config_file)
    config_file.close()


create_setting()

