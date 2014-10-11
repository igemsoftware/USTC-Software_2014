package GUI.Assembly{
	import flash.display.Shape;
	
	
	public class SkinBox extends Shape {
		
		public static const DIM_SKIN:int=0;
		public static const LIGHT_SKIN:int=1;
		
		private var Type:int;
		
		public function SkinBox(type=DIM_SKIN)
		{
			Type=type;
			
		}
		
		public function setSize(w:Number, h:Number):void
		{
			graphics.clear();
			graphics.lineStyle(GlobalVaribles.SKIN_LINE_WIDTH,GlobalVaribles.SKIN_LINE_COLOR,1,true);
			switch(Type)
			{
				case DIM_SKIN:
					graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
					break;
				case LIGHT_SKIN:
					graphics.beginFill(GlobalVaribles.SKIN_CONTENT_COLOR,GlobalVaribles.SKIN_ALPHA);
					break;
			}
			
			graphics.drawRoundRect(0,0,w,h,5,5);
			graphics.endFill();
		}
	}
}