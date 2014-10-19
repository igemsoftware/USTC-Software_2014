package IgemPartAPI
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Dock.NodePreviewer;
	
	import GUI.FlexibleWidthObject;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	import GUI.Windows.WindowSpace;
	
	import IEvent.FocusItemEvent;
	
	import IvyBoard.FocusReceiver;
	
	import Layout.GlobalLayoutManager;
	
	import Platform.Canvas.GxmlContainer;
	
	import Style.FontPacket;
	import Style.Tween;
	
	
	
	
	public class SequencePanel extends FocusReceiver implements FlexibleWidthObject
	{
		
		public var searchbn:RichButton=new RichButton(0,60,30);
		public var searchtxt:TextField=new TextField;
		public var sequence:TextField=new TextField;
		
		private var visit_bn:RichButton=new RichButton(0,100,30);
		private var post_bn:RichButton=new RichButton(0,60,30);
		
		private var seq_label:TextField=new TextField;
		private var igem:IgemAPI;
		
		private var grid:RichGrid=new RichGrid(false,false,false,false,true);
		private var data:Array=[];
		
		
		public function SequencePanel(){
			
			addChild(searchtxt);
			addChild(searchbn);
			addChild(sequence);
			addChild(seq_label);
			addChild(visit_bn);
			addChild(post_bn);
			
			searchbn.label="Search";
			searchbn.x=155;
			searchbn.y=9;
			searchbn.setSize(60,30);
			
			post_bn.label="Post";
			post_bn.setSize(60,30);
			post_bn.y=150;
			post_bn.x=30;
			
			visit_bn.label="Visit Website";
			visit_bn.x=30;
			visit_bn.y=440;
			visit_bn.setSize(100,30);
			
			grid.columns=["Type","Value"];
			grid.columnWidths=[80,200];
			grid.setSize(240,500);
			grid.x=-5;
			grid.y=180;
			addChild(grid);
			grid.addEventListener("redrawed",function (e):void{
				dispatchEvent(new Event("redrawed"));
			});
			
			searchtxt.type=TextFieldType.INPUT
			searchtxt.defaultTextFormat=FontPacket.ContentText;
			searchtxt.background=true;
			searchtxt.backgroundColor=0xffffff;
			searchtxt.x=5;
			searchtxt.y=10;
			searchtxt.height=30;
			searchtxt.width=150;
			searchtxt.text="BBa_B0034";
			
			
			seq_label.text="Input Sequence";

			seq_label.width=100;
			seq_label.textColor=0xffffff;
			seq_label.selectable=false;
			seq_label.x=5;
			seq_label.y=50;
			seq_label.height=20;
			
			
			sequence.defaultTextFormat=FontPacket.SmallContentText;
			sequence.type=TextFieldType.INPUT
			sequence.background=true;
			sequence.multiline=true;
			sequence.wordWrap=true;
			sequence.backgroundColor=0xffffff;
			sequence.x=5;
			sequence.y=70;
			sequence.height=80;
			sequence.width=200;
			
			searchbn.addEventListener(MouseEvent.CLICK,search);
			visit_bn.addEventListener(MouseEvent.CLICK,visit);
			post_bn.addEventListener(MouseEvent.CLICK,post);
			
		}
		
		protected function post(event:MouseEvent):void
		{
			var handle:String=GlobalVaribles.SEQUENCE_ADDRESS;
			var searchRequest:URLRequest=new URLRequest(handle);
			
			var postvar:URLVariables=new URLVariables();
			
			
			
			postvar.sequence=sequence.text;
			
			postvar.user="beibei";
			
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
			if(result.result.length!=0){
				for(var i=0;i<result.result.length;i++){
				webSearch(result.result[i].id);
				}
			}
			else{
				sequence.text="Sequence Not Found";
			}
			
			
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
		protected function visit(event:MouseEvent):void
		{
			var urlreq:URLRequest=new URLRequest(igem.part_url)
			navigateToURL(urlreq,"_self");
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

		protected function search(event:MouseEvent):void
		{
			var str:String=searchtxt.text;
			if(igem==null){
				igem=new IgemAPI(str);
			}
			else{
				igem.search(str);
			}
			igem.addEventListener(Event.COMPLETE,push);
		}
			
			
		
		protected function push(event:Event):void
		{
			sequence.text=igem.part_sequence;
			data=[];
			data.push({Type:"id",Value:igem.part_id});
			data.push({Type:"name",Value:igem.part_name});
			data.push({Type:"type",Value:igem.part_type});
			data.push({Type:"describe",Value:igem.part_desc});
			data.push({Type:"sequence",Value:igem.part_sequence});
			data.push({Type:"url",Value:igem.part_url});
			data.push({Type:"twins",Value:igem.part_twins});
			data.push({Type:"categories",Value:igem.categories});
			grid.dataProvider=data;
		}
	
		
		public function setSize(w:Number):void{
	
		}
	}
}
	

