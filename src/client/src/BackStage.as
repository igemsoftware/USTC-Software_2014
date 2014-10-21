package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	import air.net.URLMonitor;
	
	
	public class BackStage extends Sprite {
		
		
		include "API.as"
		
		private var ServerMon:URLMonitor=new URLMonitor(new URLRequest(SERVER_ADDRESS));
		
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		
		public function BackStage()
		{
			
			
			mainToWorker= Worker.current.getSharedProperty("mainToBackStage");
			workerToMain = Worker.current.getSharedProperty("BackStageToMain");
			
			
			
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE,onMainToWorker);

			
			/////////
			ServerMon.start();
			ServerMon.addEventListener(StatusEvent.STATUS,function (e:StatusEvent):void{
				if(ServerMon.available){
					workerToMain.send("serverConnected");
				}else{
					workerToMain.send("serverDisconnected");
				}
			});
		}
		
		protected function onMainToWorker(event:Event):void
		{
			var msg:*= mainToWorker.receive();
		/*	if(msg==""){
				
			}*/
		}
	}
}