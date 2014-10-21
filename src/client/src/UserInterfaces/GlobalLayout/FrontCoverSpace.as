package UserInterfaces.GlobalLayout{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FrontCoverSpace{
		
		public static var coverSpace:Sprite=new Sprite;
		
		coverSpace.addEventListener(Event.ADDED_TO_STAGE,function (e):void{
			coverSpace.stage.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				if (!coverSpace.hitTestPoint(coverSpace.mouseX,coverSpace.mouseY)) {
					coverSpace.removeChildren();
				}
			})
		})
		
		public static function addChild(tar,monopolize=true):void{
			if (monopolize){
				coverSpace.removeChildren();
			}
			coverSpace.addChild(tar);
		}
		public static function removeChild(tar):void{
			if (coverSpace.contains(tar)) {
				coverSpace.removeChild(tar);
			}
		}
		public static function contains(tar):Boolean{
			return coverSpace.contains(tar);
		}
	}
}