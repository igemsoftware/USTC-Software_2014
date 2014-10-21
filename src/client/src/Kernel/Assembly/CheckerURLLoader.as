package Kernel.Assembly 
{
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import UserInterfaces.ReminderManager.ReminderManager;
	
	public class CheckerURLLoader extends URLLoader
	{
		
		/**This URLLoader will give users hint for IO_ERROR. 
		 * 
		 */
		public function CheckerURLLoader(request:URLRequest=null)
		{
			super(request);
			addEventListener(IOErrorEvent.IO_ERROR,function (e):void{
				
				ReminderManager.remind("No server response. Please check your internet access");
				
			});
		}
		
	}
}