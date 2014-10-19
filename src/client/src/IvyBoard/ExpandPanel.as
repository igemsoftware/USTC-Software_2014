package IvyBoard {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import Assembly.Compressor.CompressedNode;
	import Assembly.ExpandThread.ExpandManager;
	
	import GUI.Assembly.LabelTextField;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	
	import IEvent.ExpandEvent;
	import IEvent.FocusItemEvent;
	
	import Style.FontPacket;
	
	public class ExpandPanel extends Sprite{
		
		private var title:TextField=new TextField();
		private var grid:RichGrid=new RichGrid(false,false,true);
		private var loadingMark:LoadingMark=new LoadingMark();
		private var hint:LabelTextField=new LabelTextField("No Exteral Link");
		
		private var ExpandButton:RichButton=new RichButton();
		
		private var target:CompressedNode;
		
		public var linkedObject:*;
		private var showState:int=0;
		
		public var selectedItem:*;
		
		private var remlength:int;
		private var Width:Number;
		public var Height:Number;
		
		public var Label:String="Connection"
		
		private var receiver:EventDispatcher;
		
		public function ExpandPanel():void {
			
			title.y=0;
			title.selectable=false;
			title.autoSize="left";
			title.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			grid.y=36;
			grid.columns=["External_Links"];
			grid.rowHeight=22;
			
			ExpandButton.label="Expand"
			ExpandButton.setIcon(Icon_Expand);
			ExpandButton.setSize(120,40);
			
			addChild(title);
			addChild(ExpandButton);
			
			clear();
			grid.addEventListener(MouseEvent.CLICK,focused);
			
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				setExpandNode(GlobalVaribles.FocusedTarget);
				GlobalVaribles.eventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,function (e:FocusItemEvent):void{
					setExpandNode(e.focusTarget);
					dispatchEvent(new Event("redrawed"));
				});
			})
			
			ExpandButton.addEventListener(MouseEvent.CLICK,ExpandButton_clickHandler);
			
			
			ExpandButton.y=title.height+5;
			Height=ExpandButton.y+ExpandButton.height+5;
		}
		
		
		protected function focused(event):void{
			if(grid.selectedItems.length!=remlength){
				var tmparr:Array=[];
				for (var i:int = 0; i < grid.selectedItems.length; i++) {
					tmparr.push(grid.selectedItems[i].LinkID);
				}
				ExpandManager.Explode(target,tmparr);
				remlength=grid.selectedItems.length;
			}
		}
		
		public function clear():void {
			title.text="Click a node to Expand";
			removeChildren();
			addChild(title);
		}
		
		public function setExpandNode(obj):void {
			if(obj==null||obj.constructor!=CompressedNode){
				
				clear();
				
			}else{
				target=obj;
				title.text=obj.Name;
				removeChildren();
				addChild(title);
				addChild(ExpandButton);
			}
			Height=ExpandButton.y+ExpandButton.height+5;
			
		}
		public function setSize(w):void{
			
			if(Width!=w){
				grid.setSize(w,480);
				
				Width=w;
				
				ExpandButton.x=w/2-ExpandButton.Width/2;
				ExpandButton.y=title.height+5;
				
				hint.x=w/2-hint.width/2;
				hint.y=title.height+5;
				
				loadingMark.x=w/2-loadingMark.width/2;
				loadingMark.y=title.height+5;
				
			}
			if(contains(ExpandButton)){
				Height=ExpandButton.y+ExpandButton.height+5;
			}
		}
		
		protected function ExpandButton_clickHandler(event:MouseEvent):void{
			// TODO Auto-generated method stub
			receiver=ExpandManager.Expand(target,ExpandManager.SEARCHLINES);
			
			if(receiver!=null){
				removeChild(ExpandButton);
				addChild(loadingMark);
				receiver.addEventListener(ExpandEvent.EXPAND_COMPLETE,function (e:ExpandEvent):void{
					var table:Array=[];
					var label:String;
					if(e.ExpandList.length>0){
						for (var i:int = 0; i < e.ExpandList.length; i++) {
							if(e.ExpandList[i].DIRECT==1){
								label=" → "+e.ExpandList[i].NAME
							}else{
								label=" ← "+e.ExpandList[i].NAME
							}
							table.push({External_Links:label,LinkID:e.ExpandList[i]});
						}
						grid.dataProvider=table;
						addChild(grid);
						if(contains(loadingMark)){
							removeChild(loadingMark);
						}
						Height=grid.y+grid.Height+5;
					}else{
						addChild(hint);
						Height=hint.y+hint.height+5;
					}
					dispatchEvent(new Event("redrawed"));
				},false,0,true);
			}
		}
	}
	
}