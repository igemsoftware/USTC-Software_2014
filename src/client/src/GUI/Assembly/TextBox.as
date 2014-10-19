package GUI.Assembly{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import GUI.Scroll.Scroll;
	
	import Style.FontPacket;

	public class TextBox{
		public function TextBox(){
			var menu:ContextMenu=new ContextMenu();
			
			var menu_del:ContextMenuItem=new ContextMenuItem("清空");
			menu.customItems.push(menu_del);
			menu.clipboardMenu=true;
			menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clearText);
			textfield.contextMenu=menu;
			textfield.wordWrap=true;
			textfield.defaultTextFormat=FontPacket.SmallContentText;
			textfield.addEventListener(Event.CHANGE,function (e):void{
				
			})
		}
		private var textfield:TextField=new TextField();
		
		private var scroll:Scroll=new Scroll(textfield);

		
		protected function clearText(event:ContextMenuEvent):void
		{
			textfield.text="";
		}
		
		protected function setSize(w,h):void
		{
			scroll.setSize(w,h);
		}
		public function set text(t):void{
			textfield.text=t;
			scroll.rollToButtom();
		}
	}
}