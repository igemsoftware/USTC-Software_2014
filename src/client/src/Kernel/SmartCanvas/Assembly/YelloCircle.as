package Kernel.SmartCanvas.Assembly{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.Canvas.Net;
	
	
	
	public class YelloCircle extends Sprite{
		private var sh:Shape=new Shape();
		private var sx:Number,sy:Number;
		
		public function YelloCircle(r){
			redraw(r);
			addChild(sh);
			addEventListener(MouseEvent.MOUSE_DOWN,startM);
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				stage.addEventListener(MouseEvent.MOUSE_DOWN,hit);
			});
			addEventListener(Event.REMOVED_FROM_STAGE,function (e):void{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,hit);
			});
		}
		
		protected function hit(event:MouseEvent):void
		{
			if(event.target!=this&&event.target!=FreePlate.back){
				Net.cancel_centerView();
			}
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