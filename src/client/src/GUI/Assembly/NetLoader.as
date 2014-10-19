package GUI.Assembly
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class NetLoader extends Sprite
	{
		private var loadmark:LoadingMark=new LoadingMark;
		public var loader:Loader=new Loader;
		public var cache:Bitmap;
		public function NetLoader(){
			addChild(loadmark);
		}
		public function load(url:URLRequest):void{
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,cmp);
		}
		protected function cmp(event:Event):void{
			removeChild(loadmark);
			var db:BitmapData=new BitmapData(event.target.width,event.target.height);
			db.draw(event.target.content);
			cache=new Bitmap(db,"auto",true);		
			addChild(cache);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,cmp);
		}
	}
}