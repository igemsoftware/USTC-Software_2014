package GUI.RichUI{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import UserInterfaces.Style.FontPacket;
	import UserInterfaces.Style.Tween;
	
	public class RichIconList extends Sprite{
		
		public var minHeight:int=25;
		public var Height:Number,Width:Number;
		public var keepHitArea:Boolean;
		
		public var selectedItem:*;
		public var selectedIndex:int;
		
		private var Data:Array=[];
		private var iconData:Array=[];
		private var Base:Shape=new Shape();
		
		public function RichIconList(w=200){
			Width=w;
			addChild(Base);
		}
		
		public function setIconField(arr:Array,showLabel=true,showIcon=true,rev=false):void
		{
			removeChildren(1);
			Data=arr;
			iconData=[];
			var tmpLabel:TextField;
			for (var i:int = 0; i < arr.length; i++) {
				tmpLabel=new TextField();
				tmpLabel.defaultTextFormat=FontPacket.ContentText;
				tmpLabel.selectable=false;
				tmpLabel.text=arr[i].label;
				tmpLabel.mouseEnabled=false;
				
				var tmpButton:Sprite=new Sprite();
				
				tmpButton.graphics.lineStyle(0,0x2222ff);
				tmpButton.graphics.beginFill(0x0088ff);
				tmpButton.graphics.drawRect(0,0,100,100);
				tmpButton.graphics.endFill();
				
				tmpButton.alpha=0;
				tmpButton.tabIndex=i;
				
				tmpButton.addEventListener(MouseEvent.MOUSE_OVER,function (e):void{
					Tween.smoothIn(e.target);	
				})
				tmpButton.addEventListener(MouseEvent.MOUSE_OUT,function (e):void{
					Tween.smoothOut(e.target);
				})
				tmpButton.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
					selectedItem=Data[e.target.tabIndex];
					selectedIndex=e.target.tabIndex;
				})
				
				var tmpIcon:*
				if(arr[i].icon!=null&&showIcon){
					tmpIcon=new arr[i].icon();
					if (rev) {
						tmpIcon.scaleX=-1;
					}
					tmpIcon.mouseEnabled=false;
				}else{
					tmpIcon=null;
				}
				
				iconData.push({icon:tmpIcon,label:tmpLabel,labelButton:tmpButton});
				
				addChild(tmpButton);
				if(showLabel)addChild(tmpLabel);
				if(showIcon)addChild(tmpIcon);
				
				
			}
			setSize();
		}		
		
		public function setSize(w=0):void{
			if (w==0) {
				w=Width;
			}else {
				Width=w
			}
			var b:*;
			var currentHeight:Number=2;
			Base.graphics.clear();
			
			Base.graphics.lineStyle(0,0xaaaaaa,1);
			for (var i:int = 0; i < iconData.length; i++) {
				
				var dh:int
				if(iconData[i].icon!=null){
					dh=int(Math.max(iconData[i].icon.height,minHeight));
				}else{
					dh=25;
				}
				
				iconData[i].label.x=0
				iconData[i].label.y=currentHeight
				
				if(iconData[i].icon!=null){
					iconData[i].icon.x=w/2;
					iconData[i].icon.y=currentHeight+dh/2;
				}
				
				iconData[i].labelButton.width=w;
				iconData[i].labelButton.height=dh+4;
				iconData[i].labelButton.y=currentHeight-2
				
				currentHeight+=dh+4;
				
				if (i== iconData.length-1) {
					break;
				}
				Base.graphics.moveTo(2,currentHeight-2);
				Base.graphics.lineTo(w-2,currentHeight-2);
			}
			Height=currentHeight;
			Base.graphics.beginFill(0xffffff,0.9);
			Base.graphics.drawRect(0,0,w,currentHeight);
			Base.graphics.endFill();
		}
	}
}