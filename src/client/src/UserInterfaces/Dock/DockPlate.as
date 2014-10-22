package UserInterfaces.Dock
{
	import flash.display.Sprite;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;

	public class DockPlate extends Sprite{
		
		
		public function DockPlate(){
			this.cacheAsBitmap=true;
			
		}
		public function setSize(w:Number):void{
			var HEIGHT:int=GlobalLayoutManager.DOCK_HEIGHT;
			this.graphics.clear();
			this.graphics.lineStyle(GlobalVaribles.SKIN_LINE_WIDTH,GlobalVaribles.SKIN_LINE_COLOR,1,true);
			this.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			this.graphics.lineTo(0,-HEIGHT+7);
			this.graphics.curveTo(0,-HEIGHT,7,-HEIGHT);
			this.graphics.lineTo(w-7,-HEIGHT);
			this.graphics.curveTo(w,-HEIGHT,w,-HEIGHT+7);
			this.graphics.lineTo(w,0);
			this.graphics.lineTo(0,0);
			this.graphics.endFill();
		}
	}
}