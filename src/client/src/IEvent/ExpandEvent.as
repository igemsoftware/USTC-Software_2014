package IEvent{
	import flash.events.Event;
	
	import Assembly.Compressor.CompressedNode;
	
	
	
	public class ExpandEvent extends Event {
		public static const EXPAND:String="expand";
		public static const EXPAND_COMPLETE:String="expandComplete";
		
		public var ExpandList:Array;
		public var ExpandTarget:CompressedNode;
		
		public function ExpandEvent(type:String,list:Array,tar:CompressedNode, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			ExpandList=list;
			ExpandTarget=tar;
			
			super(type, bubbles, cancelable);
		}
	}
}