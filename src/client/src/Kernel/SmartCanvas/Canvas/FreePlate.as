package Kernel.SmartCanvas.Canvas
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Kernel.Events.ScaleEvent;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import UserInterfaces.Sorpotions.Navigator;
	
	/**
	 * Basic Canvas Container
	 * providing basic UI Environment for canvas system
	 * including functions:
	 * 		1.Move
	 * 		2.Change Scale 
	 */
	public class FreePlate extends GxmlContainer{
		
		///Basic Layers:
		
		///background, also exist as hitArea
		public static var back:Sprite=new Sprite();
		///grid, seemingly boundless
		public static var grid:Shape=new Shape();
		///moveable container for canvas
		public static var plate:Sprite=new Sprite();
		///canvas scale
		public static var scaleXY:Number=1;
		
		///@see lock() & unLock()
		private static var _lock:Boolean=false;
		
		///Location storage
		public static var PlateLocation:Array=[0,0];
		
		/**
		 * Constructor
		 */
		public function FreePlate(){
			
			///for speed
			grid.cacheAsBitmap=true;
			back.cacheAsBitmap=true;
			
			addEventListener(MouseEvent.MOUSE_WHEEL,Rdelta);
		}
		
		/**
		 * Set lock : when locked, the canvas will not respond to user input (change scale/move)
		 */
		public static function lock():void
		{	
			_lock=true;	
		}
		/**
		 * Set lock : when unlocked, the canvas will respond to user input (change scale/move)
		 */
		public static function unlock():void
		{
			_lock=false;
		}
		
		///for Tween
		protected static var AimScale:Number=1;
		
		///for mouse operation, start location and current location.
		private static var dragStartX:Number=0,dragStartY:Number=0,currentX:Number=0,currentY:Number=0;
		
		/**
		 * Event Handler :: mouse wheel event
		 */
		private function Rdelta(e):void {
			if(!_lock){
				AimScale-=e.delta*0.04;
				if (AimScale>1) {
					AimScale=1;
				}
				if (AimScale<0.2) {
					AimScale=0.2;
				}
				addEventListener(Event.ENTER_FRAME,dragScale);
			}
		}
		
		/**
		 * Event Handler :: mouse wheel event
		 */
		protected function dragScale(event:Event):void
		{
			if(Math.abs(scaleXY-AimScale)>0.01){
				scaleXY=(scaleXY+AimScale)/2;
				Net.ChangeScale(scaleXY)
			}else{
				Net.ChangeScale(AimScale,true);
				removeEventListener(Event.ENTER_FRAME,dragScale);
			}
			stage.dispatchEvent(new ScaleEvent(ScaleEvent.SCALE_CHANGE,scaleXY));
		}
		
		/**
		 * Event Handler :: move canvas
		 */
		protected static function MoveStage(event:MouseEvent):void {
			if(!_lock){
				currentX=plate.x;
				currentY=plate.y;
				dragStartX=plate.stage.mouseX;
				dragStartY=plate.stage.mouseY;
				if(event.type==MouseEvent.RIGHT_MOUSE_DOWN){
					plate.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,endMoveStage);
				}else if(event.type==MouseEvent.MOUSE_DOWN){
					plate.stage.addEventListener(MouseEvent.MOUSE_UP,endMoveStage);
				}
				plate.stage.addEventListener(MouseEvent.MOUSE_MOVE,movingStage);
			}
		}
		
		/**
		 * Event Handler :: moving canvas
		 */
		private static function movingStage(e):void{
			
			Navigator.refreshLocation();
			
			Net.NodeSpace.setArea();
			
			plate.x=plate.stage.mouseX-dragStartX+currentX;
			plate.y=plate.stage.mouseY-dragStartY+currentY;
			
			grid.x=	plate.x%50;
			grid.y=	plate.y%50;
			
			try {
				e.updateAfterEvent();
			} catch (er) {
			}
		}
		
		/**
		 * move canvas to certain location
		 */
		public static function movePlateTo(ax,ay):void{
			plate.x=ax;
			plate.y=ay;
			
			grid.x=	plate.x%50;
			grid.y=	plate.y%50;
			
			PlateLocation=[plate.x/scaleXY,plate.y/scaleXY];
			
			Net.NodeSpace.setArea();
		}
		
		/**
		 * Event Handler :: End move stage
		 */
		private static function endMoveStage(e:MouseEvent):void {
			PlateLocation=[plate.x/scaleXY,plate.y/scaleXY];
			plate.stage.removeEventListener(e.type,endMoveStage);
			plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,movingStage);
			
		}
	}
}