package IvyBoard
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import IEvent.FocusItemEvent;
	
	public class FocusReceiver extends Sprite
	{
		public function FocusReceiver()
		{
			addEventListener(Event.ADDED_TO_STAGE,function (e):void{
				if (GlobalVaribles.FocusedTarget!=null) {
					showData(GlobalVaribles.FocusedTarget);
					alpha=1;
					mouseEnabled=true;
				}else{
					alpha=0.5;
					mouseEnabled=false;
				}
				GlobalVaribles.eventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,function (e:FocusItemEvent):void{
					if (e.focusTarget!=null) {
						showData(e.focusTarget);
						alpha=1;
						mouseEnabled=true;
					}else{
						alpha=0.5;
						mouseEnabled=false;
					}
				});
			})
		}
		protected function showData(tar:*):void{
			
		}
	}
}