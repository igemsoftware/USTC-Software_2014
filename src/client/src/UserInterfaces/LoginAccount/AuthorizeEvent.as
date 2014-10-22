package UserInterfaces.LoginAccount
{
	import flash.events.Event;
	
	/**
	 * authorized event
	 */
	public class AuthorizeEvent extends Event
	{
		
		public static const AUTHORIZE_FAILED:String="authorizedFailed";
		
		
		public var status:String;
		
		public function AuthorizeEvent(type:String, statu,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			status=statu;
			super(type, bubbles, cancelable);
		}
	}
}