package Assembly.ExpandThread{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLoader_Edges extends URLLoader{
		
		include "API.as"
		
		public var NodeID:String;
		
		public function URLLoader_Edges()
		{
			
			super(null);
		}
		
		public function loadID(ID):void{
			NodeID=ID;
			trace("[Loader]:grab",EXPAND_INTERFACE+NodeID+"/link/")
			load(new URLRequest(EXPAND_INTERFACE+NodeID+"/link/"));
		}
	}
}