package Kernel.SmartCanvas.Parts {
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Kernel.Biology.Types.NodeType;
	import Kernel.ExpandThread.ExpandManager;
	import Kernel.ProjectHolder.GxmlContainer;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.FunctionPanel.TypePanel;
	import UserInterfaces.FunctionPanel.GoogleAPI.GoogleFramework;
	import UserInterfaces.IvyBoard.Ivy;
	
	/**
	 * BioNode extands from Node
	 * including
	 * 		1.ContextMenu
	 */
	
	public class BioNode extends Node {
		
		private var Rdown:Boolean=false;
		public var tPanel:Panel;
		
		
		public function BioNode(node:CompressedNode) {
			
			node.Instance=this;
			
			NodeLink=node;
			
			x=node.x;
			y=node.y;
			
			title.text=node.Name;
			
			redraw();
			
			generateTextMap();
			
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,Rdown_evt);
			addEventListener(MouseEvent.RIGHT_MOUSE_UP,showContextMenu);
		}

		protected function Rdown_evt(event:MouseEvent):void
		{	
			Rdown=true;
			addEventListener(MouseEvent.MOUSE_MOVE,link_evt);
		}
		private function link_evt(e):void {
			Rdown=false;
			dispatchEvent(new Event("tryLink"));
			removeEventListener(MouseEvent.MOUSE_MOVE,link_evt);
		
		}
		
		public function showContextMenu(e:MouseEvent=null):void{
			
			removeEventListener(MouseEvent.MOUSE_MOVE,link_evt);
			if (Rdown) {
				
				var BlockMenu:ContextMenu=new ContextMenu();
				
				BlockMenu.hideBuiltInItems();
				
				var menu_rem:ContextMenuItem=new ContextMenuItem("Rename");
				var menu_ctp:ContextMenuItem=new ContextMenuItem("Change Type");
				var menu_del:ContextMenuItem=new ContextMenuItem("Delete");
				
				var menu_SelectAll:ContextMenuItem=new ContextMenuItem("Select with Linked Nodes",true);
				var menu_SelectType:ContextMenuItem=new ContextMenuItem("Select with Same Type");

				var menu_Expand:ContextMenuItem=new ContextMenuItem("Expand",true);
				var menu_Expand_all:ContextMenuItem=new ContextMenuItem("Expand All External Links");
				
				var menu_google:ContextMenuItem=new ContextMenuItem("Search on Google Scholar",true);
				var menu_detail:ContextMenuItem=new ContextMenuItem("Detail");
				
				if(NodeLink.ID.length!=24){
					menu_Expand.enabled=false;
					menu_Expand_all.enabled=false;
				}
				
				
				
				BlockMenu.customItems=[menu_rem,menu_ctp,menu_del,menu_SelectAll,menu_SelectType,menu_Expand,menu_Expand_all,menu_google,menu_detail];
				
				menu_del.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,toDestory);
				menu_rem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,edit_text);
				menu_SelectAll.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,selectAll);
				//menu_cen.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,centerlize);
				menu_SelectType.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,selectType);
				menu_ctp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changeTyp);
				menu_detail.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,openDetail);
				//menu_post.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function (e):void{SyncManager.tmpSYNC()});
				menu_Expand.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function (e):void{
					Ivy.toExpand(NodeLink);
				});
				menu_Expand_all.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function (e):void{
					ExpandManager.Expand(NodeLink,ExpandManager.EXPAND);
				});
				
				menu_google.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function (e):void{
					WindowSpace.addWindow(new Panel("Google Scholar",new GoogleFramework(NodeLink.Name)));
				});
				
				BlockMenu.display(stage,stage.mouseX,stage.mouseY);
			}else{
				dispatchEvent(new Event("upOnThis"));
			}
			Rdown=false;
		}
		
		protected function selectType(event:ContextMenuEvent):void
		{
			Net.SelectType(NodeLink.Type);
		}
		
		/**
		 * Event Handler :: Select linked nodes
		 * @see Net.SelectAround
		 */
		protected function selectAll(event:ContextMenuEvent):void
		{
			Net.SelectAround(NodeLink);
		}

		protected function toDestory(event:ContextMenuEvent):void
		{
			if(this.focused){
				Net.DeleteFocus();
			}else{
				Net.DestoryNode(NodeLink);
				GxmlContainer.RecordNodeExistance(NodeLink,GxmlContainer.DELETE_NODE);
			}
		}
		
		
		public function set bioType(b:NodeType):void{
			NodeLink.Type=b;
			redraw();
		}
		
		protected function changeTyp(event:ContextMenuEvent):void{
		
			if(tPanel==null){
				tPanel=new Panel("Choose type",new TypePanel(this.NodeLink),stage.stageWidth/2,stage.stageHeight/2)
			}
			WindowSpace.addWindow(tPanel);
		}
		
		public function edit_text(e=null):void {
			Net.setfocus(NodeLink);
			unlocktext();
		}
	}
	
}