package Biology.TypeEditor{
	import flash.display.Sprite;
	
	import Biology.Types.NodeType;
	
	import Geometry.DrawBitMap;
	import Geometry.DrawNode;
	
	
	public class NodeSample extends Sprite {
		
		public function NodeSample()
		{
		}
		public function showSample(tp:NodeType):void{
			graphics.clear();
			graphics.drawGraphicsData(DrawNode.drawNode(tp.skindata,0,0,1));
			DrawBitMap.drawBitmap_Center(this,tp.icon,0,0,tp.iconScale);
			
		}
	}
}