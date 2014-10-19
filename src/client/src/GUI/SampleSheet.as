package GUI
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import Biology.TypeEditor.NodeSample;
	
	import Biology.Types.NodeType;
	
	import GUI.FlexibleWidthObject;
	
	import Style.ColorMixer;
	import Style.FontPacket;
	import Style.Tween;
	
	public class SampleSheet extends Sprite implements FlexibleWidthObject{
		
		public var LeftAlign:int=5;
		public var LabelAlign:int=0;
		public var minHeight:int=25;
		public var Height:Number,Width:Number;
		public var keepHitArea:Boolean;
		
		public var SelectedItem:*;
		
		private var Data:Array=[];
		private var iconData:Array=[];
		private var Base:Shape=new Shape();
		
		public function SampleSheet(w=200){
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
					
					var tmpSample:NodeSample=new NodeSample();
					tmpSample.showSample((arr[i] as NodeType));
					
					tmpLabel=new TextField();
					tmpLabel.defaultTextFormat=FontPacket.ContentText;
					tmpLabel.selectable=false;
					tmpLabel.text=arr[i].label;
					tmpLabel.mouseEnabled=false;
					
					var tmpButton:Sprite=new Sprite();
					
					tmpButton.graphics.lineStyle(0,0x6699ff);
					var Fill:Array=[ColorMixer.MixColor(0x0088ff,0xdddddd), ColorMixer.MixColor(0x0088ff,0x999999)];
					var Fillmatrix:Matrix=new Matrix();
					Fillmatrix.createGradientBox(100, 100, Math.PI / 2, 0, 0);
					tmpButton.graphics.beginGradientFill(GradientType.LINEAR, Fill, [0.7, 0.8], [0, 255], Fillmatrix);
					tmpButton.graphics.drawRect(0,0,100,100);
					tmpButton.graphics.endFill();
					
					iconData.push({Sample:tmpSample,type:arr[i],label:tmpLabel,labelButton:tmpButton});
					if (tmpSample.width+10>LabelAlign) {
						LabelAlign=tmpSample.width+10;
					}
					
					iconData[i].Sample.mouseEnabled=false;
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
					addChild(iconData[i].Sample);
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
			var currentHeight:Number=0;
			Base.graphics.clear();
			
			Base.graphics.lineStyle(0,0xaaaaaa,1);
			for (var i:int = 0; i < iconData.length; i++) {
				iconData[i].Sample.x=LeftAlign+iconData[i].type.skindata.radius/2+2;
				iconData[i].Sample.y=currentHeight+7+iconData[i].type.skindata.radius/2;
				
				iconData[i].label.x=LabelAlign;
				iconData[i].label.y=currentHeight+iconData[i].Sample.height/2-iconData[i].label.textHeight/2+2;
				
				iconData[i].labelButton.width=w;
				iconData[i].labelButton.height=iconData[i].Sample.height+8;
				iconData[i].labelButton.y=currentHeight;
				
				currentHeight+=iconData[i].Sample.height+8;
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
		
		public function redraw():void{
			for (var i:int = 0; i < iconData.length; i++) {
				(iconData[i].Sample as NodeSample).showSample(iconData[i].type);
			
			}
		}
	}
}