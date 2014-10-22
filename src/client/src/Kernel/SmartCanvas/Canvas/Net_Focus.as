/**this file is a part of Class Net
 * Net -> Focus Management
 */

 
 /**
 * set focus items on Net
 * @param target Item to set focus on
 * @param multi If it is multi-selection (not kill previous focus)
 * @param ani If animation is used.
 */
public static function setfocus(target,multi=false,ani=true):void {
	
	target.Instance.setFocus(ani);
	
	if(multi){
		////////Must be CompressedNode
		
		if (focusedLine!=null) {	
			focusedLine.loseFocus();
			focusedLine=null;
		}
		if(PickList[target.ID]==null){
			PickList[target.ID]=target.Instance;
			NodeSpace.PopUp(target.Instance);
		}else{
			PickList[target.ID].loseFocus(ani);
			delete PickList[target.ID];
			return;
		}
		
	}else{
		
		for each (var node:BioNode in PickList) {
			if(node!=target.Instance){
				node.loseFocus(ani);
				NodeSpace.compressChild(node);
			}
		}
		
		if (focusedLine!=null&&focusedLine != target.Instance) {	
			focusedLine.loseFocus();
			
			LinkSpace.compressMultiLines([focusedLine.Creator]);
			
			focusedLine=null;
		}
		
		PickList=[];
		
		if(target.constructor==CompressedNode){
			PickList[target.ID]=target.Instance;
			NodeSpace.PopUp(target.Instance);
		}else {
			focusedLine=target.Instance;
		}
	}
	
	GlobalVaribles.FocusedTarget=target;
	GlobalVaribles.FocusEventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,target));
}


/**
 * Kill all focus on Net, include nodes and links. 
 */
private static function KillAllFocus(e=null):void {
	cancel_centerView();
	for each (var node:BioNode in PickList) {
		node.loseFocus(true);
	}
	PickList=[];
	
	if(focusedLine!=null){
		focusedLine.loseFocus();
		focusedLine=null;
	}
	
	GlobalVaribles.FocusedTarget=null;
	GlobalVaribles.FocusEventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
	
	NodeSpace.compressAllChild();
	
	LinkSpace.compressAllChild();
	
	endtryLink();
	
}