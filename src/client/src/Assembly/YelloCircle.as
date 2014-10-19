package Assembly{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class YelloCircle extends Sprite{
		private var sh:Shape=new Shape();
		private var sx:Number,sy:Number;
		
		public function YelloCircle(r){
			redraw(r);
			addChild(sh);
			addEventListener(MouseEvent.MOUSE_DOWN,startM);
		}
		public function startM(e):void{
			dispatchEvent(new Event("StartDrag"));
			stage.addEventListener(MouseEvent.MOUSE_MOVE,Scaling);
			stage.addEventListener(MouseEvent.MOUSE_UP,endScaling);
		}
		
		protected function endScaling(event:MouseEvent):void{
			dispatchEvent(new Event("StopDrag"));
			stage.removeEventListener(MouseEvent.MOUSE_UP,endScaling);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,Scaling);
		}
		public function redraw(r):void{
			sh.graphics.clear();
			sh.graphics.lineStyle(3,0xffff00,0.8,true);
			sh.graphics.drawCircle(0,0,r);
			sh.graphics.lineStyle(10,0xffff00,0.3,true);
			sh.graphics.drawCircle(0,0,r);
		}
		protected function Scaling(event:MouseEvent):void{
			 var dl:Number=Math.sqrt(Math.pow(mouseX,2)+Math.pow(mouseY,2));
			 dispatchEvent(new Event("y_scaling"));
			 redraw(dl);
			 event.updateAfterEvent();
		}
	}
}