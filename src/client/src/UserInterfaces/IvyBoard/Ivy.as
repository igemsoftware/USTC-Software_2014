package UserInterfaces.IvyBoard
{
	import flash.events.Event;
	
	import Kernel.SmartCanvas.CompressedNode;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	import UserInterfaces.IvyBoard.IvyPanels.AddPanel;
	import UserInterfaces.IvyBoard.IvyPanels.AttribPanel;
	import UserInterfaces.IvyBoard.IvyPanels.LayoutPanel;
	import UserInterfaces.IvyBoard.IvyPanels.ProjectDetailPanel;
	
	
	public class Ivy
	{
		
		
		public static var Banner:IvyBanner=new IvyBanner();
		public static var Board:IvyBoard=new IvyBoard();
		
		private static var add_panel:AddPanel;
		private static var attribe_panel:AttribPanel=new AttribPanel();
		private static var layout_panel:LayoutPanel=new LayoutPanel();
		private static var project_panel:ProjectDetailPanel=new ProjectDetailPanel();
		
		public static var show:Boolean=false;
		private static var remPannel:String;
		
		Board.y=Board.aimY=50;
		
		Banner.addEventListener(Event.CHANGE,function (e):void{
			showBoard(Banner.panel);
		})
		
		public static function showBoard(pane:String):void{
			if (Board.parent==null) {
				Board.dispatchEvent(new Event("showBoard"));
			}
			if (pane!=remPannel) {
				remPannel=pane;
				switch(pane)
				{
					case "Add":
					{
						if(add_panel==null){
							add_panel=new AddPanel();
						}
						Board.loadPanel(add_panel,"Add Node");
						break;
					}
					case "Connect":
					{
						Board.loadPanel(attribe_panel,"Connection");
						break;
					}
					case "Edit":
					{
						Board.loadPanel(layout_panel,"Layout");
						break;
					}
					case "Info":
					{
						Board.loadPanel(project_panel,"Project Information");
						break;
					}
						
				}
			}
		}
		
		public static function clearSelection():void{
			Banner.clearSeletion();
		}
		
		public static function redraw(w,h):void{
			Banner.redraw(w);
			Board.redraw(w,h-50);
		}
		public static function resetLayout():void{
			Banner.x=GlobalLayoutManager.StageWidth-GlobalLayoutManager.IVY_WIDTH;
			if (show) {
				Board.x=GlobalLayoutManager.StageWidth-GlobalLayoutManager.IVY_WIDTH;
			}else {
				Board.x=GlobalLayoutManager.StageWidth+5;
			}
		}
		
		public static function toExpand(NodeLink:CompressedNode):void
		{
			Banner.setSelection(Banner.Icon_Connect);
			showBoard("Connect");
			attribe_panel.toExpand(NodeLink);
		}
	}
}