package GUI.Assembly{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import UserInterfaces.Style.FontPacket;
	
	
	public class LabelTextField extends TextField{
		public function LabelTextField(t:String)
		{
			defaultTextFormat=FontPacket.LabelText;
			text=t;
			selectable=false;
			mouseEnabled=false;
			autoSize=TextFieldAutoSize.LEFT;
			
		}
	}
}