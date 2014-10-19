package Assembly.ExpandThread{
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Biology.LinkTypeInit;
	
	import FunctionPanel.PerspectiveViewer;
	
	import IEvent.ExpandEvent;
	
	import Layout.ReminderManager;
	import Layout.Sorpotions.Navigator;
	
	import Style.TweenX;
	
	
	public class ExpandManager {
		
		public static const EXPAND:int=0;
		public static const SEARCHLINES:int=1;
		public static const LINKLINES:int=2;
		
		private static var expandBuffer:Sprite=new Sprite();
		private static var LoaderBuffer:Sprite=new Sprite();
		
		public static var ExpandList:Array=[];
		public static var ExpandListener:Array=[];
		
		protected static var mainToWorker:MessageChannel;
		protected static var workerToMain:MessageChannel;
		protected static var loaderThread:Worker;
		
		protected static var returnBytes:ByteArray=new ByteArray();
		protected static var sendBytes:ByteArray=new ByteArray();
		
		protected static var returnBytesMutex:Mutex=new Mutex();
		protected static var sendBytesMutex:Mutex=new Mutex();
		
		loaderThread= WorkerDomain.current.createWorker(Workers.Platform_LoaderThread_LoaderThread,true);
		
		mainToWorker= Worker.current.createMessageChannel(loaderThread);
		workerToMain= loaderThread.createMessageChannel(Worker.current);
		
		returnBytes.shareable=true;
		sendBytes.shareable=true;
		
		loaderThread.setSharedProperty("Loader_returnBytes",returnBytes);
		loaderThread.setSharedProperty("Loader_sendBytes",sendBytes);
		
		loaderThread.setSharedProperty("Loader_returnBytesMutex",returnBytesMutex);
		loaderThread.setSharedProperty("Loader_sendBytesMutex",sendBytesMutex);
		
		loaderThread.setSharedProperty("MainToLoaderThread",mainToWorker);
		loaderThread.setSharedProperty("LoaderThreadToMain",workerToMain);
		
		loaderThread.setSharedProperty("Loader_RestorePosition",false);
		loaderThread.setSharedProperty("Main_RestorePosition",false)
		
		workerToMain.addEventListener(Event.CHANNEL_MESSAGE,onWorkerToMain);
		
		loaderThread.start();
		
		
		public static function Expand(tar:CompressedNode,mode:int):*{
			
			if(ExpandList[tar.ID]==null){
				
				if(sendBytesMutex.tryLock()){
					ExpandList[tar.ID]=mode;
					
					if(loaderThread.getSharedProperty("Main_RestorePosition")){
						loaderThread.setSharedProperty("Main_RestorePosition",false);
						sendBytes.clear();
						trace("[Main]:Clear")
					}
					
					sendBytes.writeUTF("<CheckEdges>");
					sendBytes.writeUTF(tar.ID);
					
					sendBytesMutex.unlock();
					
					mainToWorker.send("Start");
					
					if(mode==SEARCHLINES){
						return ExpandListener[tar.ID]=new EventDispatcher();
					}
				}else{
					ReminderManager.remind("Busy")
				}
			}else{
				ReminderManager.remind("is already Expanding")
			}
			return null;
		}
		protected static function onWorkerToMain(event:Event):void{
			var msg:*= workerToMain.receive();
			
			trace("[Main]:",msg);
			if(msg=="Loaded"){
				if(!LoaderBuffer.hasEventListener(Event.ENTER_FRAME)){
					LoaderBuffer.addEventListener(Event.ENTER_FRAME,CheckLoader);
				}
			}
		}
		private static var currentPostion:int=0;
		protected static function CheckLoader(e):void{
			if(returnBytesMutex.tryLock()){
				trace("[Main]:EnterLock");
				
				returnBytes.position=currentPostion;
				
				var t:int=getTimer();
				
				returnBytes.position=currentPostion;
				
				while(returnBytes.bytesAvailable>0){
					
					var key:String=returnBytes.readUTF();
					
					var tar:CompressedNode;
					
					trace("[Main]:Key",key);
					
					if(key=="[Edge]"){
						var edges:Array=[];
						
						tar=GxmlContainer.Block_space[returnBytes.readUTF()];
						var edgesNum:int=returnBytes.readInt();
						
						for (var i:int = 0; i < edgesNum; i++) {
							edges.push(new ExpandBranch(returnBytes.readUTF(),tar,returnBytes.readUTF(),returnBytes.readUTF(),returnBytes.readUTF(),returnBytes.readUTF(),returnBytes.readInt()));
						}
						
						currentPostion=returnBytes.position;
						
						if(edges.length>0){
							if(ExpandList[tar.ID]==EXPAND){
								Explode(tar,edges);
							}else if(ExpandList[tar.ID]==LINKLINES){
								AutoLink(tar,edges);
							}else if(ExpandList[tar.ID]==SEARCHLINES){
								(ExpandListener[tar.ID] as EventDispatcher).dispatchEvent(new ExpandEvent(ExpandEvent.EXPAND_COMPLETE,edges,tar));
								delete ExpandListener[tar.ID];
							}
						}
						delete ExpandList[tar.ID]
					}
				}
				returnBytes.clear();
				loaderThread.setSharedProperty("Loader_RestorePosition",true);
				currentPostion=0;
				
				LoaderBuffer.removeEventListener(Event.ENTER_FRAME,CheckLoader);
				returnBytesMutex.unlock();
				trace("[Main]:Release Lock");
			}
		}
		
		private static function AutoLink(tar:CompressedNode,edges:Array):void{
			var hasAutoline:Boolean=false;
			trace("[Main]:PreExpandReceive");
			for each (var branch:ExpandBranch in edges) {
				
				if(GxmlContainer.Block_space[branch.node_id]!=null){
					if(branch.DIRECT==0){
						Net.loadLink(branch.link_id,"",LinkTypeInit.LinkTypeList[branch.LinkType].label,GxmlContainer.Block_space[branch.node_id],branch.father,branch.LinkType);
					}else{
						Net.loadLink(branch.link_id,"",LinkTypeInit.LinkTypeList[branch.LinkType].label,branch.father,GxmlContainer.Block_space[branch.node_id],branch.LinkType);
					}
					hasAutoline=true;
				}
			}
			
			if(hasAutoline){
				Navigator.refreshMap();
				PerspectiveViewer.refreshPerspective();
			}
		}
		
		private static var explodeArray:Array=[];
		private static var explodeManager:Sprite=new Sprite();
		
		public static function Explode(tar,branches):void{
			
			var c:int=0
			var r0:Number=tar.centerRadius;
			var n0:int=int(r0*2*Math.PI/60);
			if (n0>branches.length) {
				n0=branches.length;
			}
			var dceta:Number=(Math.PI*2)/n0;
			var sa:Number=ExpandLayout.Arrange(n0);
			
			for (var i:int = 0; i < branches.length; i++) {
				
				if (c==n0) {
					c=0;
					r0=r0+80;
					n0=int(r0*2*Math.PI/60);
					if (n0>branches.length-i) {
						n0=branches.length-i
					}
					dceta=(Math.PI*2)/n0;
					sa=ExpandLayout.Arrange(n0);
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
		private static function buffer(e):void{
			
			var t:int=getTimer();
			var branch:ExpandBranch;
			var tar:CompressedNode;
			
			var tmpArr:Array=[];
			
			while(getTimer()-t<18&&explodeArray.length>0){
				branch=explodeArray.shift();
				
				
				if (GxmlContainer.Block_space[branch.node_id]==null) {
					
					tar=Net.loadCompressedBlock(branch.node_id,"",branch.NAME,branch.father.Position[0],branch.father.Position[1],branch.TYPE);
					tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);
					tmpArr.push(tar);
					trace("[main]:Create Node:",tar.Name);
				}else{
					tar=GxmlContainer.Block_space[branch.node_id];
					tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);
					trace("[main]:Repeated Node:",tar.Name);
				}
				
				
				try{
					if(branch.DIRECT==0){
						Net.loadLink(branch.link_id,"",null,GxmlContainer.Block_space[branch.node_id],branch.father,branch.LinkType,null,true);
					}else{
						Net.loadLink(branch.link_id,"",null,branch.father,GxmlContainer.Block_space[branch.node_id],branch.LinkType,null,true);
					}
					trace("[main]:Create Link:",branch.link_id);
				}catch(error:Error) {
					trace("-----------------[Error @ main]:Fail to Create Link:",branch.link_id,branch.LinkType);
				}
				
			}
			
			GxmlContainer.RecordMultiNodeExistance(tmpArr,GxmlContainer.ADD_NODE);
			Navigator.refreshMap();
			PerspectiveViewer.refreshPerspective();
			if(explodeArray.length==0){
				explodeManager.removeEventListener(Event.ENTER_FRAME,buffer);
			}
			
		}
		
		private var ExpandList:Array=[];
		
		
		protected function expendlist(event:Event):void{
			
		}
	}
}