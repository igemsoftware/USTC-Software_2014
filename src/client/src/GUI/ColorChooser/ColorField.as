package GUI.ColorChooser{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	
	public class ColorField extends Sprite{
		
		public var colorLoader:Loader=new Loader();
		public var db:BitmapData;
		public var ColorPanel:Bitmap;
		public var selectedColor:uint=0;
		
		public function ColorField()
		{
			colorLoader.load(new URLRequest("colorpicker.jpg"));
			colorLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,cmp);
			addEventListener(MouseEvent.MOUSE_MOVE,getColor);
		}
		
		protected function cmp(event:Event):void
		{
			db=new BitmapData(event.target.width,event.target.height);
			db.draw(event.target.content);
			ColorPanel=new Bitmap(db,"auto",true);	
			ColorPanel.scaleX=0.35;
			ColorPanel.scaleY=0.5;
			addChild(ColorPanel);
			ColorPanel.y=ColorPanel.x=5;
			graphics.clear();
			var matrix:Matrix=new Matrix();
			graphics.lineStyle(1,0xffffff,1,true);
			graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			graphics.drawRoundRect(0,0,ColorPanel.width+10,ColorPanel.height+10,4,4);
			graphics.endFill();
			colorLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,cmp);
		}
		
		public function getColor(e:MouseEvent):void{
			selectedColor=db.getPixel(mouseX/0.35,mouseY/0.5);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}