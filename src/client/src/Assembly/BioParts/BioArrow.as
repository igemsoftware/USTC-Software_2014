package Assembly.BioParts {

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import FunctionPanel.typePanel;
	
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	
	public class BioArrow extends Arrow {
		
		public var tPanel:Panel;
		
		public function BioArrow(creator:CompressedLine) {
			Creator=creator;
			label=creator.Name;
			redraw();
			addEventListener(MouseEvent.RIGHT_MOUSE_UP,showContextMenu);
		}
		
		public function showContextMenu(e=null):void{
			var ArrowMenu:ContextMenu=new ContextMenu();
			
			ArrowMenu.hideBuiltInItems();
			var menu_del:ContextMenuItem=new ContextMenuItem("Delete");
			var menu_rem:ContextMenuItem=new ContextMenuItem("Rename");
			var menu_ctp:ContextMenuItem=new ContextMenuItem("Change Type");
			
			menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toDestory);
			menu_rem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,edit_text);
			menu_ctp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changeTyp);
			
			ArrowMenu.customItems=[menu_rem,menu_ctp,menu_del];
			ArrowMenu.display(stage,stage.mouseX,stage.mouseY);
		}
		
		protected function toDestory(event:ContextMenuEvent):void
		{
			Net.DestoryLink(Creator);
		}
		
		public function set bioType(b):void{
			Creator.Type=b;
			redraw();
		}
		
		protected function changeTyp(event:ContextMenuEvent):void{
			if(tPanel==null){
				tPanel=new Panel("Choose type",new typePanel(this.Creator),stage.stageWidth/2,stage.stageHeight/2)
				
			}
			WindowSpace.addWindow(tPanel);
		}
		
		public function highLight():void{
			this.alpha=1;
			redraw();
		}
		public function reset():void{
			this.alpha=1;
			DrawSkin(LINE_COLOR);
		}
		public function dimLight():void{
			this.alpha=0.4;
			DrawSkin(LINE_COLOR);
		}
	}
}