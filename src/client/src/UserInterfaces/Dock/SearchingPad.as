package UserInterfaces.Dock
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import GUI.RadioButton.GlowRadioIcon;
	import GUI.RadioButton.RadioGroup;
	import GUI.RichGrid.RichList;
	import GUI.Windows.WindowSpace;
	
	import Kernel.ProjectHolder.GxmlContainer;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	import UserInterfaces.Style.FontPacket;
	import UserInterfaces.Style.Tween;
	
	import fl.controls.List;
	import fl.events.ListEvent;
	/**
	 * the searching pad panel
	 */
	public class SearchingPad extends Sprite{
		
		public var SearchText:TextField=new TextField();
		public var SearchHint:TextField=new TextField();
		public var ResultHint:TextField=new TextField();
		
		public static var webIndecator:Icon_Web_ind=new Icon_Web_ind();
		public var SeachResult:List=new List();
		private var RedBox:Shape=new Shape();
		private var Box:Shape=new Shape();
		private var Box2:Shape=new Shape();
		private var list:RichList=new RichList();
		
		private var RGroup:RadioGroup=new RadioGroup();
		private var search_b:GlowRadioIcon=new GlowRadioIcon(Icon_Search,RGroup,false);
		private var web_b:GlowRadioIcon=new GlowRadioIcon(Icon_Web,RGroup,false);
		
		public var Width:Number;
		public var Height:Number;
		
		private var mode:Boolean=false;
		
		private var preview:NodePreviewer=new NodePreviewer();
		
		private var Loader:URLLoader=new URLLoader();;
		
		public function SearchingPad(){
			SearchText.type=TextFieldType.INPUT
			SearchText.defaultTextFormat=FontPacket.ContentText;
			SearchText.restrict="\u0020-~"
			SearchText.tabEnabled=false;
			
			SearchHint.defaultTextFormat=FontPacket.LabelHintText;
			SearchHint.text="Search Node"
			SearchHint.mouseEnabled=false;
			SearchHint.selectable=false;
			SearchHint.autoSize="left";
			
			ResultHint.defaultTextFormat=FontPacket.WhiteContentText;
			ResultHint.text="Search this Project";
			ResultHint.mouseEnabled=false;
			ResultHint.selectable=false;
			ResultHint.autoSize="left";
			
			webIndecator.visible=false;
			
			addChild(Box);
			addChild(search_b);
			addChild(web_b);
			addChild(ResultHint);
			addChild(list);
			addChild(Box2);
			addChild(SearchHint);
			addChild(webIndecator);
			addChild(SearchText);
			
			Box2.alpha=0.9;
			
			ResultHint.visible=search_b.visible=web_b.visible=list.visible=false;
			ResultHint.alpha=search_b.alpha=web_b.alpha=list.alpha=0;
			
			list.x=5;
			
			search_b.selected=true;
			search_b.addEventListener(MouseEvent.CLICK,function (e):void{chgMode(false)});
			web_b.addEventListener(MouseEvent.CLICK,function (e):void{chgMode(true)});
			
			SearchText.addEventListener(Event.CHANGE,chg_evt);
			list.addEventListener(ListEvent.ITEM_CLICK,choose_evt);
			
			addEventListener(MouseEvent.MOUSE_DOWN,setFocus);
			
		}
		/**
		 * set focus to when clicking the mouse
		 */
		public function setFocus(event:MouseEvent=null):void{
			
			if(!focused){
				focused=true
				
				Tween.smoothIn(list);
				Tween.smoothIn(search_b);
				Tween.smoothIn(web_b);
				Tween.smoothIn(ResultHint);
				stage.focus=SearchText;
				flushList();
				stage.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
				stage.addEventListener(KeyboardEvent.KEY_UP,key_mon);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,checkFocus);
				hided=false;
				Box2.alpha=1;
				dispatchEvent(new Event("FocusIn"));
			}
		}
		/**
		 * hide the searching box
		 */
		private function hideBox():void{
			if (focused) {
				Tween.fadeOut(list);
				Tween.fadeOut(search_b);
				Tween.fadeOut(web_b);
				Tween.fadeOut(ResultHint);
				preview.dispatchEvent(new Event("close"));
				TweenHeight(0);
				
				stage.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,checkFocus);
				hided=true;
				focused=false;
				Box2.alpha=0.9;
				dispatchEvent(new Event("FocusOut"));
			}
		}
		/**
		 * set key mode
		 */
		protected function key_mon(event:KeyboardEvent):void
		{
			trace(event.keyCode);
			if(event.keyCode==Keyboard.TAB){
				search_b.selected=mode;
				web_b.selected=!mode;
				chgMode(!mode);
				stage.focus=SearchText;
				event.stopPropagation();
			}
		}
		/**
		 * check the focus
		 */
		protected function checkFocus(event:MouseEvent):void
		{
			if (!this.hitTestPoint(stage.mouseX,stage.mouseY)) {
				hideBox();
			}
		}
		private var tick:int;
		/**
		 * change the mode
		 */
		private function chgMode(n):void{
			Loader=new URLLoader();
			
			list.dataProvider=[];
			if (n) {
				
				webSearch();
				
			}else{
				preview.dispatchEvent(new Event("close"));
				localSearch();
			}
			mode=n;
		}
		/**
		 * get web tick and process
		 */
		protected function webtick(event:Event):void
		{
			if(tick>15){
				tick=0;
				webSearch();
				removeEventListener(Event.ENTER_FRAME,webtick);
			}
			tick++;
			
		}
		/**
		 * the choose event
		 */
		protected function choose_evt(event:ListEvent):void{
			if (web_b.selected) {
				if (GxmlContainer.Node_Space[list.selectedItem.id]==null) {
					preview.GiveNode(list.selectedItem.id,list.selectedItem.label,list.selectedItem.type);
					
					var locPoint:Point=new Point();
					locPoint.y=list.y;
					locPoint.x=-preview.W-2;
					var absPoint:Point=localToGlobal(locPoint);
					preview.aimX=absPoint.x;
					if (absPoint.y+preview.height>GlobalLayoutManager.StageHeight-10) {
						absPoint.y=GlobalLayoutManager.StageHeight-preview.height-10;
					}
					preview.x=absPoint.x;
					preview.y=absPoint.y;
					
					if (!WindowSpace.contains(preview)) {
						WindowSpace.addWindow(preview,
							function ():void{Tween.floatLeft(preview);},
							function ():void{Tween.FloatDownWindow(preview);}
						);
					}
				}else{
					preview.dispatchEvent(new Event("close"));
					Net.Centerlize(GxmlContainer.Node_Space[list.selectedItem.id]);
				}
			}else{
				Net.Centerlize(list.selectedItem.Item);
			}
		}
		/**
		 * the event when mode change
		 */
		protected function chg_evt(event):void{
			preview.dispatchEvent(new Event("close"));
			setFocus();
			if (SearchText.text.length==0) {
				SearchHint.visible=true;
				ResultHint.visible=true;
				ResultHint.text="Search from Cloud"
			}else {
				SearchHint.visible=false;
				ResultHint.visible=true;
				if (web_b.selected&&SearchText.text.length==1){
					ResultHint.text="Type one more letter";
				}else{
					ResultHint.text="Searching...";
				}
			}
			if (web_b.selected) {
				tick=0;
				removeEventListener(Event.ENTER_FRAME,webtick);
				addEventListener(Event.ENTER_FRAME,webtick);
			}else  {
				localSearch();
			}
		}
		/**
		 * flush the list
		 */
		public function flushList():void{
			var showHeight:Number;
			if (list.dataProvider.length==0) {
				showHeight=100;
				TweenHeight(showHeight);
				
				Tween.fadeOut(list);
				ResultHint.visible=true;
				if (SearchText.text.length==0) {
					ResultHint.text="Type your search";
				}else if (SearchText.text.length==1&&web_b.selected) {
					ResultHint.text="Type one more letter";
				}else {
					ResultHint.text="No result found";
				}
				
			}else{
				ResultHint.visible=false;
				Tween.smoothIn(list);
				showHeight=list.contentHeight;
				
				
				if (showHeight>400) {
					showHeight=400;
				}
				list.setSize(Width-10,showHeight);
				
				TweenHeight(showHeight+60);
			}
		}
		/**
		 * web search mode
		 */
		private function webSearch():void{
			
			if (SearchText.text.length<2) {
				searchResult=[];
				return;
			}
			
			var handle:String=GlobalVaribles.SEARCH_INTERFACE;
			var searchRequest:URLRequest=new URLRequest(handle);
			
			var SearchJson_AND:Array=[]
			
			SearchJson_AND.push({NAME:{$regex:SearchText.text,$options:"i"}});
			
			var SearchJson:Object={$and:SearchJson_AND}
			
			var postvar:URLVariables=new URLVariables();
			
			postvar.spec=JSON.stringify(SearchJson);
			//postvar.fields='{}';
			postvar.skip=0;
			postvar.limit =50;
			
			searchRequest.method="post";
			searchRequest.data=postvar;
			
			Loader=new URLLoader(searchRequest);
			
			Loader.addEventListener(Event.COMPLETE,Loader_CMP,false,0,true);
			
			Loader.addEventListener(IOErrorEvent.IO_ERROR,IOreport,false,0,true);
		}
		/**
		 * IO report
		 */
		protected function IOreport(event:IOErrorEvent):void
		{
			ResultHint.text="Server unavailable";
		}
		/**
		 * loader compare
		 */
		protected function Loader_CMP(event:Event):void{
			
			if(mode&&!hided){
				var results:Array=JSON.parse(event.target.data).result;
				trace(event.target.data);
				var res:Array=[];
				for each(var item:Object in  results){
					if (String(item._id).length==24) {
						res.push({label:item.NAME,type:item.TYPE,id:item._id});
					}
				}
				searchResult=res;
			}
		}
		/**
		 * local search
		 */
		private function localSearch():void{
			searchResult=GxmlContainer.search(SearchText.text);
		}
		public function set searchResult(db:Array):void{
			list.dataProvider=db;
			flushList();
		}
		/**
		 * refresh the searching pad
		 */
		public function setSize(w,h):void{
			Width=w;
			Height=h;
			ch=0;
			
			Box.graphics.clear();
			
			Box.graphics.lineStyle(0,0xeeeeee,1,true);
			Box.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			Box.graphics.drawRoundRect(0,0,w,h,3,3);
			Box.graphics.endFill();
			
			Box2.graphics.clear();
			Box2.graphics.lineStyle(0,0xaaaaaa,1,true);
			Box2.graphics.beginFill(0xffffff);
			Box2.graphics.drawRoundRect(5,5,w-10,h-10,(h-10)/2,(h-10)/2);
			Box2.graphics.endFill();
			
			SearchHint.y=8;
			SearchHint.x=7;
			
			SearchText.y=8;
			SearchText.x=7;
			SearchText.height=24;
			SearchText.width=w-12;
			
			webIndecator.y=h/2;
			webIndecator.x=w-webIndecator.width/2-10;
			
			search_b.x=w/4;
			web_b.x=w*3/4;
			
			ResultHint.width=w;
			ResultHint.autoSize="center";
		}
		
		private var ah:Number,ch:Number;
		private var hided:Boolean=true;
		public var focused:Boolean;
		/** 
		 * show height smoothly
		 */
		public function TweenHeight(h):void{
			ah=h;
			removeEventListener(Event.ENTER_FRAME,TweenScaling);
			addEventListener(Event.ENTER_FRAME,TweenScaling);
			
		}
		/**
		 * scale the dock smoothly
		 */
		private function TweenScaling(e):void{
			boxSetSize((ah+ch*2)/3,false);
			if (Math.abs(ah-ch)<0.4) {
				ch=ah;
				boxSetSize(ah,false);
				removeEventListener(Event.ENTER_FRAME,TweenScaling);
			}
		}
		/**
		 * set the size of the box
		 */
		private function boxSetSize(h,setList=true):void{
			ch=h;
			Box.graphics.clear();
			
			Box.graphics.lineStyle(0,0xeeeeee,1,true);
			Box.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			Box.graphics.drawRoundRect(0,-h,Width,h+Height,3,3);
			Box.graphics.endFill();
			
			if (h>5) {
				Box.graphics.lineStyle(0,0xeeeeee);
				Box.graphics.moveTo(Width/2,-h+Math.min(50,h-5));
				Box.graphics.lineTo(Width/2,-h+5);
			}
				
			list.y=-h+60;
			web_b.y=-h+30;
			search_b.y=-h+30;
			
			ResultHint.y=(-h+34)/2;
		}
		
		
	}
}