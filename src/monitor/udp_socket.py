import socket
from config import config



s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def init_recv():
    try:
        s.bind((config['server'], config['port']))
    except:
        pass


def recv():
    data, address = s.recvfrom(config['port'])
    if not data:
        pass
    return data


def send(data):
    s.sendto(data, (config['server'], config['port']))
