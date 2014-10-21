package{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	import Style.FontPacket;
	
	public class VersionHint extends TextField{
		public function VersionHint(t)
		{
			defaultTextFormat=FontPacket.WhiteContentText;
			text=t;
			selectable=false;
			mouseEnabled=false;
			autoSize=TextFieldAutoSize.CENTER;
		}
	}
}