package UserInterfaces.FunctionPanel{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import Kernel.Biology.NodeTypeInit;
	
	import GUI.Assembly.FlexibleLayoutObject;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichGrid;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import Kernel.Assembly.SelectArray;
	
	import fl.events.ListEvent;
	
	public class PerspectiveViewer extends Sprite implements FlexibleLayoutObject{
		
		private static var grid:RichGrid=new RichGrid();
		private var NameSearcher:TextInput=new TextInput(true);
		private  var _searchlabel:LabelTextField=new LabelTextField("Search:")
		private static var Data:Array;
		public var Height:Number;
		
		grid.columns=["Type","Name","Edges"];
		grid.columnWidths=[90,300,60];
		
		public function PerspectiveViewer()
		{
			setSize(550,300);
			
			addChild(grid);
			
			cacheAsBitmap=true;
			
			NameSearcher.addEventListener("change",search);
			
			grid.addEventListener(Event.ADDED_TO_STAGE,refreshPerspective);
			
			grid.addEventListener(ListEvent.ITEM_CLICK,choose_evt);
			
		}
		
		protected function search(event:Event):void
		{
			var stable:Array = SelectArray.searchArray(Data,"Name",NameSearcher.text);
			grid.dataProvider = stable;
			if (stable.length != NodeTypeInit.BiotypeList.length&&stable.length>0) {
				grid.selectedIndex = 0;
				grid.scrollToSelected();
			}
		}
		public static function addPerspective(ID):void{
			
		}
		public static function refreshPerspective(e=null):void{
			
			if(grid.stage!=null){
				Data=[];
				
				for each (var node:CompressedNode in GxmlContainer.Node_Space) {
					Data.push({Node:node,Name:node.Name,Type:node.Type.label,Edges:node.Edges});
				}
				
				grid.dataProvider=Data;
				
			}
			
		}
		protected function choose_evt(event:ListEvent):void{
			Net.Centerlize(event.item.Node);
		}
		public function setSize(w:Number,h:Number):void{
			
			Height=h;
			
			NameSearcher.setSize(w-100,24);
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,1,2,5,_searchlabel,NameSearcher);
			
			
			grid.setSize(w,h-30);
			
			grid.y=30;
		}
	}
}