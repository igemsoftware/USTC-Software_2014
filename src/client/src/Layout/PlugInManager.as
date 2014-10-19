package Layout
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class PlugInManager extends GlobalLayoutManager{
		
		public var pluginList:Array=[];
		public var RequestList:Array=[];
		
		public function PlugInManager(){
		//	loadPlugIn("plugin.swf");
		}
		public function loadPlugIn(url):void{
			pluginList[pluginList.length]=new Loader();
			var path:Loader=pluginList[pluginList.length-1];
			path.load(new URLRequest(url));
			path.contentLoaderInfo.addEventListener(Event.COMPLETE,cmp_evt);
		}
		
		protected function cmp_evt(event:Event):void{
			event.target.content.addEventListener("PlugInRequest",function():void{dealRequest(event.target.content)});
			addChild(pluginList[0]);
		}
		protected function dealRequest(tar):void{
			RequestList=tar.RequestList;
			if(RequestList[0]=="focusedBlock"){
				tar.receiveList=[TheNet.focusedItem];
			}else if(RequestList[0]=="centerlize"){
				TheNet.centerlize(RequestList[1]);
			}
		}
	}
}