package IvyBoard
{
	import flash.events.Event;
	
	import Biology.TypeEditor.LinkStylePanel;
	import Biology.TypeEditor.NodeStylePanel;
	
	import Layout.GlobalLayoutManager;
	
	
	public class Ivy
	{

		
		public var Banner:IvyBanner=new IvyBanner();
		public var Board:IvyBoard=new IvyBoard();
		
		
		public var attribe_panel:AttribPanel=new AttribPanel();
		public var expand_panel:ExpandPanel=new ExpandPanel();
		public var layout_panel:LayoutPanel=new LayoutPanel();
		public var project_panel:ProjectDetailPanel=new ProjectDetailPanel();
		
		public var show:Boolean=false;
		private var remPannel:String;
		
		public function Ivy()
		{
			Board.y=Board.aimY=50;
			
			Banner.addEventListener(Event.CHANGE,function (e):void{
				if (Board.parent==null) {
					Board.dispatchEvent(new Event("showBoard"));
				}
				if (Banner.panel!=remPannel) {
					remPannel=Banner.panel;
					switch(Banner.panel)
					{
						case "Add":
						{
							Board.loadPanel([
								{label:"Add Node",Object:new AddPanel()}
							],"Add Node");
							break;
						}
						case "Connect":
						{
							Board.loadPanel([
								{label:"Connection",Object:attribe_panel},
								{label:"Expand",Object:expand_panel}
							],"Connection");
							break;
						}
						case "Edit":
						{
							Board.loadPanel([
								{label:"Layout",Object:layout_panel}
							],"Layout");
							break;
						}
						case "Info":
						{
							Board.loadPanel([
								{label:"Project Information",Object:project_panel}
							],"Project Information");
							break;
						}
						
					}
				}
			})
		}
		
		public function redraw(w,h):void{
			Banner.redraw(w);
			Board.redraw(w,h-50);
		}
		public function resetLayout():void{
			Banner.x=GlobalLayoutManager.StageWidth-GlobalLayoutManager.IVY_WIDTH;
			if (show) {
				Board.x=GlobalLayoutManager.StageWidth-GlobalLayoutManager.IVY_WIDTH;
			}else {
				Board.x=GlobalLayoutManager.StageWidth+5;
			}
		}
	}
}