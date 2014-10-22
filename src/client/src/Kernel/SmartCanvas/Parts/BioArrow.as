package Kernel.SmartCanvas.Parts {

	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.FunctionPanel.TypePanel;
	import UserInterfaces.FunctionPanel.Detail.DetailDispatcher;
	import UserInterfaces.FunctionPanel.GoogleAPI.GoogleFramework;
	
	/**
	 * Biology Linkage (UI component)
	 * including:
	 * 		1.Context Menu
	 */
	public class BioArrow extends Arrow {
		
		public var tPanel:Panel;
		private var isLoadingDetail:Boolean=false;
		
		/**
		 * Constructor
		 * Construct Linkage (UI Component) from Compressed
		 */
		public function BioArrow(creator:CompressedLine) {
			Creator=creator;
			label=creator.Name;
			doubleClickEnabled=true;
			redraw();
			addEventListener(MouseEvent.RIGHT_MOUSE_UP,showContextMenu);
			addEventListener(MouseEvent.DOUBLE_CLICK,openDetail);
		}
		
		/**
		 * Constructor
		 */
		public function showContextMenu(e=null):void{
			var ArrowMenu:ContextMenu=new ContextMenu();
			
			ArrowMenu.hideBuiltInItems();
			var menu_del:ContextMenuItem=new ContextMenuItem("Delete");
			var menu_rem:ContextMenuItem=new ContextMenuItem("Rename");
			var menu_ctp:ContextMenuItem=new ContextMenuItem("Change Type");
			
			var menu_google:ContextMenuItem=new ContextMenuItem("Search on Google Scholar",true);
			var menu_google2:ContextMenuItem=new ContextMenuItem("Search Linked Nodes on Google Scholar");
			
			var menu_detail:ContextMenuItem=new ContextMenuItem("Detail");
			
			menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toDestory);
			menu_rem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,edit_text);
			menu_ctp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changeTyp);
			menu_google.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,google_evt);
			menu_google2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,google_evt2);
			menu_detail.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,openDetail);
			
			ArrowMenu.customItems=[menu_rem,menu_ctp,menu_del,menu_google,menu_google2,menu_detail];
			ArrowMenu.display(stage,stage.mouseX,stage.mouseY);
		}
		
		
		///Handlers:
		
		protected function openDetail(e):void{
			DetailDispatcher.LauchDetail(Creator)
		}
		
		protected function google_evt(event:ContextMenuEvent):void
		{
			WindowSpace.addWindow(new Panel("Google Scholar",new GoogleFramework(Creator.Name)));
		}
		
		protected function google_evt2(event:ContextMenuEvent):void
		{
			WindowSpace.addWindow(new Panel("Google Scholar",new GoogleFramework(Creator.linkObject[0].Name+" "+Creator.linkObject[1].Name)));
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
	}
}