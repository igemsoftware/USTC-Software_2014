import Assembly.ExpandThread.ExpandManager;

// ActionScript file
private static var isAddingBlock:Boolean=false;

public static function addBlock(id:String,nam:String,type:String):void {
	if (!isAddingBlock) {
		if (Block_space[id]==null) {
			var tar:CompressedNode;
			if (id==""||id.length!=24) {
				id=String((new Date()).getTime());
				
				var tmpName:String="New "+type;
				
				tar=Block_space[id]=new CompressedNode(id,tmpName,NodeTypeInit.BiotypeList[type],plate.mouseX/scaleXY,plate.mouseY/scaleXY);
				
				tar.detail=JSON.stringify({
					NAME:tmpName,
					TYPE:type,
					Description:"Add your descriptions here by clicking <b>EDIT</b>!"
				});
			}else{
				tar=Block_space[id]=new CompressedNode(id,"New "+type,NodeTypeInit.BiotypeList[type],plate.mouseX/scaleXY,plate.mouseY/scaleXY);
			}
			if (nam!="") {
				tar.Name=nam;
			}
			isAddingBlock=true;
			EmergeBlock(tar);
		}else{
			Centerlize(Block_space[id]);
		}
		PerspectiveViewer.refreshPerspective();
	}
}

public static function WakeBlock(node:CompressedNode):void{
	if (node.Instance==null) {
		var b:BioBlock=RealizeBlock(node);
		b.ready(false);
	}
}

public static function RealizeBlock(node:CompressedNode):BioBlock{
	node.Instance=new BioBlock(node);
	setBlock(node.Instance);
	return node.Instance;
}

private static var DmouseX:int,DmouseY:int;
public static function EmergeBlock(node:CompressedNode):BioBlock{
	CurrentBlock=RealizeBlock(node);
	BlockSpace.AddChild(CurrentBlock);
	DmouseX=plate.mouseX;
	DmouseY=plate.mouseY;
	plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,try_setpos);
	plate.stage.addEventListener(MouseEvent.MOUSE_DOWN,setpos);
	CurrentBlock.startDrag3D(true);
	return CurrentBlock;
}

protected static function try_setpos(event:MouseEvent):void
{
	if ((DmouseX-plate.mouseX)>5||(DmouseY-plate.mouseY)>5) {
		plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,try_setpos);
		plate.stage.addEventListener(MouseEvent.MOUSE_UP,setpos);
		plate.stage.removeEventListener(MouseEvent.MOUSE_DOWN,setpos);
	}
}


public static function loadCompressedBlock(id:String,refID:String,_name:String,px:Number,py:Number,biotp:String,detail:String=""):CompressedNode {
	if (Block_space[id]==null) {
		var tar:CompressedNode=Block_space[id]=new CompressedNode(id,_name,NodeTypeInit.BiotypeList[biotp],px,py,detail);
		trace("refID : ",refID);
		tar.refID=refID;
		tar.TextMap=TextMapLoader.generateTextMap(_name);
		tar.textY=Math.round(tar.skindata.radius/2);	
		BlockSpace.AddCompressedChild(tar);
	}
	return Block_space[id];
}

private static function setBlock(tar:BioBlock):void{
	tar.resetScale();
	
	tar.addEventListener("tryLink",tryLink);
	tar.addEventListener("upOnThis",tryLink2);
	tar.addEventListener("StartDrag",function (e):void{
		
		if(!e.target.focused){
			RecordPosition([e.target.NodeLink]);	
			LineSpace.pickMultiLines(e.target.NodeLink.Arrowlist);
			e.target.startDrag3D();
		}else{
			var tmpArr:Array=[]
			
			for each (var node:BioBlock in PickList) {
				tmpArr.push(node.NodeLink);
				LineSpace.pickMultiLines(node.NodeLink.Arrowlist);
				node.startDrag3D();
			}
			RecordPosition(tmpArr);
		}
	})
	tar.addEventListener("StopDrag",function (e):void{
		
		if(!e.target.focused){
			e.target.stopDrag3D();
		}else{
			for each (var node:BioBlock in PickList) {
				node.stopDrag3D();
			}
		}
		
		LineSpace.placePickedLines();
		
	})
	tar.addEventListener("FlushMovingLines",function (e):void{
		LineSpace.flushPickedLines();
	})
}
private static function setpos(e=null):void{
	
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