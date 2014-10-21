package GUI.Assembly{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import UserInterfaces.Style.FontPacket;
	
	
	public class TitleTextField extends TextField{
		public function TitleTextField(t:String)
		{
			defaultTextFormat=FontPacket.WhiteTitleText;
			text=t;
			selectable=false;
			mouseEnabled=false;
			autoSize=TextFieldAutoSize.LEFT;
		}
	}
}