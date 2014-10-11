package GUI.Assembly{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import Style.FontPacket;
	
	
	public class LinkTextField extends TextField{
		public function LinkTextField(t:String)
		{
			defaultTextFormat=FontPacket.LinkLabelText;
			text=t;
			selectable=false;
			autoSize=TextFieldAutoSize.LEFT;
		}
	}
}