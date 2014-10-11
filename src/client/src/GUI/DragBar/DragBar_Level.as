package GUI.DragBar
{
	import flash.geom.Rectangle;

	public class DragBar_Level extends DragBar
	{
		public var Width:Number;
		public var Step:int;
		
		public function DragBar_Level(h,step=0){
			Step=step;
			Width=h;
			drager.y=-8;
			drager.scaleY=-1;
			drager.rotation=90;
			setSize();
		}
		override public function refresh(Set=false):void{
			Scale=Math.round(drager.x/Width*Step)/Step;
			if (Set&&Step!=0){
				drager.x=Scale*Width;
			}
		}
		override public function setSize(h=0):void{
			
			if (h==0) {
				h=Width;
			}else  {
				Width=h;
			}
			graphics.clear();
			graphics.lineStyle(1,0xffffff,0.7);
			graphics.lineTo(h,0);
			graphics.lineTo(h,-6);
			graphics.moveTo(0,0);
			graphics.lineTo(0,-6);
			drager.x=Scale*Width;
			DragRect=new Rectangle(0,-8,Width,0);
			for(var i:int=1;i<Step;i++){
				graphics.moveTo(Width/Step*i,0);
				graphics.lineTo(Width/Step*i,-4);
			}
		}
	}
}