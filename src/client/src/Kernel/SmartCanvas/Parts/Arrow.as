package Kernel.SmartCanvas.Parts{

	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import GUI.Assembly.LabelField;
	
	/**
	 * UI base for Biology Link 
	 * including:
	 * 		1.MouseEvent Listener
	 * 		2.KeyBoardEvent Listener
	 * 		3.Label
	 * 		4.Focus
	 * 		5.Redraw
	 */
	public class Arrow extends Sprite{
		
		public const HIGHLIGHT_LINE_COLOR:uint=0xffff00;
		private const HIT_TEST_RANGE:int=8;	
		
		public var title:LabelField;
		
		public var Creator:CompressedLine;
		private var focused:Boolean;
		public var compressed:Boolean=true;
		
		private var downed:Boolean;
		private var Click_tick:int=0;
		
		public function Arrow(){
			title=new LabelField();
			this.cacheAsBitmap=true;
			addChild(title);
			label="Junction";
			title.selectable=false;
			
			addEventListener(MouseEvent.MOUSE_DOWN,focus_evt);
			
			addEventListener(MouseEvent.MOUSE_UP,mouseUp_evt);
			
		}
		
		/**
		 * Event Handler :: When mouse Up on line
		 * This function solve the situation when line is just Wake UP from Compressed Canvas (Mouse is already Down)
		 */
		protected function mouseUp_evt(event:MouseEvent):void {
			if (downed) {
				
				downed=false;
				
				var dt:int=getTimer()-Click_tick;
				Click_tick=getTimer();
				trace(dt);
				if (dt<300) {
					trace("Trans_DoubleClick");
					dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
				}
			}
		}
		
		/**
		 * Setter :: label text
		 */
		public function set label(t:String):void{
			title.text=t;
		}
		
		/**
		 * Event Handler :: Mouse Down
		 */
		protected function focus_evt(event:MouseEvent):void
		{
			downed=true
			dispatchEvent(new Event("ClickOn"));
			setFocus();
			event.stopPropagation();	
		}
		
		/**
		 * Set focus event
		 */
		public function setFocus(ani=false):void{
			focused=true;
			DrawSkin(HIGHLIGHT_LINE_COLOR);
		}
		
		/**
		 * Lose focus event
		 */
		public function loseFocus():void{
			focused=false;
			DrawSkin();
			if(title.selectable){
				lock_text();
			}
			title.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
		}
		
		/**
		 * Edit label text
		 */
		protected function edit_text(event:ContextMenuEvent):void
		{
			Net.setfocus(Creator);
			title.selectable=true;
			title.addEventListener(KeyboardEvent.KEY_UP,key_mon);
		}
		
		/**
		 * lock label text
		 */
		protected function lock_text():void{
			if(Creator.Name!=title.text){
				GxmlContainer.RecordLineDetail(Creator);
			}
			Creator.Name=title.text;
			title.selectable=false;
		}
		
		/**
		 * Key Monitor, for Enter (confirm changing) and Esc (cancel changing)
		 */
		private function key_mon(e:KeyboardEvent):void{
			if (e.keyCode==Keyboard.ENTER) {
				title.selectable=false;
			}
			if (e.keyCode==Keyboard.ESCAPE) {
				title.text=Creator.Name;
				title.selectable=false;
			}
			e.stopPropagation();
		}
		
		/**
		 *Draw skin on UI component
		 */
		public function DrawSkin(c=null):void{
			this.graphics.clear();
			Creator.drawSkin(this.graphics,c);
		}
		
		/**
		 *Redraw Skin, for applying change.
		 */
		public function redraw():void {
			var obj1:* = Creator.linkObject[0];
			var obj2:* = Creator.linkObject[1];
			
			title.text=Creator.Name;
			
			title.x=(obj2.x+obj1.x)/2;
			title.y=(obj2.y+obj1.y)/2;
			
			title.rotationZ=Math.atan((obj2.y-obj1.y)/(obj2.x-obj1.x))/Math.PI*180;
			
			DrawSkin();
		}
	}
}