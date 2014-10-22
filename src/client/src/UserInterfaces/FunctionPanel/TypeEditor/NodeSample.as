package UserInterfaces.FunctionPanel.TypeEditor{
	import flash.display.Sprite;
	
	import Kernel.Biology.Types.NodeType;
	
	import Kernel.Geometry.DrawBitMap;
	import Kernel.Geometry.DrawNode;
	
	/**
	 * a sample of selected node style
	 */
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