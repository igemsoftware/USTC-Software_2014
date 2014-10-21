package UserInterfaces.GlobalLayout{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	
	import UserInterfaces.Style.ColorMixer;

	public class BackGround{
		public static var backGround:Sprite=new Sprite();
		private static var picloader:Loader;
		private static var pic:Bitmap;
		private static var Browser:File;
	
		public static function SetBackGroundPic():void{
			Browser=new File();
			Browser.browseForOpen("Choose background picture",[new FileFilter("JPEG","*.jpg"),new FileFilter("PNG","*.png")]);
			Browser.addEventListener(Event.SELECT,function (e):void{
				Browser.load();
			});
			Browser.addEventListener(Event.COMPLETE,function (event:Event):void
			{
				picloader=new Loader();
				picloader.loadBytes(Browser.data);
				picloader.contentLoaderInfo.addEventListener(Event.COMPLETE,Smooth)
				Browser=null;
			});
		}
		
		protected static function Smooth(event:Event):void{
			backGround.removeChildren(0);
			var data:BitmapData=new BitmapData(picloader.content.width,picloader.content.height);
			data.draw(picloader);
			pic=new Bitmap(null,"auto",true);
			pic.bitmapData=data;
			backGround.graphics.clear();
			backGround.addChild(pic);
			backGround.width=GlobalLayoutManager.StageWidth+20;
			backGround.height=GlobalLayoutManager.StageHeight+20;
			
			picloader=null;
		}
		
		public static function set color(s):void{
			backGround.removeChildren(0);
			backGround.graphics.clear();
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(600,600,0,-200,-200);
			backGround.graphics.beginGradientFill(GradientType.RADIAL,[ColorMixer.MixColor(s,0x252525),ColorMixer.MixColor(s,0)],[1,1],[100,255],Fillmatrix);
			backGround.graphics.drawRect(0,0,500,500);
			backGround.graphics.endFill();
			backGround.width=GlobalLayoutManager.StageWidth+20;
			backGround.height=GlobalLayoutManager.StageHeight+20;
		}
		
		public static function setSize(stageWidth:int, stageHeight:int):void{
			backGround.width=stageWidth+20;
			backGround.height=stageHeight+20;
		}
	}
}