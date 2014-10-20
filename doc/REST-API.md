# API document

## Instruction

All the following API(expect OAUTH) must have Authorization parameter in Http Header. 



		Authorization:  Token 13sdfs32fsadf 



>The default response is in Json, if you want the response in other format, please add parameter "format=XML", "format=YAML", etc. 

If anything goes south, you will get a error response:
	
	{
		'status': 'error',
		'reason': '<err_reason>',
	}

## DIRECTORY
	
	
	POST	/auth/oauth/(baidu|google)/login
	GET		/auth/oauth/(baidu|google)/complete&...
	#GET    /user/<uid>
	
	
	GET		/project/project/  # list my project
	POST	/project/project/  # add
	
	GET		/project/<pid>  # login
	PUT     /project/<pid>  # modify
	DELETE  /project<pid>  # delete
	
	POST	/project/<pid>/collaborator/<uid> 
	DELETE	/project/<pid>/collaborator/<uid>
	
	
	GET		/data/(node|link)/<id>
	POST	/data/(node|link)
	DELETE	/data/(node|link)/<ref_id>
	PATCH 	/data/node/<ref_id>
	PUT		/data/(node|link)/<id>
	
	GET 	/data/project/<pid>
	
>GET		/data/(node|link)/<ref_id>/link
@zhaosensen
	
	POST	/search/(node|link)/
	POST	/search/user/
	POST	/search/project/
	
	POST	/algorithm/shortestpath
	POST	/algorithm/blastn

## OAUTH LOGIN:

request:

	POST /auth/oauth/(baidu|google)/login

When the user login in successfully, the pages will redirect to the /auth/oauth/<baidu|google>/complete

## OAUTH COMPLETE

request(automatically):

	GET /auth/oauth/(baidu|google)/complete&....

success :

	{
		"status": "success",
	 	"token": "16517d0809f225b7b65a79ef1dc8c552441bf58a", 
	 	"uid": 8,
	 	"googleid": "zhoulong6@gmail.com",
	 	[OR "baiduid": "347238434"]
	}	
	
## LIST PROJECT

request:

	GET /project/project/

response:

	{	
		'status':'success',
		'resultes': 
		[
			...
		]
	}


## ADD PROJECT

request:

	POST /project/project/
	
	prj_name:<string>
	[species:<string>]
	[description:<string>]

response:

	{
		'status':'success',
		'pid':...
	}


## PROJECT INFO

request:

	GET /project/<pid>/

success response:

	{
		'status': 'success',
		'result':
		{
			'pid':....,
			'prj_name':...,
			'author':...,
			'authorid':...,
			'species':...,
			'description':...,
			'collaborators':
			[1, 5, ...
			]
		}
	}

## DELETE PROJECT

request:

	DELETE /project/<pid>/

response:

	{
		'status':'success'
	}
	
## MODIFY PROJECT
request:
	
	PUT /project/<pid>/
	request body:
	
	name : ...,
	species: ...,
	description:...
	
	

## ADD COLLABORATOR

request:

	POST /project/<pid>/collaborator
	uid:<uid>

response:

	{
		'status':'success'
	}

## DELETE COLLABORATOR

request:

	DELETE /project/<pid>/collaborator/<uid>

response:

	{
		'status':'success'
	}


## LOGOUT:

request:
	
	POST /auth/logout/

response:

	{
		'status': 'success‘,
	}
	

	
## DETAIL

request:

	GET /data/(node|link)/<ref_id>/

response:

	{
		I'm results
	}


## ADD

request:

	POST /data/(node|link)
	
	info: 
	{
		'TYPE': 'Gene',
		'NAME': 'trnL',
		...
	}
	x: 123.123131
	y: 321314.324
	pid: basfji3458113dsfnmsdjkf
	
	----
	PS:
	x,y(float) is optional
	pid,info are required
		
response:

	{
		'ref_id': '<ref_id>'	
	}
	

## REFERENCE

request:

	PUT /data/(node|link)/<node\link_id>/
	
	pid: basfji3458113dsfnmsdjkf
	x: 123.123
	y: -213.231
	
response:

	{
		'ref_id': '<ref_id>'	
	}
	
## PATCH 
request:

	PATCH /data/(node|link)/<ref_id
	
	x: 1231.123
	y: 232.234234
	

## DELETE

request:

	DELETE /data/(node|link)/<ref_id>

response:

	{
		'status': 'success‘,
	}
		

## LIST ALL DATA IN PROJECT

request:
		
	GET 	/data/project/<pid>

response:
	
	{
		'status': 'success',
		'node': [
					{},{}...
				],
		'link': [
					{},{}..
				],
	}

	
## SEARCH NODE|LINK

request:

	POST /search/(node|link)
	
	method:query
	spec:{}
	fields:{}
	skip:[INTEGER]
	limit:[INTEGER]

default:

	skip:0
	limit:infinite

response:

	{
		results:
		[
			{
				'_id': '53f455e1af4bd63ddccee4a3',
				'NAME':'ehrL',
				'TYPE':'Gene',
				'....':'...'

			},
			{
				'_id': '53f455e1af4bd63ddccee4a4'
				'NAME':'thrA',
				'TYPE':'Gene',
				'....':'...'
			}
		]
	}

### ex1

request :

	POST /search/(node|link)
		
	'spec':
	{
		"$and":
		[
			{"$or":
			[
				{"key1":"abc"},
				{"key2":123},
				{"key3":"sfda"}
			]},
			{"key4":"feiyicheng"}
		]
	}
	
explain: 
	
	(key1 || key2 || key3) && key4
	
### ex2

request:

	POST /search/(node|link)
	
	'spec':
	{
		"age":
		{
			"$gt":18
		}
	}


explain:

	< : "$lt"
	> : "$gt"
	<= : "$le"
	>= : "$ge"
	!= : "$ne"

### ex3

only return ID, NAME and TYPE fields

request:

	POST /search/(node|link)
	
	spec:
	{
	}
	field:
	{
		'NAME':True,
		'TYPE':True
	}



### ex4

return all fields except NAME

request:

	POST /search/(node|link)
	
	'spec':
	{
	}
	'field':
	{
		'NAME':False
	}

## SEARCH USER

request:

	POST /search/user
	name: <name>
	
	----
	PS: It will be fuzzy search
	eg:
		POST /search/user
		name: zhoulo
		
response:

	{
		'status': 'success', 
		'results': 
		[
			{
				'username': <username>,
                'first_name': <first_name>,
                'last_name': <last_name>,
               	'id':<uid>,
			},
			{}...
		]
	}


## SEARCH PROJECT

request:

	POST /search/project
	query: <query>
	
	PS: query must conform the Json format, and all the fields are shown as following:
	 'name','author','authorid',
	
response:

	{
		'status': 'success',
		'results': 
		{
			{
				'pid':...,
				'name':...,
				'authorid':...,
				'collaborators':
				[
					2,412,4...
				]
			},
			{}...
		}
	}

## SHORTESTPATH

request:
	
	POST /algorithm/shortestpath
	
	ID1:<string>
	ID2:<string>
	global:[boolean]

default:

	global:False

response:

	{
		results:
		[
			{
				node:[1,2,3,4,5],
				link:[12,23,34,45]
			},
			{
				node:[1,2,7,8,9,10,11],
				link:[......]
			}
		]
	}

## BLASTN

request:

	POST /algorithm/blastn
	//TODO