package GUI.Assembly{
	import flash.display.Sprite;
	
	
	public class ContentBox extends Sprite implements FlexibleLayoutObject {
		public function ContentBox(w=100,h=100)
		{
			setSize(w,h);
		}
		
		public function setSize(w:Number, h:Number):void
		{
			graphics.clear();
			graphics.beginFill(GlobalVaribles.SKIN_CONTENT_COLOR);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
}