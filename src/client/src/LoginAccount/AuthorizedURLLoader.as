package LoginAccount 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import Layout.ReminderManager;
	
	public class AuthorizedURLLoader extends URLLoader
	{
		
		public static const AUTHORIZE_FAILED:String="authorizedFailed";
		
		public function AuthorizedURLLoader(request:URLRequest=null)
		{
			if(request!=null&&GlobalVaribles.token!=null){
				var uloaderheader:URLRequestHeader=new URLRequestHeader("Authorization","Token "+GlobalVaribles.token);
				
				request.requestHeaders.push(uloaderheader);
				
			}
			
			addEventListener(Event.COMPLETE,function (e:Event):void{
				
				var tmp:String=String(data).split("'").join('"');
				
				try{
					var chk:Object=JSON.parse(tmp);
				
				
					if(chk.status=="error"){
						ReminderManager.remind(chk.reason);
						dispatchEvent(new AuthorizeEvent(AUTHORIZE_FAILED,chk.reason));
						e.stopImmediatePropagation();
					}
				}catch(e){
					
				}
				
			});
			
			super(request);
		}
		
		override public function load(request:URLRequest):void
		{
			
			if(GlobalVaribles.token!=null){
				
				var uloaderheader:URLRequestHeader=new URLRequestHeader("Authorization","Token "+GlobalVaribles.token);
				trace("push Header")
				request.requestHeaders.push(uloaderheader);
			}
			
			super.load(request);
		}
		
		
	}
}