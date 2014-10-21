package GUI.ContextSheet{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import GUI.Assembly.FlexibleWidthObject;
	
	import UserInterfaces.Style.Tween;
	
	
	
	public class ContextSheet extends Sprite implements FlexibleWidthObject{
		private const LINE_COLOR:uint=0x999999;
		
		
		private var Width:Number=200;
		public var Height:Number;
		private var _contextSheetList:Array=new Array();
		public var scroll:Sprite=new Sprite();
		
		
		public function ContextSheet(w=200){
			addChild(scroll);
		}

		public function set contextSheetList(value:Array):void{
			_contextSheetList = value;
			init();
		}

		public function setSize(w:Number):void{
			
			Width=w;
			redraw();
		}
		private function init():void{
			scroll.removeChildren();
			for (var i:int = 0; i < _contextSheetList.length; i++){
				scroll.addChild(_contextSheetList[i]);
				_contextSheetList[i].addEventListener("fold",fold_redraw);
			}
		}
		private function redraw():void{
			var currentHeight:Number=0;
			for (var i:int = 0; i < _contextSheetList.length; i++){
				_contextSheetList[i].setSize(Width);
				_contextSheetList[i].roll_y=currentHeight;
				if (_contextSheetList[i].Folded){
					currentHeight+=_contextSheetList[i].banner.height+2;
				}else {
					currentHeight+=_contextSheetList[i].Height+2;
				}
				Tween.smoothRoll(_contextSheetList[i]);
			}
			Height=currentHeight;
		}
		private function fold_redraw(e):void{
			var currentHeight:Number=0;
			for (var i:int = 0; i < _contextSheetList.length; i++){
				_contextSheetList[i].roll_y=currentHeight;
				if (_contextSheetList[i].Folded){
					currentHeight+=_contextSheetList[i].banner.height+2;
				}else {
					currentHeight+=_contextSheetList[i].Height+2;
				}
				Tween.smoothRoll(_contextSheetList[i]);
			}
			Height=currentHeight;
			dispatchEvent(new Event("redrawed"));
		}
	}
}