package GUI.RichGrid
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import GUI.Scroll.Scroll;
	
	import fl.events.ListEvent;
	
	
	public class RichList extends Sprite{
		
		private var sheet:Table;
		
		public var contentHeight:int;
		public var rowHeight:int=25;
		public var back:Shape=new Shape();
		private var cl:Array=[];
		private var clw:Array=[];
		
		private var scroll:Scroll=new Scroll(sheet);

		public var Width:Number=100,Height:Number=100;
		
		private var edit:Boolean=false;
		
		private var currentMoveIndex:int;
		private var currentMoveRange:Number;
		
		private var masker:Shape=new Shape();
		
		public function RichList(key:String="label",editable=false,selectable=false){
			edit=editable
			
			sheet=new Table(editable,selectable);
			
			sheet.columns=[key];
			scroll=new Scroll(sheet);
			
			addChild(back);
			addChild(scroll);
			addChild(masker);
			
			sheet.addEventListener("TableClicked",function (e):void{
				var evt:ListEvent=new ListEvent(ListEvent.ITEM_CLICK,false,false,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedItem);
				dispatchEvent(evt);
			});
			sheet.addEventListener("TableDoubleClicked",function (e):void{
				var evt:ListEvent=new ListEvent(ListEvent.ITEM_DOUBLE_CLICK,false,false,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedItem);
				dispatchEvent(evt);
			});
			
		}
		public function setSize(w:Number,h:Number=0):void{
			Width=w;
			if (h==0) {
				h=Height;
			}else {
				Height=h;
			}
			masker.graphics.clear();
			masker.graphics.beginFill(0);
			masker.graphics.drawRect(0,0,w,h);
			masker.graphics.endFill();
			mask=masker;
			scroll.setSize(w,h);
			redraw();
		}
		
		public function set dataProvider(d:Array):void{
			sheet.dataProvider=d;
			contentHeight=sheet.contentHeight;
			scroll.negativeRedraw();
		}
		public function get dataProvider():Array{
			return sheet.dataProvider;
		}
		
		public function get selectedIndex():int{
			return sheet.selectedIndex;
		}
		
		public function set selectedIndex(s:int):void{
			sheet.selectedIndex=s;
		}
		
		public function get selectedItem():Object{
			return sheet.selectedItem;
		}
		
		public function get selectedItems():Array{
			return sheet.selectedItems;
		}
		
		public function redraw():void{
			sheet.columnWidths=[Width];
			sheet.redraw();
			contentHeight=sheet.contentHeight;
			back.graphics.clear();
			back.graphics.lineStyle(0,0xdddddd);
			back.graphics.beginFill(0xffffff);
			back.graphics.drawRect(0,0,Width,Height);
		}
		
		public function scrollToSelected():void{
			scroll.rollPosition=selectedIndex*rowHeight;;
		}
	}
}

