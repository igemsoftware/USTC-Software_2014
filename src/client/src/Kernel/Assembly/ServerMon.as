package Kernel.Assembly
{
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import UserInterfaces.Dock.SearchingPad;
	
	import air.net.URLMonitor;

	
	/**Server Monitor for api.biopano.org
	 * if sever is availible, a green global icon will show in the search box on the right bottom.
	 */
	
	public class ServerMon
	{
		
		private var ServerMon:URLMonitor=new URLMonitor(new URLRequest(GlobalVaribles.SERVER_ADDRESS));
		
		public function ServerMon()
		{
			ServerMon.start();
			
			/**
			 * manage the Icon by access status
			 */
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