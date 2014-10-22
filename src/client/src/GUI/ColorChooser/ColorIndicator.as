package GUI.ColorChooser{
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class ColorIndicator extends Sprite{
		private const W:int=30;
		private const H:int=30;
		
		private var masker:Shape=new Shape();
		private var base:Shape=new Shape();
		
		public function ColorIndicator(){
			
			masker.graphics.lineStyle(2,0xaaaaaa,1,true);
			var myFill:GraphicsGradientFill=new GraphicsGradientFill();
			var matrix:Matrix=new Matrix();
			matrix.createGradientBox(W, H, Math.PI/2, 0,0);
			masker.graphics.beginGradientFill(GradientType.LINEAR,[0xffffff,0xffffff,0xffffff,0xffffff],[0.2, 0.3, 0.1, 0],[0, 127, 128, 255],matrix);
			masker.graphics.drawRoundRect(0,0,W,H,3,3);
			masker.graphics.endFill();
			addChild(base);
			addChild(masker);
			
			color=0x000000;
		}
		public function set color(c):void{
			base.graphics.clear();
			base.graphics.beginFill(c);
			base.graphics.drawRoundRect(0,0,W,H,5,5);
			base.graphics.endFill();
		}
	}
}