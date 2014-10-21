package Kernel.SmartCanvas.Canvas {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Kernel.Biology.LinkTypeInit;
	import Kernel.Biology.NodeTypeInit;
	import Kernel.Biology.Types.LinkType;
	import Kernel.Biology.Types.NodeType;
	import Kernel.Events.FocusItemEvent;
	import Kernel.ExpandThread.ExpandManager;
	import Kernel.ProjectHolder.GxmlContainer;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.SmartCanvas.SmartLinkSpace;
	import Kernel.SmartCanvas.SmartNodeSpace;
	import Kernel.SmartCanvas.Assembly.TextMapLoader;
	import Kernel.SmartCanvas.Assembly.YelloCircle;
	import Kernel.SmartCanvas.Parts.BioArrow;
	import Kernel.SmartCanvas.Parts.BioNode;
	import Kernel.SmartLayout.CenterLayout;
	
	import UserInterfaces.FunctionPanel.PerspectiveViewer;
	import UserInterfaces.Sorpotions.Navigator;
	import UserInterfaces.Style.AniContainer;
	import UserInterfaces.Style.Tween;
	import UserInterfaces.Style.TweenX;
	
	/**
	 * class Net
	 * the Terminal Container of all the bio-network instances.
	 * including:
	 * Node Management
	 * Link Management
	 * Focus Management
	 * Select Management
	 * Delete Management
	 */
	
	public class Net extends FreePlate {
		
		///Color of Joint line (link)
		private static const JOINT_LINE_COLOR:int=0x1166ff;
		
		///background mask color
		private const BACKGROUND_COLOR:int=0xffffff;
		
		///UI Layers:
		///cover -> NodeSpace -> LinkSpace -> bottom
		private static var cover:Sprite;
		public static var NodeSpace:SmartNodeSpace;
		public static var LinkSpace:SmartLinkSpace;
		public static var bottom:Sprite;
		
		///UI assembly 
		/// Selece Rect
		private static var selectRange:Sprite=new Sprite();
		
		/// Animation Manager
		public static var ani_container:AniContainer=new AniContainer();
		
		/// Circle
		private static var focus_circle:YelloCircle;
		
		/// Focus
		/// focus line
		private static var focusedLine:BioArrow;
		/// focus nodes (multi selection)
		public static var PickList:Array=[];
		
		/// memorize scale (for scaling)
		private static var remScaleXY:Number=1;
		
		///current adding block		
		private static var CurrentBlock:BioNode;
		
		/////ADD Node
		include"Net_Node.as"
		/////Link
		include"Net_Link.as"
		/////Center View
		include"Net_CenterView.as"
		/////Delete Item
		include"Net_Destory.as"
		/////Select Management
		include "Net_Selection.as"
		/////Focus Management
		include"Net_Focus.as"
		
		public function Net() {
			
			///For Speed
			cacheAsBitmap=true;
			plate.cacheAsBitmap=true;
			
			LinkSpace=new SmartLinkSpace();
			
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
		
		
		/**
		 * Key Board Monitor
		 * for Delete & Esc
		 */
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
				case Keyboard.DELETE:{
					DeleteFocus()
					break;
				}
					
			}
		}
		
		
	/**
	 * User Habit Management
	 * manage two operation:
	 * Drag canvas & Selection Rect
	 * divide to Left / Right Mouse button
	 */
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
		
		/**
		 * Arrange the Canvas by window size
		 * @see GlobalLayoutManager
		 */
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
		
		/**
		 * Redraw Item (Apply changes)
		 * @param tar Item to redraw
		 */
		public static function RedrawFocus(tar:*):void
		{
			if (tar.constructor == CompressedNode) {
				NodeSpace.flushChild(tar);
			}else if (tar.constructor == CompressedLine) {
				LinkSpace.flushChild(tar);
			}
		}
		
		/**
		 * Redraw all nodes (when changing global setting)
		 * @see BioStyleEditor
		 */
		public static function ShapeRedraw():void{
			NodeSpace.ClearCompressSpace();
			for each (var tar:CompressedNode in Node_Space) {
				if (NodeSpace.isFloating(tar)) {
					tar.Instance.redraw();
				}else{
					NodeSpace.AddCompressedChild(tar);
				}
			}
		}
		
		/**
		 * Redraw all links (when changing global setting)
		 * @see BioStyleEditor
		 */
		public static function LinkRedraw():void{
			for each (var line:CompressedLine in Link_Space) {
				line.setLine();
			}
			LinkSpace.Redraw();
		}
		
		/**
		 * Change canvas scale
		 * @param scale aim scale
		 * @param setScale Whether the change is temporary [false] (change scale) or predominant [true] (redraw)
		 */
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
				
				NodeSpace.setArea();
			}else{
				
				plate.scaleX=plate.scaleY=scaleXY/remScaleXY;
				
				NodeSpace.setArea();
				
				Navigator.refreshRange();
			}
		}
		
		
		
		/**
		 * When Scale is predominantly changed, Redraw the canvas
		 */
		private static function ScaleRedraw():void{
			NodeSpace.ClearCompressSpace();
			for each (var tar:CompressedNode in Node_Space) {
				tar.x=tar.Position[0]*scaleXY;
				tar.y=tar.Position[1]*scaleXY;
				if (NodeSpace.isFloating(tar)) {
					tar.Instance.resetScale();
				}else{
					NodeSpace.AddCompressedChild(tar);
				}
			}
			LinkRedraw();
		}

		/**
		 * Centerlize an Item by Gliding the Net
		 * @param tar Target to be centerlize
		 */
		public static function Centerlize(tar):void{
			Tween.GlideNet(-tar.x,-tar.y);
			
			if (tar.Instance==null) {
				if (tar.constructor==CompressedNode) {
					NodeSpace.browseChild(tar);
				}else if (tar.constructor==CompressedLine) {
					WakeLine(tar);
				}
			}
			
			///This is a time when node is a Instance but not floated
			
			setfocus(tar,false,false);
		}
		
		/**
		 * When a loading is complete, move the Net to center of the Screen
		 */
		public static function toCenterPosition():void{
			var rect:Rectangle=plate.getBounds(plate);
			
			Tween.GlideNet(-rect.width/2-rect.left,-rect.height/2-rect.top);
		}
		
		
		/**
		 * restore the Net to original status, also for initializing 
		 */
		public static function restore():void{
			GlobalVaribles.FocusEventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.FOCUS_CHANGE,null));
			plate.removeChildren(0);
			
			focusedLine=null;
			PickList=[];
			
			cover=new Sprite();
			cover.mouseEnabled=false;
			NodeSpace=new SmartNodeSpace();
			LinkSpace.restore()
			bottom=new Sprite();
			
			bottom.cacheAsBitmap=true;
			
			Navigator.setTarget(plate);
			
			Node_Space=new Array();
			Link_Space=new Array();
			
			plate.addChild(bottom);
			plate.addChild(selectRange);
			plate.addChild(LinkSpace);
			
			//	plate.addChild(ShadowSpace);
			plate.addChild(NodeSpace);
			plate.addChild(cover);
			
			PerspectiveViewer.refreshPerspective();
			
		}
		
		/**
		 * Move Net
		 */
		public function setCenter(cx,cy):void{
			x=cx;
			y=cy;
		}
		
	}	
}