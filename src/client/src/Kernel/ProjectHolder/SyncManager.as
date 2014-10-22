package Kernel.ProjectHolder
{
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.LoginAccount.AuthorizedURLLoader;
	import UserInterfaces.ReminderManager.ReminderManager;
	
	public class SyncManager
	{
		
		private static var Origin_Node_Space:Object=new Object();
		private static var Origin_Link_Space:Object=new Object();
		
		public static function SYNC(e=null):void{
			
			
			//Get Original Project
			
			var projectLoader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest(GlobalVaribles.PROJECT_LOAD_PROJECT))
			projectLoader.addEventListener(Event.COMPLETE,loadProject);
			ReminderManager.remind("Checking Project Status...");
			
			function loadProject(event:Event):void
			{	
				
				Origin_Node_Space=new Object();
				Origin_Link_Space=new Object();
				
				var Gobj:Object=JSON.parse(event.target.data);
				
				var nodes:Array=Gobj.node;
				var lines:Array=Gobj.link;
				
				for each(var node:Object in  nodes){
					Origin_Node_Space[node._id]={refID:node.ref_id,Name:node.NAME,x:node.x,y:node.y,Type:node.TYPE};
				}
				
				
				for each(var line:Object in  lines){
					Origin_Link_Space[line._id]={Name:line.NAME,refID:line.ref_id,Type:line.TYPE};
				}
				
				ReminderManager.remind("Uploading...");
				_sync();
			}
		}
		
		private static function _syncNode():void{
			//New Nodes should firstly get an ObjectID
			
		}
		
		private static function _sync():void{
			//Node:
			//patch moved   Patch
			//upload modified   Delete&Add
			//upload new   Add
			
			//Link:
			//upload modified   Delete&Add
			//upload new   Add
			
			var NewList:Array=[];
			var DeleteList:Array=[];
			var RefList:Array=[];
			var PatchList:Array=[];
			
			var NewLinkList:Array=[];
			var DeleteLinkList:Array=[];
			var RefLinkList:Array=[];
			
			var node:CompressedNode;
			
			for each (node in GxmlContainer.Node_Space){
				
				if(Origin_Node_Space[node.ID]!=null){
					
					//Node from Original Project
					
					node.modified=node.modified||node.Name!=Origin_Node_Space[node.ID].Name||node.Type.Type!=Origin_Node_Space[node.ID].Type;
					
					if(node.modified){
						//Delete & Add
						DeleteList.push(node.refID);
						
						NewList.push(node);
						
					}else if(node.remPosition[0]!=Origin_Node_Space[node.ID].x||node.remPosition[1]!=Origin_Node_Space[node.ID].y){
						PatchList.push(node);
					}
					delete Origin_Node_Space[node.ID];
				}else if(node.ID.length==24){
					
					//Node Add from Cloud
					if(node.modified){
						NewList.push(node);
					}else{
						RefList.push(node);
					}
				}else{
					
					//New Node
					NewList.push(node);
					
				}
			}
			
			//For what no longer exist:
			for each(var dobj:Object in Origin_Node_Space){
				DeleteList.push(dobj.refID);
			}
			
			for each (var line:CompressedLine in GxmlContainer.Link_Space) {
				
				if(Origin_Link_Space[line.ID]!=null){
					
					//Link from Original Project, must have a refID
					//||line.Name!=Origin_Link_Space[line.ID].Name
					line.modified=line.modified||line.Type.Type!=Origin_Link_Space[line.ID].Type;
					
					if(line.modified){
						//Delete & Add
						DeleteLinkList.push(line.refID);
						
						NewLinkList.push(line);
						
					}
					delete Origin_Link_Space[line.ID]
				}else if(line.ID.length==24){
					
					//Link Add from Cloud
					if(line.modified){
						NewLinkList.push(line);
					}else{
						RefLinkList.push(line);
					}
				}else{
					
					//New Link
					NewLinkList.push(line);
					
				}
				
				
			}
			
			//For what no longer exist:
			for each(var lobj:Object in Origin_Link_Space){
				DeleteLinkList.push(lobj.refID);
			}
			
			/////////////SYNC START
			
			var i:int;
			
			/////////////ADD_NODE
			
			var add_node_obj:Array=[]
			
			for (i = 0; i < NewList.length; i++) 
			{
				node=NewList[i];
				
				node.detail.NAME=node.Name;
				node.detail.TYPE=node.Type.Type;
				
				add_node_obj.push({
					pid:ProjectManager.ProjectID,
					x:node.remPosition[0],
					y:node.remPosition[1],
					info:JSON.stringify(node.detail)
				});
				trace("ADD Node:", node.Name)
			}
			
			
			
			
			
			
			////////////DELETE_NODE
			
			var del_node_obj:Array=[]
			
			for (i = 0; i < DeleteList.length; i++) 
			{	
				del_node_obj.push({
					ID:DeleteList[i],
					pid:ProjectManager.ProjectID
				});
			}
			
			////////////DELETE_LINK
			
			var del_line_obj:Array=[]
			
			for (i = 0; i < DeleteLinkList.length; i++) 
			{	
				del_line_obj.push({
					ID:DeleteLinkList[i],
					pid:ProjectManager.ProjectID
				});
				
				trace("Delete Link:", DeleteLinkList[i])
			}
			
			////////////PATCH_NODE
			
			var patch_node_obj:Array=[]
			
			for (i = 0; i < PatchList.length; i++)
			{
				node=PatchList[i];
				
				patch_node_obj.push({
					ID:node.refID,
					x:node.remPosition[0],
					y:node.remPosition[1]
				});
				
				trace("Patch Node:", node.Name)
			}
			
			
			//////////PUT_NODE
			
			var put_node_obj:Array=[]
			
			for (i = 0; i < RefList.length; i++) 
			{
				node=RefList[i];
				
				put_node_obj.push({
					pid:ProjectManager.ProjectID,
					x:node.remPosition[0],
					y:node.remPosition[1],
					ID:node.ID
				});
				trace("PUT Node:", node.Name)
			}
			
			//////////PUT_LINK
			
			var put_link_obj:Array=[]
			
			for (i = 0; i < RefLinkList.length; i++) 
			{
				line=RefLinkList[i];
				
				put_link_obj.push({
					pid:ProjectManager.ProjectID,
					ID:line.ID,
					id1:line.linkObject[0].ID,
					id2:line.linkObject[1].ID
				});
				
				trace("PUT Link:", line.Name)
			}
			
			
			/////////////Orginize
			
			syncNode();
			
			function syncNode():void{
				
				var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader();
				
				var postJSONObject:Array=[];
				
				var postvar:URLVariables=new URLVariables();
				
				postJSONObject.push({ADD_NODE:add_node_obj});
				postJSONObject.push({DELETE_NODE:del_node_obj});
				postJSONObject.push({PATCH_NODE:patch_node_obj});
				postJSONObject.push({PUT_NODE:put_node_obj});
				
				
				var xdata:String=JSON.stringify(postJSONObject);
				
				trace(xdata);
				postvar.orderlist=xdata;	
				
				var posturl:URLRequest=new URLRequest(GlobalVaribles.BATCH_INTERFACE);
				posturl.method=URLRequestMethod.POST;
				posturl.data=postvar;
				
				urlloader.load(posturl);
				urlloader.addEventListener(Event.COMPLETE,function (e):void{
					trace("SYNC NODE COMPLETE");
					trace("[BACKEND]:",e.target.data);
					
					var celebrate:Array=JSON.parse(e.target.data)[0];
					
					for (var j:int = 0; j < celebrate.length; j++) 
					{
						ChangeID(NewList[j],celebrate[j].id,celebrate[j].ref_id)
					}
					
					syncLink();
				});
			}
			
			function syncLink():void{
				
				//////////ADD_LINK
				
				var add_link_obj:Array=[]
				
				for (i = 0; i < NewLinkList.length; i++){
					
					line=NewLinkList[i];
					
					line.detail.NAME=line.Name;
					line.detail.TYPE=line.Type.Type;
					
					add_link_obj.push({
						info:JSON.stringify(line.detail),
						pid:ProjectManager.ProjectID,
						id1:line.linkObject[0].ID,
						id2:line.linkObject[1].ID
					});
					
					trace("ADD Link:", line.Name)
				}
				

				
				var urlloader:AuthorizedURLLoader=new AuthorizedURLLoader();
				
				var postJSONObject:Array=[];
				
				var postvar:URLVariables=new URLVariables();
				
				postJSONObject.push({ADD_LINK:add_link_obj});
				postJSONObject.push({DELETE_LINK:del_line_obj});
				postJSONObject.push({PUT_LINK:put_link_obj});
				
				var xdata:String=JSON.stringify(postJSONObject);
				
				trace(xdata);
				postvar.orderlist=xdata;	
				
				var posturl:URLRequest=new URLRequest(GlobalVaribles.BATCH_INTERFACE);
				posturl.method=URLRequestMethod.POST;
				posturl.data=postvar;
				
				urlloader.load(posturl);
				urlloader.addEventListener(Event.COMPLETE,function (e):void{
					trace("SYNC LINK COMPLETE");
					trace("[BACKEND]:",e.target.data);
					
					var celebrate:Array=JSON.parse(e.target.data)[0];
					
					for (var j:int = 0; j < celebrate.length; j++) 
					{
						ChangeID(NewLinkList[j],celebrate[j].id,celebrate[j].ref_id)
					}
					
					ReminderManager.remind("Project Synchronized");
					
				});
			}
		}
		
		public static function ChangeID(tar,newID:String,refID:String):void{
			if(tar.constructor==CompressedLine){
				
				Net.LinkSpace.changeChildID(tar,newID);
				
				delete GxmlContainer.Link_Space[tar.ID];
				
				var obj1:CompressedNode=(tar as CompressedLine).linkObject[0];
				var obj2:CompressedNode=(tar as CompressedLine).linkObject[1];
				
				delete obj1.Arrowlist[tar.ID];
				
				delete obj2.Arrowlist[tar.ID];
				
				obj1.Arrowlist[newID]=tar;
				obj2.Arrowlist[newID]=tar;
				
				(tar as CompressedLine).ID=newID;
				(tar as CompressedLine).refID=refID;
				
				GxmlContainer.Link_Space[newID]=tar;
				
			}else if(tar.constructor==CompressedNode){
				
				Net.NodeSpace.changeChildID(tar,newID);
				
				delete GxmlContainer.Node_Space[tar.ID];
				
				(tar as CompressedNode).ID=newID;
				(tar as CompressedNode).refID=refID;
				
				trace("IDChange:",tar.Name,tar.ID);
				
				GxmlContainer.Node_Space[newID]=tar;
			}
		}
	}
}