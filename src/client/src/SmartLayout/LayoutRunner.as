package SmartLayout
{
	import flash.concurrent.Mutex;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Style.TweenX;
	
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
			backStage= WorkerDomain.current.createWorker(Workers.SmartLayout_BackStage,true);
			
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
					
					node=GxmlContainer.Block_space[layout_receive_bytes.readUTF()];
					node.aimPosition[0]=layout_receive_bytes.readDouble();
					node.aimPosition[1]=layout_receive_bytes.readDouble();
					
				}
				
				layout_receive_bytes.length=0;
				
				receiveMutex.unlock();
				
				TweenX.GlideNodes(GxmlContainer.Block_space);
			}
			
		}
		
		public static function runLayout():void{
			if(sendMutex.tryLock()){
				
				layout_send_bytes.length=0;
				for each (var node:CompressedNode in GxmlContainer.Block_space) {
					layout_send_bytes.writeUTF(node.ID);
					layout_send_bytes.writeDouble(node.Position[0]);
					layout_send_bytes.writeDouble(node.Position[1]);
				}
				layout_send_bytes.writeUTF("LINE");
				for each (var line:CompressedLine in GxmlContainer.Linker_space) {
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
		
	}
}