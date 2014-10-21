package Layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import Style.FontPacket;

	public class Reminder extends Sprite
	{
		
		private var text:TextField=new TextField();
		
		public var aimY:Number;
		
		public var aimAlpha:Number=0;
		
		
		public function Reminder(msg)
		{
			text.defaultTextFormat=FontPacket.WhiteContentText;
			text.autoSize="left"
			text.text=msg;
			addChild(text);
			graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			graphics.drawRoundRect(0,0,text.width+4,text.height+4,8,8);
			
			alpha=0;
			
			text.x=text.y=2;
			
			var t:Timer=new Timer(2000,1);
			t.addEventListener(TimerEvent.TIMER,function (e):void{
				dispatchEvent(new Event("ease"));
			});
			
			t.start();
		}
		
	}
}