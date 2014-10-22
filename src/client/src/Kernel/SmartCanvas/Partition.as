package Kernel.SmartCanvas{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Kernel.SmartCanvas.Canvas.FreePlate;
	
	import Kernel.Geometry.DrawBitMap;
	import Kernel.Geometry.DrawNode;
	
	public class Partition extends Sprite{
		
		private var ChildList:Array=new Array();
		public var focusNode:CompressedNode;
		public var X:int,Y:int
		
		public function Partition(px,py){
			cacheAsBitmap=true;
			X=px;
			Y=py;
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
			this.graphics.drawGraphicsData(DrawNode.drawNode(node.skindata,node.x,node.y,FreePlate.scaleXY));
			if(GlobalVaribles.showIconMap){
				DrawBitMap.drawBitmap_Center(this,node.Type.icon,node.x,node.y,node.Type.iconScale*FreePlate.scaleXY);
			}
			if(node.TextMap.width>1){
				DrawBitMap.drawBitmap_Center(this,node.TextMap,node.x+node.textX,node.y+node.textY*FreePlate.scaleXY+8+node.TextMap.height*FreePlate.scaleXY/2,(FreePlate.scaleXY+1)/2);
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
		
		public function changeChildID(child:CompressedNode,newID:String):void{
			if(ChildList[child.ID]!=null){
				delete ChildList[child.ID];
				ChildList[newID]=child;
			}
		}
		
		public function getChildUnderPoint(x:int,y:int):CompressedNode{
			for each(var node:CompressedNode in ChildList) {
				var r:int=node.skindata.radius*FreePlate.scaleXY;
				if (node.x<x+r&&node.x>x-r&&node.y>y-r&&node.y<y+r&&node.visible) {
					return node;
				}
			}
			return null;
		}
	}
}