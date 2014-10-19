package GUI.RadioButton
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Style.FilterPacket;
	
	public class GlowRadioIcon extends Sprite
	{
		
		private var icon:Sprite;
		public var Group:RadioGroup;
		public var Circle:Shape=new Shape();
		private var Selected:Boolean;
		private var hitArea:Sprite=new Sprite();
		
		
		public function GlowRadioIcon(url,group:RadioGroup,circle=true){
			
			Icon=url;
			
			hitArea.graphics.beginFill(0,0);
			hitArea.graphics.drawCircle(0,0,28);
			hitArea.graphics.endFill();
			
			if (circle) {
				Circle.graphics.lineStyle(1,0xffffff,1);
				Circle.graphics.drawCircle(0,0,28);
			}
			
			addChild(icon);
			addChild(Circle);
			addChild(hitArea);
			Group=group;
			
			addEventListener(MouseEvent.MOUSE_OVER,MouseIn_evt);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut_evt);
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown_evt);
			addEventListener(MouseEvent.MOUSE_UP,MouseUp_evt);
		}
		
		public function loseSelection():void{
			this.filters=[];
		}
		private function setSelection():void{
			this.filters=[FilterPacket.HighLightGlow];
		}
		
		public function set selected(s):void{
			Selected=s;
			if (s) {
				setSelection();
				Group.setSelection(this);
			}else {
				loseSelection();
			}
		}
		public function get selected():Boolean{
			return Selected;
		}
		protected function MouseUp_evt(event:MouseEvent):void{
		
		}
		
		protected function MouseDown_evt(event:MouseEvent):void{
			selected=true;
		}
		
		protected function MouseOut_evt(event:MouseEvent):void{
			
		}
		
		protected function MouseIn_evt(event:MouseEvent):void{
			
		}
		
		public function set Icon(url):void{
			icon=new url();
		}
	}
}