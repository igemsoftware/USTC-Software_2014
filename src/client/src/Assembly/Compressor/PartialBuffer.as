package Assembly.Compressor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	
	public class PartialBuffer extends Sprite{
		public const OBJECT_RECT:int=30;
		
		private const BUFFER_LENGTH:int=100;
		
		private var PartitionSpace:Array=[];
		
		public function PartialBuffer(){
			
		}
		
		public function AddChild(node:CompressedNode):void{
			var PartitionX:int=Math.floor(node.x/100);
			var PartitionY:int=Math.floor(node.y/100);
			if (PartitionSpace[PartitionX]==null) {
				PartitionSpace[PartitionX]=[];
			}
			if (PartitionSpace[PartitionX][PartitionY]==null) {
				PartitionSpace[PartitionX][PartitionY]=new Partition();
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
						PartitionSpace[PartitionX][PartitionY]=new Partition();
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