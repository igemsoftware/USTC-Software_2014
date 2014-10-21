package GUI.Windows{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	import UserInterfaces.Style.FilterPacket;
	import UserInterfaces.Style.FontPacket;
	
	public class FreeWindow extends Sprite{
		
		public var detailTarget:*;
		public var title:TextField=new TextField();
		public var backGround:Shape=new Shape();
		public var backGroundShadow:Shape=new Shape();
		public var backGroundmask:Shape=new Shape();
		public var flexable:Boolean=true;
		
		private var Banner:banner=new banner();
		private var Drager:drager=new drager();
		private var closeButton:close_button=new close_button();
		
		public var aimX:Number,aimY:Number,aimW:Number,aimH:Number;
		
		private var EX:Number,EY:Number,EW:Number,EH:Number;
		private var CW:Number,CH:Number;
		private var protectTick:uint=0;
		public var attach:Boolean=false;
		public var Content:*;
		private var dragY0:Number;
		
		private var IconField:Array=[];
		
		public function FreeWindow(titl:String,content=null,sw=500,sh=400,sx=null,sy=null){
			if(sx==null){
				sx=GlobalLayoutManager.StageWidth/2
				sy=GlobalLayoutManager.StageHeight/2
			}
			
			this.cacheAsBitmap=true;
			
			aimW=sw;
			aimH=sh;

			title.x=title.y=9;
			title.defaultTextFormat=FontPacket.WhiteTitleText;
			title.mouseEnabled=false;
			
			title.text=titl;
			
			title.height=title.textHeight;
			
			
			Banner.scale9Grid=new Rectangle(15,15,380,39);
			Banner.doubleClickEnabled=true;
			
			closeButton.addEventListener("click",close);
			
			addChild(backGroundShadow);
			addChild(backGroundmask);
			addChild(backGround);
			
			addChild(Banner);
			addChild(closeButton);
			addChild(title);
			addChild(Drager);
			
			Content=content;
			addChildAt(Content,getChildIndex(backGround)+1);
			Content.y=Banner.height+2;
			Content.x=2;
			Content.mask=backGroundmask;
			
			setScale(sw,sh);
			
			Drager.addEventListener(MouseEvent.MOUSE_DOWN,sscale_evt);
			addEventListener(MouseEvent.MOUSE_DOWN,focus_evt);
			Banner.addEventListener(MouseEvent.DOUBLE_CLICK,Maximum);
			
			Banner.addEventListener(MouseEvent.MOUSE_DOWN,draging);
		}
		
		public function setContent(c):void{
			if (Content!=null&&contains(Content)) {
				removeChild(Content);
			}
			if (c!=null) {
				Content=c;
				addChildAt(Content,getChildIndex(backGround)+1);
				Content.y=Banner.height+2;
				Content.x=2;
				Content.mask=backGroundmask;
				Content.setSize(CW-4,CH-Banner.height-2);
			}
		}
		
		protected function Maximum(event:MouseEvent):void{
			dispatchEvent(new Event("Maximum"));
		}
		protected function sscale_evt(event:MouseEvent):void{
			Drager.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,change_scale_evt);
			stage.addEventListener(MouseEvent.MOUSE_UP,escale_evt);
			stage.addEventListener(MouseEvent.RELEASE_OUTSIDE,escale_evt);
		}
		
		protected function escale_evt(event:MouseEvent):void{
			Drager.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,escale_evt);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,change_scale_evt);
			stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE,escale_evt);
		}
		
		protected function change_scale_evt(event:MouseEvent):void{
			setScale(Drager.x,Drager.y,true);
			event.updateAfterEvent();
		}
		
		public function resetScale():void{
			attach=false;
			setScale(aimW,aimH);
			this.x=parent.mouseX-aimW/2;
		}
		public function setScale(w,h,record=false):void{
			
			title.width=w-100;
			title.height=Banner.height;
			
			if (record) {
				aimW=w;
				aimH=h;
			}
			CW=w;
			CH=h;
			
			backGround.graphics.clear();
			backGround.graphics.lineStyle(0,0xcccccc,1,true);
			backGround.graphics.beginFill(0xeeeeee,0.8);
			backGround.graphics.drawRoundRect(0,2, w,h-2,15,15);
			backGround.graphics.endFill();
			
			backGroundmask.graphics.clear();
			backGroundmask.graphics.lineStyle(0,0xcccccc,1,true);
			backGroundmask.graphics.beginFill(0xeeeeee,0.8);
			backGroundmask.graphics.drawRoundRect(0,2, w,h-2,15,15);
			backGroundmask.graphics.endFill();
			
			
			backGroundShadow.graphics.clear();
			backGroundShadow.graphics.lineStyle(0);
			backGroundShadow.graphics.beginFill(0x000000,0.6);
			backGroundShadow.graphics.drawRoundRect(-4,-4, w+8,h+10,15,15);
			backGroundShadow.graphics.endFill();
			backGroundShadow.filters=[FilterPacket.ShadowBlur];
			
			arrangeIcon();
			
			Banner.width=w+1;
			
			closeButton.x=w-20;
			closeButton.y=10;
			
			Drager.x=w;
			Drager.y=h;
			
			if (Content!=null) {
				Content.setSize(w-4,h-Banner.height-2);
			}
						
		}
		protected function close(event:MouseEvent):void{
			dispatchEvent(new Event("close"));
		}
		
		protected function focus_evt(event:MouseEvent):void{
			dispatchEvent(new Event("focused"));
		}
		
		public function showUp(e):void{
		
		}
		
		protected function draging(event:MouseEvent):void{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdraging);
			dragY0=parent.mouseY;
			addEventListener(MouseEvent.MOUSE_MOVE,moving_evt);
			dispatchEvent(new Event("startDrag"));
		}
		
		protected function moving_evt(event:MouseEvent):void
		{
			if (dragY0-parent.mouseY<0&&attach) {
				resetScale();
			}
			event.updateAfterEvent();
		}
		protected function stopdraging(event:MouseEvent):void{
			this.stopDrag();
			removeEventListener(MouseEvent.MOUSE_MOVE,moving_evt);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdraging);
			dispatchEvent(new Event("stopDrag"));
		}
		
		public function set ButtonField(field:Array):void{
			for (var i:int=0;i<IconField.length;i++){
				removeChild(IconField[i]);
			}
			IconField=field;
			for (i=0;i<IconField.length;i++){
				addChild(IconField[i]);
				IconField[i].y=Banner.height/2-IconField[i].height/2+2;
			}
			arrangeIcon();
		}
		public function arrangeIcon():void{
			var currentX:Number=35;
			for (var i:int=IconField.length-1;i>=0;i--){
				
				currentX+=	IconField[i].width+5;
				IconField[i].x=CW-currentX;
				
			}
		}
	}
}