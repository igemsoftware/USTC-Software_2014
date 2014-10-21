package Biology.Loader{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	
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