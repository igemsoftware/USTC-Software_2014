package Kernel.Events{
	import flash.events.Event;
	
	/**
	 * This Event specified for transmiting Focus information.
	 */
	
	public class FocusItemEvent extends Event {
		
		public static const FOCUS_CHANGE:String="Focus_Change";
		
		public var focusTarget:*;
		
		public function FocusItemEvent(type:String,tar,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			focusTarget=tar;
			super(type, bubbles, cancelable);
			
		}
	}
}