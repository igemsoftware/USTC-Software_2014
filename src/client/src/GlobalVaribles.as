package 
{
	import flash.events.EventDispatcher;
	
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.ProjectManager;
	
	import LoginAccount.OauthLogin;

	public class GlobalVaribles
	{
		//"api.ailuropoda.org"
		
		
		public static var FocusedTarget:*;
		public static var EmergeBlock:CompressedNode;
		public static var EmergeLine:CompressedLine;
		
		public static var LeftHabit:Boolean=true;
		
		public static var eventDispatcher:EventDispatcher=new EventDispatcher();
		
		public static var showIconMap:Boolean=true;
		
		
		
		///////////Don't forget API.as
		
		public static var ServerAvailable:Boolean=false;
		
		public static const SERVER_ADDRESS:String="master.server.ailuropoda.org";
		public static const NODE_INTERFACE:String="http://"+SERVER_ADDRESS+"/data/node/";
		public static const LINK_INTERFACE:String="http://"+SERVER_ADDRESS+"/data/link/";
		public static const SEARCH_INTERFACE:String="http://"+SERVER_ADDRESS+"/search/node/";
		
		public static const SEQUENCE_ADDRESS:String="http://"+SERVER_ADDRESS+"/biopano/alignment/";
		public static const kShort_ADDRESS:String="http://"+SERVER_ADDRESS+"/biopano/find_way/"
		
		
		
		public static const PROJECT_INTERFACE:String="http://"+SERVER_ADDRESS+"/project/";
		public static const PROJECT_MY:String=PROJECT_INTERFACE+"project/";
		
		public static const PROJECT_SEARCH_USER:String="http://"+SERVER_ADDRESS+"/search/user/";
		
		public static function get PROJECT_LOAD_PROJECT():String{
			return "http://"+SERVER_ADDRESS+"/data/project/"+ProjectManager.ProjectID+"/";
		}
		
		public static function get PROJECT_USER():String{
			return PROJECT_INTERFACE+ProjectManager.ProjectID+"/collaborator/";
		}
		
		public static function get PROJECT_CURRENT():String{
			return PROJECT_INTERFACE+ProjectManager.ProjectID+"/";
		}
		
		
		public static const BaiduLogin:OauthLogin=new OauthLogin("baidu","http://openapi.baidu.com/oauth/2.0/authorize?");
		public static const GoogleLogin:OauthLogin=new OauthLogin("google","https://accounts.google.com/ServiceLogin");
		
		
		public static const SKIN_COLOR:uint=0x505050;
		public static const SKIN_ALPHA:Number=0.75;
		public static const SKIN_LINE_WIDTH:int=1;
		public static const SKIN_LINE_COLOR:int=0xffffff;
		public static const SKIN_CONTENT_COLOR:int=0xffffff;
		
		public static const SKIN_WINDOW_COLOR:uint=0x909090;
		
		public static var token:String;
		public static var userName:String;
		
	
	}
}