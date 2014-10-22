package UserInterfaces.Sorpotions{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import GUI.Assembly.FlexibleLayoutObject;
	
	import UserInterfaces.Style.FontPacket;
	
	public class Sorption extends Sprite implements FlexibleLayoutObject {
		
		private var frame:Sprite=new Sprite();
		private var Target:*;
		private var tf:TextField=new TextField();
		
		public function Sorption(tar,str){
			Target=tar;
			
			setSize(tar.width,tar.height);
			
			tf.defaultTextFormat=FontPacket.WhiteContentText;
			tf.selectable=false;
			tf.text=str;
			tf.autoSize="left";
			tf.mouseEnabled=false;
			
			addChild(frame);
			addChild(tf);
			addChild(tar);
			
			TweenHeight();
			
			frame.addEventListener(MouseEvent.MOUSE_DOWN,TweenHeight);
			
			frame.cacheAsBitmap=true;
		}
		
		private var ay:Number;
		
		private var FoldY:int;
		
		public function TweenHeight(e=null):void{
			if(ay==FoldY){
				ay=0;
				Target.active();
			}else{
				ay=FoldY;
				Target.inactive();
			}
			removeEventListener(Event.ENTER_FRAME,TweenScaling);
			addEventListener(Event.ENTER_FRAME,TweenScaling);
		}
		
		private function TweenScaling(e):void{
			y=(y*2+ay)/3;
			if (Math.abs(y-FoldY)<0.4) {
				this.y=ay;
				removeEventListener(Event.ENTER_FRAME,TweenScaling);
			}
		}
		
		public function setSize(w:Number, h:Number):void{
			FoldY=-h-4;
			
			frame.graphics.clear();
			frame.graphics.lineStyle(1,GlobalVaribles.SKIN_LINE_COLOR);
			frame.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			frame.graphics.drawRect(0,0,w+4,h+24);
			frame.graphics.endFill();
			
			Target.y=Target.x=2;
			
			tf.y=h;
			
		}
	}
}