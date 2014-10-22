/**this file is part of class Net
 * Net -> Select Management
 * including
 * 		1.Select linked nodes from a node
 * 		2.Select by Type
 * 		3.Select by Rectangle
 */


/**
 * Selection Method :: Select Connected Nodes to a node;
 * @param node The center node
 */
public static function SelectAround(node:CompressedNode):void
{
	if(!node.Instance.focused){
		setfocus(node,true);
	}
	for each (var pnode:CompressedNode in node.Linklist){
		NodeSpace.browseChild(pnode);
		if(!pnode.Instance.focused){
			setfocus(pnode,true);
		}
	}
	
}


/**
 * Selection Method :: Select Nodes to by a type
 * @param Type Target Type
 */
public static function SelectType(Type:NodeType):void
{
	for each (var pnode:CompressedNode in GxmlContainer.Node_Space){
		if(pnode.Type==Type){
			NodeSpace.browseChild(pnode);
			if(!pnode.Instance.focused){
				setfocus(pnode,true);
			}
		}
	}
	
}


///record mouse button status
private static var Rdown:Boolean=false;

///record mouse location
private static var Rsx:Number,Rsy:Number;

/**
 * Event Handler :: Start selecting by rectangle
 * @param event MouseEvent Instance
 */
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


/**
 * Event Handler :: End selecting.
 * @param event MouseEvent Instance
 */
protected static function endRangeEvt(event:MouseEvent):void
{
	
	plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,rangeEvt);
	plate.stage.removeEventListener(event.type,endRangeEvt);
	
	var sRect:Rectangle=selectRange.getBounds(plate);
	
	for each (var node:CompressedNode in Node_Space) {
		if(node.x<sRect.right&&node.x>sRect.left&&node.y>sRect.top&&node.y<sRect.bottom){
			NodeSpace.browseChild(node);
			setfocus(node,true);
		}	
	}
	
	selectRange.graphics.clear(); 
	
}

/**
 * Event Handler :: Refresh Rectangle graphics while selecting
 * @param event MouseEvent Instance
 */
protected static function rangeEvt(event:MouseEvent):void
{
	
	selectRange.graphics.clear();
	selectRange.graphics.lineStyle(0,0xffffff,0.5);
	selectRange.graphics.beginFill(0xffffff,0.3);
	selectRange.graphics.drawRect(Rsx,Rsy,plate.mouseX-Rsx,plate.mouseY-Rsy);
	selectRange.graphics.endFill();
	
	event.updateAfterEvent();
}