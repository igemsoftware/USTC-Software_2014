package Assembly.BioParts
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import GUI.Assembly.LabelField;
	
	import Layout.Sorpotions.Navigator;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedNode;

	import Assembly.FocusCircle;
	
	/*
	author ZLstudio
	
	Functional Part of Node
	Including following Parts:
	Linkage,  DragingUP/Down Tween,  MouseEvent Listeners
	*/
	public class DisplayNodeObject extends Sprite{
		
		public var title:LabelField=new LabelField();
		
		public var focusCircle:FocusCircle;
		public var focused:Boolean=false;
		
		private var downed:Boolean;
		
		public var justWakeUp:Boolean=false;
		
		public function DisplayNodeObject(){
			addEventListener(MouseEvent.MOUSE_UP,mouseUp_evt);
			addEventListener(MouseEvent.RELEASE_OUTSIDE,end_move_evt);
		}
		
		//////Linkage
		private var Click_tick:int=0;
		protected function mouseUp_evt(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,move_evt);
			if (downed) {
				
				downed=false;
				
				var dt:int=getTimer()-Click_tick;
				Click_tick=getTimer();
				if (dt<300) {
					trace("Trans_DoubleClick");
					block_base.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
				}
			}
			if(justWakeUp){
				justWakeUp=false;
				var newEvt:MouseEvent=new MouseEvent(MouseEvent.CLICK,event.bubbles,event.cancelable,event.localX,event.localY,event.relatedObject,event.ctrlKey,event.altKey,event.shiftKey,event.buttonDown,event.delta,event.commandKey,event.controlKey,event.clickCount);
				dispatchEvent(newEvt);
			}
		}
		
		/////EventListeners
		
		public function Down_evt(e:MouseEvent):void {
			downed=true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,move_evt);
			Net.BlockSpace.PopUp(this as BioBlock);
			e.stopPropagation();
		}
		protected function move_evt(e):void {
			justWakeUp=false;
			dispatchEvent(new Event("StartDrag"));
			
			tweenscale();
			
			stage.addEventListener(MouseEvent.MOUSE_UP,end_move_evt);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,move_evt);
			removeEventListener(MouseEvent.CLICK,Click_evt);
			block_base.removeEventListener(MouseEvent.MOUSE_DOWN,Down_evt);
		}
		protected function end_move_evt(e):void {
			downed=false;
			tweenscaleBack();

			dispatchEvent(new Event("StopDrag"));
			stage.removeEventListener(MouseEvent.MOUSE_UP,end_move_evt);
			block_base.addEventListener(MouseEvent.MOUSE_DOWN,Down_evt);
		}
		
		
		public var block_base:Sprite=new Sprite();
		protected var dgstartx:Number,dgstarty:Number;
		
		public var NodeLink:CompressedNode;
		
		public var deployed:Boolean=true;
		
		public function deployChildren():void{}
		
		public function setCenter(cx,cy):void{
			var p:PerspectiveProjection=new PerspectiveProjection();
			p.projectionCenter=new Point(cx,cy);
			this.transform.perspectiveProjection=p;
			x=cx;
			y=cy;
			
		}
		public function startDrag3D(center=false):void {

			if (center) {
				dgstartx=0;
				dgstarty=0;
			}else{
				dgstartx=mouseX;
				dgstarty=mouseY;
			}
			
			this.x=parent.mouseX-dgstartx;
			this.y=parent.mouseY-dgstarty;
			draging=true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,draging3D);
		}
		
		private var cx:Number,cy:Number,tick:int;
		private var draging:Boolean=false;
		
		public function stopDrag3D():void {
			if(draging){
				
				setCurrentLocation();
				NodeLink.SetRemPostion();
				
				Navigator.refreshMap();
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,draging3D);
				
				draging=false;
			}
		}
		protected function draging3D(e:MouseEvent):void {
			this.x=parent.mouseX-dgstartx;
			this.y=parent.mouseY-dgstarty;	
			setCurrentLocation();
			
			e.updateAfterEvent();
		}
		
		public function setCurrentLocation():void{
		}
		public function withFather():void{}
		
		public function get absLocation():Point{
			var locPoint:Point=new Point();
			return localToGlobal(locPoint);
		}
		/////Tween UP/Down
		private function tweenscaleBack():void{
			addEventListener(Event.ENTER_FRAME,tweenDown_evt)
			removeEventListener(Event.ENTER_FRAME,tweenUP_evt)
		}
		private function tweenscale():void{
			addEventListener(Event.ENTER_FRAME,tweenUP_evt)
			removeEventListener(Event.ENTER_FRAME,tweenDown_evt)
		}
		protected function tweenUP_evt(event:Event):void{
			
			scaleX=scaleY=(scaleX+1.2)/2
			alpha=1/(scaleX*1.5);
			if (Math.abs(scaleX-1.2)<0.01) {
				removeEventListener(Event.ENTER_FRAME,tweenUP_evt)
			}
		}
		protected function tweenDown_evt(event:Event):void{
			scaleX=scaleY=(scaleX+1)/2
			alpha=1/(scaleX*1.5);
			if (Math.abs(scaleX-1)<0.01) {
				scaleX=scaleY=1;
				alpha=1
				removeEventListener(Event.ENTER_FRAME,tweenDown_evt);
				addEventListener(MouseEvent.CLICK,Click_evt);
			}
		}
		
		protected function Click_evt(e:MouseEvent):void {}
	}
}