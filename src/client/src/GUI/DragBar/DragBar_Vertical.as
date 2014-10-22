package GUI.DragBar
{

	import flash.geom.Rectangle;
	
	public class DragBar_Vertical extends DragBar{
		
		
		private var Height:Number;
		
		public function DragBar_Vertical(h){
			Height=h;
			drager.x=-10;
		}
		override public function refresh(Set=false):void{
			Scale=drager.y/Height*0.8+0.2;
		}
		public function showScale(s):void{
			Scale=s;
			drager.y=(Scale-0.2)*Height/0.8;
		}
		override public function setSize(h=0):void{
			
			if (h==0) {
				h=Height;
			}else  {
				Height=h;
			}
			graphics.clear();
			graphics.lineStyle(1,0xffffff,0.7);
			graphics.lineTo(0,h);
			graphics.lineTo(-8,h);
			graphics.moveTo(0,0);
			graphics.lineTo(-8,0);
			drager.y=(Scale-0.2)*Height/0.8;
			DragRect=new Rectangle(-10,0,0,Height);
		}
	}
}