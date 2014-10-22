package UserInterfaces.IvyBoard
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import GUI.Scroll.Scroll;
	
	import UserInterfaces.Style.FontPacket;
	
	public class IvyBoard extends Sprite
	{
		public var Height:Number;
		public var Width:Number;
		public var aimX:Number,aimY:Number;
		public var scroll:Scroll=new Scroll();
		
		public var title:TextField=new TextField();
		
		public function IvyBoard(){
			addChild(title);
			title.autoSize=TextFieldAutoSize.CENTER;
			title.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			title.mouseEnabled=false;
			scroll.x=5;
			scroll.y=29;
			addChild(scroll);
		}
		
		public function loadPanel(pane,label):void{
			scroll.content=pane;
			title.text=label;
			redraw();
			
		}
		
		/*public function loadMultiPanels(arr:Array,label):void{
		scroll.content=InspectorLoader.fetch(arr);
		title.text=label;
		redraw();
		}*/
		
		public function switchPanel(tar):void{
			
		}
		
		public function redraw(w=0,h=0):void{
			
			
			if(w==0){
				w=Width;
				h=Height;
			}else{
				
				Width=w;
				Height=h;
				
			}
			
			scroll.setSize(Width-10,Height-30);
			title.x=0;
			title.width=Width;
			graphics.clear();
			graphics.lineStyle(GlobalVaribles.SKIN_LINE_WIDTH,GlobalVaribles.SKIN_LINE_COLOR,1,true);
			graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			graphics.drawRect(0,0,w+5,h);
			graphics.endFill();
			graphics.moveTo(5,27);
			graphics.lineTo(w-5,27);
			
		}
	}
}