package Layout
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import GUI.Scroll.Scroll;
	
	import Style.FontPacket;
	
	public class TraceManager extends Sprite
	{
		private static var TraceText:TextField=new TextField();
		
		private static var scroll:Scroll=new Scroll(TraceText);
		private var win:NativeWindow;
		
		public function TraceManager()
		{
			var winopt:NativeWindowInitOptions=new NativeWindowInitOptions()
			winopt.renderMode=NativeWindowRenderMode.GPU;
			winopt.systemChrome=NativeWindowSystemChrome.STANDARD;
			
			win=new NativeWindow(winopt);
			win.width=300;
			win.height=300;
			win.stage.scaleMode=StageScaleMode.NO_SCALE;
			win.stage.align=StageAlign.TOP_LEFT;
			win.title="Monitor";
			
			win.stage.addChild(scroll);
			win.stage.addEventListener(Event.RESIZE,setStage);
			
			win.activate();
			
			var menu:ContextMenu=new ContextMenu();
			
			var menu_del:ContextMenuItem=new ContextMenuItem("清空");
			menu.customItems.push(menu_del);
			menu.clipboardMenu=true;
			menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clearText);
			TraceText.contextMenu=menu;
			TraceText.wordWrap=true;
			TraceText.defaultTextFormat=FontPacket.SmallContentText;
			setStage();
		}
		
		protected function clearText(event:ContextMenuEvent):void
		{
			TraceText.text="";
		}
		
		protected function setStage(event:Event=null):void
		{
			scroll.setSize(win.stage.stageWidth-3,win.stage.stageHeight);
		}
		public static function trace(...args):void{
			TraceText.appendText(args.join("\t"));
			TraceText.appendText("\n");
			TraceText.height=TraceText.textHeight+10;
			scroll.rollToButtom();
		}
	}
}