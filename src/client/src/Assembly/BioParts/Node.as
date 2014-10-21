package Assembly.BioParts
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import FunctionPanel.WindowsDispatcher;
	
	import Geometry.DrawBitMap;
	import Geometry.DrawNode;
	
	import Layout.ReminderManager;
	import Layout.Sorpotions.Navigator;
	
	import Assembly.ProjectHolder.GxmlContainer;
	import Assembly.Canvas.I3DPlate;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	
	import Style.Tween;
	import Style.TweenX;
	import Assembly.FocusCircle;
	import LoginAccount.AuthorizedURLLoader;
	import LoginAccount.AuthorizeEvent;
	
	
	
	/*
	Node:
	This part include functions of :
	Ready,
	Destroy, 
	Key Mon,
	Focus Manager,
	Scale Manager
	Redraws
	*/
	
	public class Node extends DisplayNodeObject{
		private const NORMAL_COLOR:uint=0xe0e0e0;
		private const HIGHLIGHT_COLOR:uint=0xe0eeff;
		private const DISABLED_COLOR:uint=0xaaaaaa;
		private const EDIT_COLOR:uint=0xffff99;
		private const ICON_CIRILE_COLOR:uint=0x9999dd;
		private var isLoadingDetail:Boolean=false;
		
		public function Node(){
			addChild(block_base);
			addChild(title);
			
			cacheAsBitmap=true;
			
			title.selectable=false;
			title.addEventListener(FocusEvent.FOCUS_OUT,locktext);
			
			addEventListener(Event.REMOVED_FROM_STAGE,function (e):void{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,move_evt);
				stage.removeEventListener(MouseEvent.MOUSE_UP,end_move_evt);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,draging3D);
			});
		}
		
		public function ready(edit=true):void{
			block_base.addEventListener(MouseEvent.MOUSE_DOWN,Down_evt);
			block_base.addEventListener(MouseEvent.DOUBLE_CLICK,detail_handle);
			addEventListener(MouseEvent.CLICK,Click_evt);
			
			if (edit) {
				unlocktext();
			}
		}
		
		
		protected function detail_handle(e):void{
			
			if (NodeLink.detail==null||NodeLink.detail=="") {
				
				if(NodeLink.ID.length==24){
					if(!isLoadingDetail){
						var loader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest(NodeLink.ContentURL));
						isLoadingDetail=true;
						loader.dataFormat = URLLoaderDataFormat.TEXT;
						loader.addEventListener(Event.COMPLETE,function (event):void{
							trace(event.target.data);
							NodeLink.detail=String(event.target.data);
							WindowsDispatcher.LaunchJSONContent(NodeLink.detail,true,NodeLink);
							isLoadingDetail=false;
						});
						loader.addEventListener(AuthorizeEvent.AUTHORIZE_FAILED,function (event:AuthorizeEvent):void{
							ReminderManager.remind(event.status);	
							NodeLink.detail='{"NAME":"'+NodeLink.Name+'","TYPE":"'+NodeLink.Type.label+'","Information":"Failed loading detail from Cloud, Hit Edit to add your information."}'
							WindowsDispatcher.LaunchJSONContent(NodeLink.detail,true,NodeLink);
							isLoadingDetail=false;
						});
						trace(NodeLink.ContentURL);
					}
					
				}else{
					NodeLink.detail='{"NAME":"'+NodeLink.Name+'","TYPE":"'+NodeLink.Type.label+'","Information":"Add your Information here by hiting <b>EDIT</b>!"}'
					WindowsDispatcher.LaunchJSONContent(NodeLink.detail,true,NodeLink);
				}
			}else{
				WindowsDispatcher.LaunchJSONContent(NodeLink.detail,true,NodeLink);
			}
		}
		////Key Mon
		private function key_mon(e:KeyboardEvent):void{
			if (e.keyCode==Keyboard.ENTER) {
				locktext();
			}
			if (e.keyCode==Keyboard.ESCAPE) {
				title.text=NodeLink.Name;
				locktext();
			}
			e.stopPropagation();
		}
		public function locktext(e=null):void {
			title.selectable=false;
			title.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
			
			if(NodeLink.Name!=title.text){
				GxmlContainer.RecordNodeDetail(NodeLink);
			}
			
			NodeLink.Name=title.text;
			generateTextMap();
		}
		
		public function generateTextMap():void{
			var bmp:BitmapData=new BitmapData(title.width,title.height,true,0);
			bmp.draw(title.textField);
			bmp.lock();
			for (var i:int = 0; i < title.width; i++) {
				for (var j:int = 0; j < title.height; j++) {
					if (bmp.getPixel32(i,j)==0) {
						bmp.setPixel32(i,j,0x00000000);
					}
				}
			}
			bmp.unlock();
			NodeLink.TextMap=bmp;
			//NodeLink.textX=title.x;
			NodeLink.textY=int(NodeLink.skindata.radius/2);
		}
		
		public function unlocktext():void {
			scaleX=scaleY=1;
			z=0;
			title.addEventListener(KeyboardEvent.KEY_UP,key_mon);
			title.selectable=true;
		}
		
		/////Focus Manager
		override public function setFocus():void{
			if (!focused) {
				focusCircle=new FocusCircle(NodeLink.skindata.radius/2*I3DPlate.scaleXY+8);
				focusCircle.x=this.x;
				focusCircle.y=this.y;
				focusCircle.scaleX=focusCircle.scaleY=2.6;
				
				Net.bottom.addChild(focusCircle);
				
				Tween.zoomFocus(focusCircle);
				focused=true;
			}
		}
		
		override protected function Click_evt(e:MouseEvent):void {
			Net.setfocus(NodeLink,e.shiftKey);
		}
		
		override public function loseFocus():void {
			focused=false;
			if (focusCircle!=null) {
				Tween.zoomOutFocus(focusCircle);
			}
			focusCircle=null;
			if(title.selectable){
				locktext();
			}
		}
		
		//////redraws
		
		public function flushArrow():void {
			var toset:Boolean=false;
			for each(var arrow:CompressedLine in NodeLink.Arrowlist) {
				arrow.setLine();
				toset=true
			}
			if(toset){
				Net.LineSpace.flushPickedLines();
			}
		}
		
		
		override public function setCurrentLocation():void{
			
			//////////This simply for draging,must be picked
			
			NodeLink.Position[0]=x/I3DPlate.scaleXY;
			NodeLink.Position[1]=y/I3DPlate.scaleXY;
			
			NodeLink.x=x;
			NodeLink.y=y;
			
			if (focusCircle!=null) {
				focusCircle.x=x;
				focusCircle.y=y;
			}
			flushArrow();
			
			Navigator.refreshMap();
		}
		
		public function setPositionX(px):void{
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=px;
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=NodeLink.Position[1];
			TweenX.GlideNode(this.NodeLink);
		}
		
		public function setPositionY(py):void{
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=py;
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=NodeLink.Position[0];
			TweenX.GlideNode(this.NodeLink);
		}
		
		public function setPositionXY(px,py):void{
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=px;
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=py;
			TweenX.GlideNode(this.NodeLink);
		}
		
		public function resetScale():void{
			x=NodeLink.Position[0]*I3DPlate.scaleXY;
			y=NodeLink.Position[1]*I3DPlate.scaleXY;
			if (focusCircle!=null) {
				focusCircle.x=x;
				focusCircle.y=y;
			}
			drawSkin();
			title.y=int(NodeLink.skindata.radius/2*I3DPlate.scaleXY)+8;
		}
		
		public function drawSkin():void{
			block_base.graphics.clear();
			block_base.graphics.drawGraphicsData(DrawNode.drawNode(NodeLink.skindata,0,0,I3DPlate.scaleXY));
			if(GlobalVaribles.showIconMap){
				DrawBitMap.drawBitmap_Center(block_base,NodeLink.Type.icon,0,0,NodeLink.Type.iconScale*I3DPlate.scaleXY);
			}
			
			if (focusCircle!=null) {
				focusCircle.redraw(NodeLink.skindata.radius/2*I3DPlate.scaleXY+8);
			}
		}
		public function redraw():void {
			title.text=NodeLink.Name;
			drawSkin();
			title.y=int(NodeLink.skindata.radius/2*I3DPlate.scaleXY)+8;
		}
	}
}