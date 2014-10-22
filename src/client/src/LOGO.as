package{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	public class LOGO {
		
		private var ticks:uint=0;
		private var win:NativeWindow;
		
		public function LOGO()
		{
			var logo:Logo=new Logo();
			var winopt:NativeWindowInitOptions=new NativeWindowInitOptions()
			winopt.renderMode=NativeWindowRenderMode.GPU;	
			winopt.transparent=true;
			winopt.systemChrome=NativeWindowSystemChrome.NONE;
			
			win=new NativeWindow(winopt);
			win.activate();
			
			win.width=logo.width+100;
			win.height=logo.height+100;
			
			win.x=(Capabilities.screenResolutionX-win.width)/2;
			win.y=(Capabilities.screenResolutionY-win.height)/2+50;
			
			win.alwaysInFront=true;
			win.stage.scaleMode=StageScaleMode.NO_SCALE;
			win.stage.align=StageAlign.TOP_LEFT;
			
			win.stage.addChild(logo);
			
			win.stage.addEventListener(Event.ENTER_FRAME,tick_evt);
		}
		
		protected function tick_evt(event:Event):void{
			ticks++;
			if (ticks>36) {
				win.stage.removeEventListener(Event.ENTER_FRAME,tick_evt);
				win.close();
			}
		}
	}
}