package GUI.RichGrid
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import GUI.Assembly.FocusRect;
	
	import UserInterfaces.Style.FontPacket;
	
	import fl.controls.CheckBox;
	
	public class Table extends Sprite
	{
		public var rowHeight:Array=[];
		public var rowY:Array=[];
		public var contentHeight:int;
		
		private var back:Shape=new Shape();
		
		private var db:Array=new Array();
		private var cl:Array=[];
		private var clw:Array=[];
		private var Width:Number=200;
		private var focusRect:FocusRect=new FocusRect();
		private var min:DEL;
		private var addingMark:Add;
		private var currentR:int;
		private var hit_R:int;
		private var contentWidth:Number=0;
		
		private var textSpace:Array=[];
		private var checkSpace:Array=[];
		private var highLightSpace:Array=[];
		
		private var rowHit:Shape=new Shape();
		
		private var moveHit:Shape=new Shape();
		
		private var editable:Boolean=false;
		private var selectable:Boolean=false;
		private var multiSelection:Boolean=false;
		private var autoHeight:Boolean=false;
		private var Html:Boolean;
		private var DoubleClick:Boolean;
		
		private var _selectedIndex:int;
		
		public var selectedItem:Object;
		public var selectedItems:Array=[];
		
		private var sortcol:int;
		private var sortdirct:Boolean;
		public var Height:int;
		
		public function Table(edit=false,select=false,multi=false,autoheight=false,html=false,doubleClick=false)
		{
			
			DoubleClick=doubleClick;
			Html=html
			editable=edit;
			selectable=edit|select;
			multiSelection=multi;
			autoHeight=autoheight;
			
			addChild(back);
			addChild(rowHit);
			addChild(moveHit);
			
			
			rowHit.graphics.beginFill(0x0099ff,0.2);
			rowHit.graphics.drawRect(0,0,100,100);
			rowHit.graphics.endFill();
			
			moveHit.graphics.beginFill(0x0099ff,0.1);
			moveHit.graphics.drawRect(0,0,100,100);
			moveHit.graphics.endFill();
			
			rowHit.visible=false;
			moveHit.visible=false;
			
			addEventListener(MouseEvent.MOUSE_OUT,function (e):void{
				moveHit.visible=false;
			})
			
			if (editable) {
				addChild(focusRect);
				
				min=new DEL;
				addingMark=new Add();
				
				addChild(min);
				addChild(addingMark);
				
				
				
				min.visible=false;
				min.scaleX=min.scaleY=0.5;
				min.addEventListener(MouseEvent.CLICK,function (e:MouseEvent):void{
					db.splice(currentR,1);
					min.visible=false;
					focusRect.graphics.clear();
					rowHit.visible=false;
					redraw();
					if(autoHeight){
						dispatchEvent(new Event("redrawed"));
					}
				})
				
				addingMark.scaleX=addingMark.scaleY=0.5;
				addingMark.addEventListener(MouseEvent.CLICK,function (e):void{
					var obj:Object=new Object();
					for (var k:int = 0; k < cl.length; k++) {
						obj[cl[k]]="";
					}
					db.push(obj);
					redraw();
					
					setSelection(db.length-1);
					
					stage.focus=textSpace[(db.length-1)*cl.length+1];
					
					if(autoHeight){
						dispatchEvent(new Event("redrawed"));
					}
				});
			}
		}
		
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void{
			setSelection(value);
		}
		
		public function set dataProvider(d:Array):void{
			
			db=d;
			selectedIndex=-1;
			selectedItem=null;
			rowHit.visible=false;
			if(dataProvider.length<hit_R){
				moveHit.visible=false;
			}
			redraw(true);
		}
		public function get dataProvider():Array{
			return db;
		}
		public function set columns(a:Array):void{
			cl=a;
			clw=[];
			for (var i:int = clw.length; i < cl.length; i++) {
				clw[i]=100;
			}
		}
		public function set columnWidths(a:Array):void{
			clw=a;
		}
		public function redraw(reset=false):void{
			var id:int=1;
			var k:int;
			
			back.graphics.clear();	
			back.graphics.lineStyle(0,0xdddddd);
			
			var curW:int=int(multiSelection)*30;
			
			var curH:int=0;
			
			var maxH:int=0;
			
			
			
			for (var i:int=0;i<db.length;i++){
				
				curW=int(multiSelection)*30;
				maxH=0;
				
				if(multiSelection){
					if (checkSpace[i]==null) {
						checkSpace[i]=new CheckBox();
						checkSpace[i].label="";
						
						checkSpace[i].name=String(i);
						checkSpace[i].addEventListener(MouseEvent.CLICK,function (e:MouseEvent):void{
							if(e.currentTarget.selected){
								selectedItems.push(db[Number(e.currentTarget.name)]);
								addChildAt(highLightSpace[Number(e.currentTarget.name)],0);
							}else{
								removeChild(highLightSpace[Number(e.currentTarget.name)]);
								selectedItems.splice(
									selectedItems.indexOf(db[Number(e.currentTarget.name)]),1
								);
							}
						});
						highLightSpace[i]=new Shape();
						highLightSpace[i].graphics.beginFill(0xffffaa);
						highLightSpace[i].graphics.drawRect(0,0,100,100);
						highLightSpace[i].graphics.endFill();
					}
					addChild(checkSpace[i]);
					checkSpace[i].y=curH+2;
					checkSpace[i].x=3;
					
					
					highLightSpace[i].y=curH;
					highLightSpace[i].x=0;
					highLightSpace[i].height=rowHeight[i];
					highLightSpace[i].width=curW;
					
				}
				
				for (j=0;j<cl.length;j++) {
					if (textSpace[id]==null) {
						textSpace[id]=new TextField();
						textSpace[id].selectable=selectable;
						textSpace[id].defaultTextFormat=FontPacket.ContentText;
						
						
						textSpace[id].multiline=autoHeight;
						textSpace[id].wordWrap=autoHeight;
						
						
						addChild(textSpace[id]);
						
						///////Edit
						if (editable) {
							textSpace[id].type=TextFieldType.INPUT;
							textSpace[id].addEventListener(KeyboardEvent.KEY_UP,trysetField);
							textSpace[id].addEventListener(Event.CHANGE,trysetField);
							textSpace[id].addEventListener(FocusEvent.FOCUS_OUT,trysetField);
							
							function trysetField(e):void{
								var i:int=int((e.target.tabIndex-1)/cl.length);
								var j:int=(e.target.tabIndex-1)%cl.length;
								db[i][cl[j]]=e.target.text;
								if(Math.abs(e.target.textHeight-e.target.height)>5){
									redraw();
									dispatchEvent(new Event("redrawed"));
								}
							}
							
						}
						
						textSpace[id].addEventListener(MouseEvent.CLICK,focus_evt);
						if(DoubleClick){
							textSpace[id].addEventListener(MouseEvent.DOUBLE_CLICK,focus_evt);
							textSpace[id].doubleClickEnabled=true
						}
						textSpace[id].addEventListener(MouseEvent.ROLL_OVER,hit_evt);
						
						
						
					}
					textSpace[id].width=clw[j];
					textSpace[id].y=curH;
					textSpace[id].x=curW;
					
					if(Html){
						textSpace[id].htmlText=db[i][cl[j]];
					}else{
						textSpace[id].text=db[i][cl[j]];
					}
					textSpace[id].height=textSpace[id].textHeight+4;
					
					if(maxH<textSpace[id].height)maxH=textSpace[id].height;
					
					textSpace[id].tabIndex=id++;
					
					curW+=clw[j];
					
				}
				rowHeight[i]=maxH;
				rowY[i]=curH;
				curH+=maxH;
				
				back.graphics.moveTo(0,curH);
				back.graphics.lineTo(curW,curH);
			}
			
			contentWidth=curW;
			contentHeight=curH;
			
			/////draw Coloum
			curW=int(multiSelection)*30;
			if(multiSelection){
				
				for (var i2:int = 0; i2 < highLightSpace.length; i2++) 
				{
					highLightSpace[i2].width=contentWidth;
					highLightSpace[i2].height=rowHeight[i2];
				}
				back.graphics.moveTo(curW,2);
				back.graphics.lineTo(curW,curH);
			}
			
			for (var j:int=0;j<cl.length;j++) {
				curW+=clw[j];
				
				back.graphics.moveTo(curW,0);
				back.graphics.lineTo(curW,curH);
			}
			
			for (k = id; k < textSpace.length; k++) {
				removeChild(textSpace[k]);
				if(focusRect.focusItem==textSpace[k])focusRect.setItem(null);
				delete textSpace[k];
			}
			textSpace.splice(id,textSpace.length-id);
			
			for (k = i; k < checkSpace.length; k++) {
				removeChild(checkSpace[k]);
				delete checkSpace[k];
			}
			checkSpace.splice(i,checkSpace.length-i);
			
			//////////////hints
			
			rowHit.y=rowY[currentR];
			rowHit.width=contentWidth;
			rowHit.height=rowHeight[currentR];
			
			if(editable){
				focusRect.redraw();
				min.x=contentWidth+min.width/2+2;
				min.y=rowY[currentR]+rowHeight[currentR]/2+2;
			}
			
			if(reset&&multiSelection){
				selectAll(false);
			}
			if(editable){
				addingMark.y=contentHeight+addingMark.height/2+2;
				addingMark.x=addingMark.width/2+2;
				
				contentHeight+=addingMark.height+5;
			}
			Height=contentHeight;
			
		}
		
		//			*/redraw
		public function setSize(w:Number):void{
			Width=w;
			redraw();
		}
		
		public function selectAll(selected:Boolean):void{
			if(multiSelection){
				var i:int;
				if(selected){
					selectedItems=[];
					for (i = 0; i < db.length; i++) {
						checkSpace[i].selected=true;
						addChildAt(highLightSpace[i],0);
						selectedItems.push(db[i]);
					};
					
				}else{
					for (i = 0; i < db.length; i++) {
						if(checkSpace[i]!=null&&contains(highLightSpace[i])){
							checkSpace[i].selected=false;
							removeChild(highLightSpace[i]);
						}
					};
					selectedItems=[];
				}
			}
		}
		protected function focus_evt(e):void{
			// TODO Auto Generated method stub
			currentR=int((e.target.tabIndex-1)/cl.length);
			
			if(editable){
				focusRect.setItem(e.currentTarget);
			}
			
			setSelection(currentR);
			
			if(e.type==MouseEvent.DOUBLE_CLICK){
				dispatchEvent(new Event("TableDoubleClicked"));
			}else{
				dispatchEvent(new Event("TableClicked"));
			}
		}
		
		
		protected function setSelection(n:int):void{
			
			_selectedIndex=n;
			
			currentR=n;
			
			if(n!=-1){
				selectedItem=db[n];
				
				rowHit.visible=true;
				rowHit.y=rowY[n];
				rowHit.height=rowHeight[n];
				rowHit.width=contentWidth
				
				if(editable){
					
					min.visible=true;
					
					min.x=contentWidth+min.width/2+2;
					min.y=rowY[n]+rowHeight[n]/2+2;
				}
			}else{
				selectedItem=null;
				rowHit.visible=false;
			}
		}
		protected function hit_evt(e):void{
			// TODO Auto Generated method stub
			hit_R=int((e.target.tabIndex-1)/cl.length);
			
			moveHit.visible=true;
			moveHit.y=rowY[hit_R];
			moveHit.height=rowHeight[hit_R];
			moveHit.width=contentWidth;
		}

		
		public function sortOnColumn(n:int):void{
			if(sortcol!=n){
				sortdirct=true;
				sortcol=n;
			}else{
				sortdirct=!sortdirct;
			}
			if(db.length>0&&!isNaN(db[0][cl[n]])){
				if(sortdirct){
					db=db.sortOn(cl[n],Array.NUMERIC|Array.DESCENDING);
				}else{
					db=db.sortOn(cl[n],Array.NUMERIC);
				}
			}else{
				if(sortdirct){
					db=db.sortOn(cl[n]);
				}else{
					db=db.sortOn(cl[n],Array.DESCENDING);
				}
			}
			dataProvider=db;
		}
	}
}