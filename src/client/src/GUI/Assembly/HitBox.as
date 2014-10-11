package GUI.Assembly{
	import flash.display.Shape;
	
	import GUI.FlexibleLayoutObject;
	
	public class HitBox extends Shape implements FlexibleLayoutObject{
		
		public function HitBox(w=100,h=100){
			setSize(w,h);
		}
		
		public function setSize(w:Number,h:Number):void{
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
}