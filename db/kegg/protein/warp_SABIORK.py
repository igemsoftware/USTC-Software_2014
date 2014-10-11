__author__ = 'feiyicheng'

import urllib2
import multiprocessing
#import time
#import logging
import os

#base url

baseurl = "http://rest.kegg.jp/get/ko:K"

#warp function
def warp(baseurl, begin, end):
    '''warp data
    '''
    for i in range(begin, end + 1):
        url = baseurl + str(i//10000)+ str(i//1000-i//10000*10)+ str(i//100-i//1000*10)+ str(i//10-i//100*10)+ str(i-i//10*10)
        #print url
        try:
            content = urllib2.urlopen(url).read()
        except urllib2.HTTPError, e:
            print 'The server couldn\'t fulfill the request.', 'Error code: ', e.code
            #logging.debug('file ' + str(i) + ' Error code: ' + e.code)
            continue

        except urllib2.URLError, e:
            print 'We failed to reach a server.', 'Reason: ', e.reason
            #logging.debug('file ' + str(i) + ' Reason: ' + e.reason)
            continue
        if os.path.isfile(str(i)+'.xml'):
            continue
        fp = open(str(i) + ".xml", "w")
        if fp:
            fp.write(content)
            fp.close()
            print("file " + str(i) + "is downloaded successfully!")

        else:
            #logging.debug('failed to open the file' + str(i))
            print("file " + str(i) + 'failed to open')

def multiproc(num, begin, end, jobs):
    step = (end-begin)//num
    for j in xrange(num):
         work = multiprocessing.Process(name='worker' + str(j+1),target=warp,args=(baseurl,begin+j*step,begin+(j+1)*step))
         jobs.append(work)
         print 'job ' + str(j+1) + ' started!'

def startwork(jobs):
    for work in jobs: work.start()
    for work in jobs: work.join()



if __name__ == '__main__':
    jobs = []
    multiproc(10,0,18450,jobs)
    startwork(jobs)

