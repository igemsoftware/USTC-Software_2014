package GUI.Assembly
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import UserInterfaces.Style.FilterPacket;
	import UserInterfaces.Style.FontPacket;
	import UserInterfaces.Style.Tween;
	

	public class IconButton extends Sprite{
		
		private var icon:*;
		private var label0:TextField=new TextField();
		private var hitA:Shape=new Shape();
		
		public function IconButton(url,Label){
			
			label0.defaultTextFormat=FontPacket.HintText;
			label0.autoSize="left";
			label0.selectable=false;
			
			label0.filters=[FilterPacket.TextGlow];
			
			
			label=Label;
			
			Icon=url;
			label0.visible=false;
			
			
			addChild(label0);
			addChild(hitA);
			
			addEventListener(MouseEvent.MOUSE_OVER,MouseIn_evt);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut_evt);
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown_evt);
			addEventListener(MouseEvent.MOUSE_UP,MouseUp_evt);
		}
		
		protected function MouseUp_evt(event:MouseEvent):void{
			Tween.zoomUp(icon);
		}
		
		protected function MouseDown_evt(event:MouseEvent):void{
			Tween.zoomDownSmall(icon);
		}
		
		protected function MouseOut_evt(event:MouseEvent):void{
			label0.visible=false;
			Tween.zoomDown(icon);
		}
		
		protected function MouseIn_evt(event:MouseEvent):void{
			label0.visible=true;
			Tween.zoomUp(icon);
		}
		
		public function set Icon(url):void{
			if(icon!=null){
				removeChild(icon);
			}
			icon=new url();
			icon.mouseEnabled=false;
			icon.scaleX=icon.scaleY=0.7;
			icon.alpha=0.8
				
			icon.filters=[FilterPacket.TextGlow];
			label0.y=-55;
			label0.x=-label0.width/2
			hitA.graphics.clear();
			hitA.graphics.beginFill(0,0);
			hitA.graphics.drawRect(-icon.width/2-2,-icon.height/2-2,icon.width+4,icon.height+4);
			hitA.graphics.endFill();
			addChild(icon);
		}
		public function set label(Label):void{
			label0.text=Label;
			label0.x=-label0.width/2
		}
	}
}