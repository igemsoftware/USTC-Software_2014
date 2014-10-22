package Kernel.SmartLayout
{
	import flash.concurrent.Mutex;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import UserInterfaces.IvyBoard.IvyPanels.LayoutPanel;
	
	import UserInterfaces.ReminderManager.ReminderManager;
	
	import UserInterfaces.Style.TweenX;
	
	public class LayoutRunner
	{
		
		private static var backStage:Worker;
		protected static var mainToWorker:MessageChannel;
		protected static var workerToMain:MessageChannel;
		
		private static var layout_send_bytes:ByteArray=new ByteArray();
		private static var layout_receive_bytes:ByteArray=new ByteArray();
		
		private static var sendMutex:Mutex=new Mutex();
		private static var receiveMutex:Mutex=new Mutex();
		
		public function LayoutRunner()
		{
			backStage= WorkerDomain.current.createWorker(Workers.Kernel_SmartLayout_LayoutThread,true);
			
			mainToWorker= Worker.current.createMessageChannel(backStage);
			workerToMain= backStage.createMessageChannel(Worker.current);
			
			layout_send_bytes.shareable= true;
			layout_receive_bytes.shareable= true;
			
			backStage.setSharedProperty("LayoutRunner_SendMutex",sendMutex);
			backStage.setSharedProperty("LayoutRunner_returnMutex",receiveMutex);
			
			backStage.setSharedProperty("LayoutRunner_Send",layout_send_bytes);
			backStage.setSharedProperty("LayoutRunner_Receive",layout_receive_bytes);
			
			backStage.setSharedProperty("mainToBackStage",mainToWorker);
			backStage.setSharedProperty("BackStageToMain",workerToMain);
			
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE,onWorkerToMain);
			
			backStage.start();
		}
		protected function onWorkerToMain(event:Event):void
		{
			var msg:String=workerToMain.receive();
			if(msg=="Complete"){
				
				receiveMutex.lock();
				var node:CompressedNode;
				
				while(layout_receive_bytes.bytesAvailable>0){
					
					node=GxmlContainer.Node_Space[layout_receive_bytes.readUTF()];
					node.remPosition[0]=node.aimPosition[0]=layout_receive_bytes.readDouble();
					node.remPosition[1]=node.aimPosition[1]=layout_receive_bytes.readDouble();
					
				}
				
				layout_receive_bytes.length=0;
				
				receiveMutex.unlock();
				
				TweenX.GlideNodes(GxmlContainer.Node_Space);
			}
			
		}
		
		private static var socket:Socket = new Socket();
		private static var nodeList:Array;
		private static var linkList:Array;
		
		
		socket.endian = Endian.LITTLE_ENDIAN;
		
		
		public static function initGpuLayout():void{
			
			if(!socket.connected){
				
				OpenCLManager.activiteOpenCL();
				
				socket.addEventListener(Event.CONNECT,connectHandle);
				socket.addEventListener(Event.CLOSE,closeHandle);
				socket.addEventListener(ProgressEvent.SOCKET_DATA,receiveEvt);
				socket.connect("127.0.0.1",6197);
			}else{
				ReminderManager.remind("OpenCL Activited");
			}
		}
		
		private static var t:int;
		
		private static function runGPULayout():void{
			
			
			
			if(socket.connected){
				
				t=getTimer();
				
				nodeList=[];
				linkList=[];
				
				var rev:int;
				
				var bytes:ByteArray=new ByteArray();
				bytes.endian= Endian.LITTLE_ENDIAN;
				
				bytes.writeInt(0);
				for each (var node:CompressedNode in GxmlContainer.Node_Space) {
					nodeList.push(node);
					node.CLID=nodeList.length-1;
					bytes.writeDouble(node.Position[0]);
					bytes.writeDouble(node.Position[1]);
				}
				
				rev=bytes.position;
				
				bytes.writeInt(0);
				for each (var line:CompressedLine in GxmlContainer.Link_Space) {
					linkList.push(line);
					bytes.writeInt(line.linkObject[0].CLID);
					bytes.writeInt(line.linkObject[1].CLID);
				}
				var rev2:int=bytes.position;
				
				
				bytes.position=0;
				bytes.writeInt(nodeList.length);
				
				bytes.position=rev;
				bytes.writeInt(linkList.length);
				
				bytes.position=0;
				
				hs=0;
				
				socket.writeBytes(bytes);
				socket.flush();
			}else{
				ReminderManager.remind("OpenCL not activited");
				LayoutPanel.OpenCL_b.selected=false;
			}
		}
		
		private static var hs:int=0;
		protected static function receiveEvt(event:ProgressEvent):void
		{
			trace("receive: ",getTimer()-t);
			var node:CompressedNode;
			while(socket.bytesAvailable>=8&&hs<nodeList.length){
				node=nodeList[hs];
				if(node.CLID==hs){
					node.remPosition[0]=node.aimPosition[0]=socket.readFloat();
					node.remPosition[1]=node.aimPosition[1]=socket.readFloat();
				}
				if(hs==nodeList.length-1){
					hs==0;
					TweenX.GlideNodes(GxmlContainer.Node_Space);
					return;
				}
				hs++;
			}
		}
		
		protected static function closeHandle(event:Event):void
		{
			ReminderManager.remind("OpenCL Close");
			LayoutPanel.OpenCL_b.selected=false;
			
		}
		
		protected static function connectHandle(event:Event):void
		{
			ReminderManager.remind("OpenCL Activited");
			
		}
		
		private static function runLayout():void{
			if(sendMutex.tryLock()){
				
				layout_send_bytes.length=0;
				for each (var node:CompressedNode in GxmlContainer.Node_Space) {
					layout_send_bytes.writeUTF(node.ID);
					layout_send_bytes.writeDouble(node.Position[0]);
					layout_send_bytes.writeDouble(node.Position[1]);
				}
				layout_send_bytes.writeUTF("LINE");
				for each (var line:CompressedLine in GxmlContainer.Link_Space) {
					layout_send_bytes.writeUTF(line.ID);
					layout_send_bytes.writeUTF(line.linkObject[0].ID);
					layout_send_bytes.writeUTF(line.linkObject[1].ID);
				}
				
				sendMutex.unlock();
				
				mainToWorker.send("go!");
				
			}else{
				trace("Lock Busy");
			}
		}
		
		public static function RUNLayout(gpu:Boolean):void{
			if(gpu){
				runGPULayout()
			}else{
				runLayout();
			}
		}
	}
}