package Ask
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;
	
	import Style.FontPacket;
	import Style.Tween;
	
	public class AskBar extends Sprite
	{
		private const H:int=40;
		
		public var asktext:TextField=new TextField();
		public var ok_b:RichButton=new RichButton(RichButton.LEFT_EDGE);
		public var no_b:RichButton=new RichButton(RichButton.MIDDLE);
		public var cn_b:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		public var roll_y:Number=0;
		
		public function AskBar()
		{
			y=-H-1;
			
			asktext.defaultTextFormat=FontPacket.WhiteContentText;
			asktext.autoSize="left";
			asktext.mouseEnabled=false;
			
			addChild(asktext);
			
			
			
			ok_b.label="Yes"
			no_b.label="No"
			cn_b.label="Cancel"

			LayoutManager.UnifyScale(60,30,ok_b,cn_b,no_b);
			
		}
		
		public function ask(msg,showC):void{
			asktext.text=msg;
			setSize(asktext.width+60*(2+Number(showC))+20,showC);
		}
		
		public function setSize(w:Number,showC):void
		{
			graphics.clear();
			graphics.lineStyle(GlobalVaribles.SKIN_LINE_WIDTH,GlobalVaribles.SKIN_LINE_COLOR,1,true);
			graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			graphics.drawRoundRectComplex(-w/2,0,w,H,0,0,10,10);
			graphics.endFill();
			
			asktext.x=-w/2+5;
			asktext.y=(H-asktext.height)/2;
			
			removeChildren(1);
			
			if(showC){
				no_b.Type=RichButton.MIDDLE;
				no_b.redraw(0);
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w/2-5,5,0,ok_b,no_b,cn_b);
			}else{
				no_b.Type=RichButton.RIGHT_EDGE;
				no_b.redraw(0);
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w/2-5,5,0,ok_b,no_b);
			}
		}
		
		public function show():void{
			roll_y=-1
			Tween.smoothRoll(this);
		}
		
		public function out():void
		{
			roll_y=-H-1;
			Tween.smoothRoll(this);
			
		}
	}
}