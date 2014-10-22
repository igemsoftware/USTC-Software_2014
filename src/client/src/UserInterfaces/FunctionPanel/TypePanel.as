package UserInterfaces.FunctionPanel{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import Kernel.Biology.LinkTypeInit;
	import Kernel.Biology.NodeTypeInit;
	
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import Kernel.ProjectHolder.GxmlContainer;
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	
	import Kernel.Assembly.SelectArray;
	
	/**
	 * a panel to set the type of the node
	 */
	public class TypePanel extends Sprite{
		private const W:uint=250;
		private const H:uint=320;
		
		public var searchT:TextInput=new TextInput();
		public var grid:RichList=new RichList();
		public var ok_b:RichButton=new RichButton();
		public var cel_b:RichButton=new RichButton();
		private var Target:*;
		
		/**
		 * a panel to set the type
		 * @param tar the target to set type
		 */
		public function TypePanel(tar){
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
		/**
		 * to listen to keybroad event
		 */
		protected function key_mon(event:KeyboardEvent):void{
			if (event.keyCode==13) {
				if (grid.selectedItem!=null) {
					setType_evt();
				}
			}
		}
		/**
		 * to set the type
		 */
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
		
		/**
		 * when close the panel
		 */
		protected function close_evt(event:MouseEvent):void{
			Target.Instance.tPanel=null;
			dispatchEvent(new Event("close"));
		}
		/**
		 * search
		 */
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