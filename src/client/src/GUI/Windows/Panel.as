package GUI.Windows{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import Style.FilterPacket;
	import Style.FontPacket;
	import Style.Tween;
	
	
	public class Panel extends Sprite{
		
		public var title:TextField=new TextField();
		public var backGround:Sprite=new Sprite();
		public var backGroundShadow:Shape=new Shape();
		private var closeButton:close_button=new close_button();
		public var aimY:Number;
		public var Content:*;
		public var flexable:Boolean=false;
		
		private var SX:Number,SY:Number;
		
		public function Panel(nam,Target:Object,sx=300,sy=300){
			var w:Number,h:Number;
			
			this.cacheAsBitmap=true;
			
			Content=Target;
			
			if(Target.hasOwnProperty("Height")){
				SY=sy-Content.Height/2;
			}else{
				SY=sy-Content.height/2;
			}
			SX=sx-Content.width/2;
			this.x=SX;
			aimY=SY;
			
			title.x=title.y=9;
			title.defaultTextFormat=FontPacket.WhiteTitleText;
			title.mouseEnabled=false;
			title.autoSize="left";
			title.text=nam;
			
			closeButton.addEventListener("click",close);
			
			Content.y=title.height+10;
			Content.x=5;
			
			addChild(backGroundShadow);
			addChild(backGround);
			addChild(Content);
			addChild(closeButton);
			addChild(title);
			
			if(Content.hasOwnProperty("Width")){
				w=Content.Width;
			}else{
				w=Content.width;
			}
			
			if(Content.hasOwnProperty("Height")){
				h=Content.Height;
			}else{
				h=Content.height;
			}
				
			setSize(w+9,h+title.height+15);
			
			addEventListener(MouseEvent.MOUSE_DOWN,focus_evt);
			this.addEventListener(MouseEvent.MOUSE_DOWN,draging);
			Target.addEventListener("close",close);
			Target.addEventListener("closeDelay",close_delay);
			Tween.floatIn(this);
		}
		
		protected function focus_evt(event:MouseEvent):void{
			if (event.target!=closeButton) {	
				dispatchEvent(new Event("focused"));
			}
		}

		public function setSize(w:Number,h:Number):void{			
			backGround.graphics.clear();
			backGround.graphics.lineStyle(0,0xcccccc,1,true);
			backGround.graphics.beginFill(GlobalVaribles.SKIN_WINDOW_COLOR,GlobalVaribles.SKIN_ALPHA);
			backGround.graphics.drawRoundRect(0,0, w,h,15,15);
			backGround.graphics.endFill();
			
			backGroundShadow.graphics.clear();
			backGroundShadow.graphics.lineStyle(0);
			backGroundShadow.graphics.beginFill(0x000000,0.6);
			backGroundShadow.graphics.drawRoundRect(-4,-4, w+8,h+10,15,15);
			backGroundShadow.graphics.endFill();
			backGroundShadow.filters=[FilterPacket.ShadowBlur];
			
			closeButton.x=w-closeButton.width-4;
			closeButton.y=10;
		}
		protected function close(e):void{
			Tween.floatOut(this);
		}
		
		protected function close_delay(e):void{
			addEventListener(Event.ENTER_FRAME,tick_evt);
			Content.addEventListener("close",close);
			Content.addEventListener("closeDelay",close_delay);
		}
		private var ticks:uint=0;
		protected function tick_evt(event:Event):void{
			ticks++;
			if (ticks>50) {
				Tween.floatOut(this);
				removeEventListener(Event.ENTER_FRAME,tick_evt);
			}
		}
		
		protected function draging(event:MouseEvent):void{
			if (event.target==backGround) {
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP,stopdraging);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,nowdraging);
			}
		}
		protected function nowdraging(event:MouseEvent):void{
			event.updateAfterEvent();
		}
		protected function stopdraging(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdraging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,nowdraging);
			this.stopDrag();
		}
	}
}