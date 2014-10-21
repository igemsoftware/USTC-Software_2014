package Kernel.Assembly{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	/**This Class is specified for mass loading process.
	 * an int is included as a member attribution, thus the index of the loader can be known in COMPLETE event handler
	 */
	public class LoaderWithNum extends Loader {
		
		public var num:int;
		public var url:String;
		
		public function LoaderWithNum(n:int,u:String)
		{
			num=n;
			url=u;
			super();
			load(new URLRequest(u));
		}
	}
}