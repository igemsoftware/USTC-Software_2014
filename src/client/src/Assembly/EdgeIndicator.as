package Assembly{
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	
	
	public class EdgeIndicator extends Shape {
		public function EdgeIndicator()
		{
			graphics.lineStyle(2);
			var tmatrix:Matrix=new Matrix();
			tmatrix.createGradientBox(20, 10, 0);
			graphics.lineGradientStyle(GradientType.LINEAR,[0xffffff,0xffffff],[1, 0],[0, 255],tmatrix);
			graphics.lineTo(0,20);
		}
	}
}