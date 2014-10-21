package Kernel.Geometry
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class DrawLine extends Sprite
	{

		public function DrawLine()
		{
			
		}
		
		public static function drawDashedLine(tar:Graphics,p1:Point, p2:Point,length:Number=5, gap:Number=5):void
		{
			var distance:Number=Point.distance(p1,p2)
			gap=(distance)/(Math.floor((distance)/(gap+length)))-length;
			var l:Number=0;
			var p3:Point;
			var p4:Point;
			while (l < distance)
			{
				p3=Point.interpolate(p2, p1, l / distance);
				l+=length;
				if (l > distance)
					l=distance
				p4=Point.interpolate(p2, p1, l / distance);
				tar.moveTo(p3.x, p3.y);
				tar.lineTo(p4.x, p4.y)
				l+=gap;
			}
		}
	}
}
