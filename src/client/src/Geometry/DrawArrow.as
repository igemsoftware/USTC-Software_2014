package Geometry
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Assembly.Canvas.I3DPlate;
	import Assembly.Compressor.CompressedLine;
	
	
	public class DrawArrow extends Sprite
	{
		
		public static function drawArrow(tar:Graphics, line:CompressedLine):void{
			var start:Point=new Point(line.SX,line.SY);
			var end:Point=new Point(line.EX,line.EY);
			var color:uint=line.skindata.lineColor;
			var lineType:uint=line.skindata.lineType;
			var startArrowType:uint=line.skindata.startArrowType;
			var endArrowType:uint=line.skindata.endArrowType;
			
			_draw(tar,start,end,color,lineType,startArrowType,endArrowType);
			
		}
		public static function _draw(tar,start,end,color,lineType,startArrowType,endArrowType):void{
			
			var alpha:Number;
			var alpha2:Number;
			var a1:Point=new Point();
			var a2:Point=new Point();
			var a3:Point=new Point();
			var a4:Point=new Point();
			var theta:Number=0.4;
			var len:Number=8*I3DPlate.scaleXY+4
			var theta1:Number;
			var theta2:Number;
			var theta3:Number;
			var theta4:Number;
			
			switch(lineType){
				//1:straight line
				//2:dashed line large gap
				//3:dashed line small gap
				
				case 1:
					tar.moveTo(start.x,start.y);
					tar.lineTo(end.x,end.y);
					break;
				case 2:
					Geometry.DrawLine.drawDashedLine(tar,start,end,10,10);
					break;
				case 3:
					Geometry.DrawLine.drawDashedLine(tar,start,end,5,5);
					break;
			}
			
			switch(endArrowType){
				case 0:
					
					break;
				
				case 1:
					
					alpha=Math.atan2(end.y - start.y, end.x - start.x);
					theta1=alpha + 1.5 * Math.PI - theta;
					theta2=alpha + theta + 1.5 * Math.PI;
					
					a1.x=end.x + len * Math.sin(theta1);
					a1.y=end.y - len * Math.cos(theta1);
					
					a2.x=end.x + len * Math.sin(theta2);
					a2.y=end.y - len * Math.cos(theta2);
					
					var command:Vector.<int>=new Vector.<int>();
					command.push(1, 2, 2);
					
					var coord:Vector.<Number>=new Vector.<Number>();
					coord.push(a1.x, a1.y, end.x, end.y, a2.x, a2.y);
					
					tar.drawPath(command, coord);
					break;
				
				case 2:
					
					alpha=Math.atan2(end.y - start.y, end.x - start.x);
					theta1=alpha + 1.5 * Math.PI - theta;
					theta2=alpha + theta + 1.5 * Math.PI;
					
					a1.x=end.x + len * Math.sin(theta1);
					a1.y=end.y - len * Math.cos(theta1);
					
					a2.x=end.x + len * Math.sin(theta2);
					a2.y=end.y - len * Math.cos(theta2);
					var command1:Vector.<int>=new Vector.<int>();
					command1.push(1, 2);
					
					var coord1:Vector.<Number>=new Vector.<Number>();
					coord1.push(start.x, start.y, end.x, end.y);
					
					var command2:Vector.<int>=new Vector.<int>();
					command2.push(1, 2, 2, 2);
					var coord2:Vector.<Number>=new Vector.<Number>();
					coord2.push(end.x, end.y, a1.x, a1.y, a2.x, a2.y, end.x, end.y);
					
					
					tar.beginFill(color);
					tar.drawPath(command2, coord2);
					tar.endFill();
					break;
				
				case 3:
					
					alpha=Math.atan2(end.y - start.y, end.x - start.x);
					theta1=alpha + 1.5 * Math.PI - theta;
					theta2=alpha + theta + 1.5 * Math.PI;
					
					a1.x=end.x + len * Math.sin(theta1);
					a1.y=end.y - len * Math.cos(theta1);
					
					a2.x=end.x + len * Math.sin(theta2);
					a2.y=end.y - len * Math.cos(theta2);
					var command3:Vector.<int>=new Vector.<int>();
					command3.push(1, 2, 2, 2);
					
					var coord3:Vector.<Number>=new Vector.<Number>();
					coord3.push( end.x, end.y, a1.x, a1.y, a2.x, a2.y, end.x, end.y);
					
					tar.drawPath(command3, coord3);
					break;
			}
			
			switch(startArrowType){
				case 0:
					break;
				
				case 1:
					alpha2=Math.atan2(end.x - start.x, end.y - start.y);
					theta3=alpha + 1.5 * Math.PI - theta;
					theta4=alpha + theta + 1.5 * Math.PI;
					
					a3.x=start.x - len * Math.sin(theta3);
					a3.y=start.y + len * Math.cos(theta3);
					
					a4.x=start.x - len * Math.sin(theta4);
					a4.y=start.y + len * Math.cos(theta4);
					
					var command23:Vector.<int>=new Vector.<int>();
					command23.push(1, 2, 1, 2);
					
					var coord23:Vector.<Number>=new Vector.<Number>();
					coord23.push(start.x, start.y, a3.x, a3.y, start.x, start.y, a4.x, a4.y);
					tar.drawPath(command23, coord23);
					break;
				
				case 2:
					alpha2=Math.atan2(end.x - start.x, end.y - start.y);
					theta3=alpha + 1.5 * Math.PI - theta;
					theta4=alpha + theta + 1.5 * Math.PI;
					
					a3.x=start.x - len * Math.sin(theta3);
					a3.y=start.y + len * Math.cos(theta3);
					
					a4.x=start.x - len * Math.sin(theta4);
					a4.y=start.y + len * Math.cos(theta4);
					
					var command33:Vector.<int>=new Vector.<int>();
					command33.push(1, 2, 2, 2);
					var coord33:Vector.<Number>=new Vector.<Number>();
					coord33.push(start.x, start.y, a3.x, a3.y, a4.x, a4.y, start.x, start.y);
					
					tar.beginFill(color);
					tar.drawPath(command33, coord33);
					tar.endFill();
					break;
				
				case 3:
					alpha2=Math.atan2(end.x - start.x, end.y - start.y);
					theta3=alpha + 1.5 * Math.PI - theta;
					theta4=alpha + theta + 1.5 * Math.PI;
					
					a3.x=start.x - len * Math.sin(theta3);
					a3.y=start.y + len * Math.cos(theta3);
					
					a4.x=start.x - len * Math.sin(theta4);
					a4.y=start.y + len * Math.cos(theta4);
					
					var command22:Vector.<int>=new Vector.<int>();
					command22.push(1, 2, 2, 2);
					
					var coord22:Vector.<Number>=new Vector.<Number>();
					coord22.push(start.x, start.y, a3.x, a3.y, a4.x, a4.y, start.x, start.y);
					tar.drawPath(command22, coord22);
					break;
			}
		}
	}
}
