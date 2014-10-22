package Kernel.ExpandThread{
	import flash.events.Event;
	
	import Kernel.SmartCanvas.CompressedNode;
	
	/**
	 * This Event specified for transmiting Expand information.
	 */
	
	public class ExpandEvent extends Event {
		
		///Enumeration of Event types
		public static const EXPAND:String="expand";
		public static const EXPAND_COMPLETE:String="expandComplete";
		
		///ExpandList contains all the branches.
		public var ExpandList:Array;
		
		///ExpandTarget is the node expand from
		public var ExpandTarget:CompressedNode;
		
		
		///Constructor 
		public function ExpandEvent(type:String,list:Array,tar:CompressedNode, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			ExpandList=list;
			ExpandTarget=tar;
			
			super(type, bubbles, cancelable);
		}
	}
}