package IvyBoard {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import GUI.RichGrid.RichGrid;
	
	import IEvent.FocusItemEvent;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	
	import Style.FontPacket;
	
	public class AttribPanel extends Sprite{
		
		private var title:TextField=new TextField();
		private var grid:RichGrid=new RichGrid(false,false);
		
		public var linkedObject:*;
		private var showState:int=0;
		
		public var selectedItem:*;
		
		public var Height:Number;
		
		public var Label:String="Connection"
		
		public function AttribPanel():void {
			
			title.y=0;
			title.selectable=false;
			title.autoSize="left";
			title.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			
			grid.columns=["Link"];
			grid.rowHeight=22;
			
			addChild(title);
			addChild(grid);
			
			clear();
			grid.addEventListener(MouseEvent.CLICK,focused);
			
			
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				showAttrib(GlobalVaribles.FocusedTarget);
				GlobalVaribles.eventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,function (e:FocusItemEvent):void{
					showAttrib(e.focusTarget);
				});
			})
		}
		
		protected function focused(event):void{
			if (event.currentTarget.selectedItem!=null) {
				Net.Centerlize(event.currentTarget.selectedItem.Item);
			}
		}
		
		public function clear():void {
			linkedObject=null;
			title.text="USTCsoftware";
			grid.dataProvider=[];
		}
		
		public function showAttrib(obj):void {
			var table:Array=[];
			
			linkedObject=obj;
			if (linkedObject==null) {
				clear();
			} else if (obj.constructor==CompressedNode) {
				title.text=(obj as CompressedNode).Type.label+" : "+obj.Name;
				var tb1:Array=[];
				var tb2:Array=[];
				for each(var arrow:CompressedLine in obj.Arrowlist) {
					if (arrow.linkObject[0]==obj) {
						tb1.push({Link:arrow.linkObject[0].Name+" → "+arrow.linkObject[1].Name,Item:arrow});
					} else {
						tb2.push({Link:arrow.linkObject[1].Name+" ← "+arrow.linkObject[0].Name,Item:arrow});
					}
				} 
				table=tb1.concat(tb2);
			} else {
				
				title.text=obj.linkObject[0].Name+" → "+obj.linkObject[1].Name;
				
				table.push({Link:obj.linkObject[0].Name,Item:obj.linkObject[0]});
				table.push({Link:obj.linkObject[1].Name,Item:obj.linkObject[1]});
			}
			grid.dataProvider=table
		}
		public function setSize(w):void{
			Height=0;
			grid.y=36;
			grid.setSize(w,240);
			
			Height=240+55;
		}
	}
	
}