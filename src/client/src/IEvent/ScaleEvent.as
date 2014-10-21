package IEvent{
	import flash.events.Event;
	
	
	public class ScaleEvent extends Event {
		
		public static const 	SCALE_CHANGE:String="scaleChange" 
		public static const SCALE_SET:String="scaleSet"
		
		
		public var scale:Number;
		
		
		public function ScaleEvent(type:String, Scale:Number,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			scale=Scale;
			super(type, bubbles, cancelable);
		}
	}
}