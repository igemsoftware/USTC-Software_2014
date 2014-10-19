package kShortest
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Dock.NodePreviewer;
	
	import GUI.RichUI.RichButton;
	import GUI.Windows.WindowSpace;
	
	import IEvent.FocusItemEvent;
	
	import Layout.GlobalLayoutManager;
	
	import Style.Tween;

	public class KShortest extends Sprite
	{
		public var searchbn:RichButton=new RichButton(0,60,30);
		public function KShortest()
		{
			
			/*<object_id> means the id of objective data.   you can replace string like '54abd652987a55fee' to <object_id>
				the format is [ [<object_id>,<object_id>,<object_id>,.....], [<object_id>,<object_id>,....], .....]
				is a list of list of object_id, each list inside is a path, more front,more short */
			base.graphics.beginFill(0xffffff,0.6);
			base.graphics.drawRect(0,0,800,600);
			base.graphics.endFill();
			addChild(base);
			
			addChild(searchbn)
			searchbn.label="Search";
			searchbn.x=155;
			searchbn.y=9;
			searchbn.setSize(60,30);
			searchbn.addEventListener(MouseEvent.CLICK,post);
		}
		private var base:Shape=new Shape();
		public function setSize(w:Number,h:Number):void{
			
			base.graphics.beginFill(0xffffff,0.6);
			base.graphics.drawRect(0,0,800,600);
			base.graphics.endFill();
			addChild(base);
		}
		
		protected function post(event:MouseEvent):void
		{
			var handle:String=GlobalVaribles.SEQUENCE_ADDRESS;
			var searchRequest:URLRequest=new URLRequest(handle);
			
			var postvar:URLVariables=new URLVariables();
			
			
			
			postvar.id1="54315b8cfc368962020918b6";//R00006
			postvar.id2="54315b78fc36896202090504";//R00014
			
			searchRequest.method="post";
			searchRequest.data=postvar;
			
			var Loader:URLLoader=new URLLoader(searchRequest);
			
			Loader.addEventListener(Event.COMPLETE,shownode);
		}
		
		protected function shownode(e:Event):void{
			var id:String;
			id=e.target.data;
			trace(id)
			id='{"result":'+id.split("\'").join("\"")+"}";
			var result=JSON.parse(id);
			trace(result)
			
			
			
		}
		private function webSearch(ID:String):void{
			
			var handle:String=GlobalVaribles.SEARCH_INTERFACE;
			var searchRequest:URLRequest=new URLRequest(handle);
			var postvar:URLVariables=new URLVariables();
			var Loader:URLLoader=new URLLoader(searchRequest);
			postvar.spec='{"_id":"'+ID+'"}';
			//postvar.fields='{}';
			postvar.format="xml"
			
			searchRequest.method="post";
			searchRequest.data=postvar;
			
			Loader=new URLLoader(searchRequest);
			
			Loader.addEventListener(Event.COMPLETE,Loader_CMP,false,0,true)
		}
		protected function Loader_CMP(event:Event):void
		{
			
			trace(event.target.data);
			
			var xml:XML=new XML(String(event.target.data));
			trace(xml.result.NAME)
			
			//searchResult=res;
			var preview:NodePreviewer=new NodePreviewer();
			if (GxmlContainer.Block_space[xml.result._id]==null) {
				preview.GiveNode(xml.result._id,xml.result.NAME,xml.result.TYPE);
				
				var locPoint:Point=new Point();
				locPoint.y=100;
				locPoint.x=-preview.W-2;
				var absPoint:Point=localToGlobal(locPoint);
				preview.aimX=absPoint.x;
				if (absPoint.y+preview.height>GlobalLayoutManager.StageHeight-10) {
					absPoint.y=GlobalLayoutManager.StageHeight-preview.height-10;
				}
				preview.y=absPoint.y;
				
				if (!WindowSpace.contains(preview)) {
					WindowSpace.addWindow(preview);
					Tween.floatLeft(preview);
				}
			}else{
				
				GlobalVaribles.eventDispatcher.dispatchEvent(new FocusItemEvent(FocusItemEvent.CENTERLIZE,GxmlContainer.Block_space[xml.result._id]))
			}
		}
	}
}