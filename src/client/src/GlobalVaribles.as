/**
 * This class contains most of the static varibles used repeadly or modified frequently.
 * These kinds of Variables are included:
 * 1. Global Focus Event
 * 2. User Appreciation
 * 3. API Address
 * 4. UI Skin Style
 * */
package 
{
	

	import flash.events.EventDispatcher;
	
	import Kernel.ProjectHolder.ProjectManager;
	
	import UserInterfaces.LoginAccount.OauthLogin;

	public class GlobalVaribles
	{
		
		///for focus
		
		public static var FocusedTarget:*;
		public static var FocusEventDispatcher:EventDispatcher=new EventDispatcher();

		
		///for user appreciation
		
		public static var LeftHabit:Boolean=true;
		public static var showIconMap:Boolean=true;
		
		
		
		///APIs to backend:
		
		///sever used
		public static const SERVER_ADDRESS:String="api.biopano.org";
		public static var ServerAvailable:Boolean=false;
		
		///These are Interfaces for cloud function
		public static const NODE_INTERFACE:String="http://"+SERVER_ADDRESS+"/data/node/";
		
		public static const SYNC_INTERFACE:String="http://"+SERVER_ADDRESS+"/biopano/sync/";
				
		public static const LINK_INTERFACE:String="http://"+SERVER_ADDRESS+"/data/link/";
		
		public static const BATCH_INTERFACE:String="http://"+SERVER_ADDRESS+"/biopano/batch/";
		
		public static const SEARCH_INTERFACE:String="http://"+SERVER_ADDRESS+"/search/node/";
		
		public static const EXPAND_INTERFACE:String="http://"+SERVER_ADDRESS+"/biopano/node/";
		
		public static const SEQUENCE_INTERFACE:String="http://"+SERVER_ADDRESS+"/biopano/alignment/";
		
		public static const KSHORT_INTERFACE:String="http://"+SERVER_ADDRESS+"/biopano/find_way/"
		
		///Project Interfaces:
		public static const PROJECT_INTERFACE:String="http://"+SERVER_ADDRESS+"/project/";
		
		public static const PROJECT_MY:String=PROJECT_INTERFACE+"project/";
		
		public static const PROJECT_SEARCH_USER:String="http://"+SERVER_ADDRESS+"/search/user/";
		
	
		/**
		 * @name: PROJECT_LOAD_PROJECT
		 * @return: the URL to load project by current ProjectID
		 * @see: Kernel.ProjectHolder.ProjectManager.openProject
		 * */
		public static function get PROJECT_LOAD_PROJECT():String
		{
			return "http://"+SERVER_ADDRESS+"/data/project/"+ProjectManager.ProjectID+"/";
		}
		
		
		public static function get PROJECT_COLLABORATOR():String{
			/**
			 * @return the URL to load project by current ProjectID
			 * @see Kernel.ProjectHolder.ProjectManager
			 * */
			return PROJECT_INTERFACE+ProjectManager.ProjectID+"/collaborator/";
		}
		
		public static function get PROJECT_CURRENT():String{
			/**
			 * @return the URL to current Project
			 * @see Kernel.ProjectHolder.ProjectManager
			 * */
			return PROJECT_INTERFACE+ProjectManager.ProjectID+"/";
		}
		
		///These are varibles for Login, include two OauthLogin URL
		///see Class: OauthLogin
		public static const BaiduLogin:OauthLogin=new OauthLogin("baidu","http://openapi.baidu.com/oauth/2.0/authorize?");
		public static const GoogleLogin:OauthLogin=new OauthLogin("google","https://accounts.google.com/");
		public static var token:String;
		public static var userName:String; 

		
		///These are data for skin
		public static const SKIN_LINE_WIDTH:int=1;
		
		public static const SKIN_LINE_COLOR:int=0xffffff;
		
		public static const SKIN_CONTENT_COLOR:int=0xffffff;
		
		public static const SKIN_WINDOW_COLOR:uint=0x909090;
		
		public static const SKIN_COLOR:uint=0x505050;
		
		public static const SKIN_ALPHA:Number=0.75;

	}
}
