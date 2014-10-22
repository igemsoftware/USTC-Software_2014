package UserInterfaces.GlobalLayout{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * a space which covers the stage 
	 */
	public class FrontCoverSpace{
		
		public static var coverSpace:Sprite=new Sprite;
		
		coverSpace.addEventListener(Event.ADDED_TO_STAGE,function (e):void{
			coverSpace.stage.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				if (!coverSpace.hitTestPoint(coverSpace.mouseX,coverSpace.mouseY)) {
					coverSpace.removeChildren();
				}
			})
		})
		/**
		 * add child to the space
		 */
		public static function addChild(tar,monopolize=true):void{
			if (monopolize){
				coverSpace.removeChildren();
			}
			coverSpace.addChild(tar);
		}
		/**
		 * remove child from the space
		 */
		public static function removeChild(tar):void{
			if (coverSpace.contains(tar)) {
				coverSpace.removeChild(tar);
			}
		}
		/**
		 * return what the space contains
		 */
		public static function contains(tar):Boolean{
			return coverSpace.contains(tar);
		}
	}
}