package GUI.Scroll{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Style.Tween;

	public class scrollBar extends Sprite{
		private const NARROW_WIDTH:uint=6;
		private const WIDE_WIDTH:uint=18;
		
		public var Height:Number;
		public var Target:Scroll;
		private var sy:Number;
		private var ty:Number;
		private var lineWidth:Number=5;
		
		public function scrollBar(target:Scroll,h=200){
			Target=target;
			addEventListener(MouseEvent.MOUSE_DOWN,startRoll);
			addEventListener(MouseEvent.MOUSE_OVER,wide_evt);
			addEventListener(MouseEvent.MOUSE_OUT,narrow_evt);
		}
		
		protected function narrow_evt(e=null):void{
			removeEventListener(Event.ENTER_FRAME,widing);
			addEventListener(Event.ENTER_FRAME,narrowing);
		}
		
		protected function wide_evt(event:MouseEvent):void{
			removeEventListener(Event.ENTER_FRAME,narrowing);
			addEventListener(Event.ENTER_FRAME,widing);
		}
		
		protected function widing(event:Event):void{
			lineWidth=(lineWidth*2+WIDE_WIDTH)/3;
			if (WIDE_WIDTH-lineWidth<0.1) {
				removeEventListener(Event.ENTER_FRAME,widing);
			}
			reLocation();
		}
		protected function narrowing(event:Event):void{
			lineWidth=(lineWidth*2+NARROW_WIDTH)/3;
			if (lineWidth-NARROW_WIDTH<0.1) {
				removeEventListener(Event.ENTER_FRAME,narrowing);
			}
			reLocation();
		}
		
		protected function stopRoll(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,Rolling);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopRoll);
			addEventListener(MouseEvent.MOUSE_OUT,narrow_evt);
			if (!this.hitTestPoint(stage.mouseX,stage.mouseY)){
				narrow_evt();
			}
		}
		
		protected function startRoll(event:MouseEvent):void{
			sy=mouseY;
			ty=Target.rollPosition;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,Rolling);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopRoll);
			removeEventListener(MouseEvent.MOUSE_OUT,narrow_evt);
		}
		
		protected function Rolling(event:MouseEvent):void{
			Target.rollPosition=ty-(mouseY-sy)*Target.contentHeight/(Height);
			if (Target.rollPosition>0) {
				Target.rollPosition=0;
			}
			if (Target.rollPosition<Target.Height-Target.contentHeight) {
				Target.rollPosition=Target.Height-Target.contentHeight;
			}
		}
		public function setSize(h=0):void{
			if (h==0) {
				h=Height;
			}else {
				Height=h;
			}
			reLocation();
		}
		public function reLocation():void{
			if (Target.Content==null) {
				return;
			}
			var R_Height:Number=Target.Height/Target.contentHeight*Height;
			var R_Position:Number=-Target.Content.y/Target.contentHeight*Height;
			
			if (R_Height<Height){
				if (this.alpha!=1) {
					Tween.smoothIn(this);
					mouseEnabled=true;
				}
				this.graphics.clear();
				this.graphics.lineStyle(lineWidth,0,0.2);
				this.graphics.moveTo(-lineWidth/2.1,lineWidth/2);
				this.graphics.lineTo(-lineWidth/2.1,Height-lineWidth/2);
			
				this.graphics.lineStyle(lineWidth,0,0.5);
				
				
				if (R_Position>0) {
					this.graphics.moveTo(-lineWidth/2.1,R_Position+lineWidth/2);
				}else {
					this.graphics.moveTo(-lineWidth/2.1,lineWidth/2);
				}
				
				if (R_Position+R_Height<Height) {
					this.graphics.lineTo(-lineWidth/2.1,R_Position+R_Height-lineWidth/2);
				}else {
					this.graphics.lineTo(-lineWidth/2.1,Height);
				}
			}else{
				this.graphics.clear();
				this.graphics.lineStyle(lineWidth,0,0.5);
				this.graphics.moveTo(-lineWidth/2.1,2);
				this.graphics.lineTo(-lineWidth/2.1,Height-lineWidth/2);
				Tween.fadeOut(this);
				mouseEnabled=false;
			}
		}
	}
}