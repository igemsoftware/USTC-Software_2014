package Layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	public class FPSviewer extends Sprite
	{
		
		private var time:int;
		private var frames:int;
		private var FPSshow:TextField=new TextField();
		
		public function FPSviewer()
		{
			addChild(FPSshow);
			FPSshow.autoSize=TextFieldAutoSize.LEFT;
			FPSshow.background=true;
			addEventListener(Event.ENTER_FRAME,cont);
			time=getTimer();
		}
		
		
		protected function cont(event:Event):void
		{
			frames++;
			var dt:int=getTimer()-time;
			if (dt>500) {
				FPSshow.text=String("FPS:"+Math.round(1000/dt*frames));
				frames=0;
				time+=dt;
			}
			
			// TODO Auto-generated method stub
			
		}
		
	}
}