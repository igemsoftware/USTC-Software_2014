package Kernel.SmartCanvas
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	
	
	public class PartialBuffer extends Sprite{
		
		private const BUFFER_LENGTH:int=100;
		
		private var PartitionSpace:Array=[];
		
		public function PartialBuffer(){
			
		}
		
		public function setArea():void{
			var p1:Point=new Point(0,0);
			var p2:Point=new Point(GlobalLayoutManager.StageWidth,GlobalLayoutManager.StageHeight);
			
			p1=globalToLocal(p1);
			p2=globalToLocal(p2);
			
			var sx:int=Math.floor(p1.x/100);
			var sy:int=Math.floor(p1.y/100);
			
			var ex:int=Math.ceil(p2.x/100);
			var ey:int=Math.ceil(p2.y/100);
			
			for each(var PartitionY:Array in PartitionSpace)
			{
				for each(var part:Partition in PartitionY)
				{
					if (part.X<sx||part.X>ex||part.Y<sy||part.Y>ey) {
						part.visible=false;
					}else{
						part.visible=true;
					}
				}
			}
		}
		
		public function AddChild(node:CompressedNode):void{
			var PartitionX:int=Math.floor(node.x/100);
			var PartitionY:int=Math.floor(node.y/100);
			if (PartitionSpace[PartitionX]==null) {
				PartitionSpace[PartitionX]=[];
			}
			if (PartitionSpace[PartitionX][PartitionY]==null) {
				PartitionSpace[PartitionX][PartitionY]=new Partition(PartitionX,PartitionY);
				PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.MOUSE_DOWN,mouse_evt);
				PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.MOUSE_UP,mouse_evt);
				PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mouse_evt);
				PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.RIGHT_MOUSE_UP,mouse_evt);
				
				//PartitionSpace[PartitionX][PartitionY].graphics.lineStyle(3,0xffff00,0.5);
				//PartitionSpace[PartitionX][PartitionY].graphics.drawRect(PartitionX*100,PartitionY*100,100,100);
				
				addChild(PartitionSpace[PartitionX][PartitionY]);
			}
			PartitionSpace[PartitionX][PartitionY].AddChild(node);
		}
		public function addMultiChildren(nodes:Array):void{
			for each (var node:CompressedNode in nodes) {
				
				if(node.Instance==null){
					
					var PartitionX:int=Math.floor(node.x/100);
					var PartitionY:int=Math.floor(node.y/100);
					if (PartitionSpace[PartitionX]==null) {
						PartitionSpace[PartitionX]=[];
					}
					if (PartitionSpace[PartitionX][PartitionY]==null) {
						PartitionSpace[PartitionX][PartitionY]=new Partition(PartitionX,PartitionY);
						PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.MOUSE_DOWN,mouse_evt);
						PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.MOUSE_UP,mouse_evt);
						PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mouse_evt);
						PartitionSpace[PartitionX][PartitionY].addEventListener(MouseEvent.RIGHT_MOUSE_UP,mouse_evt);
						
						//PartitionSpace[PartitionX][PartitionY].graphics.lineStyle(3,0xffff00,0.5);
						//PartitionSpace[PartitionX][PartitionY].graphics.drawRect(PartitionX*100,PartitionY*100,100,100);
						
						addChild(PartitionSpace[PartitionX][PartitionY]);
					}
					PartitionSpace[PartitionX][PartitionY].AddChild(node);
				}
			}
		}
		
		public function Contains(node:CompressedNode):Boolean{
			var PartitionX:int=Math.floor(node.x/100);
			var PartitionY:int=Math.floor(node.y/100);
			if(PartitionSpace[PartitionX]==null){
				return false;
			}
			if(PartitionSpace[PartitionX][PartitionY]==null){
				return false;
			}
			
			return PartitionSpace[PartitionX][PartitionY].Contains(node);
		}
		
		public function RemoveChild(node:CompressedNode):void{
			var PartitionX:int=Math.floor(node.x/100);
			var PartitionY:int=Math.floor(node.y/100);
			PartitionSpace[PartitionX][PartitionY].RemoveChild(node);
		}
		
		public function removeMultiChildren(nodes:Array):void{
			for each (var node:CompressedNode in nodes) {
				if(node.Instance==null){
					var PartitionX:int=Math.floor(node.x/100);
					var PartitionY:int=Math.floor(node.y/100);
					PartitionSpace[PartitionX][PartitionY].RemoveChild(node);	
				}
			}
		}
		
		public function flushChild(node:CompressedNode):void{
			RemoveChild(node);
			AddChild(node);
		}
		
		public function ChangeChildID(node:CompressedNode,newID:String):void{
			var PartitionX:int=Math.floor(node.x/100);
			var PartitionY:int=Math.floor(node.y/100);
			PartitionSpace[PartitionX][PartitionY].changeChildID(node,newID);
		}
		
		public var focusedNode:CompressedNode;
		protected function mouse_evt(event:MouseEvent):void{
			focusedNode=event.target.getChildUnderPoint(mouseX,mouseY);
			dispatchEvent(event);
			event.stopPropagation();
		}
		
		
		public function getChildUnderObject(tar):CompressedNode{
			var MX:int=Math.floor(tar.x/100);
			var MY:int=Math.floor(tar.y/100);
			if (PartitionSpace[MX]!=null&&PartitionSpace[MX][MY]!=null) {
				return PartitionSpace[MX][MY].getChildUnderPoint(tar.x,tar.y);
			}
			return null;
		}
		
		
		
	}
}