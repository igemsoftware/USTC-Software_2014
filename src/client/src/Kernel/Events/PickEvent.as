package Kernel.Events{
	import flash.events.Event;
	
	/**
	 * This Event specified for transmiting information of Picking a Node for the Net.
	 */
	
	public class PickEvent extends Event {
		public static const PICK:String="ClickOn";
		
		public var Multi:Boolean=false;
		
		public function PickEvent(type:String, multi=false ,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			Multi=multi;
			super(type, bubbles, cancelable);
		}
	}
}