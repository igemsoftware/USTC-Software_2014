package Kernel.SmartCanvas.Parts
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import Kernel.SmartCanvas.Assembly.FocusCircle;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import UserInterfaces.FunctionPanel.Detail.DetailDispatcher;
	
	import Kernel.Geometry.DrawBitMap;
	import Kernel.Geometry.DrawNode;
	
	import UserInterfaces.Sorpotions.Navigator;

	
	import UserInterfaces.Style.Tween;
	import UserInterfaces.Style.TweenX;

	/**
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
		
		/**
		 * regist event Listeners
		 */
		public function ready(edit=true):void{
			block_base.addEventListener(MouseEvent.MOUSE_DOWN,Down_evt);
			block_base.addEventListener(MouseEvent.DOUBLE_CLICK,openDetail);
			addEventListener(MouseEvent.CLICK,Click_evt);
			
			if (edit) {
				unlocktext();
			}
		}
		
		/**
		 * open detail board
		 */
		protected function openDetail(e):void{
			DetailDispatcher.LauchDetail(NodeLink)
		}
		
		/**
		 * Key Monitor, for Enter (confirm changing) and Esc (cancel changing)
		 */
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
		
		/**
		 * lock label text
		 */
		public function locktext(e=null):void {
			title.selectable=false;
			title.removeEventListener(KeyboardEvent.KEY_UP,key_mon);
			
			if(NodeLink.Name!=title.text){
				GxmlContainer.RecordNodeDetail(NodeLink);
			}
			
			NodeLink.Name=title.text;
			generateTextMap();
		}
		
		/**
		 * generate bitmap for label text, for compress
		 * @see Partition
		 */
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
		
		/**
		 * Perpare to edit label
		 */
		public function unlocktext():void {
			scaleX=scaleY=1;
			z=0;
			title.addEventListener(KeyboardEvent.KEY_UP,key_mon);
			title.selectable=true;
		}
		
		/**
		 * refresh links when node moved
		 * @see LinePicker
		 * @param ani if ani==true, then the focus circle will show up with Tween.
		 * @see Tween
		 */
		public function setFocus(ani=false):void{
			if (!focused) {
				focusCircle=new FocusCircle(NodeLink.skindata.radius/2*FreePlate.scaleXY);
				focusCircle.x=this.x;
				focusCircle.y=this.y;
				
				if(ani){
					focusCircle.scaleX=focusCircle.scaleY=3;
					Tween.zoomFocus(focusCircle);
				}
				
				Net.bottom.addChild(focusCircle);
				
				focused=true;
			}
		}
		
		/**
		 * refresh links when node moved
		 * @see LinePicker
		 * @param ani if ani==true, then the focus circle will show up with Tween.
		 * @see Tween
		 */
		public function loseFocus(ani=false):void {
			focused=false;
			if (focusCircle!=null&&ani) {
				Tween.zoomOutFocus(focusCircle);
			}else{
				focusCircle.parent.removeChild(focusCircle);
			}
			focusCircle=null;
			if(title.selectable){
				locktext();
			}
		}
		
		
		/**
		 * refresh links when node moved
		 * @see LinePicker
		 */
		public function flushArrow():void {
			var toset:Boolean=false;
			for each(var arrow:CompressedLine in NodeLink.Arrowlist) {
				arrow.setLine();
				toset=true
			}
			if(toset){
				Net.LinkSpace.flushPickedLines();
			}
		}
		

		/**
		 * apply new location for CompressedNode
		 * @see CompressedNode
		 * This simply for draging,links must be picked before
		 */
		override public function setCurrentLocation():void{

			NodeLink.Position[0]=x/FreePlate.scaleXY;
			NodeLink.Position[1]=y/FreePlate.scaleXY;
			
			NodeLink.x=x;
			NodeLink.y=y;
			
			if (focusCircle!=null) {
				focusCircle.x=x;
				focusCircle.y=y;
			}
			flushArrow();
			
			Navigator.refreshMap();
		}
		
		/**
		 *Tween Move function
		 */
		public function setPositionX(px):void{
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=px;
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=NodeLink.Position[1];
			TweenX.GlideNode(this.NodeLink);
		}
		
		/**
		 *Tween Move function
		 */
		public function setPositionY(py):void{
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=py;
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=NodeLink.Position[0];
			TweenX.GlideNode(this.NodeLink);
		}
		
		/**
		 *Tween Move function
		 */
		public function setPositionXY(px,py):void{
			NodeLink.remPosition[1]=NodeLink.aimPosition[1]=py;
			NodeLink.remPosition[0]=NodeLink.aimPosition[0]=px;
			TweenX.GlideNode(this.NodeLink);
		}
		
		
		/**
		 *change scale with Canvas
		 * @see FreePlate
		 * @see Net
		 */
		public function resetScale():void{
			x=NodeLink.Position[0]*FreePlate.scaleXY;
			y=NodeLink.Position[1]*FreePlate.scaleXY;
			if (focusCircle!=null) {
				focusCircle.x=x;
				focusCircle.y=y;
			}
			drawSkin();
			title.y=int(NodeLink.skindata.radius/2*FreePlate.scaleXY)+8;
		}
		
		
		/**
		 *Draw skin on UI component
		 */
		public function drawSkin():void{
			block_base.graphics.clear();
			block_base.graphics.drawGraphicsData(DrawNode.drawNode(NodeLink.skindata,0,0,FreePlate.scaleXY));
			if(GlobalVaribles.showIconMap){
				DrawBitMap.drawBitmap_Center(block_base,NodeLink.Type.icon,0,0,NodeLink.Type.iconScale*FreePlate.scaleXY);
			}
			
			if (focusCircle!=null) {
				focusCircle.redraw(NodeLink.skindata.radius/2*FreePlate.scaleXY);
			}
		}
		
		/**
		 *Redraw Skin, for applying change.
		 */
		public function redraw():void {
			title.text=NodeLink.Name;
			drawSkin();
			title.y=int(NodeLink.skindata.radius/2*FreePlate.scaleXY)+8;
		}
	}
}