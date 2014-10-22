

// ActionScript file
private static var Rdown:Boolean=false;
private static var Rsx:Number,Rsy:Number;

protected static function startRangeEvt(event:MouseEvent):void{
	Rdown=true;
	
	Rsx=plate.mouseX;
	Rsy=plate.mouseY;
	
	plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,rangeEvt);
	if(event.type==MouseEvent.RIGHT_MOUSE_DOWN){
		plate.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,endRangeEvt);
	}else if(event.type==MouseEvent.MOUSE_DOWN){
		plate.stage.addEventListener(MouseEvent.MOUSE_UP,endRangeEvt);
	}
}

protected static function endRangeEvt(event:MouseEvent):void
{
	
	plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,rangeEvt);
	plate.stage.removeEventListener(event.type,endRangeEvt);
	
	var sRect:Rectangle=selectRange.getBounds(plate);
	
	for each (var node:CompressedNode in Block_space) {
		if(node.x<sRect.right&&node.x>sRect.left&&node.y>sRect.top&&node.y<sRect.bottom){
			BlockSpace.browseChild(node);
			setfocus(node,true);
		}	
	}
	
	selectRange.graphics.clear(); 
	
}

protected static function rangeEvt(event:MouseEvent):void
{
	
	selectRange.graphics.clear();
	selectRange.graphics.lineStyle(0,0xffffff,0.5);
	selectRange.graphics.beginFill(0xffffff,0.3);
	selectRange.graphics.drawRect(Rsx,Rsy,plate.mouseX-Rsx,plate.mouseY-Rsy);
	selectRange.graphics.endFill();
	
	event.updateAfterEvent();
}