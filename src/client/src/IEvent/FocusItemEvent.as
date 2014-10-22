package IEvent{
	import flash.events.Event;
	
	
	public class FocusItemEvent extends Event {
		
		public static const FOCUS_CHANGE:String="Focus_Change";
		public static const CENTERLIZE:String="centerlize";
		
		public var focusTarget:*;
		
		public function FocusItemEvent(type:String,tar,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			focusTarget=tar;
			super(type, bubbles, cancelable);
			
		}
	}
}