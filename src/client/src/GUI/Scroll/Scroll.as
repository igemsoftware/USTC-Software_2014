package GUI.Scroll{
	import flash.desktop.IFilePromise;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.core.mx_internal;
	
	import GUI.FlexibleLayoutObject;
	
	
	public class Scroll extends Sprite implements FlexibleLayoutObject{
		public var Content:*;
		public var masker:Shape=new Shape();
		private var RollPosition:int=0;
		public  var Height:Number; 
		private var ScrollBar:scrollBar;
		private var hitTest:Shape=new Shape();
		
		public function Scroll(target=null,w=200,h=200){
			masker.graphics.beginFill(0);
			masker.graphics.drawRect(0,0,10,10);
			
			hitTest.graphics.beginFill(0);
			hitTest.graphics.drawRect(0,0,10,10);
			hitTest.alpha=0;
			
			ScrollBar=new scrollBar(this,h);
			
			addChild(masker);
			
			addChild(ScrollBar);
			addChild(hitTest);
			
			addEventListener(MouseEvent.MOUSE_WHEEL,scrolling);
			
			content=target;
		}
		public function set content(tar):void{
			if (tar==null) {
				this.visible=false;
			}else {
				this.visible=true;
				if (Content!=null) {
					removeChild(Content);
				}
				Content=tar;
				Content.mask=masker;
				addChildAt(Content,getChildIndex(masker));
				addEventListener(Event.ENTER_FRAME,Roll);
				Content.addEventListener("redrawed",negativeRedraw);
			}
		}
		public function negativeRedraw(e=null):void{
			ScrollBar.setSize();
			scrolling();
		}
		public function set rollPosition(r):void{
			RollPosition=r;
			if (Content==null) {
				return;
			}
			removeEventListener(Event.ENTER_FRAME,Roll);
			addEventListener(Event.ENTER_FRAME,Roll);
		}
		public function get rollPosition():Number{
			return RollPosition;
		}
		
		public function rollToButtom():void{
			if (-contentHeight+this.Height<0) {
				rollPosition=-contentHeight+this.Height;
			}else{
				rollPosition=0;
			}
			
		}
		
		
		protected function scrolling(e=null):void{
			var stacked:Boolean=false;
			if (e!=null) {
				rollPosition+=e.delta*20;
			}
			if (rollPosition<-contentHeight+Height) {
				rollPosition=-contentHeight+Height;
				stacked=true;
			}
			
			if (rollPosition>0) {
				rollPosition=0;
				stacked=true;
			}
			if (e!=null&&!stacked) {
				(e as MouseEvent).stopPropagation();
			}
		}
		public function get contentHeight():Number{
			if (Content==null) {
				return 100;
			}
			if (Content.hasOwnProperty("Height")) {
				return Content.Height;
			}else {
				return Content.height;
			}
		}
		protected function Roll(e):void{
			if (Math.abs(rollPosition-Content.y)>0.5) {
				Content.y = (rollPosition + Content.y * 2) / 3;
				ScrollBar.reLocation();
			}else{
				removeEventListener(Event.ENTER_FRAME,Roll);
			}
		}
		
		public function setSize(w:Number,h:Number):void{
			masker.width=w+1;
			masker.height=h;
			hitTest.width=w;
			hitTest.height=h;
			ScrollBar.x=w+1;
			Height=h;
			if (Content!=null) {
				if (Content.constructor==TextField) {
					Content.width=w-5;
				}else if(Content.hasOwnProperty("setSize")){
					Content.setSize(w-5);
				}
			}
			ScrollBar.setSize(h-2);
			scrolling();
		}
	}
}