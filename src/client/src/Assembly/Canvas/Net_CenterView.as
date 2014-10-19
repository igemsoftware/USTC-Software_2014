import Assembly.YelloCircle;

// ActionScript file

private static var centeredBlock:CompressedNode;
private static var centerView:Boolean=false;
private static var centerSolve:Object;
public static function DragClose(node:BioBlock=null):void{
	if (node==null) {
		
	}else if (node.NodeLink!=centeredBlock) {
		centeredBlock=node.NodeLink;
	}
	centerSolve=Center_Cal.CUL_Center(centeredBlock);
	var res:Array=Center_Cal.cal_Position(centerSolve,centeredBlock);
	for each (var lnode:CompressedNode in centeredBlock.Linklist) {
		lnode.aimPosition[0]=res[lnode.ID][0];
		lnode.aimPosition[1]=res[lnode.ID][1];
		lnode.centerBlock=centeredBlock;
		TweenX.GlideNode(lnode);
	}
	//LineSpace.dimLight();
	
	if(focus_circle==null){
		focus_circle=new YelloCircle(centeredBlock.centerRadius*scaleXY);
		focus_circle.addEventListener("StartDrag",PickFullCirile);
	}else{
		focus_circle.redraw(centeredBlock.centerRadius*scaleXY);
	}
	focus_circle.x=centeredBlock.x;
	focus_circle.y=centeredBlock.y;
	bottom.addChild(focus_circle);
	focus_circle.scaleX=focus_circle.scaleY=0;
	Tween.zoomIn(focus_circle);
	centerView=true;
}

protected static function cancel_centerView():void{
	if (centerView) {
		for each (var tar:CompressedNode in Block_space) {
			if (tar.visible&&tar.Position[0]!=tar.remPosition[0]&&tar.Position[1]!=tar.remPosition[1]) {
				tar.AimToRemPostion();
				tar.centerBlock=null;
				TweenX.GlideNode(tar);
			}
		}
		//LineSpace.normalLight();
		Tween.fadeOut(focus_circle);
		focus_circle.addEventListener("destory",function (e):void{
			bottom.removeChild(focus_circle);
			focus_circle=null;
		});
		centeredBlock=null;
		centerView=false;
	}
}

protected static function PickFullCirile(event:Event):void
{
	for each (var node:CompressedNode in centeredBlock.Linklist) {
		LineSpace.pickMultiLines(node.Arrowlist);
	}
	focus_circle.addEventListener("StopDrag",PlaceFullCirile);
	focus_circle.addEventListener("y_scaling",y_scaling);
}

protected static function PlaceFullCirile(event:Event):void
{
	LineSpace.placePickedLines();
	focus_circle.removeEventListener("StopDrag",PlaceFullCirile);
	focus_circle.removeEventListener("y_scaling",y_scaling);
}

public static function  y_scaling(e):void{
	centeredBlock.centerRadius=e.target.width/2/scaleXY;
	var res:Array=Center_Cal.cal_Position(centerSolve,centeredBlock,focus_circle.x/scaleXY,focus_circle.y/scaleXY);
	
	var arrow:CompressedLine;
	
	Net.BlockSpace.removeMultiChild(centeredBlock.Linklist);
	
	for each (var node:CompressedNode in centeredBlock.Linklist) {
		var ax:Number=res[node.ID][0];
		var ay:Number=res[node.ID][1];
		
		node.Position[0]=ax;
		node.Position[1]=ay;
		
		node.x=ax*I3DPlate.scaleXY;
		node.y=ay*I3DPlate.scaleXY;
		
		if(node.Instance!=null){
			node.Instance.x=node.x;
			node.Instance.y=node.y;
			
			if (node.Instance.focusCircle!=null) {
				node.Instance.focusCircle.x=node.Instance.x;
				node.Instance.focusCircle.y=node.Instance.y;
			}
		}
		for each(arrow in node.Arrowlist) {
			arrow.setLine();
		}
	}
	Net.BlockSpace.AddMulitCompressedChild(centeredBlock.Linklist);
	LineSpace.flushPickedLines();
	
	Navigator.refreshMap();
}