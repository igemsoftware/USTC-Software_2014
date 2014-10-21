/**this file is a part of Class Net
 * Net -> Delete Management
 * when deleting:
 * 		for nodes: delete all links from or to the node, then delete node
 * 		for links: delete the link, change link list in linked nodes
 */

/**
 * Delete focused item
 * valid when focus exist
 */
public static function DeleteFocus():void{
	if(focusedLine!=null){
		RecordLineExistance(focusedLine.Creator,DELETE_LINE);
		DestoryLink(focusedLine.Creator);
		
	}else{
		var tmpArr:Array=[];
		for each (var pnode:BioNode in PickList) 
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


/**
 * Delete node
 * @param node node to be deleted
 */
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
		GlobalVaribles.FocusEventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
	}
	NodeSpace.RemoveChild(node);
	
	delete Node_Space[node.ID];

	node.Instance=null;
	
	Navigator.refreshMap();
	PerspectiveViewer.refreshPerspective();
}

/**
 * Delete link
 * @param line link to be deleted
 */
public static function DestoryLink(line:CompressedLine):void {
	///////Both Arrow List
	delete line.linkObject[0].Arrowlist[line.ID];
	
	delete line.linkObject[1].Arrowlist[line.ID];
	
	line.linkObject[0].Edges--;
	
	line.linkObject[1].Edges--;
	
	////////both link list
	delete line.linkObject[0].Linklist[line.linkObject[1].ID];
	
	delete line.linkObject[1].Linklist[line.linkObject[0].ID];
	
	if (GlobalVaribles.FocusedTarget==line) {
		focusedLine.loseFocus();
		focusedLine=null;
		
		GlobalVaribles.FocusedTarget=null;
		GlobalVaribles.FocusEventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
	}
	
	LinkSpace.RemoveChild(line);
	
	delete Link_Space[line.ID];
	
	Navigator.refreshMap();
	
	PerspectiveViewer.refreshPerspective();
}