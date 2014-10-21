/**this file is a part of Class Net, but for Layout function
 * Net -> CenterView Interface
 * @see LayoutPanel
 * @see CenterLayout
 */

///Node set as center
private static var centeredBlock:CompressedNode;

///Center Layout solve
private static var centerSolve:Object;


/**
 * Apply Center Layout
 * @param node node at center
 */
public static function DragClose(node:BioNode):void{
	if (node.NodeLink!=centeredBlock) {
		
		centeredBlock=node.NodeLink;
		
		RecordPosition(centeredBlock.Linklist)
	}
	centerSolve=CenterLayout.CUL_Center(centeredBlock);
	var res:Array=CenterLayout.cal_Position(centerSolve,centeredBlock);
	for each (var lnode:CompressedNode in centeredBlock.Linklist) {
		lnode.remPosition[0]=lnode.aimPosition[0]=res[lnode.ID][0];
		lnode.remPosition[1]=lnode.aimPosition[1]=res[lnode.ID][1];
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
}

/**
 * finish center Layout setting
 */
public static function cancel_centerView():void{
	if(focus_circle!=null){
		Tween.fadeOut(focus_circle);
		focus_circle.addEventListener("destory",function (e):void{
			if(focus_circle!=null){
				if(bottom.contains(focus_circle)){
					bottom.removeChild(focus_circle);
				}
				focus_circle=null;
			}
		},false,0,true);
		centeredBlock=null;
	}
}

/**
 * Event Handler :: when stop draging center circle
 */
protected static function PickFullCirile(event:Event):void
{
	for each (var node:CompressedNode in centeredBlock.Linklist) {
		LinkSpace.pickMultiLines(node.Arrowlist);
	}
	focus_circle.addEventListener("StopDrag",PlaceFullCirile);
	focus_circle.addEventListener("y_scaling",ChangingCenterRadius);
}

/**
 * Event Handler :: when stop draging center circle
 */
protected static function PlaceFullCirile(event:Event):void
{
	LinkSpace.placePickedLines();
	focus_circle.removeEventListener("StopDrag",PlaceFullCirile);
	focus_circle.removeEventListener("y_scaling",ChangingCenterRadius);
}


/**
 * Event Handler :: when changing center layout radius
 */
public static function  ChangingCenterRadius(e):void{
	centeredBlock.centerRadius=e.target.width/2/scaleXY;
	var res:Array=CenterLayout.cal_Position(centerSolve,centeredBlock,focus_circle.x/scaleXY,focus_circle.y/scaleXY);
	
	var arrow:CompressedLine;
	
	Net.NodeSpace.removeMultiChild(centeredBlock.Linklist);
	
	for each (var node:CompressedNode in centeredBlock.Linklist) {
		var ax:Number=res[node.ID][0];
		var ay:Number=res[node.ID][1];
		
		node.remPosition[0]=node.Position[0]=ax;
		node.remPosition[1]=node.Position[1]=ay;
		
		node.x=ax*FreePlate.scaleXY;
		node.y=ay*FreePlate.scaleXY;
		
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
	Net.NodeSpace.AddMulitCompressedChild(centeredBlock.Linklist);
	LinkSpace.flushPickedLines();
	
	Navigator.refreshMap();
}