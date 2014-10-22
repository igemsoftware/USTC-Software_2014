package UserInterfaces.FunctionPanel.GoogleAPI
{
	import flash.display.Sprite;
	
	import UserInterfaces.Style.Tween;

	public class GooglePageAppend extends Sprite
	{
	
		private var arrow:Sprite=new Sprite();
		
		public function GooglePageAppend(){
			
			buttonMode=true;
			useHandCursor=true;
			
			arrow.graphics.clear()
			arrow.graphics.lineStyle(0,0xddddddd);
			arrow.graphics.moveTo(-30,10);
			arrow.graphics.lineTo(0,30);
			arrow.graphics.lineTo(30,10);
			
			addChild(arrow);
		}
		public function setSize(w):void{
			
			graphics.clear();
			
			graphics.lineStyle(0,0xddddddd);
			graphics.beginFill(0xffffff);
			graphics.drawRect(0,0,w,40);
			graphics.endFill();
			
			arrow.x=w/2;
			
		}
		
		
		public function unsuspend():void
		{
			Tween.smoothIn(arrow);
			
		}
		
		public function suspend():void
		{
			Tween.fadeOut(arrow);
			// TODO Auto Generated method stub
			
		}
	}
}