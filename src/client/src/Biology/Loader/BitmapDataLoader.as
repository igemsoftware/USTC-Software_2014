package Biology.Loader{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	
	public class BitmapDataLoader {
		
		public var data:BitmapData;
		
		public function BitmapDataLoader(url:String)
		{ 
			var loader:Loader=new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function (e):void{
				var bmp:Bitmap=Bitmap(loader);
				data=BitmapData(bmp.bitmapData);
			});
		}
		public function get bitmapData():BitmapData{
			return data;
		}
	}
}