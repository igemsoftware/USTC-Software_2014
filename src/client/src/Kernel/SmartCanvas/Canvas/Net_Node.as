/**this file is part of class Net
 * Net -> Node Management
 * including create node, load node
 */


///Record the attemption to add node
private static var isAddingBlock:Boolean=false;


/**
 * Create a node
 * @param id node ID
 * @param nam node name
 * @param type node type
 * @see CompressedNode
 */
public static function addNode(id:String,nam:String,type:String):void {
	if (!isAddingBlock) {
		if (Node_Space[id]==null) {
			var tar:CompressedNode;
			if (id==""||id.length!=24) {
				id=String((new Date()).getTime());
				
				var tmpName:String="New "+type;
				
				tar=Node_Space[id]=new CompressedNode(id,tmpName,NodeTypeInit.BiotypeList[type],plate.mouseX/scaleXY,plate.mouseY/scaleXY);
				
				tar.detail={
					NAME:tmpName,
					TYPE:type,
					Description:"Add your descriptions here by clicking <b>EDIT</b>!"
				};
			}else{
				tar=Node_Space[id]=new CompressedNode(id,"New "+type,NodeTypeInit.BiotypeList[type],plate.mouseX/scaleXY,plate.mouseY/scaleXY);
			}
			if (nam!="") {
				tar.Name=nam;
			}
			isAddingBlock=true;
			EmergeBlock(tar);
		}else{
			Centerlize(Node_Space[id]);
		}
		PerspectiveViewer.refreshPerspective();
	}
}

/**
 * Wake up a compressed node (CompressedNode -> BioNode)
 * For picking a compressed node from compressed Canvas
 * @see SmartNodeSpace
 */
public static function WakeBlock(node:CompressedNode):void{
	if (node.Instance==null) {
		var b:BioNode=RealizeBlock(node);
		b.ready(false);
	}
}


/**
 * Create the UI instance of  a compressed node (CompressedNode -> BioNode)
 * @param node Target CompressedNode (Compressed)
 * @return the instance of the BioNode (UI Component)
 */
public static function RealizeBlock(node:CompressedNode):BioNode{
	node.Instance=new BioNode(node);
	setNode(node.Instance);
	return node.Instance;
}

///Mouse track
private static var DmouseX:int,DmouseY:int;

/**
 * Wake up a compressed node (CompressedNode -> BioNode)
 * For adding a VISIBLE node instance (addNode)
 * @see addNode
 */
public static function EmergeBlock(node:CompressedNode):BioNode{
	CurrentBlock=RealizeBlock(node);
	NodeSpace.AddChild(CurrentBlock);
	DmouseX=plate.mouseX;
	DmouseY=plate.mouseY;
	plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,try_setpos);
	plate.stage.addEventListener(MouseEvent.MOUSE_DOWN,setpos);
	CurrentBlock.startDrag3D(true);
	return CurrentBlock;
}

/**
 * Estimate user's intention
 * if node has not been moved far, wait until next MOUSE_DOWN.
 * otherwise put the node to canvas when MOUSE_UP 
 */
protected static function try_setpos(event:MouseEvent):void
{
	if ((DmouseX-plate.mouseX)>5||(DmouseY-plate.mouseY)>5) {
		plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,try_setpos);
		plate.stage.addEventListener(MouseEvent.MOUSE_UP,setpos);
		plate.stage.removeEventListener(MouseEvent.MOUSE_DOWN,setpos);
	}
}


/**
 * Load a node (Compressed)
 * @param id node ID
 * @param refID reference node ID
 * @see SyncManager
 * @param _name node name
 * @param px node location X 
 * @param py node location Y 
 * @param biotp node type
 * @param detail node detail
 * @see CompressedNode
 * @see SmartNodeSpace
 * @see PartitialBuffer
 * @see Partition
 */
public static function loadCompressedBlock(id:String,refID:String,_name:String,px:Number,py:Number,biotp:String,detail:String="{}"):CompressedNode {
	if (Node_Space[id]==null) {
		var tar:CompressedNode=Node_Space[id]=new CompressedNode(id,_name,NodeTypeInit.BiotypeList[biotp],px,py,detail);
		trace("refID : ",refID);
		tar.refID=refID;
		tar.TextMap=TextMapLoader.generateTextMap(_name);
		tar.textY=Math.round(tar.skindata.radius/2);	
		NodeSpace.AddCompressedChild(tar);
	}
	return Node_Space[id];
}

/**
 * regist listeners for a BioNode.
 * @param target BioNode to be registed.
 */
private static function setNode(target:BioNode):void{
	
	target.resetScale();
	
	target.addEventListener("tryLink",tryLink);
	target.addEventListener("upOnThis",tryLink2);
	target.addEventListener("StartDrag",function (e):void{
		
		if(!e.target.focused){
			RecordPosition([e.target.NodeLink]);	
			LinkSpace.pickMultiLines(e.target.NodeLink.Arrowlist);
			e.target.startDrag3D();
		}else{
			var tmpArr:Array=[]
			
			for each (var node:BioNode in PickList) {
				tmpArr.push(node.NodeLink);
				LinkSpace.pickMultiLines(node.NodeLink.Arrowlist);
				node.startDrag3D();
			}
			RecordPosition(tmpArr);
		}
	})
	target.addEventListener("StopDrag",function (e):void{
		
		if(!e.target.focused){
			e.target.stopDrag3D();
		}else{
			for each (var node:BioNode in PickList) {
				node.stopDrag3D();
			}
		}
		
		LinkSpace.placePickedLines();
		
	})
	target.addEventListener("FlushMovingLines",function (e):void{
		LinkSpace.flushPickedLines();
	})
}

/**
 * Event Handler : set the position of a draged node
 * @param e Event Instance
 */
private static function setpos(e):void{
	
	plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,try_setpos);
	plate.stage.removeEventListener(MouseEvent.MOUSE_DOWN,setpos);
	plate.stage.removeEventListener(MouseEvent.MOUSE_UP,setpos);
	CurrentBlock.stopDrag3D();
	CurrentBlock.ready(CurrentBlock.NodeLink.ID.length!=24);
	
	setfocus(CurrentBlock.NodeLink);
	
	if(CurrentBlock.NodeLink.ID.length==24){
		ExpandManager.Expand(CurrentBlock.NodeLink,ExpandManager.LINKLINES);
	}
	
	RecordNodeExistance(CurrentBlock.NodeLink,ADD_NODE);
	
	CurrentBlock=null;
	isAddingBlock=false;

}