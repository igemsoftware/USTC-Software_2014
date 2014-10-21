package Kernel.ExpandThread{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.getTimer;
	
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import Kernel.Biology.LinkTypeInit;
	
	import UserInterfaces.FunctionPanel.PerspectiveViewer;
	
	
	import UserInterfaces.ReminderManager.ReminderManager;
	import UserInterfaces.Sorpotions.Navigator;
	
	import UserInterfaces.Style.TweenX;
	
	
	/**
	 * Expand Manager
	 * --Solve three kinds of requirements--
	 * 1. Explode from a node (Expand all external links)
	 * 2. Search Links (check external links)
	 * 3. Auto Link (auto-link external links);
	 */
	
	public class ExpandManager {
		
		///Enumeration of operation types
		public static const EXPAND:int=0;
		public static const SEARCHLINES:int=1;
		public static const LINKLINES:int=2;
		
		///Frame Buffer
		private static var expandBuffer:Sprite=new Sprite();
		private static var LoaderBuffer:Sprite=new Sprite();
		
		///Expand Queue
		public static var ExpandList:Array=[];
		public static var ExpandListeners:Array=[];
		
		
		///Explode Queue
		private static var explodeArray:Array=[];
		private static var explodeManager:Sprite=new Sprite();
		
		/**
		 * Expand
		 * @param target the node from which to expand.
		 * @param mode Enumeration of operation type.
		 */
		public static function Expand(target:CompressedNode,mode:int):EventDispatcher{
			
			if(ExpandList[target.ID]==null){
				
				ExpandList[target.ID]=new ExpandLoader();
				
				ExpandList[target.ID].mode=mode;
				
				ExpandList[target.ID].loadID(target.ID);
				
				ExpandList[target.ID].addEventListener(Event.COMPLETE,EdgeLoaderCMP);
				
				ExpandList[target.ID].addEventListener(IOErrorEvent.IO_ERROR,function (e):void{
					ReminderManager.remind("Fail to Expand : "+target.Name);
					(ExpandListeners[target.ID] as EventDispatcher).dispatchEvent(new ExpandEvent(ExpandEvent.EXPAND_COMPLETE,[],null));
					delete ExpandListeners[target.ID];
					delete ExpandList[target.ID];
				});
				
				ExpandListeners[target.ID]=new EventDispatcher();
				
			}
			if(mode==EXPAND){
				ExpandList[target.ID].mode=mode;
			}
			trace("patchEvent:",ExpandListeners[target.ID]);
			
			return ExpandListeners[target.ID];
		}
		
		
		/**
		 * @param event:
		 * event.target is the Edge Loader
		 * event.target.NodeID is the ID of the Node, so ExpandListener[event.target.NodeID] is the listener;
		 * event.target.mode is the type of operation that follows
		 */
		protected static function EdgeLoaderCMP(event):void{

			if(String(event.target.data).indexOf("{'status':'error'")==0){
				(ExpandListeners[tar.ID] as EventDispatcher).dispatchEvent(new ExpandEvent(ExpandEvent.EXPAND_COMPLETE,[],null));
				delete ExpandListeners[tar.ID];
				delete ExpandList[tar.ID];
				return;
			}
			
			var edges:Array=JSON.parse('{"results":'+event.target.data+"}").results;
			var branches:Array=[];
			
			var tar:CompressedNode=GxmlContainer.Node_Space[event.target.NodeID];
			
			for (var i:int = 0; i < edges.length; i++) {
				branches.push(new ExpandBranch(edges[i].link_id,tar,edges[i].node_id,edges[i].NAME,edges[i].TYPE,edges[i].link_type,edges[i].DIRECT));
			}
			
			if(branches.length>0){
				if(event.target.mode==EXPAND){
					Explode(tar,branches);
				}else if(event.target.mode==LINKLINES){
					AutoLink(tar,branches);
				}
			}
			
			trace("dispatchEvent:",ExpandListeners[tar.ID]);
			(ExpandListeners[tar.ID] as EventDispatcher).dispatchEvent(new ExpandEvent(ExpandEvent.EXPAND_COMPLETE,branches,tar));
			delete ExpandListeners[tar.ID];
			delete ExpandList[tar.ID];
			trace("Expand Loader Complete.",edges.length,"Branches Loaded");
		}
		
		
		/**
		 * Auto-Link function
		 * @param target Node to check external links.
		 * @param branches Branches load form Cloud
		 * If a node in the current Project has external link with target node, the link will be created.
		 */
		private static function AutoLink(target:CompressedNode,branches:Array):void{
			var hasAutoline:Boolean=false;
			trace("Preform auto-Linkage");
			var tmpName:String;
			for each (var branch:ExpandBranch in branches) {
				
				if(GxmlContainer.Node_Space[branch.node_id]!=null){
					
					if(LinkTypeInit.LinkTypeList[branch.LinkType]==null){
						tmpName=branch.LinkType;
					}else{
						tmpName=LinkTypeInit.LinkTypeList[branch.LinkType].label;
					}
					if(branch.DIRECT==0){
						Net.loadLink(branch.link_id,"",tmpName,GxmlContainer.Node_Space[branch.node_id],branch.father,branch.LinkType);
					}else{
						Net.loadLink(branch.link_id,"",tmpName,branch.father,GxmlContainer.Node_Space[branch.node_id],branch.LinkType);
					}
					hasAutoline=true;
				}
			}
			
			if(hasAutoline){
				Navigator.refreshMap();
				PerspectiveViewer.refreshPerspective();
			}
		}
		
	
		
		/**
		 * Explode function
		 * @param target node to check external links.
		 * @param branches branches load form Cloud
		 * All External links in branches will be imported.
		 */
		public static function Explode(tar,branches):void{
			
			var c:int=0;
			var r0:Number=tar.centerRadius;
			var n0:int=int(r0*2*Math.PI/60);
			if (n0>branches.length) {
				n0=branches.length;
			}
			var dceta:Number=(Math.PI*2)/n0;
			var sa:Number=Arrange(n0);
			
			for (var i:int = 0; i < branches.length; i++) {
				
				if (c==n0) {
					c=0;
					r0=r0+80;
					n0=int(r0*2*Math.PI/60);
					if (n0>branches.length-i) {
						n0=branches.length-i
					}
					dceta=(Math.PI*2)/n0;
					sa=Arrange(n0);
				}
				branches[i].aimx=tar.Position[0]+r0*(Math.cos(dceta*c+sa));
				branches[i].aimy=tar.Position[1]+r0*(Math.sin(dceta*c+sa));
				c++;
			}
			
			explodeArray=explodeArray.concat(branches);
			
			if(!explodeManager.hasEventListener(Event.ENTER_FRAME)){
				explodeManager.addEventListener(Event.ENTER_FRAME,buffer);
			}
			
		}
		
		/**
		 * Frame buffer for Explode.
		 * to divided the work load of CPU
		 */
		private static function buffer(e):void{
			
			var t:int=getTimer();
			var branch:ExpandBranch;
			var tar:CompressedNode;
			
			var tmpArr:Array=[];
			
			while(getTimer()-t<18&&explodeArray.length>0){
				branch=explodeArray.shift();
				
				
				if (GxmlContainer.Node_Space[branch.node_id]==null) {
					
					tar=Net.loadCompressedBlock(branch.node_id,"",branch.NAME,branch.father.Position[0],branch.father.Position[1],branch.TYPE);
					tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);
					tmpArr.push(tar);
					trace("Create Node:",tar.Name);
				}else{
					
					tar=GxmlContainer.Node_Space[branch.node_id];
					/*tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);*/
					trace("Repeated Node:",tar.Name);
				}
				
				
				try{
					if(branch.DIRECT==0){
						Net.loadLink(branch.link_id,"",null,GxmlContainer.Node_Space[branch.node_id],branch.father,branch.LinkType,"{}",true);
					}else{
						Net.loadLink(branch.link_id,"",null,branch.father,GxmlContainer.Node_Space[branch.node_id],branch.LinkType,"{}",true);
					}
					trace("Create Link:",branch.link_id);
				}catch(error:Error) {
					trace("[Error]:Fail to Create Link:",branch.link_id,branch.LinkType);
				}
				
			}
			
			GxmlContainer.RecordMultiNodeExistance(tmpArr,GxmlContainer.ADD_NODE);
			Navigator.refreshMap();
			PerspectiveViewer.refreshPerspective();
			if(explodeArray.length==0){
				explodeManager.removeEventListener(Event.ENTER_FRAME,buffer);
			}
			
		}
		
		
		/**
		 * arrange for Explode layout
		 */
		public static function Arrange(n:int):Number{
			switch(n)
			{
				
				case 3:
				{
					return Math.PI/6;
					break;
				}
					
				case 4:
				{
					return Math.PI/4;
					break;
				}
					
				case 1:
				case 2:
				{
					return 0;
					break;
				}
					
				default:
				{
					return Math.PI/2;
					break;
				}
			}
		}
	}
}