package GUI.Assembly{
	import flash.text.TextField;
	
	
	import UserInterfaces.Style.FontPacket;
	
	
	public class SkinTextField extends TextField implements FlexibleWidthObject{
		public function SkinTextField(t:String)
		{
			defaultTextFormat=FontPacket.LabelText;
			text=t;
			selectable=false;
			mouseEnabled=false;
			multiline=true;
			wordWrap=true
		}
		
		public function setSize(w:Number):void
		{
			width=w;
			height=textHeight+5;;
			
		}
		
	}
}