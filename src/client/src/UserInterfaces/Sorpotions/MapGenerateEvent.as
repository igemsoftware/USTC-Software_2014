package UserInterfaces.Sorpotions
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class MapGenerateEvent extends Event
	{
		public var map:Bitmap;
		public function MapGenerateEvent(type:String, m:Bitmap,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			map=m;
			super(type, bubbles, cancelable);
		}
	}
}