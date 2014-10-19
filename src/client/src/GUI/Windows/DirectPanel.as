package GUI.Windows{

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import Style.ColorMixer;
	import Style.FilterPacket;
	import Style.FontPacket;
	import Style.Tween;
	
	
	public class DirectPanel extends Sprite{
		private const DEPLOY_WIDTH:Number=240;
		private const ANGLE_RADIUS:Number=6;
		private const ARROW_SCALE:Number=10;
		private const SHOW_TIMEOUT:int=5;
		private const DEPLOY_TIMEOUT:int=50;
		
		public var Color:uint=0xcccccc;
		public var Base:Shape=new Shape();
		public var Shadow:Shape=new Shape();
		public var title:TextField=new TextField();
		public var detail:TextField=new TextField();
		
		public var Width:Number,Height:Number;
		public var tweenWidth:Number,tweenHeight:Number;
		
		
		public var step:int=1;
		public var Target:*;
		
		public function DirectPanel(tar,titl,detailContent=null){
			
			Target=tar;
			
			this.z=-10;
			
			title.defaultTextFormat=FontPacket.BlackTitleTextLv2;
			title.autoSize="left";
			title.selectable=false;
			title.text=titl;
			
			detail.defaultTextFormat=FontPacket.ContentText;
			detail.selectable=false;
			detail.multiline=true;
			detail.wordWrap=true;
			
			if (detailContent!=null){
				detail.htmlText=detailContent;	
			}else {
				detail.text="";
			}
			
			Shadow.z=10;
			addChild(Shadow);
			addChild(Base);
			addChild(title);
			addChild(detail);
			
			detail.visible=false;
			detail.alpha=0;
			stepChange(1);
			this.visible=false;
			
		}
		
		
		public var tick_s:int=0;
		public function showUp():void{
			tick_s=0;
			removeEventListener(Event.ENTER_FRAME,tickOut);
			addEventListener(Event.ENTER_FRAME,tickShow);
		}
		protected function tickShow(event:Event):void{
				tick_s++;
				if (tick_s>SHOW_TIMEOUT){
					reset();
					stepChange();
					removeEventListener(Event.ENTER_FRAME,tickShow);
					addEventListener(Event.ENTER_FRAME,steptick);
					this.visible=true;
					this.alpha=0;
					Tween.smoothIn(this);
				}
		}
		
		public function fadeOut():void{
			removeEventListener(Event.ENTER_FRAME,tickShow);
			removeEventListener(Event.ENTER_FRAME,steptick);
			tick_s=0;
			addEventListener(Event.ENTER_FRAME,tickOut);
		}
		
		protected function tickOut(event:Event):void{
			tick_s++;
			if (tick_s>SHOW_TIMEOUT) {
				removeEventListener(Event.ENTER_FRAME,tickOut);
				this.visible=false;
				stepChange(1);
				Tween.fadeOut(this);
			}
		}
		
		private var tick:int=0;
		protected function steptick(event:Event):void{
			tick++;
			if (tick>DEPLOY_TIMEOUT) {
				stepChange(2);
				tick=0;
				removeEventListener(Event.ENTER_FRAME,steptick);
			}
		}
		
		
		public function stepChange(n=null):void{
			if (n==null) {
				n=step;
			}
			if (n==2&&detail.text!="") {
				step=2;
				detail.width=DEPLOY_WIDTH-10;
				detail.x=-detail.width/2;
				detail.y=title.y+title.height+2;
				detail.height=detail.textHeight+5;
				var h:Number=title.height+detail.height+ARROW_SCALE+10;
				tweenWidth=DEPLOY_WIDTH;
				tweenHeight=h;
				Tween.TweenScale(this);
				Tween.smoothIn(detail);
			}else{
				step=1;
				Width=title.width+10;
				Height=title.height+ARROW_SCALE+5;
				reset();
				setSize();
				detail.visible=false;
				detail.alpha=0;
			}
		}
		
		
		public function reset():void{
			this.x=Target.x;
			this.y=Target.y+Target.block_base.height/2+5;
		}
		
		public function setSize(w=0,h=0,r=ANGLE_RADIUS):void{
			if (w==0) {
				w=Width;
				h=Height;
			}else {
				Width=w;
				Height=h;
			}
			
			var Graphic:Graphics=Base.graphics;
			
			var Fillmatrix:Matrix=new Matrix();
			
			title.y=ARROW_SCALE+3;
			title.x=-title.width/2;
			
			Fillmatrix.createGradientBox(w,h,Math.PI/2,0,0);
			var hw:Number=w/2;
			var i:int=0;
			
			while(i<2){
			Graphic.clear();
			Graphic.lineStyle(1,0,1,true);
			Graphic.lineGradientStyle(GradientType.LINEAR,[ColorMixer.MixColor(Color,0xbbbbbb),ColorMixer.MixColor(Color,0)],[1,1],[0,255],Fillmatrix);
			Graphic.beginGradientFill(GradientType.LINEAR,[ColorMixer.MixColor(Color,0),ColorMixer.MixColor(Color,0xcccccc)],[1,1],[0,255],Fillmatrix);
			
			Graphic.lineTo(-ARROW_SCALE,ARROW_SCALE);
			Graphic.lineTo(-hw+r,ARROW_SCALE);
			
			Graphic.curveTo(-hw,ARROW_SCALE,-hw,r+ARROW_SCALE);
			
			Graphic.lineTo(-hw,h-r);
			Graphic.curveTo(-hw,h,-hw+r,h);
			Graphic.lineTo(hw-r,h);
			Graphic.curveTo(hw,h,hw,h-r);
			
			Graphic.lineTo(hw,r+ARROW_SCALE);
			Graphic.curveTo(hw,ARROW_SCALE,hw-r,ARROW_SCALE);
			Graphic.lineTo(ARROW_SCALE,ARROW_SCALE);
			
			Graphic.endFill();
			if (step==2&&i==0) {
				Graphic.lineStyle(0,0x999999);
				Graphic.moveTo(-hw+8,title.height+ARROW_SCALE+4);
				Graphic.lineTo(hw-8,title.height+ARROW_SCALE+4);
			}
			Graphic=Shadow.graphics;
			i++;
			}
			Shadow.transform.colorTransform=new ColorTransform(0,0,0);
			
			Shadow.filters=[FilterPacket.ShadowBlur];
			
		}
	}
}