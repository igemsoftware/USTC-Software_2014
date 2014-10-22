package Assembly.Compressor{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Geometry.DrawBitMap;
	import Geometry.DrawNode;
	
	import Assembly.Canvas.I3DPlate;
	
	public class Partition extends Sprite{
		
		private var ChildList:Array=new Array();
		public var focusNode:CompressedNode;
		
		public function Partition(){
			cacheAsBitmap=true;
		}
		
		public function AddChild(node:CompressedNode):void{
			if(ChildList[node.ID]==null){
				ChildList[node.ID]=node;
				appendDraw(node);
			}
		}
		
		public function RemoveChild(node:CompressedNode):void{
			if(ChildList[node.ID]!=null){
				delete ChildList[node.ID];
				Redraw();
			}
		}
		public function RemoveMultiChilds(arr:Array):void{
			for each(var node:CompressedNode in ChildList) {
				if (node==arr[node.ID]) {
					delete ChildList[node.ID];
				}
			}
			Redraw();
		}
		public function Contains(node:CompressedNode):Boolean{
			return ChildList[node.ID]!=null
		}
		
		private function appendDraw(node:CompressedNode):void{
			this.graphics.drawGraphicsData(DrawNode.drawNode(node.skindata,node.x,node.y,I3DPlate.scaleXY));
			if(GlobalVaribles.showIconMap){
				DrawBitMap.drawBitmap_Center(this,node.Type.icon,node.x,node.y,node.Type.iconScale*I3DPlate.scaleXY);
			}
			if(node.TextMap.width>1){
				DrawBitMap.drawBitmap_Center(this,node.TextMap,node.x+node.textX,node.y+node.textY*I3DPlate.scaleXY+8+node.TextMap.height*I3DPlate.scaleXY/2,(I3DPlate.scaleXY+1)/2);
			}
		}
		
		public function Redraw():void{
			if (!hasEventListener(Event.EXIT_FRAME)) {
				addEventListener(Event.EXIT_FRAME,redraw);
			}
		}
		public function redraw(e=null):void{
			graphics.clear();
			for each(var node:CompressedNode in ChildList) {
				if (node.visible) {
					appendDraw(node);
				}
			}
			removeEventListener(Event.EXIT_FRAME,redraw);
		}
		
		public function getChildUnderPoint(x:int,y:int):CompressedNode{
			for each(var node:CompressedNode in ChildList) {
				var r:int=node.skindata.radius*I3DPlate.scaleXY;
				if (node.x<x+r&&node.x>x-r&&node.y>y-r&&node.y<y+r&&node.visible) {
					return node;
				}
			}
			return null;
		}
	}
}