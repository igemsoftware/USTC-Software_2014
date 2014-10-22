package Kernel.SmartCanvas.Assembly{
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	import UserInterfaces.Style.FontPacket;
	
	public class TextMapLoader {
		
		private static var _text:TextField=new TextField();
		_text.defaultTextFormat=FontPacket.WhiteTinyText;
		_text.autoSize=TextFieldAutoSize.LEFT;
		_text.antiAliasType=AntiAliasType.NORMAL;
		
		public function TextMapLoader()
		{
		}
		
		public static function generateTextMap(t:String):BitmapData{
			// TODO Auto Generated method stub
			
			_text.text=t;
			
			
			var fitted:Boolean=false;
			while(_text.textWidth>150){
				fitted=true;
				_text.text=_text.text.slice(0,_text.text.length-2);
			}
			
			if(fitted){
				_text.appendText("...");
			}
			
			
			var bmp:BitmapData=new BitmapData(_text.width,_text.height,true,0);
			bmp.draw(_text);
			bmp.lock();
			for (var i:int = 0; i < _text.width; i++) {
				for (var j:int = 0; j < _text.height; j++) {
					if (bmp.getPixel32(i,j)==0) {
						bmp.setPixel32(i,j,0x00000000);
					}
				}
			}
			bmp.unlock();
			
			return bmp;
		}
	}
}