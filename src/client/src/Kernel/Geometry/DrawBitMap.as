package Kernel.Geometry{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class DrawBitMap{
		public function DrawBitMap()
		{
			
		}
		public static function drawBitmap_Center(tar,map:BitmapData,dx=0,dy=0,scale=1):void{
			var matrix:Matrix = new Matrix(scale,0,0,scale,int(dx-scale*map.width/2),int(dy-scale*map.height/2));
			tar.graphics.lineStyle(0,0,0);
			tar.graphics.beginBitmapFill(map,matrix,false,true);
			tar.graphics.drawRect(int(dx-scale*map.width/2),int(dy-scale*map.height/2),int(scale*map.width),int(scale*map.height));
			tar.graphics.endFill();
		}
		public static function drawBitmap(tar,map:BitmapData,dx=0,dy=0,scale=1):void{
			var matrix:Matrix = new Matrix(scale,0,0,scale,int(dx),int(dy));
			tar.graphics.lineStyle(0,0,0);
			tar.graphics.beginBitmapFill(map,matrix,false,true);
			tar.graphics.drawRect(int(dx),int(dy),scale*map.width,scale*map.height);
			tar.graphics.endFill();
		}
	}
}