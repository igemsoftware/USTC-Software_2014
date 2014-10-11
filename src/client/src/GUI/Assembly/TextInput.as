package GUI.Assembly{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import GUI.FlexibleLayoutObject;
	import GUI.Scroll.Scroll;
	
	import Style.FontPacket;
	
	
	
	public class TextInput extends Sprite implements FlexibleLayoutObject{
		
		private var _textf:TextField=new TextField();
		private var back:Shape=new Shape();
		
		public var Width:Number=100,Height:Number=26;
		
		private var searcher:Boolean=false;
		
		private var n:Icon_Search_small;
		
		private var scroll:Scroll;
		
		private var hintTF:TextField;
		
		public function TextInput(searchBar=false,multiLines:Boolean=false,disabled=false)
		{
			searcher=searchBar;
			
			_textf.restrict="\u0020-~";
			
			_textf.multiline=multiLines;
			
			_textf.defaultTextFormat=FontPacket.ContentText;
			
			_textf.height=26;

			disabled?_textf.type=TextFieldType.DYNAMIC:_textf.type=TextFieldType.INPUT;
			
			addChild(back);
			
			if(multiLines){
				
				_textf.wordWrap=true;
				
				scroll=new Scroll(_textf);
				
				addChild(scroll);
				
				_textf.addEventListener(Event.CHANGE,function (e):void{
					_textf.height=_textf.textHeight+5;
					_textf.dispatchEvent(new Event("redrawed"));
					_textf_keyDownHandler();
				});
				_textf.addEventListener(KeyboardEvent.KEY_DOWN,_textf_keyDownHandler);
				_textf.addEventListener(KeyboardEvent.KEY_UP,_textf_keyDownHandler);
				
			}else{
				
				addChild(_textf);
				_textf.addEventListener(KeyboardEvent.KEY_DOWN,Enter_mon);
			}
			
			if(searchBar){
				n=new Icon_Search_small();
				n.mouseEnabled=false;
				addChild(n);
			}
			
			_textf.addEventListener("change",function (e):void{
				dispatchEvent(new Event("change"));
			});
			
			_textf.addEventListener(FocusEvent.FOCUS_OUT,function (e):void{
				back.graphics.clear();
				back.graphics.lineStyle(0,0,0.3);
				back.graphics.beginFill(0xffffff,0.8);
				back.graphics.drawRect(0,0,Width,Height);
				back.graphics.endFill();
				
				if(hintTF!=null && _textf.length==0){
					hintTF.visible=true;
				}
				
			});
			
			_textf.addEventListener(FocusEvent.FOCUS_IN,function (e):void{
				back.graphics.clear();
				back.graphics.lineStyle(0,0,0.3);
				back.graphics.beginFill(0xffffff,1);
				back.graphics.drawRect(0,0,Width,Height);
				back.graphics.endFill();
				
				if(hintTF!=null){
					hintTF.visible=false;
				}
			});
			
			addEventListener(FocusEvent.FOCUS_IN,function (e):void{
				stage.focus=_textf;
			});
			
		}
		
		protected function Enter_mon(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.ENTER){
				dispatchEvent(new Event("Enter"))
			}
		}
		
		public function set hintText(s:String):void{
			if(hintTF==null){
				hintTF=new TextField();
				hintTF.x=2;
				hintTF.defaultTextFormat=FontPacket.LabelHintText;
				hintTF.mouseEnabled=false;
				hintTF.autoSize="left";
				addChild(hintTF);
			}
			hintTF.text=s;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			
			if(scroll!=null){
				_textf.width=w;
				_textf.height=Math.max(_textf.textHeight+5,h);
				scroll.setSize(w,h);
				
			}else{
				_textf.width=int(w);
				_textf.height=int(h);
			}
			
			Width=w;
			Height=h;

			back.graphics.clear();
			back.graphics.lineStyle(0,0,0.3);
			back.graphics.beginFill(0xffffff,0.8);
			back.graphics.drawRect(0,0,w,h);
			back.graphics.endFill();
			
			if(searcher){
				n.x=w-12;
				n.y=h/2;
			}
		}
		
		public function get text():String{
			return _textf.text;
		}
		
		public function set text(s:String):void{
			_textf.text=s;
		}
		
		public function get textHeight():Number{
			return _textf.textHeight;
		}
		
		protected function _textf_keyDownHandler(event:KeyboardEvent=null):void
		{
			// TODO Auto-generated method stub
			var pos:int=_textf.getLineIndexOfChar(_textf.caretIndex-1);
			
			trace(_textf.caretIndex,pos);
			
			if(pos<0)pos=0;
			
			if(pos*22<-scroll.rollPosition){
				scroll.rollPosition=-pos*22;
			}
			if((pos+1)*22>-scroll.rollPosition+Height){
				scroll.rollPosition=-(pos+1)*22+Height;
			}
		}
		
	}
}