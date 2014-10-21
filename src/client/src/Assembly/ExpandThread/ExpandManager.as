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
	
	import IEvent.ExpandEvent;
	
	import Assembly.ProjectHolder.GxmlContainer;
	import Assembly.Compressor.CompressedNode;
	
	
	public class ExpandManager {
		
		private var expandBuffer:Sprite=new Sprite();
		private var LoaderBuffer:Sprite=new Sprite();
		
		public static var ExpandResult:Array=[];
		
		protected static var mainToWorker:MessageChannel;
		protected static var workerToMain:MessageChannel;
		protected static var loaderThread:Worker;
		
		protected static var returnBytes:ByteArray=new ByteArray();
		protected static var sendBytes:ByteArray=new ByteArray();
		
		protected static var returnBytesMutex:Mutex=new Mutex();
		protected static var sendBytesMutex:Mutex=new Mutex();
		
		public function ExpandManager()
		{
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
		}
		
		public static function Expand(tar:CompressedNode):*{
			
			if(ExpandResult[tar.ID]==null){
				ExpandResult[tar.ID]=new EventDispatcher();
				if(sendBytesMutex.tryLock()){
					
					
					if(loaderThread.getSharedProperty("Main_RestorePosition")){
						loaderThread.setSharedProperty("Main_RestorePosition",false);
						sendBytes.clear();
						trace("[Main]:Clear")
					}
					
					sendBytes.writeUTF("<CheckEdges>");
					sendBytes.writeUTF(tar.ID);
					
					sendBytesMutex.unlock();
				}
				mainToWorker.send("Start");	
			}
			return ExpandResult[tar.ID];
		}
		protected function onWorkerToMain(event:Event):void{
			var msg:*= workerToMain.receive();
			
			trace("[Main]:",msg);
			if(msg=="Loaded"){
				if(!LoaderBuffer.hasEventListener(Event.ENTER_FRAME)){
					LoaderBuffer.addEventListener(Event.ENTER_FRAME,CheckLoader);
				}
			}
		}
		private var currentPostion:int=0;
		protected function CheckLoader(e):void{
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
						
						(ExpandResult[tar.ID] as EventDispatcher).dispatchEvent(new ExpandEvent(ExpandEvent.EXPAND_COMPLETE,edges,tar));
						delete ExpandResult[tar.ID];
						currentPostion=returnBytes.position;
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
		
	}
}