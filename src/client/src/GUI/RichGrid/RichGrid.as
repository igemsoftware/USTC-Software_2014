package GUI.RichGrid
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import GUI.Scroll.Scroll;
	
	import Style.FontPacket;
	
	import fl.controls.CheckBox;
	import fl.events.ListEvent;
	
	public class RichGrid extends Sprite{
		
		private var sheet:Table;
		
		public var BoardAlign:int=2;
		public var rowHeight:int=25;
		public var labelHeight:int=27;
		public var back:Shape=new Shape();
		
		private var cl:Array=[];
		private var clw:Array=[];
		
		private var scroll:Scroll=new Scroll(sheet);
		private var f_width:Number=100;
		
		private var textSpace:Array=[];
		private var buttonSpace:Array=[];
		private var SortSpace:Array=[];
		
		public var Width:Number=100,Height:Number=100;
		
		private var edit:Boolean=false;
		private var multi:Boolean=false;
		
		private var currentMoveIndex:int;
		private var currentMoveRange:Number;
		
		private var masker:Shape;
		private var allselectCheck:CheckBox;
		
		private var autoHeight:Boolean=false;
		private var sortAble:Boolean;
		
		public function RichGrid(editable=false,selectable=false,multiSelection=false,sortable=true,autoheight=false,html=false,double=false){
			edit=editable
			multi=multiSelection;
			sortAble=sortable;
			autoHeight=autoheight;
			
			if (multiSelection) {
				allselectCheck=new CheckBox();
				allselectCheck.label="";
				allselectCheck.addEventListener(MouseEvent.CLICK,function (e):void{
					sheet.selectAll(allselectCheck.selected)
				});
			}
			
			sheet=new Table(editable,selectable,multiSelection,true,html,double);
			
			
			addChild(back);
			if(autoHeight){
				addChild(sheet);
				sheet.x=BoardAlign;
				sheet.y=BoardAlign+labelHeight+1;
			}else{
				masker=new Shape();
				scroll=new Scroll(sheet);	
				scroll.x=BoardAlign;
				scroll.y=BoardAlign+labelHeight+1;
				addChild(scroll);
				addChild(masker);
			}
			
			sheet.addEventListener("TableClicked",function (e):void{
				var evt:ListEvent=new ListEvent(ListEvent.ITEM_CLICK,false,false,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedIndex,sheet.selectedItem);
				dispatchEvent(evt);
			});
			sheet.addEventListener("redrawed",function (e):void{
				redraw(true);
				dispatchEvent(new Event("redrawed"));
			});
			
		}
		public function setSize(w:Number,h:Number=0):void{
			if(Width!=w||Height!=h){
				
				Width=w;
				if (h==0) {
					h=Height;
				}else {
					Height=h;
				}
				if(!autoHeight){
					masker.graphics.clear();
					masker.graphics.beginFill(0);
					masker.graphics.drawRect(0,0,w,h);
					masker.graphics.endFill();
					mask=masker;
				}
				if(!autoHeight){
					scroll.setSize(w-BoardAlign*2,h-labelHeight-BoardAlign*2);
				}
				redraw();
			}
		}
		
		public function set dataProvider(d:Array):void{
			sheet.dataProvider=d;
			if(allselectCheck!=null){
				allselectCheck.selected=false; 
			}
		}
		public function get dataProvider():Array{
			return sheet.dataProvider;
		}
		
		public function get selectedIndex():int{
			return sheet.selectedIndex;
		}
		
		public function set selectedIndex(n:int):void{
			sheet.selectedIndex=n;
		}
		public function get selectedItem():Object{
			return sheet.selectedItem;
		}
		
		public function set columns(a:Array):void{
			cl=a;
			clw=[];
			for (var i:int = clw.length; i < cl.length; i++) {
				clw[i]=100;
			}
			sheet.columns=a;
		}
		public function set columnWidths(a:Array):void{
			clw=a;
			var k:Number=0;
			for (var i:int = 0; i < a.length-1; i++) {
				f_width+=clw[i];
			}
		}
		
		public function get selectedItems():Array{
			return sheet.selectedItems;
		}
		
		public function redraw(neg:Boolean=false):void{
			f_width=int(multi)*30;
			for (var i:int = 0; i < clw.length-1; i++) {
				f_width+=clw[i];
			}
			if(edit){
				clw[clw.length-1]=Width-f_width-30;
			}else{
				clw[clw.length-1]=Width-f_width;
			}
			if(!neg){
				sheet.columnWidths=clw;
				sheet.redraw();
			}
			if(autoHeight){
				Height=sheet.contentHeight+BoardAlign*2+labelHeight;
			}
			back.graphics.clear();
			back.graphics.lineStyle(0,0xdddddd);
			back.graphics.beginFill(0xdddddd);
			back.graphics.drawRect(0,0,Width,Height);
			back.graphics.endFill();
			back.graphics.beginFill(0xffffff);
			
			back.graphics.drawRect(BoardAlign,BoardAlign,Width-BoardAlign*2,Height-BoardAlign*2);
			
			back.graphics.endFill();
			back.graphics.lineStyle(0,0xaaaaaa);
			var tmatrix:Matrix=new Matrix();
			tmatrix.createGradientBox(1, labelHeight, Math.PI/2);
			back.graphics.beginGradientFill(GradientType.LINEAR,[0xdddddd,0xbbbbbb],[1, 1],[0, 255],tmatrix);
			back.graphics.drawRect(BoardAlign,BoardAlign,Width-BoardAlign*2,labelHeight);
			back.graphics.endFill();
			
			var curW:Number=int(multi)*30;
			for ( i = 0; i < cl.length; i++) {
				if (textSpace[i]==null) {
					textSpace[i]=new TextField();
					textSpace[i].defaultTextFormat=FontPacket.ContentText;
					textSpace[i].selectable=false;
					textSpace[i].y=BoardAlign+1;
					addChild(textSpace[i]);
					if(sortAble){
						SortSpace[i]=new Sprite();
						
						SortSpace[i].tabIndex=i;
						SortSpace[i].addEventListener("click",sortOnColumn);
						addChild(SortSpace[i]);
					}
					
				}
				if(sortAble){
					SortSpace[i].graphics.clear();
					SortSpace[i].graphics.beginFill(0,0);
					SortSpace[i].graphics.drawRect(0,0,clw[i],labelHeight);
					SortSpace[i].graphics.endFill();
					SortSpace[i].x=BoardAlign+curW;
					SortSpace[i].y=1;
				}
				
				textSpace[i].text=cl[i];
				textSpace[i].x=BoardAlign+curW;
				textSpace[i].height=labelHeight;
				textSpace[i].width=clw[i];
				curW+=clw[i];
			}
			
			//////////Redraw.DragBox
			
			back.graphics.lineStyle(0,0xeeeeee);
			
			curW=int(multi)*30;
			if(multi){
				back.graphics.moveTo(BoardAlign+curW,BoardAlign+2);
				back.graphics.lineTo(BoardAlign+curW,BoardAlign+labelHeight-1);
				allselectCheck.x=5;
				allselectCheck.y=BoardAlign+4;
				addChild(allselectCheck);
			}
			for (var j:int=0;j<cl.length-int(!edit);j++) {
				curW+=clw[j];
				back.graphics.moveTo(BoardAlign+curW,BoardAlign+2);
				back.graphics.lineTo(BoardAlign+curW,BoardAlign+labelHeight-1);
				if(buttonSpace[j]==null){
					buttonSpace[j]=new Sprite();
					buttonSpace[j].graphics.beginFill(0,0);
					buttonSpace[j].graphics.drawRect(0,0,10,labelHeight);
					buttonSpace[j].graphics.endFill();
					buttonSpace[j].tabIndex=j;
					addChild(buttonSpace[j]);
					buttonSpace[j].addEventListener(MouseEvent.MOUSE_OVER,function (e):void{
						Mouse.cursor="Grid_DragingCursor";
					});
					buttonSpace[j].addEventListener(MouseEvent.MOUSE_OUT,function (e):void{
						Mouse.cursor=MouseCursor.AUTO;
					});
					buttonSpace[j].addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
						e.target.startDrag();
						currentMoveIndex=e.target.tabIndex;
						currentMoveRange=int(multi)*30;
						for (var k:int = 0; k < currentMoveIndex ; k++) {
							currentMoveRange+=clw[k];
						}
						
						stage.addEventListener(MouseEvent.MOUSE_MOVE,moving);
						stage.addEventListener(MouseEvent.MOUSE_UP,upevt);
					});
					function upevt(e):void{
						buttonSpace[currentMoveIndex].stopDrag();
						stage.removeEventListener(MouseEvent.MOUSE_MOVE,moving);
						stage.removeEventListener(MouseEvent.MOUSE_UP,upevt);
					}
					function moving(e):void{
						clw[currentMoveIndex]=Math.min(Math.max(mouseX-currentMoveRange,20),Width-currentMoveRange-20);
						redraw();
						dispatchEvent(new Event("redrawed"));
					}
				}
				buttonSpace[j].y=BoardAlign;
				buttonSpace[j].x=BoardAlign+curW-5;
			}
		}
		
		public function scrollToSelected():void{
			scroll.rollPosition=selectedIndex*rowHeight;
		}
		
		public function sortOnColumn(e):void{
			sheet.sortOnColumn(e.target.tabIndex);
		}
	}
}