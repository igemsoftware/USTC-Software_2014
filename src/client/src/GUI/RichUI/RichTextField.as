package GUI.RichUI
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import Style.FontPacket;
	
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;

	public class RichTextField extends Sprite
	{
		public var TopHeight:int=30;
		public var BoardAlign:int=2;
		
		private var textfield:TextField=new TextField();
		private var BoldButton:RichButton=new RichButton();
		private var ItalicButton:RichButton=new RichButton();
		private var UButton:RichButton=new RichButton();
		private var color:ColorPicker=new ColorPicker();
		private var size:ComboBox=new ComboBox();
		private var back:Shape=new Shape();
		private var Height:Number=250;
		
		public function RichTextField()
		{
			
			
			
			addChild(back);
			addChild(BoldButton);
			addChild(ItalicButton);
			addChild(UButton);
			addChild(color);
			addChild(size);
			
			addChild(textfield);
			
			
			textfield.alwaysShowSelection=true;
			textfield.type=TextFieldType.INPUT;
			textfield.wordWrap=true;
			textfield.multiline=true;
			
			textfield.defaultTextFormat=FontPacket.ContentText;
			
			//////////////////Italic
			
			ItalicButton.label="I ";
			ItalicButton.Labelformat=new TextFormat("微软雅黑",14,0x000000,false,true);
			ItalicButton.setSize(30,30);
			ItalicButton.addEventListener(MouseEvent.CLICK,function (e):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				if (tf.italic) {
					tf.italic=false;
				}else {
					tf.italic=true;
				}
				textfield.setTextFormat(tf,textfield.selectionBeginIndex,textfield.selectionEndIndex)
			})
			
			//////////////////Bold
			
			BoldButton.label="B";
			BoldButton.Labelformat=new TextFormat("微软雅黑",14,0x000000,true);
			BoldButton.setSize(30,30);
			BoldButton.addEventListener(MouseEvent.CLICK,function (e):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				if (tf.bold) {
					tf.bold=false;
				}else {
					tf.bold=true;
				}
				textfield.setTextFormat(tf,textfield.selectionBeginIndex,textfield.selectionEndIndex)
			})
			//////////////////UnderLine
			
			UButton.label="U";
			UButton.Labelformat=new TextFormat("微软雅黑",14,0x000000,false,false,true);
			UButton.setSize(30,30);
			UButton.addEventListener(MouseEvent.CLICK,function (e):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				if (tf.underline) {
					tf.underline=false;
				}else {
					tf.underline=true;
				}
				textfield.setTextFormat(tf,textfield.selectionBeginIndex,textfield.selectionEndIndex);
			})
			//////////////COLOR
			
			color.addEventListener(ColorPickerEvent.CHANGE,function (e:ColorPickerEvent):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				tf.color=e.color;
				textfield.setTextFormat(tf,textfield.selectionBeginIndex,textfield.selectionEndIndex)
			})
			
			//////////////SIZE	
			size.setSize(60,25);
			size.setStyle("textFormat",FontPacket.ContentText);
			var db:DataProvider=new DataProvider();
			for (var i:int=10;i<44;i+=2){
				db.addItem({label:i,value:i})
			}
			size.dataProvider=db;
			size.addEventListener(Event.CHANGE,function(e):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				tf.size=size.selectedItem.value;
				textfield.setTextFormat(tf,textfield.selectionBeginIndex,textfield.selectionEndIndex)
			})
			
				
			////////text Field
			
			textfield.addEventListener(MouseEvent.MOUSE_UP,function (e):void{
				if (textfield.selectionBeginIndex==textfield.selectionEndIndex) {
					return;
				}
				var tf:TextFormat=textfield.getTextFormat(textfield.selectionBeginIndex,textfield.selectionEndIndex);
				color.selectedColor=uint(tf.color);
				size.selectedIndex=int((int(tf.size)-10)/2);
			})
		}
		
		public function set text(t):void{
			textfield.htmlText=t;
		}
		public function get text():String{
			return textfield.htmlText;
		}
		public function setSize(w:Number,h:Number=0):void{
			if (h==0) {
				h=Height;
			}else {
				Height=h;
			}
			back.graphics.clear();
			
			back.graphics.lineStyle(0,0xdfdfdf);
			back.graphics.beginFill(0xeeeeee,0.6);
			back.graphics.drawRect(0,0,w,h);
			back.graphics.endFill();
			
			back.graphics.lineStyle(0,0xeeeeeee);
			back.graphics.beginFill(0xffffff,0.6);
			back.graphics.drawRect(BoardAlign,TopHeight+BoardAlign*2,w-BoardAlign*2,h-TopHeight-BoardAlign*4);
			back.graphics.endFill();
			
			var items:Array=[BoldButton,ItalicButton,UButton,color,size];
			items[0].x=BoardAlign;items[0].y=BoardAlign;
			for (var i:int = 1; i < items.length; i++) {
				items[i].x=items[i-1].x+items[i-1].width+BoardAlign;
				items[i].y=BoardAlign;
			}
			
			color.y=TopHeight/2-color.height/2+BoardAlign;
			size.y=TopHeight/2-size.height/2+BoardAlign;
			
			textfield.width=w-2*BoardAlign;
			textfield.height=h-30-BoardAlign*2;
			textfield.y=30+BoardAlign*2;
			textfield.x=BoardAlign;
		}
	}
}