package Assembly.BioParts {

	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.ProjectHolder.SyncManager;
	
	import FunctionPanel.DetailDispatcher;
	import FunctionPanel.TypePanel;
	
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	
	public class BioArrow extends Arrow {
		
		public var tPanel:Panel;
		private var isLoadingDetail:Boolean=false;
		
		public function BioArrow(creator:CompressedLine) {
			Creator=creator;
			label=creator.Name;
			doubleClickEnabled=true;
			redraw();
			addEventListener(MouseEvent.RIGHT_MOUSE_UP,showContextMenu);
			addEventListener(MouseEvent.DOUBLE_CLICK,openDetail);
		}
		
		public function showContextMenu(e=null):void{
			var ArrowMenu:ContextMenu=new ContextMenu();
			
			ArrowMenu.hideBuiltInItems();
			var menu_del:ContextMenuItem=new ContextMenuItem("Delete");
			var menu_rem:ContextMenuItem=new ContextMenuItem("Rename");
			var menu_ctp:ContextMenuItem=new ContextMenuItem("Change Type");
			var menu_detail:ContextMenuItem=new ContextMenuItem("Detail",true);
			
			var menu_upload:ContextMenuItem=new ContextMenuItem("Upload",true);
			
			menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toDestory);
			menu_rem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,edit_text);
			menu_ctp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changeTyp);
			menu_upload.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,upload_evt);
			menu_detail.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,openDetail);
			
			ArrowMenu.customItems=[menu_rem,menu_ctp,menu_del,menu_upload,menu_detail];
			ArrowMenu.display(stage,stage.mouseX,stage.mouseY);
		}
		
		protected function openDetail(e):void{
			DetailDispatcher.LauchDetail(Creator)
		}
		
		protected function upload_evt(event:ContextMenuEvent):void
		{
			SyncManager.SyncLine(Creator);
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
				tPanel=new Panel("Choose type",new TypePanel(this.Creator),stage.stageWidth/2,stage.stageHeight/2)
				
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