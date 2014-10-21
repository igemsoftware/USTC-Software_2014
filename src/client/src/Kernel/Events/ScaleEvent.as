package Kernel.Events{
	import flash.events.Event;
	
	/**
	 * This Event specified for transmiting Scale information.
	 * a number (scale) is included.
	 */
	
	public class ScaleEvent extends Event {
		
		///Enumeration of event types
		public static const 	SCALE_CHANGE:String="scaleChange" 
		public static const SCALE_SET:String="scaleSet"
		
		///transmiting scale
		public var scale:Number;
		
		
		public function ScaleEvent(type:String, Scale:Number,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			scale=Scale;
			super(type, bubbles, cancelable);
		}
	}
}