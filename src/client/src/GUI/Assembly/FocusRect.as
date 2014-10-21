package GUI.Assembly
{
	import flash.display.Shape;
	
	import UserInterfaces.Style.FilterPacket;
	
	public class FocusRect extends Shape
	{
		
		public var focusItem:*
		
		public function FocusRect()
		{
			
		}
		public function setItem(item):void{
			graphics.clear();
			focusItem=item;
			if(focusItem!=null){
				graphics.lineStyle(2,0x0000ff,0.6);
				graphics.drawRect(item.x,item.y,item.width,item.height);
				this.filters=[FilterPacket.ThinHightLightGlow];
			}
		}
		
		public function redraw():void{
			if(focusItem!=null){
				setItem(focusItem);
			}
		}
	}
}