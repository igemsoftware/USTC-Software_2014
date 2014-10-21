import IEvent.FocusItemEvent;

import Assembly.BioParts.BioBlock;
import Assembly.Compressor.CompressedNode;

// ActionScript file
//////Focus Manager
public static function setfocus(tar,multi=false):void {
	
	tar.Instance.setFocus();
	
	if(multi){
		////////Must be CompressedNode
		
		if (focusedLine!=null) {	
			focusedLine.loseFocus();
		}
		if(PickList[tar.ID]==null){
			PickList[tar.ID]=tar.Instance;
			BlockSpace.PopUp(tar.Instance);
		}else{
			PickList[tar.ID].loseFocus();
			delete PickList[tar.ID];
			return;
		}
		
	}else{
		
		for each (var node:BioBlock in PickList) {
			if(node!=tar.Instance){
				node.loseFocus();
				BlockSpace.compressChild(node);
			}
		}
		
		if (focusedLine!=null&&focusedLine != tar.Instance) {	
			focusedLine.loseFocus();
			LineSpace.compressMultiLines([focusedLine.Creator]);
		}
		
		PickList=[];
		
		if(tar.constructor==CompressedNode){
			PickList[tar.ID]=tar.Instance;
			BlockSpace.PopUp(tar.Instance);
		}else {
			focusedLine=tar.Instance;
		}
	}
	
	GlobalVaribles.FocusedTarget=tar;
	GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,tar));
}

private static function KillAllFocus(e=null):void {
	
	if (centerView){
		cancel_centerView();
	}else{
		for each (var node:BioBlock in PickList) {
			PickList[node.NodeLink.ID].loseFocus();
			delete PickList[node.NodeLink.ID];
		}
		
		if(focusedLine!=null){
			focusedLine.loseFocus();
			focusedLine=null;
		}
		
		GlobalVaribles.FocusedTarget=null;
		GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
		
		BlockSpace.compressAllChild();
		
		LineSpace.compressAllChild();
		
	}
	endtryLink();
	
}