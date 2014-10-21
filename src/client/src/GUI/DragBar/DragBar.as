package GUI.DragBar{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import Kernel.Events.ScaleEvent;
	
	import Kernel.SmartCanvas.Canvas.Net;

	public class DragBar extends Sprite{
		public var drager:ScaleDrager=new ScaleDrager();
		public var Scale:Number=1;
		public var DragRect:Rectangle;
		
		public function DragBar(){
			
			setSize();
			addChild(drager);
			drager.addEventListener(MouseEvent.MOUSE_DOWN,startdraging);
			
		}
		
		protected function end_draging(event:MouseEvent):void{
			refresh(true);
			drager.stopDrag();
			Net.ChangeScale(Scale,true);
			stage.removeEventListener(MouseEvent.MOUSE_UP,end_draging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,draging);
		}
		
		
		protected function draging(event:MouseEvent):void{
			refresh();
			Net.ChangeScale(Scale);
			event.updateAfterEvent();
		}
		
		protected function startdraging(event:MouseEvent):void
		{
			drager.startDrag(false,DragRect);
			stage.addEventListener(MouseEvent.MOUSE_UP,end_draging);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,draging);
		}		
		public function setSize(h=0):void{}
		public function refresh(Set=false):void{}
	}
}