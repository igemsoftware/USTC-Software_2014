package Assembly.BioParts{

	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import GUI.Assembly.LabelField;
	
	import Assembly.ProjectHolder.GxmlContainer;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.IFocusableObject;
	
	public class Arrow extends Sprite implements IFocusableObject{
		public const LINE_COLOR:uint=0xffffff;
		public const HIGHLIGHT_LINE_COLOR:uint=0xffff00;
		public const DIM_LINE_COLOR:uint=0xffffff;
		public const ARROW_COLOR:uint=0xffff99;
		public const LINE_WIDTH:int=2;
		private const HIT_TEST_RANGE:int=8;	
		
		public var title:LabelField;
		public var type:String="Junction";
		
		public var Creator:CompressedLine;
		private var focused:Boolean;
		public var compressed:Boolean=true;
		
		public function Arrow(){
			title=new LabelField();
			this.cacheAsBitmap=true;
			addChild(title);
			label="Junction";
			title.selectable=false;
			
			addEventListener(MouseEvent.MOUSE_DOWN,focus_evt);
			
		}
		public function set label(t:String):void{
			title.text=t;
		}
		
		public function destroy(e=null):void{
			dispatchEvent(new Event("destroy"));
		}
		
		protected function focus_evt(event:MouseEvent):void
		{
			dispatchEvent(new Event("ClickOn"));
			setFocus();
			event.stopPropagation();	
		}
		public function setFocus():void{
			focused=true;
			DrawSkin(HIGHLIGHT_LINE_COLOR);
		}
		
		public function loseFocus():void{
			focused=false;
			DrawSkin();
			if(title.selectable){
				lock_text();
			}
			title.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
		}
		
		
		protected function edit_text(event:ContextMenuEvent):void
		{
			Net.setfocus(Creator);
			title.selectable=true;
			title.addEventListener(KeyboardEvent.KEY_UP,key_mon);
		}
		
		protected function lock_text():void{
			if(Creator.Name!=title.text){
				GxmlContainer.RecordLineDetail(Creator);
			}
			Creator.Name=title.text;
			title.selectable=false;
		}
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
		
		
		public function DrawSkin(c=null):void{
			this.graphics.clear();
			Creator.drawSkin(this.graphics,c);
		}
		
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