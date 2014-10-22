import Biology.Types.LinkType;

import Biology.LinkTypeInit;


// ActionScript file
private static var trylinking:Boolean=false;

private static function tryLink(e):void {
	plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,flushline);
	plate.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,endtryLink);
	CurrentBlock=e.target;
	trylinking=true;
}
private static function tryLink2(e):void {
	
	if (trylinking) {
		if (e.target!=CurrentBlock) {
			for each(var node:CompressedNode in CurrentBlock.NodeLink.LinkOutlist) {
				if (e.target.NodeLink==node) {
					endtryLink();
					return;
				}
			}
			setfocus(link(CurrentBlock.NodeLink,e.target.NodeLink));
		}
		CurrentBlock=null;
	}
	
	endtryLink();
}

private static function endtryLink(e=null):void{
	
	plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,flushline);
	plate.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,endtryLink);
	trylinking=false;
	cover.graphics.clear();
}

private static function flushline(e:MouseEvent):void{
	cover.graphics.clear();
	cover.graphics.lineStyle(2,JOINT_LINE_COLOR,0.8);
	cover.graphics.moveTo(CurrentBlock.x,CurrentBlock.y);
	cover.graphics.lineTo(cover.mouseX,cover.mouseY);
	cover.graphics.drawCircle(cover.mouseX,cover.mouseY,3);
	e.updateAfterEvent();
}

public static function link(obj1:CompressedNode,obj2:CompressedNode,type:String="Default"):CompressedLine {
	obj1.LinkOutlist[obj2.ID]=obj2;
	obj2.LinkInlist[obj1.ID]=obj1;
	var rev:Boolean=false;
	for each(var arrow:CompressedLine in obj1.Arrowlist) {
		if (obj2==arrow.linkObject[0]) {
			rev=true;
			break;
		}
	}
	if (rev) {
		arrow.DoubleDirec=true;
		LineSpace.flushChild(arrow);
	}else {
		obj1.Linklist[obj2.ID]=obj2;
		obj2.Linklist[obj1.ID]=obj1;
		
		var rID:String=String((new Date).getTime());
		
		arrow=Linker_space[rID]=new CompressedLine(rID,LinkTypeInit.LinkTypeList[type].label,obj1,obj2,LinkTypeInit.LinkTypeList[type]);
		
		RealizeLine(arrow);
		
		LineSpace.AddChild(RealizeLine(arrow));
		
		//////Change type here
		obj1.Arrowlist[rID]=arrow;
		obj2.Arrowlist[rID]=arrow;
		
		obj1.Edges++;
		obj2.Edges++;
		
		PerspectiveViewer.refreshPerspective();
	}
	
	Navigator.refreshMap();
	
	RecordLineExistance(arrow,ADD_LINE);
	
	return arrow;
}

public static function RealizeLine(line:CompressedLine):BioArrow{
	line.Instance=new BioArrow(line);
	line.Instance.addEventListener("destroy",function (e):void{DestoryLink(e.target.Creator)});
	line.Instance.addEventListener("ClickOn",function(e):void{setfocus(e.target.Creator)});
	return line.Instance;
}

public static function WakeLine(line:CompressedLine):void{
	if (line.Instance==null) {
		RealizeLine(line);	
	}
	LineSpace.wakeLine(line);
}

public static function loadLink(id:String,nam:String,obj1:CompressedNode,obj2:CompressedNode,type="Default",doubleDirec=false,picked=false):CompressedLine {
	if(obj1==null||obj2==null){
		trace("Try Link Before Node Created");
		trace("\t",id);
	}else if(obj1.Linklist[obj2.ID]==null){
		obj1.LinkOutlist[obj2.ID]=obj2;
		obj2.LinkInlist[obj1.ID]=obj1;
		obj1.Linklist[obj2.ID]=obj2;
		obj2.Linklist[obj1.ID]=obj1;
		
		if (doubleDirec) {
			obj2.LinkOutlist[obj1.ID]=obj1;
			obj1.LinkInlist[obj2.ID]=obj2;
		}
		
		var typ:LinkType;
		if(LinkTypeInit.LinkTypeList[type]==null){
			typ=LinkTypeInit.LinkTypeList["Default"];
		}else{
			typ=LinkTypeInit.LinkTypeList[type];
		}
		
		var arrow:CompressedLine=Linker_space[id]=new CompressedLine(id,nam,obj1,obj2,typ);
		
		arrow.DoubleDirec=doubleDirec;
		
		if(picked){
			LineSpace.pickMultiLines([arrow]);
		}else{
			LineSpace.AddCompressedChild(arrow);
		}
		
		obj1.Arrowlist[id]=arrow;
		obj2.Arrowlist[id]=arrow;
		
		obj1.Edges++;
		obj2.Edges++;
		
		/////////Refresh by caller;
	}
	return arrow;
}


