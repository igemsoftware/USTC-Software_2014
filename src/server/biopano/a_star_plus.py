from Queue import PriorityQueue
from Queue import Queue
from django.shortcuts import HttpResponse
from pymongo import *
from datetime import *
import bson
import json


def MakeArray(n):
	return [0 for i in range(n+1)]

#class state is aimed at A*-state
class state:
	def __init__(self, f, g, now, pre):
		self.f = f
		self.g = g
		self.now = now
		self.pre = pre
	def __lt__(self, x):
		if (x.f == self.f):
			return x.g>self.g
		return x.f>self.f

db = MongoClient()['igemdata_new']

q = Queue()
pq = PriorityQueue()
inf = 100000000
#edge ww

#edge = MakeArray(m)
#edge2 = MakeArray(m)
#next = MakeArray(m)
#next2 = MakeArray(m)
edge = []
edge2 = []
next = []
next2 = []

#ww = MakeArray(m)
#point = MakeArray(n)
#point2 = MakeArray(n)
#pre = [[] for i in range(n+1)]
#dis = [inf for i in range(n+1)]
ww = []
point = []
point2 = []
pre = []
dis = []


def AddEdge(u,v,w,ee):
	global edge, edge2, ww, next, next2, point, point2
	edge[ee]=v
	edge2[ee]=u
	ww[ee]=w
	next[ee]=point[u]
	point[u]=ee
	next2[ee]=point2[v]
	point2[v]=ee


def Relax(u,v,c):
	global dis
	if dis[v]>dis[u]+c:
		dis[v]=dis[u]+c
		return True
	return False


def SPFA(src, n):
	global dis, point2, next2, ww, inf
	global q

	vis=[False for i in range(n+1)]
	dis[src] = 0
	q.put(src)
	while (not q.empty()):
		u = q.get()
		vis[u] = False
		i = point2[u]
		while i!=0:
			v = edge2[i]
			if Relax(u,v,ww[i]) and not vis[v]:
				q.put(v)
				vis[v] = True
			i = next2[i]


def Astar(src, to, k):
	global dis
	global pq

	cnt=0
	if src == to:
		k+=1
	if dis[src]==inf:
		yield -1
		return
	pq.put(state(dis[src], 0, src, [src]))
	time_monitor = datetime.now()
	while (not pq.empty()):
		b = pq.qsize()
		a = pq.get()
		if (a.now == to):
			yield a.pre
			cnt+=1
			if (cnt == k):
				break
		i=point[a.now]
		while i!=0:

			if not edge[i] in a.pre:
				pq.put(state(a.g+ww[i]+dis[edge[i]], a.g+ww[i], edge[i], a.pre+[edge[i]]))
			i=next[i]

			if (datetime.now() - time_monitor).seconds > 5:
				yield 0
				return


def build_store():
	db = MongoClient()['igemdata_new']
	db.drop_collection('boost_store')
	db.drop_collection('node_pool')
	db.drop_collection('link_pool')
	collection = db['boost_store']
	data_dict = {}
	data_dict['last_update_time'] = datetime.now().day

	link_count = 0
	node_count = 0
	link_pool = {}
	node_pool = {}
	H2O_id = db.node.find_one({'NAME': 'H2O'})['_id']
	for node in db.node.find({'_id': {'$ne': H2O_id}}):
		if node_pool.get(str(node['_id'])) is None:
			node_count += 1
			db.node_pool.insert({'node_id': str(node['_id']), 'node_count': node_count})
			node_pool[str(node['_id'])] = node_count
	db.node_pool.create_index('node_id')
	db.node_pool.create_index('node_count')

	for link_ref in db.link_ref.find({'$and': [{'id1': {'$ne': H2O_id}}, {'id2': {'$ne': H2O_id}}]}):
		if link_pool.get(str(link_ref['id1'])+str(link_ref['id2'])) is None:
			link_count += 1
			db.link_pool.insert({'id1': str(link_ref['id1']), 'id2': str(link_ref['id2'])})
			link_pool[str(link_ref['id1'])+str(link_ref['id2'])] = True

	data_dict['node_count'] = node_count
	data_dict['link_count'] = link_count
	collection.insert(data_dict)


def a_star(request):
	global edge,edge2,next,next2,ww,point,point2,dis,q,pq

	if request.method == 'POST':
		q = Queue()
		pq = PriorityQueue()
		node_pool = {}
		link_pool = []
		search_pool = {}
		time_point = {}
		start_time = datetime.now()

		# boost by database saving
		db = MongoClient()['igemdata_new']
		information = db.boost_store.find_one({})
		#if (information is None) or (information['last_update_time'] != datetime.now().day):

		#	build_store()
		#build_store()
		information = db.boost_store.find_one()
		database_saving = datetime.now()
		time_point['database_saving'] = database_saving - start_time
		# count and read database to memory
		node_count = information['node_count']
		link_count = information['link_count']
		for node in db.node_pool.find():
			node_pool[node['node_id']] = node['node_count']
			search_pool[node['node_count']] = node['node_id']
		for link in db.link_pool.find():
			link_pool.append((link['id1'], link['id2']))

		n_count_time = datetime.now()
		time_point['database reading'] = n_count_time - database_saving

		# initial vars
		edge = MakeArray(link_count*2 + 1)
		edge2 = MakeArray(link_count*2 + 1)
		next = MakeArray(link_count*2 + 1)
		next2 = MakeArray(link_count*2 + 1)
		ww = MakeArray(link_count*2 + 1)
		point = MakeArray(node_count)
		point2 = MakeArray(node_count)
		dis = [inf for i in xrange(node_count + 1)]

		initial_time = datetime.now()
		time_point['initial'] = initial_time - n_count_time

		# add in edge
		link_count = 0
		for link in link_pool:
			id1 = link[0]
			id2 = link[1]
			# ObjectId to int
			link_count += 1
			num_id1 = node_pool[id1]
			num_id2 = node_pool[id2]
			AddEdge(num_id1, num_id2, 1, link_count)
			link_count += 1
			AddEdge(num_id2, num_id1, 1, link_count)

		s = node_pool[request.POST['id1']]
		t = node_pool[request.POST['id2']]
		if 'order' not in request.POST.keys():
			order = 14
		else:
			order = request.POST['order']
		k = int(order)

		convert_time = datetime.now()
		time_point['convert'] = convert_time - initial_time

		SPFA(t, node_count)

		SPFA_time = datetime.now()
		time_point['SPFA'] = SPFA_time - convert_time

		path_list = []
		for j in Astar(s, t, k):
			# not founded
			if j == -1:
				break

			# overtime
			if j == 0:
				break

			path = []
			for node in j:
				result = {'_id': search_pool[node]}
				object_node = db.node.find_one({'_id': bson.ObjectId(result['_id'])})
				result['NAME'] = object_node['NAME']
				result['TYPE'] = object_node['TYPE']
				path.append(result)
				del result
				# path.append(db.node.find_one({'_id': search_dict[node]})['NAME'])
			path_list.append(path)
		
		Astar_time = datetime.now()
		time_point['Astar'] = Astar_time - SPFA_time
		result_text = json.dumps(path_list)
		return HttpResponse(result_text)

	elif request.method != 'GET':
		return HttpResponse("{'status':'error', 'reason':'only POST method setting'}")

