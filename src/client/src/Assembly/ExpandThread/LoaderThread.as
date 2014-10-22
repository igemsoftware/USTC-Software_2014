package Assembly.ExpandThread{
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	
	
	public class LoaderThread extends Sprite{
		
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		
		protected var returnBytes:ByteArray,sendBytes:ByteArray;
		
		public static var Loader_space:Array=new Array();
		public static var Loaders:Array=new Array();
		
		protected var returnBytesMutex:Mutex;
		protected var sendBytesMutex:Mutex;
		
		private var EdgeLoader:URLLoader_Edges;
		private var Queue:Array=[];
		private var running:Boolean=false;
		
		public function LoaderThread(){
			
			EdgeLoader=new URLLoader_Edges();
			
			returnBytesMutex = Worker.current.getSharedProperty("Loader_returnBytesMutex") as Mutex;
			sendBytesMutex = Worker.current.getSharedProperty("Loader_sendBytesMutex") as Mutex;
			
			mainToWorker= Worker.current.getSharedProperty("MainToLoaderThread");
			workerToMain = Worker.current.getSharedProperty("LoaderThreadToMain");
			
			returnBytes= Worker.current.getSharedProperty("Loader_returnBytes");
			sendBytes=Worker.current.getSharedProperty("Loader_sendBytes");
			
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE,onMainToWorker);
			
		}
		protected function onMainToWorker(event:Event):void
		{
			var msg:*= mainToWorker.receive();
			if(msg=="Start"){
				
				sendBytesMutex.lock();
				trace("[Worker]:Now Process");
				sendBytes.position=0;
				while(sendBytes.bytesAvailable>0){
					var key:String=sendBytes.readUTF();
					if(key=="<CheckEdges>"){
						Queue.push(sendBytes.readUTF());
					}
				}
				sendBytes.clear();
				
				Worker.current.setSharedProperty("Main_RestorePosition",true);
				
				sendBytesMutex.unlock();
				
				if(!running){
					running=true;
					Next();
				}
				
			}
		}
		
		
		////////////Load Method
		public function LoadEdges(ID):void{
			
			EdgeLoader.loadID(ID);
			
			EdgeLoader.addEventListener(Event.COMPLETE,EdgeLoader_CMP);
			EdgeLoader.addEventListener(IOErrorEvent.IO_ERROR,IOError_evt);
		}
		
		protected function IOError_evt(event:IOErrorEvent):void
		{
			trace("[Worker:]Fail to Expand:",event.target.NodeID);
			Next();
		}
		
		protected function EdgeLoader_CMP(event:Event):void{
			// TODO Auto-generated method stub
			var edges:Object=JSON.parse('{"results":'+event.target.data+"}");
			trace("[Worker]:LoaderCMP:",event.target.data);
			
			returnBytesMutex.lock();
			
			trace("[Worker]:Precessing");
			
			if(Worker.current.getSharedProperty("Loader_RestorePosition")){
				Worker.current.setSharedProperty("Loader_RestorePosition",false);
				returnBytes.clear();
				trace("[Worker]:Clear")
			}
			
			returnBytes.writeUTF("[Edge]");
			
			returnBytes.writeUTF(event.target.NodeID);
			
			returnBytes.writeInt(edges.results.length);
			
			for (var i:int = 0; i < edges.results.length; i++) {
				returnBytes.writeUTF(edges.results[i].link_id);
				returnBytes.writeUTF(edges.results[i].node_id);
				returnBytes.writeUTF(edges.results[i].NAME);
				returnBytes.writeUTF(edges.results[i].TYPE);
				returnBytes.writeUTF(edges.results[i].link_type);
				returnBytes.writeInt(edges.results[i].DIRECT);
			}
			
			returnBytesMutex.unlock();
			
			workerToMain.send("Loaded");
			
			Next();
		}
		
		private function Next():void{
			// TODO Auto Generated method stub
			trace("[Worker]:Expand in Queue:",Queue.length);
			if(Queue.length>0){
				LoadEdges(Queue.shift());
			}else{
				running=false;
			}
			
		}
	}
}


