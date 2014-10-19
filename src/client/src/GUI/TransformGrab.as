package GUI {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TransformGrab extends MovieClip {
		private const LINE_COLOR:uint=0xeeeeff;
		
		private var handle1:gruber=new gruber();
		private var handle2:gruber=new gruber();
		private var handle3:gruber=new gruber();
		private var handle4:gruber=new gruber();
		public var Width:Number,Height:Number;
		public var target:*;
		public var minWidth:Number,minHeight:Number;

		public function TransformGrab(obj,minw=80,minh=50) {
			target=obj;
			resetScale(minw,minh);
			handle1.addEventListener(MouseEvent.MOUSE_DOWN,startdraging);
			handle2.addEventListener(MouseEvent.MOUSE_DOWN,startdraging);
			handle3.addEventListener(MouseEvent.MOUSE_DOWN,startdraging);
			handle4.addEventListener(MouseEvent.MOUSE_DOWN,startdraging);
			addEventListener(MouseEvent.MOUSE_UP,stopdraging);
			addChild(handle1);
			addChild(handle2);
			addChild(handle3);
			addChild(handle4);
		}
		public function resetScale(minw=80,minh=50):void{
			minWidth=minw;
			minHeight=minh+8;
			this.graphics.clear();
			handle1.x=- target.Width/2-4;
			handle1.y=- target.Height/2-4;
			handle2.x=target.Width/2+4;
			handle2.y=- target.Height/2-4;
			handle3.x=- target.Width/2-4;
			handle3.y=target.Height/2+4;
			handle4.x=target.Width/2+4;
			handle4.y=target.Height/2+4;
			this.graphics.lineStyle(0,LINE_COLOR,0.7,true);
			this.graphics.drawRect(-target.Width/2-4,-target.Height/2-4,target.Width+8,target.Height+8);
		}
		private var startx:Number,starty:Number,currentDrag:*;
		private function startdraging(e):void{
			startx=this.mouseX;
			starty=this.mouseY;
			currentDrag=e.target;
			e.target.addEventListener(MouseEvent.MOUSE_MOVE,draging);
			e.target.addEventListener(Event.ENTER_FRAME,draging);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdraging);
		}
		private function draging(e):void{
			if (Math.abs(mouseX)>minWidth/2) {
				e.target.x=mouseX;
			} else {
				e.target.x=minWidth/2;
			}
			if (Math.abs(mouseY)>minHeight/2) {
				e.target.y=mouseY;
			} else {
				e.target.y=minHeight/2;
			}
			Width=Math.abs(e.target.x)-4;
			Height=Math.abs(e.target.y)-4;
			handle1.x=- Width-4;
			handle1.y=- Height-4;
			handle2.x=Width+4;
			handle2.y=- Height-4;
			handle3.x=- Width-4;
			handle3.y=Height+4;
			handle4.x=Width+4;
			handle4.y=Height+4;
			Width*=2;
			Height*=2;
			target.setScale(Width,Height);
			this.graphics.clear();
			this.graphics.lineStyle(0,LINE_COLOR,0.6,true);
			this.graphics.drawRect(-Width/2-4,-Height/2-4,Width+8,Height+8);
			try {
				e.updateAfterEvent();
			} catch (er) {

			}
		}
		private function stopdraging(e):void {
			currentDrag.removeEventListener(MouseEvent.MOUSE_MOVE,draging);
			currentDrag.removeEventListener(Event.ENTER_FRAME,draging);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdraging);
		}
	}
}