import IEvent.FocusItemEvent;

import Assembly.BioParts.BioBlock;
import Assembly.Compressor.CompressedNode;

// ActionScript file
//////Focus Manager
public static function setfocus(tar,multi=false,ani=true):void {
	
	tar.Instance.setFocus(ani);
	
	if(multi){
		////////Must be CompressedNode
		
		if (focusedLine!=null) {	
			focusedLine.loseFocus();
		}
		if(PickList[tar.ID]==null){
			PickList[tar.ID]=tar.Instance;
			BlockSpace.PopUp(tar.Instance);
		}else{
			PickList[tar.ID].loseFocus(ani);
			delete PickList[tar.ID];
			return;
		}
		
	}else{
		
		for each (var node:BioBlock in PickList) {
			if(node!=tar.Instance){
				node.loseFocus(ani);
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
			node.loseFocus(true);
		}
		PickList=[];
		
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