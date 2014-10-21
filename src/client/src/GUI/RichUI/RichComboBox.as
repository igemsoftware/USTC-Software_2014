package GUI.RichUI{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import UserInterfaces.GlobalLayout.FrontCoverSpace;
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	
	public class RichComboBox extends Sprite{
		public static const INDEPENDENT:int=0;
		public static const LEFT_EDGE:int=1;
		public static const RIGHT_EDGE:int=2;
		public static const MIDDLE:int=3;
		
		private var button:RichButton
		private var list:RichIconList=new RichIconList();
		private var _selectedIndex:int;
		
		public var selectedItem:*;
		public var Rev:Boolean;
		private var _data:Array;
		
		private var showLabel:Boolean;
		private var showIcon:Boolean;
		
		public function RichComboBox(type=INDEPENDENT,ShowL=true,ShowI=true,rev=false){
			
			showLabel=ShowL;
			showIcon=ShowI;
			
			Rev=rev;
			button=new RichButton(type);
			button.addEventListener(MouseEvent.CLICK,function (e):void{
				if (FrontCoverSpace.contains(list)) {
					FrontCoverSpace.removeChild(list);
				}else {
					FrontCoverSpace.addChild(list);
					var locPoint:Point=new Point();
					var absPoint:Point=localToGlobal(locPoint);
					locPoint.x=0;
					if (absPoint.y+list.Height>GlobalLayoutManager.StageHeight&&absPoint.y-list.Height>0) {
						locPoint.y=-list.Height;
					}else {
						locPoint.y=button.height;
					}
					absPoint=localToGlobal(locPoint);
					list.x=absPoint.x;
					list.y=absPoint.y;
				}
			});
			list.addEventListener(MouseEvent.CLICK,function (e):void{
				if(list.selectedItem.icon!=null&&list.selectedItem.icon.constructor==Class){
					button.setIcon(list.selectedItem.icon,Rev);
				}else{
					
					button.label=list.selectedItem.label;
				}
				_selectedIndex=list.selectedIndex;
				selectedItem=list.selectedItem;
				FrontCoverSpace.removeChild(list);
				dispatchEvent(new Event(Event.CHANGE));
			});
			
			addEventListener(Event.REMOVED_FROM_STAGE,function (e):void{
				FrontCoverSpace.removeChild(list);
			})
			
			addChild(button);
		}
		public function set selectedIndex(n:int):void{
			if(showIcon&&_data[n].icon!=null&&_data[n].icon.constructor==Class){
				button.setIcon(_data[n].icon,Rev);
			}
			if(showLabel){
				button.label=_data[n].label;
			}
			selectedItem=_data[n];
			_selectedIndex=n;
		}
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		public function set dataProvider(arr:Array):void{
			_data=arr;
			list.setIconField(arr,showLabel,showIcon,Rev);
		}
		public function setSize(w:Number,h:Number):void{
			list.setSize(w);
			button.setSize(w,h);
		}
	}
}