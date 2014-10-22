package UserInterfaces.IvyBoard
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import GUI.RadioButton.GlowRadioIcon;
	import GUI.RadioButton.RadioGroup;
	
	import UserInterfaces.Style.AniContainer;
	import UserInterfaces.Style.Tween;

	/**
	 * this is a banner that countains the buttons
	 */
	public class IvyBanner extends Sprite
	{
		
		private var RGroup:RadioGroup=new RadioGroup();
		public var Icon_Add:GlowRadioIcon=new GlowRadioIcon(Icon_add,RGroup);
		public var Icon_Connect:GlowRadioIcon=new GlowRadioIcon(Icon_Linkage,RGroup);
		public var Icon_Edit:GlowRadioIcon=new GlowRadioIcon(Icon_edit,RGroup);
		public var Icon_Inf:GlowRadioIcon=new GlowRadioIcon(Icon_info,RGroup);
		
		private var Banner_back:AniContainer=new AniContainer();
		public var panel:String;
		
		public function IvyBanner()
		{
			addChild(Banner_back);
			addChild(Icon_Add);
			addChild(Icon_Inf);
			addChild(Icon_Connect);
			addChild(Icon_Edit);
			Icon_Connect.y=Icon_Add.y=Icon_Inf.y=Icon_Edit.y=29;
			
			var align:int=5;
			
			Icon_Add.x=30+align
			Icon_Connect.x=93+align
			Icon_Edit.x=156+align
			Icon_Inf.x=219+align
			
			Icon_Add.addEventListener(MouseEvent.CLICK,function (e):void{
				panel="Add";
				dispatchEvent(new Event(Event.CHANGE));
			})
			
			Icon_Edit.addEventListener(MouseEvent.CLICK,function (e):void{
				panel="Edit";
				dispatchEvent(new Event(Event.CHANGE));
			})
			Icon_Connect.addEventListener(MouseEvent.CLICK,function (e):void{
				panel="Connect";
				dispatchEvent(new Event(Event.CHANGE));
			})
			Icon_Inf.addEventListener(MouseEvent.CLICK,function (e):void{
				panel="Info";
				dispatchEvent(new Event(Event.CHANGE));
			})
			Banner_back.y=-51;
		}
		
		public function clearSeletion():void{
			RGroup.clearSelection();
		}
		public function setSelection(m):void{
			RGroup.setSelection(m)
		}
		
		public function redraw(w):void{
			Banner_back.graphics.clear();
			Banner_back.graphics.lineStyle(GlobalVaribles.SKIN_LINE_WIDTH,GlobalVaribles.SKIN_LINE_COLOR,1,true);
			Banner_back.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			Banner_back.graphics.drawRect(0,0,w+5,50);
			Banner_back.graphics.endFill();
		}
		public function set show(s:Boolean):void{
			if (s) {
				Banner_back.aimY=0;
				Tween.SlideY(Banner_back);
				Tween.fadeOut(Icon_Inf.Circle);
				Tween.fadeOut(Icon_Edit.Circle);
				Tween.fadeOut(Icon_Add.Circle);
				Tween.fadeOut(Icon_Connect.Circle);
			}else {
				Banner_back.aimY=-52;
				Tween.SlideY(Banner_back);
				Tween.smoothIn(Icon_Inf.Circle);
				Tween.smoothIn(Icon_Edit.Circle);
				Tween.smoothIn(Icon_Add.Circle);
				Tween.smoothIn(Icon_Connect.Circle);
			}
		}
	}
}