package UserInterfaces.IvyBoard.IvyPanels {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.ExpandThread.ExpandManager;
	
	import GUI.Assembly.LabelTextField;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	
	import Kernel.ExpandThread.ExpandEvent;
	import Kernel.Events.FocusItemEvent;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import UserInterfaces.Style.FontPacket;
	
	public class AttribPanel extends Sprite{
		
		private var hint:LabelTextField=new LabelTextField("No Exteral Link");
		
		private var C_hint:LabelTextField=new LabelTextField("Connection :");
		
		private var own:RichButton=new RichButton(1);
		private var external:RichButton=new RichButton(2);
		
		private var title:TextField=new TextField();
		
		private var smpinf:QuickINF=new QuickINF();
		
		private var grid:RichGrid=new RichGrid(false,false);
		private var grid_ext:RichGrid=new RichGrid(false,false,true);
		
		public var linkedObject:*;
		private var showState:int=0;
		
		public var selectedItem:*;
		
		private var remlength:int;
		
		public var Height:Number;
		private var Width:Number=200;
		
		private var receiver:EventDispatcher;
		
		private var nodataHint:LabelTextField=new LabelTextField("No result found");
		
		public function AttribPanel():void {
			
			title.y=0;
			title.selectable=false;
			title.autoSize="left";
			title.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			
			grid.columns=["Connections"];
			grid.rowHeight=22;
			
			grid_ext.columns=["External Links"];
			grid_ext.rowHeight=22;
			
			grid_ext.visible=false;
			
			nodataHint.visible=false;
			nodataHint.defaultTextFormat=FontPacket.ContentText;
			nodataHint.text="No result found"
			
			
			addChild(title);
			addChild(smpinf);
			addChild(grid);
			addChild(grid_ext);
			addChild(nodataHint);
			
			clear();
			
			grid.addEventListener(MouseEvent.CLICK,focused);
			grid_ext.addEventListener(MouseEvent.CLICK,focused_ext);
			
			own.label="Local";
			external.label="Cloud";
			
			own.focused=true;
			external.focused=false;
			
			own.addEventListener(MouseEvent.CLICK,own_click_evt)
			external.addEventListener(MouseEvent.CLICK,ExpandButton_clickHandler);
			
			
			LayoutManager.UnifyScale(100,30,own,external);
			
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				showAttrib(GlobalVaribles.FocusedTarget);
				GlobalVaribles.FocusEventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,function (e:FocusItemEvent):void{
					showAttrib(e.focusTarget);
				});
			})
		}
		
		protected function own_click_evt(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			external.focused=false;
			own.focused=true;
			
			grid.visible=true;
			
			grid_ext.visible=false;
			
			nodataHint.visible=false;
			
		}
		
		protected function focused_ext(event:MouseEvent):void
		{
			
			if(grid_ext.selectedItems.length!=remlength){
				var tmparr:Array=[];
				for (var i:int = 0; i < grid_ext.selectedItems.length; i++) {
					tmparr.push(grid_ext.selectedItems[i].LinkID);
				}
				ExpandManager.Explode(linkedObject,tmparr);
				remlength=grid_ext.selectedItems.length;
			}
			
		}
		
		protected function focused(event):void{
			if (event.currentTarget.selectedItem!=null) {
				Net.Centerlize(event.currentTarget.selectedItem.Item);
			}
		}
		
		public function clear():void {
			linkedObject=null;
			title.text="---";
			grid.dataProvider=[];
			
			external.focused=false;
			own.focused=true;
			
			grid.visible=true;
			
			grid_ext.visible=false;
			
			nodataHint.visible=false;
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
						tb1.push({Connections:arrow.linkObject[0].Type.label+" : "+arrow.linkObject[0].Name+" → "+arrow.linkObject[1].Type.label+" : "+arrow.linkObject[1].Name,Item:arrow});
					} else {
						tb2.push({Connections:arrow.linkObject[1].Type.label+" : "+arrow.linkObject[1].Name+" ← "+arrow.linkObject[0].Type.label+" : "+arrow.linkObject[0].Name,Item:arrow});
					}
				} 
				table=tb1.concat(tb2);
			} else {
				
				title.text=obj.linkObject[0].Name+" → "+obj.linkObject[1].Name;
				
				table.push({Connections:obj.linkObject[0].Type.label+" : "+obj.linkObject[0].Name,Item:obj.linkObject[0]});
				table.push({Connections:obj.linkObject[1].Type.label+" : "+obj.linkObject[1].Name,Item:obj.linkObject[1]});
			}
			grid.dataProvider=table;
			
			smpinf.target=obj;
			
			external.focused=false;
			own.focused=true;
			
			grid.visible=true;
			
			grid_ext.visible=false;
			
			nodataHint.visible=false;
			
			setSize();
		}
		
		protected function ExpandButton_clickHandler(event=null):void{
			// TODO Auto-generated method stub
			
			if(linkedObject!=null&&linkedObject.constructor==CompressedNode){
				
				
				
				receiver=ExpandManager.Expand(linkedObject,ExpandManager.SEARCHLINES);
				
				if(receiver!=null){
					external.focused=true;
					own.focused=false;
					
					external.suspend();
					
					if(contains(hint)){
						removeChild(hint);
					}
					receiver.addEventListener(ExpandEvent.EXPAND_COMPLETE,function (e:ExpandEvent):void{
						if(e.ExpandTarget!=null){
							var table:Array=[];
							var label:String;
							if(e.ExpandList.length>0){
								for (var i:int = 0; i < e.ExpandList.length; i++) {
									if(e.ExpandList[i].DIRECT==1){
										label=" → "+e.ExpandList[i].TYPE+" : "+e.ExpandList[i].NAME;
									}else{
										label=" ← "+e.ExpandList[i].TYPE+" : "+e.ExpandList[i].NAME;
									}
									table.push({"External Links":label,LinkID:e.ExpandList[i]});
								}
								nodataHint.visible=false;
								grid_ext.dataProvider=table;
								
								grid.visible=false;
								
								grid_ext.visible=true;
							}else{
			
								nodataHint.visible=true;
							}
						}else{
					
							nodataHint.visible=true;
						}
						external.unsuspend();
					});
				}
			}
		}
		
		public function setSize(w=0):void{
			
			if(w==0){
				w=Width;
			}else{
				Width=w;
			}
			
			Height=0;
			
			smpinf.y=36;
			smpinf.setSize(w);
			
			
			var ah:int=smpinf.y+smpinf.height+10;
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,ah-5,0,C_hint);
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,w/2,ah+25,0,own,external);
			
			grid_ext.y=grid.y=ah+60
			
			hint.y=grid.y+35;
			
			nodataHint.y=grid.y+30;
			nodataHint.x=w/2-nodataHint.width/2
			
			grid_ext.setSize(w,380);
			grid.setSize(w,380);
			
			Height=grid.y+grid.Height;
		}
		
		public function toExpand(NodeLink:CompressedNode):void
		{
			// TODO Auto Generated method stub
			
			showAttrib(NodeLink);
			
			ExpandButton_clickHandler();
		}
	}
	
}