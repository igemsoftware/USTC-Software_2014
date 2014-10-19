package IgemPartAPI
{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import GUI.FlexibleWidthObject;
	
	
	public class IgemGUI extends Sprite implements FlexibleWidthObject
	{
		public function IgemGUI(w)
		{
			Width=w;
			addChild(Base);
		}
		public var Width:Number;
		public var Height:Number=400;
		private var Base:Shape=new Shape();
		private var textf:TextField=new TextField();

		public function set iconField(text:String):void
		{
			textf.htmlText=text;
			textf.width=Width;
			textf.height=Height;
			addChild(textf);
			setSize(0);
		}
		public function setSize(w:Number):void{
			if (w==0) {
				w=Width;
			}else {
				Width=w
			}
			Base.graphics.clear();
			Base.graphics.lineStyle(0,0xaaaaaa,1);
			Base.graphics.beginFill(0xffffff,0.6);
			Base.graphics.drawRect(0,0,w,Height);
			Base.graphics.endFill();
		}
	}
	
}