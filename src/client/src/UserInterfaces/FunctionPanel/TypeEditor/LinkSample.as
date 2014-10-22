package UserInterfaces.FunctionPanel.TypeEditor
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Kernel.Biology.Types.LinkType;
	
	import Kernel.Geometry.DrawArrow;
	
	
	public class LinkSample extends Sprite
	{
		private var wid:int=30;
		public function LinkSample()
		{
			
		}
		public function showSample(tp:LinkType):void{
			graphics.clear();
			
			
			var start:Point=new Point(-wid,wid);
			var end:Point=new Point(wid,-wid);
			var color:uint=tp.skindata.lineColor;
			var lineType:uint=tp.skindata.lineType;
			var startArrowType:uint=tp.skindata.startArrowType;
			var endArrowType:uint=tp.skindata.endArrowType;
			
			graphics.lineStyle(tp.skindata.stroke,tp.skindata.lineColor);
				
			DrawArrow._draw(graphics,start,end,color,lineType,startArrowType,endArrowType);
			}
		}
	}