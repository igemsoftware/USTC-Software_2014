package 
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;

	public class PostManager
	{
		public function PostManager()
		{
		}
		public static function postXML(address:String,xml:XML):void{
			var posturl:URLRequest=new URLRequest(address);
			var postvar:URLVariables=new URLVariables();
			postvar.zhaosensen=xml.toXMLString();
			posturl.method="post";
			posturl.data=postvar
			sendToURL(posturl);
		}
		public static function post(address:String,c:*):void{
			var posturl:URLRequest=new URLRequest(address);
			var postvar:URLVariables=new URLVariables();
			postvar.info=c;
			posturl.method="post";
			posturl.data=postvar
			sendToURL(posturl);
			trace("POST:",c)
		}
		public static function postXMLwithReturn(address:String,xml:XML):void{
			
		}
	}
}