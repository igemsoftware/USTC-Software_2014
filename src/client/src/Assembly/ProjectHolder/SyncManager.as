package Assembly.ProjectHolder
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	
	import LoginAccount.AuthorizedURLLoader;

	public class SyncManager
	{
		public static function SYNC(e=null):void{
			
			//Node:
			//patch moved   Patch
			//upload modified   Delete&Add
			//upload new   Add
			
			//Link:
			//upload modified   Delete&Add
			//upload new   Add
			
			for each (var node:CompressedNode in GxmlContainer.Block_space) 
			{
				if(node.ID.length==24){
					//Loaded from Cloud
					if(node.modified){
						//Delete & Add
						
						
						
					}
					
				}else{
					//New Node
					
					
					
					
				}
				
				
			}
			for each (var line:CompressedLine in GxmlContainer.Linker_space) 
			{
				if(node.ID.length==24){
					//Loaded from Cloud
					
					
					
					
				}else{
					//New Node
					
					
					
					
				}
				
				
			}
			
		}
		public static function SyncNode(node:CompressedNode):void{
			
			var postvar:URLVariables=new URLVariables();
			postvar.info=node.detail;
			postvar.x=node.remPosition[0];
			postvar.y=node.remPosition[1];
			postvar.pid=ProjectManager.ProjectID;
			
			var posturl:URLRequest=new URLRequest(GlobalVaribles.NODE_INTERFACE);
			posturl.method=URLRequestMethod.POST;
			posturl.data=postvar;
			
			
			var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				
				var tJson:Object=JSON.parse(String(e.target.data));
				trace(tJson.status,tJson.id,tJson.ref_id);
				
				if(tJson.status=="success"){
					ChangeID(node,tJson.id,tJson.ref_id);
				}
			})
		}
		
		public static function SyncMovedNode(node:CompressedNode):void{
			
			var postvar:URLVariables=new URLVariables();
			postvar.x=node.remPosition[0];
			postvar.y=node.remPosition[1];
			
			var posturl:URLRequest=new URLRequest(GlobalVaribles.NODE_INTERFACE+node.refID+"/");
			posturl.method="PATCH";
			posturl.data=postvar;
			
			var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				
				var tJson:Object=JSON.parse(String(e.target.data));
				trace(tJson.status,tJson.id,tJson.ref_id);
				
				if(tJson.status=="success"){
					ChangeID(node,tJson.id,tJson.ref_id);
				}
			})
		}
		public static function DeleteNode(node:CompressedNode):void{
			
			var posturl:URLRequest=new URLRequest(GlobalVaribles.NODE_INTERFACE+node.refID+"/");
			posturl.method=URLRequestMethod.DELETE;
			
			var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				
				var tJson:Object=JSON.parse(String(e.target.data));
				trace("Delete : ",tJson.status);
			})
		}
		
		
		public static function SyncLine(line:CompressedLine):void{
			
			var postvar:URLVariables=new URLVariables();
			postvar.pid=ProjectManager.ProjectID;
			postvar.info=line.detail;
			postvar.id1=line.linkObject[0].ID;
			postvar.id2=line.linkObject[1].ID
			
			var posturl:URLRequest=new URLRequest(GlobalVaribles.LINK_INTERFACE);
			posturl.method=URLRequestMethod.POST;
			posturl.data=postvar;
			
			var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader();
			urlloader.load(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				
				var tJson:Object=JSON.parse(String(e.target.data));
				trace(tJson.status,tJson.id,tJson.ref_id);
				
				if(tJson.status=="success"){
					ChangeID(line,tJson.id,tJson.ref_id);
				}
			})
		}
		public static function DeleteLine(line:CompressedLine):void{
			
			var posturl:URLRequest=new URLRequest(GlobalVaribles.LINK_INTERFACE+line.refID+"/");
			posturl.method=URLRequestMethod.DELETE;
			
			var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				
				var tJson:Object=JSON.parse(String(e.target.data));
				trace("Delete : ",tJson.status);
			})
		}
		public static function ChangeID(tar,newID:String,refID:String):void{
			if(tar.constructor==CompressedLine){
				delete GxmlContainer.Linker_space[tar.ID];
				
				(tar as CompressedLine).ID=newID;
				(tar as CompressedLine).refID=refID;
				
				GxmlContainer.Linker_space[newID]=tar;
				
			}else if(tar.constructor==CompressedNode){
				delete GxmlContainer.Block_space[tar.ID];
				
				(tar as CompressedNode).ID=newID;
				(tar as CompressedNode).refID=refID;
				
				GxmlContainer.Block_space[newID]=tar;
			}
		}
	}
}