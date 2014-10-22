package UserInterfaces.ReminderManager
{

	import flash.display.Sprite;
	import flash.events.Event;
	
	import UserInterfaces.Style.Tween;

	public class ReminderManager
	{
		
		public static var ReminderSpace:Sprite=new Sprite();
		private static var ReminderList:Array=[];
		
		
		public function ReminderManager()
		{
			
		}
		/**
		 * remind message
		 * @param msg message
		 */
		public static function remind(msg):void{
			var rem:Reminder=new Reminder(msg);
			
			rem.x=-rem.width/2;
			
			ReminderList.push(rem);
			
			rem.y=-ReminderList.length*30;
			
			rem.aimAlpha=1;
			
			ReminderSpace.addChild(rem);
			
			rem.addEventListener("ease",function (e):void{
				ReminderList.splice(ReminderList.indexOf(e.target),1);
				Tween.fadeOut(e.target);
				rollRems();
			});
			
			rem.addEventListener("destory",function (e):void{
				ReminderSpace.removeChild(e.target);
			});
			
			rollRems();
		}
		
		/**
		 * to roll reminder list
		 */
		private static function rollRems():void
		{
			for (var i:int = 0; i < ReminderList.length; i++) 
			{
				ReminderList[i].aimY=-i*30;
			}
			if(!ReminderSpace.hasEventListener(Event.ENTER_FRAME)){
				ReminderSpace.addEventListener(Event.ENTER_FRAME,TweenRolling);
			}
		}
		/**
		 * tween the rolling
		 */
		private static function TweenRolling(e):void{
			for (var i:int = 0; i < ReminderList.length; i++)
			{
				ReminderList[i].y=(ReminderList[i].y*5+ReminderList[i].aimY)/6;
				ReminderList[i].alpha=(ReminderList[i].alpha*3+ReminderList[i].aimAlpha)/4;
			}
			if(ReminderList.length==0||Math.abs(ReminderList[ReminderList.length-1].y-ReminderList[ReminderList.length-1].aimY)<1){
				ReminderSpace.removeEventListener(Event.ENTER_FRAME,TweenRolling)
			}
		}
		
	}
}