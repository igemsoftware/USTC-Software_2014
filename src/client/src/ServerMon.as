package
{
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import Dock.SearchingPad;
	
	import air.net.URLMonitor;

	public class ServerMon
	{
		
		include "API.as"
		
		private var ServerMon:URLMonitor=new URLMonitor(new URLRequest(SERVER_ADDRESS));
		
		public function ServerMon()
		{
			ServerMon.start();
			ServerMon.addEventListener(StatusEvent.STATUS,function (e:StatusEvent):void{
				if(ServerMon.available){
					SearchingPad.webIndecator.visible=true;
				}else{
					SearchingPad.webIndecator.visible=false;
				}
			});
		}
	}
}