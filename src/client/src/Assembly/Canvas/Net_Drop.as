import Assembly.BioParts.BioBlock;
import Assembly.Compressor.CompressedNode;

import Style.Tween;

// ActionScript file
//////////Drop Manager
public function DropTest(tar):*{
	var res:CompressedNode=BlockSpace.DropObjectTest(tar);
	
	if (res!=null){
		trace("Drop:",res.Name);
		return res;
	}else{
		return null;
	}
	
}

private var DropingTarget:BioBlock;
protected function checkDrop(e):void{
	var tmp:CompressedNode=DropTest(e.target);
	if (tmp!=null) {
		if (tmp.Instance==null) {
			WakeBlock(tmp);
			BlockSpace.PopUp(e.target);
		}
		
		if (tmp.Instance!=DropingTarget) {
			DropingTarget=tmp.Instance;
			focus_circle.redraw(120*scaleXY);
			bottom.addChild(focus_circle);
			focus_circle.x=DropingTarget.x;
			focus_circle.y=DropingTarget.y;
			focus_circle.scaleX=focus_circle.scaleY=0;
			Tween.zoomIn(focus_circle);
		}
	}else{
		DropingTarget=null;
		Tween.fadeOut(focus_circle);
	}
}
protected function checkTree(e):void{
	var tmp:*=DropTest(e.target);
	if (tmp!=null && !tmp.hasFather(e.target)) {
		tmp.Instance.appendChild(e.target);
		if (!e.target.title.selectable) {
			e.target.toFather();
		}
		Tween.fadeOut(focus_circle);
	}
}