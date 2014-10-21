package UserInterfaces.AskManager
{
	import flash.events.MouseEvent;

	public class AskManager
	{
		public static var askbar:AskBar=new AskBar();
		
		public static var respose:Function;
		public static var respose_n:Function;
		
		public function AskManager()
		{
		}
		
		public static function ask(msg:String,res:Function,res_n:Function,showCancel=true):void{
			askbar.ask(msg,showCancel);
			respose=res;
			respose_n=res_n
				
			if(!askbar.ok_b.hasEventListener(MouseEvent.CLICK)){
				askbar.ok_b.addEventListener(MouseEvent.CLICK,resposer);
			}
			if(!askbar.no_b.hasEventListener(MouseEvent.CLICK)){
				askbar.no_b.addEventListener(MouseEvent.CLICK,no_ask);
			}
			if(!askbar.cn_b.hasEventListener(MouseEvent.CLICK)){
				askbar.cn_b.addEventListener(MouseEvent.CLICK,can_ask);
			}
			askbar.show();
		}
		
		protected static function no_ask(event:MouseEvent):void
		{
			askbar.no_b.removeEventListener(MouseEvent.CLICK,respose_n);
			askbar.ok_b.removeEventListener(MouseEvent.CLICK,resposer);
			respose_n();
			askbar.out();
		}
		
		protected static function can_ask(event:MouseEvent):void
		{
			askbar.ok_b.removeEventListener(MouseEvent.CLICK,resposer);
			askbar.no_b.removeEventListener(MouseEvent.CLICK,respose_n);
			askbar.out();
		}
		
		protected static function resposer(event:MouseEvent):void
		{
			askbar.ok_b.removeEventListener(MouseEvent.CLICK,resposer);
			askbar.ok_b.removeEventListener(MouseEvent.CLICK,resposer);
			respose();
			askbar.out();
		}
	}
}