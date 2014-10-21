package GUI.RichUI
{
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import UserInterfaces.Style.ColorMixer;
	import UserInterfaces.Style.FontPacket;
	
	public class RichButton extends Sprite
	{
		public static const INDEPENDENT:int=0;
		public static const LEFT_EDGE:int=1;
		public static const RIGHT_EDGE:int=2;
		public static const MIDDLE:int=3;
		
		private const R:int=5;
		
		private var labelfield:TextField=new TextField();
		private var buttonBase:Shape=new Shape();
		public var Width:Number;
		public var Height:Number;
		public var Type:int;
		private var bt_icon:*;
		public var LabelDistance:Number=5;
		private var highLighted:Boolean=false;
		private var sus:Loading_Cricle;
		
		public function RichButton(type=INDEPENDENT,w=100,h=25)
		{
			Type=type;
			
			labelfield.defaultTextFormat=FontPacket.ButtonText;
			labelfield.selectable=false;
			labelfield.autoSize=TextFieldAutoSize.LEFT;
			labelfield.text="";
			
			addChild(buttonBase);
			
			setSize(w, h);
			
			addEventListener(MouseEvent.MOUSE_OVER, function (e):void{redraw(1)});
			addEventListener(MouseEvent.MOUSE_OUT, function (e):void{redraw(0)});
			addEventListener(MouseEvent.MOUSE_DOWN, function (e):void{redraw(2)});
			addEventListener(MouseEvent.MOUSE_UP, function (e):void{redraw(1)});
		}
		
		public function setIcon(icon,rev=false,upsidedown=false,rotate=0):void{
			if (bt_icon!=null&&contains(bt_icon)) {
				removeChild(bt_icon);
			}
			
			if (typeof(icon) == "string"){
				var request:URLRequest=new URLRequest(icon);
				bt_icon=new Loader();
				bt_icon.load(request);
				bt_icon.contentLoaderInfo.addEventListener(Event.COMPLETE,function (e):void{
					addChild(bt_icon);
				})
				
			}else{
				bt_icon=new icon();
				bt_icon.x=int(Width/2);
				bt_icon.y=int(Height/2);
				if (rev) {
					bt_icon.scaleX=-1;
				}
				if(upsidedown){
					bt_icon.scaleY=-1;
				}
				bt_icon.rotation=rotate;
				bt_icon.mouseEnabled=false;
				addChild(bt_icon);
			}
		}
		
		public function set focused(b:Boolean):void{
			highLighted=b;
			redraw(0)
		}
		
		public function get focused():Boolean{
			return highLighted;
		}
		
		public function set Labelformat(s:TextFormat):void
		{
			labelfield.setTextFormat(s, 0, labelfield.length);
		}
		
		public function set label(s):void
		{
			labelfield.text=s;
			addChild(labelfield);
			rangeLabel();
		}
		
		public function get label():String
		{
			return labelfield.text;
		}
		
		public function suspend():void{
			if(sus==null){
				sus=new Loading_Cricle();
				sus.mouseEnabled=false;
			}
			addChild(sus);
			sus.x=Width/2;
			sus.y=Height/2;
			labelfield.visible=false;
			mouseEnabled=false;
		}
		
		public function unsuspend():void{
			
			if(sus!=null&&contains(sus)){
				removeChild(sus);
				sus=null;
			}
			
			labelfield.visible=true;
			mouseEnabled=true;
		}
		
		
		public function redraw(state:int):void
		{
			var line_color:uint;
			var Fill:Array;
			switch(state)
			{
				case 0:
				{
					line_color=0x888888;
					Fill=[0xffffff, 0xbbbbbb];
					break;
				}
					
				case 1:
				{
					line_color=0x888888;
					Fill=[ColorMixer.MixColor(0x0088ff,0xeeeeee), ColorMixer.MixColor(0x0088ff,0x999999)];
					break;
				}
					
				case 2:
				{
					line_color=0x888888;
					Fill=[ColorMixer.MixColor(0x0088ff,0xaaaaaa), ColorMixer.MixColor(0x0088ff,0x666666)];
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			if(highLighted){
				Fill=[ColorMixer.MixColor(0x0088ff,0xaaaaaa), ColorMixer.MixColor(0x0088ff,0x666666)];
			}
			buttonBase.graphics.clear();
			buttonBase.graphics.lineStyle(0, 0, 0.3,true);
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(Width, Height, Math.PI / 2, 0, 0);
			buttonBase.graphics.beginGradientFill(GradientType.LINEAR, Fill, [0.6, 0.7], [0, 255], Fillmatrix);
			
			switch(Type)
			{
				case 0:
				{
					buttonBase.graphics.drawRoundRect(0, 0, Width, Height, R, R);
					break;
				}
				case 3:
				{
					buttonBase.graphics.drawRect(0, 0, Width, Height);
					break;
				}
				case 1:
				{
					buttonBase.graphics.drawRoundRectComplex(0, 0, Width, Height, R,0,R,0);
					break;
				}
				case 2:
				{
					buttonBase.graphics.drawRoundRectComplex(0, 0, Width, Height, 0,R,0,R);
					break;
				}
			}
			
			buttonBase.graphics.endFill();
			
		}
		
		public function setSize(w:Number, h:Number):void
		{
			Width=w;
			Height=h;
			redraw(0);
			rangeLabel();
			
		}
		
		public function rangeLabel():void
		{
			if(labelfield.text==""&&bt_icon!=null){
				bt_icon.x=Width/2;
				bt_icon.y=Height/2;
				if(contains(labelfield)){
					removeChild(labelfield);
				}
			}else	if (bt_icon!=null) {
				var tw:Number=bt_icon.width+labelfield.width+LabelDistance;
				
				bt_icon.x=Width/2+bt_icon.width/2-tw/2;
				bt_icon.y=Height/2;
				labelfield.x=bt_icon.x+bt_icon.width/2+LabelDistance;
				labelfield.y=Height / 2 - labelfield.height / 2;
				
			}else{
				labelfield.y=Height / 2 - labelfield.height / 2;
				labelfield.x=Width/2-labelfield.width/2;
			}
			
		}
	}
}
