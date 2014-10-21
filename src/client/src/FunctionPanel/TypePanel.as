package FunctionPanel{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import Biology.LinkTypeInit;
	import Biology.NodeTypeInit;
	
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;
	
	import Assembly.ProjectHolder.GxmlContainer;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	
	import algorithm.SelectArray;
	
	
	public class typePanel extends Sprite{
		private const W:uint=250;
		private const H:uint=320;
		
		public var searchT:TextInput=new TextInput();
		public var grid:RichList=new RichList();
		public var ok_b:RichButton=new RichButton();
		public var cel_b:RichButton=new RichButton();
		private var Target:*;
		
		public function typePanel(tar){
			Target=tar;
			
			if (tar.constructor==CompressedNode) {
				grid.dataProvider = NodeTypeInit.BiotypeIndexList;
			}else if (tar.constructor==CompressedLine) {
				grid.dataProvider = LinkTypeInit.LinkTypeIndexList;
			}
			
			grid.y=searchT.height+5;
			
			ok_b.label="Confirm";
			cel_b.label="Cancel";
			
			LayoutManager.UnifyScale(100,30,ok_b,cel_b);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,W/2,grid.y+H+5,20,ok_b,cel_b)
			
			addChild(searchT);
			addChild(grid);
			
			ok_b.addEventListener(MouseEvent.CLICK,setType_evt);
			cel_b.addEventListener(MouseEvent.CLICK,close_evt);
			grid.addEventListener(MouseEvent.CLICK,function (e):void{
				searchT.text=grid.selectedItem.label;
			});
			addEventListener(KeyboardEvent.KEY_DOWN,key_mon);
			searchT.addEventListener("change",search1);
			
			setSize(W,H);
			
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				stage.focus=searchT;
			});
		}
		
		protected function key_mon(event:KeyboardEvent):void{
			if (event.keyCode==13) {
				if (grid.selectedItem!=null) {
					setType_evt();
				}
			}
		}
		
		protected function setType_evt(event=null):void{
			
			if(Target.constructor==CompressedNode){
				GxmlContainer.RecordNodeDetail(Target);
			}else{
				GxmlContainer.RecordLineDetail(Target);
			}
			
			Target.Type=grid.selectedItem;
			Net.RedrawFocus(Target);
			if(Target.Instance!=null){
				Target.Instance.tPanel=null;
			}
			dispatchEvent(new Event("close"));
		}
		
		protected function close_evt(event:MouseEvent):void{
			Target.Instance.tPanel=null;
			dispatchEvent(new Event("close"));
		}
		
		private function search1(e):void {
			var stable:Array = SelectArray.searchArray(NodeTypeInit.BiotypeList,"label",searchT.text);
			grid.dataProvider = stable;
			if (stable.length != NodeTypeInit.BiotypeList.length&&stable.length>0) {
				grid.selectedIndex = 0;
				grid.scrollToSelected();
			}
		}
		public function setSize(w:Number,h:Number):void{
			searchT.setSize(w,26);
			grid.setSize(w,h);
		}
	}
}