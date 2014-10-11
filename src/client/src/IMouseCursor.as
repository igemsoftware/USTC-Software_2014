package{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	
	public class IMouseCursor {
		
		public function IMouseCursor()
		{
			var m:MouseCursorData=new MouseCursorData();
			var gd:Grid_Drag=new Grid_Drag();
			var cur:BitmapData=new BitmapData(32,32,true,0);
			cur.draw(gd);
			m.data=new <BitmapData>[cur];
			m.hotSpot=new Point(gd.width/2,gd.height/2);
			Mouse.registerCursor("Grid_DragingCursor",m);
		}
	}
}