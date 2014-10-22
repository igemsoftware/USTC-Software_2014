package Kernel.SmartCanvas.Assembly
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import UserInterfaces.Style.FilterPacket;
	

	public class FocusCircle extends Sprite{
		
		private var CircleShape:Shape=new Shape();
		
		public function FocusCircle(r){
			CircleShape.alpha=1;
			cacheAsBitmap=true;
			redraw(r);
			CircleShape.filters=[FilterPacket.WhiteGlow];
			addChild(CircleShape);
		}
		
		public function redraw(r):void
		{
			CircleShape.graphics.clear();
			CircleShape.graphics.beginFill(0xffffff);
			CircleShape.graphics.drawCircle(0,0,r);
			CircleShape.graphics.endFill();
			
		}
	}
}