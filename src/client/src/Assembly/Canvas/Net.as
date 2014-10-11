package Assembly.Canvas {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Assembly.YelloCircle;
	import Assembly.BioParts.BioArrow;
	import Assembly.BioParts.BioBlock;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	import Assembly.Compressor.SmartCanvas;
	import Assembly.Compressor.SmartLinkage;
	import Assembly.Compressor.TextMapLoader;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Biology.Types.LinkType;
	
	import Biology.LinkTypeInit;
	import Biology.NodeTypeInit;
	
	import FunctionPanel.PerspectiveViewer;
	
	import IEvent.FocusItemEvent;
	
	import Layout.Sorpotions.Navigator;
	
	import Style.AniContainer;
	import Style.Tween;
	import Style.TweenX;
	
	import algorithm.Center_Cal;
	
	
	public class Net extends GxmlContainer {
		public const REVEAL_SCALE_BLOCK:uint=0;
		public const REVEAL_SCALE_NODE:Number=0.9;
		public const POINT_SCALE_NODE:Number=0.7;
		
		private static const JOINT_LINE_COLOR:int=0x1166ff;
		private const BACKGROUND_COLOR:int=0xffffff;
		
		private static var cover:Sprite;
		public static var BlockSpace:SmartCanvas;
		public static var LineSpace:SmartLinkage=new SmartLinkage();;
		public static var bottom:Sprite;
		private static var selectRange:Sprite=new Sprite();
		private static var ShadowSpace:Sprite;
		
		public static var ani_container:AniContainer=new AniContainer();
		
		private static var focus_circle:YelloCircle;
		
		private static var focusedLine:BioArrow;
		
		public static var PickList:Array=[];
		
		private static var remScaleXY:Number=1;
		
		private static var CanvasWidth:Number,CanvasHeight:Number;
		
		private static var CurrentBlock:BioBlock;
		
		///////ADD Block
		include"Net_Node.as"
		/////Link
		include"Net_Link.as"
		////////Center View
		include"Net_CenterView.as"
		////////Del
		include"Net_Destory.as"
		////////Range
		include "Net_Range.as"
		////////Drop
		include"Net_Drop.as"
		/////////Focus
		include"Net_Focus.as"
		
		public function Net() {
			cacheAsBitmap=true;
			
			plate.cacheAsBitmap=true;
			
			addChild(back);
			addChild(grid);
			addChild(plate);
			
			restore();
			
			setHabit();
			
			back.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				stage.focus=null;
			});
			
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				stage.addEventListener(KeyboardEvent.KEY_UP,key_mon);
			});

		}
		
		private function key_mon(e:KeyboardEvent):void {
			switch (e.keyCode){
				case Keyboard.ESCAPE:{
					KillAllFocus();
					break;
				}
				case Keyboard.DELETE:{
					DeleteFocus()
					break;
				}
					
			}
		}
		
		public static function SelectAround(node:CompressedNode):void
		{
			if(!node.Instance.focused){
				setfocus(node,true);
			}
			for each (var pnode:CompressedNode in node.Linklist){
				BlockSpace.browseChild(pnode);
				if(!pnode.Instance.focused){
					setfocus(pnode,true);
				}
			}
				
		}

		public static function setHabit():void{
			if(GlobalVaribles.LeftHabit){
				
				back.removeEventListener(MouseEvent.MOUSE_DOWN,KillAllFocus);
				back.removeEventListener(MouseEvent.MOUSE_DOWN,startRangeEvt);
				back.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,MoveStage);
				
				back.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,KillAllFocus);
				back.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,startRangeEvt);
				back.addEventListener(MouseEvent.MOUSE_DOWN,MoveStage);
			}else{
				back.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,KillAllFocus);
				back.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,startRangeEvt);
				back.removeEventListener(MouseEvent.MOUSE_DOWN,MoveStage);
				
				back.addEventListener(MouseEvent.MOUSE_DOWN,KillAllFocus);
				back.addEventListener(MouseEvent.MOUSE_DOWN,startRangeEvt);
				back.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,MoveStage);
			}
		}
		
		public function setSize(w:Number,h:Number):void{
			var left:Number=-Math.floor(x/50)*50;
			var right:Number=left+w;
			
			var top:Number=-Math.floor(y/50)*50;
			var buttom:Number=top+h;
			
			back.graphics.clear();
			back.graphics.beginFill(BACKGROUND_COLOR,0.1);
			back.graphics.drawRect(left-50,top-50,w+100,h+100);
			back.graphics.endFill();
			
			grid.graphics.clear();
			grid.graphics.lineStyle(0,0xffffff,0.2,true);
			grid.cacheAsBitmap=true;
			
			for (var i:int=left-50; i<right; i+=50) {
				grid.graphics.moveTo(i,top-100);
				grid.graphics.lineTo(i,buttom+50);
			}
			for (i=top-50; i<buttom; i+=50) {
				grid.graphics.moveTo(left-100,i);
				grid.graphics.lineTo(right+50,i);
			}
		}
		
		public static function RedrawFocus(tar:*):void
		{
			if (tar.constructor == CompressedNode) {
				BlockSpace.flushChild(tar);
			}else if (tar.constructor == CompressedLine) {
				LineSpace.flushChild(tar);
			}
		}
		
		public static function ShapeRedraw():void{
			BlockSpace.ClearCompressSpace();
			for each (var tar:CompressedNode in Block_space) {
				if (BlockSpace.isFloating(tar)) {
					tar.Instance.redraw();
				}else{
					BlockSpace.AddCompressedChild(tar);
				}
			}
		}
		
		public static function LinkRedraw(e=null):void{
			for each (var line:CompressedLine in Linker_space) {			
				line.setLine();
			}
			LineSpace.Redraw();
		}
		
		////Scale
		public static function ChangeScale(scale,setScale=false):void{
			scaleXY=scale;
			
			plate.x=PlateLocation[0]*scale;
			plate.y=PlateLocation[1]*scale;
			
			if (setScale) {
				remScaleXY=scaleXY;
				plate.scaleX=plate.scaleY=1;
				ScaleRedraw();
				if (centeredBlock!=null &&focus_circle!=null) {
					focus_circle.x=centeredBlock.x;
					focus_circle.y=centeredBlock.y;
					focus_circle.redraw(centeredBlock.centerRadius*scaleXY);
				}
				Navigator.refreshMap();
			}else{
				
				plate.scaleX=plate.scaleY=scaleXY/remScaleXY;
				
				Navigator.refreshRange();
			}
		}
		
		private static function ScaleRedraw(e=null):void{
			BlockSpace.ClearCompressSpace();
			for each (var tar:CompressedNode in Block_space) {
				tar.x=tar.Position[0]*scaleXY;
				tar.y=tar.Position[1]*scaleXY;
				if (BlockSpace.isFloating(tar)) {
					tar.Instance.resetScale();
				}else{
					BlockSpace.AddCompressedChild(tar);
				}
			}
			LinkRedraw();
		}
		
		
			
		///////Centerlize
		
		public static function Centerlize(tar):void{
			Tween.GlideNet(-tar.x,-tar.y);
			
			if (tar.Instance==null) {
				if (tar.constructor==CompressedNode) {
					BlockSpace.browseChild(tar);
				}else if (tar.constructor==CompressedLine) {
					WakeLine(tar);
				}
			}
			
			/////This is a time when node is a Instance but not floated
			
			setfocus(tar,false,false);
		}
		
		public static function toCenterPosition():void{
			var rect:Rectangle=plate.getBounds(plate);
			
			Tween.GlideNet(-rect.width/2-rect.left,-rect.height/2-rect.top);
		}
		
		public static function restore():void{
			GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
			plate.removeChildren(0);
			
			focusedLine=null;
			PickList=[];
			
			cover=new Sprite();
			cover.mouseEnabled=false;
			BlockSpace=new SmartCanvas();
			LineSpace.restore()
			bottom=new Sprite();
			
			bottom.cacheAsBitmap=true;
			
			Navigator.setTarget(plate);
			
			Block_space=new Array();
			Linker_space=new Array();
			
			centerView=false;
			
			plate.addChild(bottom);
			plate.addChild(selectRange);
			plate.addChild(LineSpace);
		
			//	plate.addChild(ShadowSpace);
			plate.addChild(BlockSpace);
			plate.addChild(cover);
			
			PerspectiveViewer.refreshPerspective();
			
		}
		public function setCenter(cx,cy):void{
			x=cx;
			y=cy;
		}
		
		
	}
	
}