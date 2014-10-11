package GUI.IconSheet
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import GUI.FlexibleWidthObject;
	
	import Geometry.DrawBitMap;
	
	import Style.FontPacket;
	import Style.Tween;
	
	public class IconSheet extends Sprite implements FlexibleWidthObject{
		
		public var LeftAlign:int=5;
		public var LabelAlign:int=0;
		public var minHeight:int=25;
		public var Height:Number,Width:Number;
		public var keepHitArea:Boolean;
		
		public var SelectedItem:*;
		
		private var Data:Array=[];
		private var iconData:Array=[];
		private var Base:Shape=new Shape();
		
		public function IconSheet(w=200){
			Width=w;
			addChild(Base);
		}
		
		public function set iconField(arr:Array):void
		{
			removeChildren(1);
			LabelAlign=0;
			Data=arr;
			iconData=[];
			var tmpLabel:TextField
			for (var i:int = 0; i < arr.length; i++) {
				if (typeof(arr[i])=="string") {
					tmpLabel=new TextField();
					tmpLabel.defaultTextFormat=FontPacket.SmallContentText;
					tmpLabel.selectable=false;
					tmpLabel.autoSize="left";
					tmpLabel.text=arr[i];
					tmpLabel.mouseEnabled=false;
					iconData.push(tmpLabel);
					addChild(iconData[i]);
				}else {
					tmpLabel=new TextField();
					tmpLabel.defaultTextFormat=FontPacket.ContentText;
					tmpLabel.selectable=false;
					tmpLabel.text=arr[i].label;
					tmpLabel.mouseEnabled=false;
					
					var tmpButton:Sprite=new Sprite();
					
					tmpButton.graphics.lineStyle(0,0x2222ff);
					tmpButton.graphics.beginFill(0x7777ff);
					tmpButton.graphics.drawRect(0,0,100,100);
					tmpButton.graphics.endFill();
					
					if (typeof(arr[i].icon)=="string") {
						var b:Loader=new Loader();
						b.load(new URLRequest(arr[i].icon));
						b.contentLoaderInfo.addEventListener(Event.COMPLETE,function (e):void{
							if (e.target.width+10>LabelAlign) {
								LabelAlign=e.target.width+10;
							}
							setSize(0);
						});
						b.mouseEnabled=false;
						iconData.push({icon:b,label:tmpLabel,labelButton:tmpButton});
					}else if (arr[i].icon.constructor==BitmapData) {
						var s:Shape=new Shape();
						DrawBitMap.drawBitmap(s,arr[i].icon,0,0);
						iconData.push({icon:s,label:tmpLabel,labelButton:tmpButton});
						if (s.width+10>LabelAlign) {
							LabelAlign=s.width+10;
						}
					}else{
						iconData[i].icon.mouseEnabled=false;
						iconData.push({icon:arr[i].icon,label:tmpLabel,labelButton:tmpButton});
						if (arr[i].icon.width+10>LabelAlign) {
							LabelAlign=arr[i].icon.width+10;
						}
					}
					iconData[i].labelButton.alpha=0;
					iconData[i].labelButton.tabIndex=i;
					iconData[i].labelButton.addEventListener(MouseEvent.MOUSE_OVER,function (e):void{
						Tween.smoothIn(e.target);	
					})
					iconData[i].labelButton.addEventListener(MouseEvent.MOUSE_OUT,function (e):void{
						Tween.smoothOut(e.target);
					})
					iconData[i].labelButton.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
						SelectedItem=Data[e.target.tabIndex];
					})
					
					
					addChild(iconData[i].labelButton);
					addChild(iconData[i].icon);
					addChild(iconData[i].label);
					
				}
			}
			setSize(0);
		}		
		public function setSize(w:Number):void{
			if (w==0) {
				w=Width;
			}else {
				Width=w
			}
			var b:*;
			var currentHeight:Number=0;
			Base.graphics.clear();
			
			Base.graphics.lineStyle(0,0xaaaaaa,1);
			for (var i:int = 0; i < iconData.length; i++) {
				if (iconData[i].constructor==TextField) {
					iconData[i].x=LeftAlign;
					iconData[i].y=currentHeight+2;
					currentHeight+=iconData[i].height+4;
				}else {
					iconData[i].icon.x=LeftAlign;
					iconData[i].icon.y=currentHeight+2;
					iconData[i].label.x=LabelAlign;
					iconData[i].label.y=currentHeight+iconData[i].icon.height/2-iconData[i].label.textHeight/2+2;
					
					iconData[i].labelButton.width=w;
					iconData[i].labelButton.height=iconData[i].icon.height+4;
					iconData[i].labelButton.y=currentHeight;
					
					currentHeight+=iconData[i].icon.height+4;
					if (i== iconData.length-1) {
						break;
					}
				}
				Base.graphics.moveTo(LeftAlign,currentHeight);
				Base.graphics.lineTo(w-LeftAlign,currentHeight);
			}
			
			Base.graphics.beginFill(0xffffff,0.6);
			Base.graphics.drawRect(0,0,w,currentHeight);
			Base.graphics.endFill();
		}
	}
}