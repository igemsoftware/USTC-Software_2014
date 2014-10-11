import Assembly.Compressor.CompressedNode;

///////////Destory Manager
public static function DeleteFocus():void{
	if(focusedLine!=null){
		RecordLineExistance(focusedLine.Creator,DELETE_LINE);
		DestoryLink(focusedLine.Creator);
		
	}else{
		var tmpArr:Array=[];
		for each (var pnode:BioBlock in PickList) 
		{
			tmpArr.push(pnode.NodeLink);
		}
		RecordMultiNodeExistance(tmpArr,DELETE_NODE);
		
		for each (var node:CompressedNode in tmpArr) 
		{
			DestoryNode(node);
		}
	}
}

public static function DestoryNode(node:CompressedNode):void {
	if(node.Instance!=null){
		if (node.Instance.focusCircle!=null){
			node.Instance.loseFocus();
		}
		
	}
	
	for each (var arrow:CompressedLine in node.Arrowlist) {
		DestoryLink(arrow);
	}
	
	if(PickList[node.ID]!=null){
		delete PickList[node.ID];
	}
	
	if (GlobalVaribles.FocusedTarget==node) {
		GlobalVaribles.FocusedTarget=null;
		GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
	}
	BlockSpace.RemoveChild(node);
	
	delete Block_space[node.ID];
	
	if (centerView) {
		if (node.centerBlock==centeredBlock) {
			DragClose();
		}
	}
	
	node.Instance=null;
	
	Navigator.refreshMap();
	PerspectiveViewer.refreshPerspective();
}

public static function DestoryLink(line:CompressedLine):void {
	///////Both Arrow List
	delete line.linkObject[0].Arrowlist[line.ID];
	
	delete line.linkObject[1].Arrowlist[line.ID];
	
	line.linkObject[0].Edges--;
	
	line.linkObject[1].Edges--;
	
	////////both link list
	delete line.linkObject[0].Linklist[line.linkObject[1].ID];
	
	delete line.linkObject[1].Linklist[line.linkObject[0].ID];
	
	if (centerView) {
		if (line.linkObject[0].centerBlock==centeredBlock||line.linkObject[1].centerBlock==centeredBlock) {
			DragClose();
		}
	}
	
	if (GlobalVaribles.FocusedTarget==line) {
		focusedLine.loseFocus();
		focusedLine=null;
		
		GlobalVaribles.FocusedTarget=null;
		GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
	}
	
	LineSpace.RemoveChild(line);
	
	delete Linker_space[line.ID];
	
	Navigator.refreshMap();
	
	PerspectiveViewer.refreshPerspective();
}