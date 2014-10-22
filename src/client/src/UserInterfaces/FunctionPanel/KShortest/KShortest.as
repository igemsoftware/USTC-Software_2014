package UserInterfaces.FunctionPanel.KShortest
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	
	import Kernel.Events.FocusItemEvent;
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.Parts.BioNode;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.ReminderManager.ReminderManager;
	import UserInterfaces.Style.FilterPacket;
	import UserInterfaces.Style.Tween;
	
	import fl.events.ListEvent;
	/**
	 * to find the first k shortest way between two nodes
	 */
	public class KShortest extends Sprite
	{
		public var searchbn:RichButton=new RichButton(0,60,30);
		public var resetbn:RichButton=new RichButton(0,60,30);
		public var searchorder:TextInput=new TextInput();
		private var grid:RichGrid=new RichGrid();
		private var data:Array=[];
		private var order_lb:LabelTextField=new LabelTextField("Results Limit:");
		private var label_y:int=10;
		private var input_y:int=30;
		
		private var searchable:Boolean=false;
		private var hitA:HitBox=new HitBox();
		
		private var resPre:LinkWayPreviewer=new LinkWayPreviewer();
		
		//private var 
		
		private static var pre:KShortestNodePreviewer=new KShortestNodePreviewer();
		/**
		 * to find the first k shortest way between two nodes
		 * <object_id> means the id of objective data.   you can replace string like '54abd652987a55fee' to <object_id>
			the format is [ [<object_id>,<object_id>,<object_id>,.....], [<object_id>,<object_id>,....], .....]
			is a list of list of object_id, each list inside is a path, more front,more short 
		 */
		public function KShortest(){
			
			/*<object_id> means the id of objective data.   you can replace string like '54abd652987a55fee' to <object_id>
			the format is [ [<object_id>,<object_id>,<object_id>,.....], [<object_id>,<object_id>,....], .....]
			is a list of list of object_id, each list inside is a path, more front,more short */
			
			searchbn.label="Search";
			searchbn.setSize(100,30);
			
			resetbn.label="Reset";
			resetbn.setSize(100,30);
			
			addChild(hitA);
			addChild(pre);
			addChild(searchbn);
			addChild(searchorder);
			addChild(order_lb);
			addChild(grid);
			addChild(resPre);
			
			searchorder.setSize(50,26);
			searchorder.text="5";
			
			grid.columns=["N","Route"];
			grid.columnWidths=[60,700];
			
			searchbn.addEventListener(MouseEvent.CLICK,post);
			resetbn.addEventListener(MouseEvent.CLICK,function (e):void{
				pre.GiveNode1(null);
				pre.GiveNode2(null);
			});
			grid.addEventListener(ListEvent.ITEM_CLICK,function (e:ListEvent):void{
				resPre.GiveNodes(e.item.Path);
			});
			
			setSize(600,350);
			
			pre.addEventListener("PickNode1",function (e):void{
				ReminderManager.remind("Now Select First Node");
				Tween.smoothLeft(parent);
				toPick=1;
				GlobalVaribles.FocusEventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,GlobalVaribles_Focus_ChangeHandler);
				stage.addEventListener(MouseEvent.RIGHT_CLICK,stage_rightClickHandler);
			});
			
			pre.addEventListener("PickNode2",function (e):void{
				ReminderManager.remind("Now Select Second Node");
				Tween.smoothLeft(parent);
				toPick=2;
				GlobalVaribles.FocusEventDispatcher.addEventListener(FocusItemEvent.FOCUS_CHANGE,GlobalVaribles_Focus_ChangeHandler);
				stage.addEventListener(MouseEvent.RIGHT_CLICK,stage_rightClickHandler);
			});
			
		}
		
		public function setSize(w:Number,h:Number):void{
			
			hitA.setSize(w,h);
			
			grid.setSize(w,h-200);
			
			pre.setSize(w);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w,40,20,searchbn);
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w,75,20,resetbn);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w,5,5,order_lb,searchorder);
			
			grid.y=120;
			
			resPre.y=grid.y+grid.Height+5;
			
			resPre.setSize(w);
			
		}
		
		private var Loader:URLLoader=new URLLoader();
		private var toPick:int=1;
		/**
		 * post input data to back end when mouse click
		 */
		protected function post(event:MouseEvent):void
		{
			grid.dataProvider=[];
			if(pre.node1!=null&&pre.node2!=null){
				searchbn.suspend();
				var handle:String=GlobalVaribles.KSHORT_INTERFACE;
				var searchRequest:URLRequest=new URLRequest(handle);
				
				var postvar:URLVariables=new URLVariables();
				
				postvar.id1=pre.node1.ID;
				postvar.id2=pre.node2.ID;
				postvar.order=searchorder.text;
				
				searchRequest.method=URLRequestMethod.POST;
				searchRequest.data=postvar;
				
				Loader.load(searchRequest);
				
				Loader.addEventListener(Event.COMPLETE,shownode);
				
				Loader.addEventListener(IOErrorEvent.IO_ERROR,function (e):void{
					searchbn.unsuspend();
				});
			}else{
				ReminderManager.remind("You need to select two nodes from project")
			}
		}
		/**
		 * to show node
		 */
		protected function shownode(e:Event):void{
			var id:String;
			id=e.target.data;
			trace(id)
			id='{"results":'+id.split("\'").join("\"")+"}";
			var result:Object=JSON.parse(id).results;
			data=[];
			if(result.length!=0){
				for(var i:int=0;i<result.length;i++){
					var tmp:Object=result[i];
					var str:String;
					for(var j:int=0;j<tmp.length;j++){
						if(j==0)str=tmp[j].NAME+" →";
						else if(j==tmp.length-1) str+=tmp[j].NAME;
						else str+=tmp[j].NAME+" →";
					}
					data.push({N:i+1,Route:str,Path:tmp});
				}
			}
			else{
				data.push({N:"Error",Route:"Route Not Found"});
			}
			
			grid.dataProvider=data;
			
			searchbn.unsuspend();
		}
		/**
		 * to handle the change event
		 */
		protected function GlobalVaribles_Focus_ChangeHandler(event:FocusItemEvent=null):void
		{
			GlobalVaribles.FocusEventDispatcher.removeEventListener(FocusItemEvent.FOCUS_CHANGE,GlobalVaribles_Focus_ChangeHandler);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK,stage_rightClickHandler);
			Loader.removeEventListener(Event.COMPLETE,shownode);
			
			Tween.smoothBack(parent);
			
			searchbn.unsuspend();
			
			if (toPick==2) {
				pre.GiveNode2(event.focusTarget);
			}else{
				pre.GiveNode1(event.focusTarget);
			}
		}
		
		protected function stage_rightClickHandler(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Tween.smoothBack(parent);
			stage.removeEventListener(MouseEvent.RIGHT_CLICK,stage_rightClickHandler);
		}
	}
}