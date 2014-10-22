package Assembly.Canvas
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import IEvent.ScaleEvent;
	
	import Layout.Sorpotions.Navigator;
	
	public class I3DPlate extends Sprite{
		
		
		public static var back:Sprite=new Sprite();
		public static var grid:Shape=new Shape();
		public static var plate:Sprite=new Sprite();
		
		public static var scaleXY:Number=1;
		
		public static var PlateLocation:Array=[0,0];
		
		
		public function I3DPlate(){
			
			grid.cacheAsBitmap=true;
			back.cacheAsBitmap=true;
			
			addEventListener(MouseEvent.MOUSE_WHEEL,Rdelta);
		}
		
		protected static var AimScale:Number=1;
		private static var dragStartX:Number=0,dragStartY:Number=0,currentX:Number=0,currentY:Number=0;
		
		private function Rdelta(e):void {
			
			AimScale-=e.delta*0.04;
			if (AimScale>1) {
				AimScale=1;
			}
			if (AimScale<0.2) {
				AimScale=0.2;
			}
			addEventListener(Event.ENTER_FRAME,dragScale);
		}
		
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
		
		protected static function MoveStage(event:MouseEvent):void {
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
		private static function movingStage(e):void{
			
			Navigator.refreshLocation();
			
			plate.x=plate.stage.mouseX-dragStartX+currentX;
			plate.y=plate.stage.mouseY-dragStartY+currentY;
			
			grid.x=	plate.x%50;
			grid.y=	plate.y%50;
			
			try {
				e.updateAfterEvent();
			} catch (er) {
			}
		}
		
		public static function movePlateTo(ax,ay):void{
			plate.x=ax;
			plate.y=ay;
			
			grid.x=	plate.x%50;
			grid.y=	plate.y%50;
			
			PlateLocation=[plate.x/scaleXY,plate.y/scaleXY];
			
		}
		
		private static function endMoveStage(e:MouseEvent):void {
			PlateLocation=[plate.x/scaleXY,plate.y/scaleXY];
			plate.stage.removeEventListener(e.type,endMoveStage);
			plate.stage.removeEventListener(MouseEvent.MOUSE_MOVE,movingStage);
			
		}
	}
}