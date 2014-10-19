package GUI.Assembly
{
	import flash.desktop.IFilePromise;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import Style.ColorPacket;
	import Style.FontPacket;
	
	public class LabelField extends Sprite
	{
		private var fullText:String;
		private var fittedText:String;
		public var textField:TextField=new TextField();
		private var boarder:Shape;
		private var tweenWidth:Number;
		private var Width:Number;
		
		public function LabelField()
		{
			textField.defaultTextFormat=FontPacket.WhiteTinyText;
			textField.autoSize=TextFieldAutoSize.LEFT;
			textField.antiAliasType=AntiAliasType.NORMAL;
			addChild(textField);
		}
		
		protected function tweenTextChange(event:Event):void
		{
			if (textField.width>20) {
				tweenWidth=textField.width;
			} else {
				tweenWidth=20;
			}
			Width=(Width*2+tweenWidth)/3;
			setBoarder();
		}
		public function set text(t:String):void{
			
			fullText=t;
			
			fit(t);
			
			Width=textField.width;
			textField.x=int(-Width/2);
		}
		
		private function fit(s:String):void{
			
			textField.text=s;
			
			var fitted:Boolean=false;
			while(textField.textWidth>150){
				fitted=true;
				textField.text=textField.text.slice(0,textField.text.length-2);
			}
			
			if(fitted){
				textField.appendText("...");
			}
			
			fittedText=textField.text;
			
		}
		
		public function get text():String{
			return fullText;
		}
		public function set focused(f:Boolean):void{
			if(f){
				boarder=new Shape();
				setBoarder();
				
				addChild(boarder);
				addEventListener(Event.ENTER_FRAME,tweenTextChange);
			}else if (boarder!=null){
				removeChild(boarder);
				boarder=null;
				
				
				removeEventListener(Event.ENTER_FRAME,tweenTextChange);
			}
			textField.x=int(-textField.width/2);
		}
		public function get selectable():Boolean{
			return textField.selectable;
		}
		public function set selectable(e:Boolean):void{
			if(e!=textField.selectable){
				
				textField.selectable=e;
				textField.mouseEnabled=e;
				if (e) {
					textField.text=fullText;
					
					textField.type=TextFieldType.INPUT;
					textField.width++;
					this.stage.focus=textField;
					textField.setSelection(textField.length,textField.length);
					
					textField.addEventListener(Event.CHANGE,synctext);
				}else{
					
					textField.removeEventListener(Event.CHANGE,synctext);
					fit(textField.text);
					
					textField.type=TextFieldType.DYNAMIC;
					textField.setSelection(0,0);
				}
				focused=e;
			}
		}
		
		protected function synctext(event:Event):void
		{
			fullText=textField.text;
		}
		private function setBoarder():void{
			boarder.graphics.clear();
			boarder.graphics.lineStyle(2,ColorPacket.FocusColor,0.8)
			boarder.graphics.drawRoundRect(-Width/2,0,Width,textField.height,4,4);
			textField.x=int(-Width/2);
		}
	}
}