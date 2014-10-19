package GUI.Windows{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Style.FilterPacket;
	import Style.Tween;
	
	
	public class WindowSpace{
		
		public static var halfArea:Shape=new Shape();
		private static var sw:Number,sh:Number;
		public static var windowSpace:Sprite=new Sprite();
		private static var currentWindow:*;
		
		halfArea.visible=false;
		
		public static function setStageScale(w,h):void{
			sw=w;
			sh=h;
			halfArea.alpha=0;
			halfArea.graphics.clear();
			halfArea.graphics.lineStyle(2,0x00aaee,0.5);
			halfArea.graphics.drawRoundRect(2,2,w/2-4,h-4,10,10);
			halfArea.filters=[FilterPacket.blueGlow];
		}
		public static function addWindow(tar,closefunction=null):void{
			if(!windowSpace.contains(tar)){
				windowSpace.addChild(tar);
				tar.addEventListener("focused",chg_focus);
				tar.addEventListener("destory",destoryBoard);
				if(closefunction==null){
					tar.addEventListener("close",defaultFadeoutWindow);
				}else{
					tar.addEventListener("close",closefunction);
				}
			
				if (tar.hasOwnProperty("flexable")&&tar.flexable) {
					tar.addEventListener("Maximum",Maximum);
					tar.addEventListener("stopDrag",stopDragBoard_evt);
					tar.addEventListener("startDrag",startDragBoard_evt);
				}
			}else{
				windowSpace.swapChildren(tar,windowSpace.getChildAt(windowSpace.numChildren-1))
			}
		}
		
		public static function contains(tar):Boolean{
			if (tar!=null&&windowSpace.contains(tar)) {
				return true
			}
			return false
		}
		protected static function Maximum(event):void{
			event.target.x=0
			event.target.y=0;
			event.target.setScale(sw,sh);
			event.target.attach=true;
		}
		public static function removeWindow(tar):void{
			if(windowSpace.contains(tar)){
				windowSpace.removeChild(tar);
			}
		}
		protected static function chg_focus(e):void{
			windowSpace.swapChildren(e.target,windowSpace.getChildAt(windowSpace.numChildren-1));
		}
		protected static function destoryBoard(e):void{
			removeWindow(e.target);
		}
		protected static function defaultFadeoutWindow(e):void{
			e.target.removeEventListener("close",defaultFadeoutWindow);
			Tween.fadeOut(e.target);
		}
		protected static function startDragBoard_evt(event:Event):void{
			windowSpace.addEventListener(Event.ENTER_FRAME,testEdge);
			currentWindow=event.target;
			halfArea.visible=true;
		}
		
		protected static function testEdge(e):void{
			if (windowSpace.mouseX<2){ 
				halfArea.x=0;
				halfArea.alpha=(halfArea.alpha*2+1)/3;
			}else if (windowSpace.mouseX>sw-2) {
				halfArea.x=sw/2;
				halfArea.alpha=(halfArea.alpha*2+1)/3;
			}else{
				halfArea.alpha=(halfArea.alpha*2)/3;
			}
		}
		protected static function stopDragBoard_evt(event:Event):void{
			if (windowSpace.mouseX<2){
				event.target.x=event.target.y=0;
				event.target.setScale(sw/2,sh);
				event.target.attach=true;
			}else if (windowSpace.mouseX>sw-2) {
				event.target.x=sw/2;
				event.target.y=0;
				event.target.setScale(sw/2,sh);
				event.target.attach=true;
			}
			if (event.target.y>0&&event.target.attach) {
				event.target.resetScale();
				event.target.attach=false;
			}else if (event.target.y<0) {
				event.target.y=0;
			}
			halfArea.alpha=0;
			halfArea.visible=false;
			windowSpace.removeEventListener(Event.ENTER_FRAME,testEdge);
		}
	}
}