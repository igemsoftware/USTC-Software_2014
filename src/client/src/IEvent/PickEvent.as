package IEvent{
	import flash.events.Event;
	
	
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