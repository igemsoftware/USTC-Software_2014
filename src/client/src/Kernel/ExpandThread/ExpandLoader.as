package Kernel.ExpandThread{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * This URLLoader has NodeID and mode properties.
	 * specified for mass loading of expanded nodes.
	 * @see ExpandManager.as
	 */
	
	public class ExpandLoader extends URLLoader{
		
		///node for which this loader loads
		public var NodeID:String;
		
		///Expand mode
		public var mode:int;
		
		public function ExpandLoader()
		{
			super(null);
		}
		
		/**
		 * Load branches by ID of a node
		 */
		public function loadID(ID):void{
			NodeID=ID;
			trace("[Loader]:grab",GlobalVaribles.EXPAND_INTERFACE+NodeID+"/link/")
			load(new URLRequest(GlobalVaribles.EXPAND_INTERFACE+NodeID+"/link/"));
		}
	}
}