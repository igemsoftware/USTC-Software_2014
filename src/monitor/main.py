import datetime
from config import config
from status import load_stat
import json
import udp_socket
import time


dataTS = {}
dataORI = {}
dataPOST = {}
thread_flag = True

def getInfo():
    load = load_stat()
    load['status'] = 'up'
    load['id'] = config['id']
    load['location'] = config['location']
    load['database_center'] = config['dc']
    load['node'] = config['node']
    #load['time'] = time.strftime("%Y/%M/%d-%H:%M:%S", time.localtime())
    load['time'] = time.time()
    return json.dumps(load)


def monitor():
    while True:
        udp_socket.send(getInfo())
        time.sleep(1)


def check():
    global dataTS, dataORI, dataPOST
    for (i, data) in dataTS.items():
        last_update_time_ori = data['time']
        last_update_time = datetime.datetime.fromtimestamp(last_update_time_ori)
        now_time = datetime.datetime.fromtimestamp(time.time())

        if (now_time - last_update_time).seconds >= 30:
            dataORI[data['id']]['status'] = "down"
        else:
            if not dataORI.has_key(data['id']):
                dataORI[data['id']] = {}
            if not dataORI[data['id']].has_key("history"):
               dataORI[data['id']]['history'] = {}
            history_old = dataORI[data['id']]['history']
            dataORI[data['id']] = data
            dataORI[data['id']]['history'] = history_old
            dataORI[data['id']]['history'][last_update_time.hour % 24] = {}
            dataORI[data['id']]['history'][last_update_time.hour % 24]['load_15'] = data['lavg_15']
            dataORI[data['id']]['history'][last_update_time.hour % 24]['time'] = int(data['time']*1000)
    dataPOST = json.loads(json.dumps(dataORI))
    #print dataPOST
    for (i, data) in dataORI.items():

        dataPOST[str(i)]['history'] = {}
        #print his_bak
        for (j, history) in data['history'].items():
            #print history
            dataPOST[str(i)]['history'][history['time']] = float(history['load_15'])
        dataPOST[str(i)]['history'] = sorted(dataPOST[str(i)]['history'].iteritems(), key=lambda d:d[0])
        #print dataORI[i]
        #print ""


def receiver():
    global dataTS
    while True:
        data_str = udp_socket.recv()
        #print(data_str)
        data = json.loads(data_str)
        dataTS[data['id']] = data.copy()
        check()
        fileHandle = open(config['json'], 'w')
        fileHandle.write("data2 = " + json.dumps(dataPOST))
        fileHandle.close()
        # print 'dataTS:', json.dumps(dataTS)


if __name__ == "__main__":
    if config['role'] == 'collector':
        monitor()
    elif config['role'] == 'server':
        udp_socket.init_recv()
        receiver()
