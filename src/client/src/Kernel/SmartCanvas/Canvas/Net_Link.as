/**this file is part of class Net
 * Net -> Link Management
 * including create link, load link
 */

///Record the attemption to link two nodes.
private static var trylinking:Boolean=false;

/**
 * Listener for start link attemption 
 */
private static function tryLink(e):void {
	plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,flushline);
	plate.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,endtryLink);
	
	///record the node from which the link start
	CurrentBlock=e.target;
	
	
	trylinking=true;
}


/**
 * Listener for end link attemption 
 * @see Node
 */
private static function tryLink2(e):void {
	
	if (trylinking) {
		if (e.target!=CurrentBlock) {
			setfocus(link(CurrentBlock.NodeLink,e.target.NodeLink));
		}
		CurrentBlock=null;
	}
	
	///clear 
	endtryLink();
}


/**
 * Finish linking
 */
private static function endtryLink(e=null):void{
	
	plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,flushline);
	plate.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,endtryLink);
	
	trylinking=false;
	
	///Clear indicator line
	cover.graphics.clear();
}

/**
 * Draw indicator line
 */
private static function flushline(e:MouseEvent):void{
	cover.graphics.clear();
	cover.graphics.lineStyle(2,JOINT_LINE_COLOR,0.8);
	cover.graphics.moveTo(CurrentBlock.x,CurrentBlock.y);
	cover.graphics.lineTo(cover.mouseX,cover.mouseY);
	cover.graphics.drawCircle(cover.mouseX,cover.mouseY,3);
	e.updateAfterEvent();
}


/**
 * Create a link
 * @param obj1 Start node (Compressed)
 * @param obj2 End node (Compressed)
 * @param type link type
 * @return line instance (Compressed)
 * @see CompressedLine
 * @see CompressedNode
 */
public static function link(obj1:CompressedNode,obj2:CompressedNode,type:String="Default"):CompressedLine {
	
	obj1.Linklist[obj2.ID]=obj2;
	obj2.Linklist[obj1.ID]=obj1;
	
	var rID:String=String((new Date).getTime());
	
	var arrow:CompressedLine=Link_Space[rID]=new CompressedLine(rID,LinkTypeInit.LinkTypeList[type].label,obj1,obj2,LinkTypeInit.LinkTypeList[type]);
	
	LinkSpace.AddChild(RealizeLine(arrow));
	
	arrow.detail={
		NAME:LinkTypeInit.LinkTypeList[type].label,
		TYPE:type,
		Description:"Add your descriptions here by clicking <b>EDIT</b>!"
	}
	
	//////Change type here
	obj1.Arrowlist[rID]=arrow;
	obj2.Arrowlist[rID]=arrow;
	
	obj1.Edges++;
	obj2.Edges++;
	
	PerspectiveViewer.refreshPerspective();
	
	
	Navigator.refreshMap();
	
	RecordLineExistance(arrow,ADD_LINE);
	
	return arrow;
}


/**
 * Create the UI instance of the link
 * CompressedLine (Compressed) -> BioArrow (UI Component)
 * @param line Compressed instance
 * @return UI instance of the link
 */
public static function RealizeLine(line:CompressedLine):BioArrow{
	line.Instance=new BioArrow(line);
	line.Instance.addEventListener("destroy",function (e):void{DestoryLink(e.target.Creator)});
	line.Instance.addEventListener("ClickOn",function(e):void{setfocus(e.target.Creator)});
	return line.Instance;
}


/**
 * Append the UI instance of the link to user interface
 * @line Compressed link instance
 */
public static function WakeLine(line:CompressedLine):void{
	if (line.Instance==null) {
		RealizeLine(line);	
	}
	LinkSpace.wakeLine(line);
}


/**
 * Load a link
 * @param id Link ID
 * @param refID Reference ID
 * @param obj1 Start node (Compressed)
 * @param obj2 End node (Compressed)
 * @param type link type
 * @param detail link detail
 * @param picked Whether the link is initinally Picked (Fast redraw mode)
 * @see LinePicker
 * @return line instance (Compressed)
 * @see CompressedLine
 * @see CompressedNode
 */
public static function loadLink(id:String,refID:String,nam:String,obj1:CompressedNode,obj2:CompressedNode,type="Default",detail="{}",picked=false):CompressedLine {
	if(obj1==null||obj2==null){
		trace("Try Link Before Node Created");
		trace("\t",id);
	}else if(obj1.Linklist[obj2.ID]==null){
		obj1.Linklist[obj2.ID]=obj2;
		obj2.Linklist[obj1.ID]=obj1;
		
		var typ:LinkType;
		if(LinkTypeInit.LinkTypeList[type]==null){
			typ=LinkTypeInit.LinkTypeList["Default"];
		}else{
			typ=LinkTypeInit.LinkTypeList[type];
		}
		
		if(nam==null){
			if(LinkTypeInit.LinkTypeList[type]!=null){
				nam=LinkTypeInit.LinkTypeList[type].label
			}else{
				nam=type;
			}
		}
		var arrow:CompressedLine=Link_Space[id]=new CompressedLine(id,nam,obj1,obj2,typ,detail);
		arrow.refID=refID;
		
		if(picked){
			LinkSpace.pickMultiLines([arrow]);
		}else{
			LinkSpace.AddCompressedChild(arrow);
		}
		
		obj1.Arrowlist[id]=arrow;
		obj2.Arrowlist[id]=arrow;
		
		obj1.Edges++;
		obj2.Edges++;
		
	}
	return arrow;
}


