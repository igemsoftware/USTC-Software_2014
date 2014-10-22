package Kernel.SmartCanvas{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Kernel.SmartCanvas.Parts.BioNode;
	import Kernel.SmartCanvas.Canvas.Net;
	
	public class SmartNodeSpace extends Sprite{
		
		private var compressedCanvas:PartialBuffer=new PartialBuffer();
		private var floatCanvas:Sprite=new Sprite();
		
		public function SmartNodeSpace(){
			
			floatCanvas.cacheAsBitmap=true;
			
			compressedCanvas.addEventListener(MouseEvent.MOUSE_DOWN,DownEvent);
			compressedCanvas.addEventListener(MouseEvent.MOUSE_UP,UpEvent);
			compressedCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,R_Event);
			compressedCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_UP,R_Event);
			addChild(compressedCanvas);
			addChild(floatCanvas);
		}
		
		public function setArea():void{
			compressedCanvas.setArea();
		}
		
		protected function R_Event(event:MouseEvent):void
		{
			var focusedNode:CompressedNode=compressedCanvas.focusedNode;
			if (focusedNode!=null) {
				browseChild(focusedNode);
				trace("Transmit_RightClick:",event.type,focusedNode.Name);
				focusedNode.Instance.dispatchEvent(event);
			}
		}
		
		
		protected function DownEvent(event:MouseEvent):void{
			var focusedNode:CompressedNode=compressedCanvas.focusedNode;
			if (focusedNode!=null) {
				browseChild(focusedNode);
				focusedNode.Instance.justWakeUp=true;
				trace("Browse:",focusedNode.Name);
				focusedNode.Instance.block_base.dispatchEvent(event);
			}
		}
		protected function UpEvent(event:MouseEvent):void{
			var focusedNode:CompressedNode=compressedCanvas.focusedNode;
			if (focusedNode!=null) {
				browseChild(focusedNode);
				
			}
		}
		
		
		public function PopUp(tar:BioNode):void{
			if (floatCanvas.contains(tar)) {
				floatCanvas.swapChildren(tar,floatCanvas.getChildAt(floatCanvas.numChildren-1));
			}
		}
		
		public function changeChildID(node:CompressedNode,newID:String):void{
			if(compressedCanvas.Contains(node)){
				compressedCanvas.ChangeChildID(node,newID);
			}
		}
		
		/////////////Children
		public function AddChild(node:BioNode):void{
			floatCanvas.addChild(node);
		}
		public function AddCompressedChild(node:CompressedNode):void{
			if (node.Instance==null) {
				compressedCanvas.AddChild(node);
			}else{
				compressChild(node.Instance);
			}
		}
		public function AddMulitCompressedChild(nodes:Array):void{
			compressedCanvas.addMultiChildren(nodes);
		}
		public function RemoveChild(node:CompressedNode):void{
			if (node.Instance!=null&&floatCanvas.contains(node.Instance)) {
				floatCanvas.removeChild(node.Instance);
			}else {
				compressedCanvas.RemoveChild(node);
			}
		}
		public function removeMultiChild(AniList:Array):void{
			compressedCanvas.removeMultiChildren(AniList);
		}
		public function flushChild(node:CompressedNode):void{
			if (node.Instance!=null&&floatCanvas.contains(node.Instance)) {
				node.Instance.redraw();
			}else {
				compressedCanvas.flushChild(node);
			}
		}
		
		public function browseChild(node:CompressedNode):void{
			if (node.Instance==null) {
				Net.WakeBlock(node);
			}
			if (!floatCanvas.contains(node.Instance)){
				compressedCanvas.RemoveChild(node);
				floatCanvas.addChild(node.Instance);
				node.Instance.redraw();
			}
		}
		
		public function compressChild(node:BioNode):void{
			compressedCanvas.AddChild(node.NodeLink);
			if (floatCanvas.contains(node)) {
				floatCanvas.removeChild(node);
			}
			node.NodeLink.Instance=null;
		}
		public function isFloating(tar:CompressedNode):Boolean{
			if(tar.Instance==null){
				return false;
			}else if (floatCanvas.contains(tar.Instance)) {
				return true;
			}
			return false;
		}
		public function compressAllChild():void{
			while(floatCanvas.numChildren>0){
				compressChild(floatCanvas.getChildAt(0) as BioNode);
			}
		}
		
		public function ClearCompressSpace():void{
			removeChild(compressedCanvas);
			compressedCanvas=new PartialBuffer();
			compressedCanvas.addEventListener(MouseEvent.MOUSE_DOWN,DownEvent);
			compressedCanvas.addEventListener(MouseEvent.MOUSE_UP,UpEvent);
			compressedCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,R_Event);
			compressedCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_UP,R_Event);
			addChildAt(compressedCanvas,0);
		}
		
		public function DropObjectTest(tar):CompressedNode{
			var focusedNode:CompressedNode=compressedCanvas.getChildUnderObject(tar);
			if (focusedNode!=null) {
				return focusedNode;
			}else{
				return null;
			}
			
		}
		
		
	}
}