package GoogleAPI
{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import GUI.FlexibleWidthObject;
	
	import Style.FontPacket;
	import Style.Tween;
	
	public class GoogleGUI extends Sprite implements FlexibleWidthObject
	{
		public function GoogleGUI(w)
		{
			Width=w;
			addChild(Base);
		}
		public var LeftAlign:int=5;
		public var LabelAlign:int=0;
		public var minHeight:int=25;
		public var Width:Number;
		public var keepHitArea:Boolean;
		
		public var SelectedItem:*;
		
		private var Data:Array=[];
		private var iconData:Array=[];
		private var Base:Shape=new Shape();
		
		public var URL:URLRequest;
		public var url:Array=new Array();
		private var tmpLabel:TextField;
		private var tmplb2:TextField=new TextField()
		public function set iconField(arr:Array):void
		{
			removeChildren(1);
			LabelAlign=0;
			Data=arr;
			iconData=[];
			
			for (var i:int = 0; i < arr[0].length; i++) {
					var tmpButton:Sprite=new Sprite();
					
					tmpButton.graphics.lineStyle(0,0x2222ff);
					tmpButton.graphics.beginFill(0x7777ff);
					tmpButton.graphics.drawRect(0,0,100,100);
					tmpButton.graphics.endFill();
					
					tmpLabel=new TextField();
					tmpLabel.defaultTextFormat=FontPacket.SmallContentText;
					tmpLabel.selectable=false;
					tmpLabel.wordWrap=true;
					tmpLabel.multiline=true;
					tmpLabel.x=20;
					
					tmpLabel.htmlText+=arr[0][i];
					tmpLabel.htmlText+=arr[2][i];
					tmpLabel.htmlText+=arr[3][i];
					tmpLabel.htmlText+=arr[4][i];

					
					tmplb2.text=arr[4][i]
					tmplb2.width=100;
					tmplb2.selectable=false;
					trace(tmplb2.text)
					
					url[i]=new URLRequest(arr[1][i]);
					
					tmpLabel.mouseEnabled=false;

					iconData.push({label:tmpLabel,cite:tmplb2,labelButton:tmpButton});

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
					iconData[i].labelButton.addEventListener(MouseEvent.CLICK,function (e):void{
						var num:int=e.target.tabIndex;
						navigateToURL(url[num],"_self");
					})
					
					addChild(iconData[i].labelButton);
					addChild(iconData[i].cite);	
					addChild(iconData[i].label);
					
					
					
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
			tmpLabel.width=w;
			Base.graphics.clear();
			
			Base.graphics.lineStyle(0,0xaaaaaa,1);
			for (var i:int = 0; i < iconData.length; i++) {
				
					iconData[i].label.x=LabelAlign;
					iconData[i].label.y=currentHeight+2;
					iconData[i].label.width=w;
					
					iconData[i].cite.x=LabelAlign+100;
					iconData[i].cite.y=currentHeight+22;
					iconData[i].cite.width=w;
					
					iconData[i].labelButton.width=w;
					iconData[i].labelButton.height=120;
					iconData[i].labelButton.y=currentHeight;
					
					currentHeight+=120;
					if (i== iconData.length-1) {
						break;
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