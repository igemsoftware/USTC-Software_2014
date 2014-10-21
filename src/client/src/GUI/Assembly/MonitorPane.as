package GUI.Assembly
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	import UserInterfaces.Style.ColorMixer;

	public class MonitorPane extends Shape
	{
		public function MonitorPane(w,h)
		{
			graphics.clear();
			graphics.lineStyle(2,GlobalVaribles.SKIN_LINE_COLOR);
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(w,h,Math.PI/3,0,0);
			graphics.beginGradientFill(GradientType.LINEAR,[ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x303030),ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x101010)],[1,1],[100,255],Fillmatrix);
			graphics.drawRoundRect(0,0,w,h,6,6);
		}
	}
}