package UserInterfaces.Sorpotions{
	import flash.concurrent.Mutex;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import Kernel.Biology.LinkTypeInit;
	import Kernel.Biology.NodeTypeInit;
	
	import GUI.Assembly.FlexibleLayoutObject;
	
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.ProjectHolder.GxmlContainer;
	
	/**
	 * a navigator of all the nodes on the screen
	 */
	public class Navigator extends Sprite implements FlexibleLayoutObject,IActivationObject {
		
		private static var frame:Sprite=new Sprite();
		private static var Range:Sprite=new Sprite();
		private static var map:Bitmap=new Bitmap(null,"auto",true);
		
		
		private static var containerW:Number,containerH:Number,centerX:Number,centerY:Number;
		
		private static var Width:Number,Height:Number;
		
		private static var Mask:Shape=new Shape();
		
		private static var Target:*
		
		private static var locked:Boolean;
		
		private static var accelerator:int;
		private static var actived:Boolean=false;
		
		private static var mapData:BitmapData;
		private static var xx:Number,yy:Number;
		private static var scale:Number;
		
		//////////0.2 MultiThread
		private static var DrawThread:Worker;
		protected static var mainToWorker:MessageChannel;
		protected static var workerToMain:MessageChannel;
		protected static var imageBytes:ByteArray;
		protected static var originBytes:ByteArray;
		protected static var drawMutex:Mutex=new Mutex();
		protected static var returnMutex:Mutex=new Mutex();
		
		private static var tofresh:Boolean;
		
		
		public function Navigator() {
			
			
			//////////0.2 MultiThread
			
			init_worker();
			
			//TODO: implement function
			setSize(200,160);
			
			addChild(frame);
			addChild(map);
			addChild(Range);
			addChild(Mask);
			
			Range.mask=Mask;
			
			Range.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				Range.startDrag();
				Range.addEventListener(MouseEvent.MOUSE_MOVE,setloc)
				stage.addEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			});
			frame.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				Range.x=mouseX-Range.width/2;
				Range.y=mouseY-Range.height/2;
				FreePlate.movePlateTo(xx-(Range.x-map.x)/map.scaleX,yy-(Range.y-map.y)/map.scaleY);
			});
			
		}
		/**
		 * to initialize worker
		 */
		private function init_worker():void{
			DrawThread= WorkerDomain.current.createWorker(Workers.UserInterfaces_Sorpotions_NavigatorTrackingThread);
			
			mainToWorker= Worker.current.createMessageChannel(DrawThread);
			workerToMain= DrawThread.createMessageChannel(Worker.current);
			
			DrawThread.setSharedProperty("Navigator_drawMutex",drawMutex);
			DrawThread.setSharedProperty("Navigator_returnMutex",returnMutex);
			
			DrawThread.setSharedProperty("mainToNavigator",mainToWorker);
			DrawThread.setSharedProperty("NavigatorToMain",workerToMain);
			
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE,onWorkerToMain);
			
			imageBytes= new ByteArray();
			originBytes= new ByteArray();
			
			imageBytes.shareable= true;
			originBytes.shareable= true;
			
			DrawThread.setSharedProperty("Navigator_imageBytes",imageBytes);
			DrawThread.setSharedProperty("Navigator_originBytes",originBytes);
			
			DrawThread.start();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			//TODO: implement function
			Width=w;
			
			Height=h;
			
			frame.graphics.clear();
			frame.graphics.lineStyle(0,GlobalVaribles.SKIN_LINE_COLOR);
			frame.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			frame.graphics.drawRect(0,0,w,h);
			frame.graphics.endFill();
			
			Mask.graphics.clear();
			Mask.graphics.lineStyle(0,0);
			Mask.graphics.beginFill(0,1);
			Mask.graphics.drawRect(0,0,w,h);
			Mask.graphics.endFill();
			
		}
		
		protected function setloc(event:MouseEvent):void
		{
			FreePlate.movePlateTo(xx-(Range.x-map.x)/scale,yy-(Range.y-map.y)/scale);
		}
		protected function stage_mouseUpHandler(event):void
		{
			// TODO Auto-generated method stub
			stage.removeEventListener(MouseEvent.MOUSE_UP,stage_mouseUpHandler);
			Range.removeEventListener(MouseEvent.MOUSE_MOVE,setloc);
			Range.stopDrag();
		}
		
		public static function lock():void{
			locked=true;
		}
		public static function unlock():void{
			locked=false;
		}
		
		public static function setTarget(tar):void{
			Target=tar;
			map.bitmapData=new BitmapData(1,1);
		}
		
		public static function refreshMap():void{
			tofresh=true;
		}
		/**
		 * refresh map
		 */
		public static function refreshMap_delay():void{
			if (tofresh&&!locked&&Target.width>0){
				
				if(drawMutex.tryLock()) {
					var rect:Rectangle=Target.getRect(Target);
					
					scale=Math.min(Width/Target.width,Height/Target.height);
					
					var w:int=Math.ceil(Math.min(Width,Target.width*scale));
					
					var h:int=Math.ceil(Math.min(Height,Target.height*scale));
					
					var t:int=getTimer();
					
					originBytes.clear();
					
					originBytes.writeInt(w);
					originBytes.writeInt(h);
					
					originBytes.writeDouble(rect.left);
					originBytes.writeDouble(rect.top);
					
					originBytes.writeDouble(scale);
					
					var c:int=originBytes.position;
					originBytes.writeInt(0);
					
					var i:int=0;
					
					for each (var link:CompressedLine in GxmlContainer.Link_Space) {
						originBytes.writeInt(link.linkObject[0].x);
						originBytes.writeInt(link.linkObject[0].y);
						originBytes.writeInt(link.linkObject[1].x);
						originBytes.writeInt(link.linkObject[1].y);
						originBytes.writeUnsignedInt(link.skindata.lineColor);
						i++;
					}
					
					originBytes.position=c;
					originBytes.writeInt(i);
					originBytes.position=originBytes.length;
					
					for each (var block:CompressedNode in GxmlContainer.Node_Space) {
						originBytes.writeInt(block.x);
						originBytes.writeInt(block.y);
						originBytes.writeUnsignedInt(block.skindata.color);
						
					}
					
					drawMutex.unlock();
					mainToWorker.send("refresh");
					tofresh=false;
					
				}
				
				xx=-rect.left*Target.scaleX-centerX;
				yy=-rect.top*Target.scaleX-centerY;
				refreshLocation();
				
			}else{
				tofresh=false;
			}
		}
		
		private static var generateMap:Bitmap=new Bitmap()
		
			/**
			 * generate map from json
			 */
		public static function generateMapFromJSON(json:String,tar:Bitmap,pw:int,ph:int):void{
			
			generateMap=tar;
			
			var mapobj:Object=JSON.parse(json);
			
			var nodes:Array=mapobj.node;
			var lines:Array=mapobj.link;
			
			var NODES:Object=new Object();
			var LINKS:Object=new Object();
			
			var left:Number=Infinity, right:Number=-Infinity, top:Number=Infinity, down:Number=-Infinity, centerX:Number=0, centerY:Number=0;

			for each(var node:Object in  nodes){
				NODES[node._id]={
					x:node.x,
					y:node.y,
					color:NodeTypeInit.BiotypeList[node.TYPE].skindata.color
				};
				if (node.x < left)
					left=node.x
				if (node.x > right)
					right=node.x
				if (node.y < top)
					top=node.y
				if (node.y > down)
					down=node.y
			}
			
			
			for each(var line:Object in  lines){
				LINKS[line._id]={
					x1:NODES[line.id1].x,
						y1:NODES[line.id1].y,
						x2:NODES[line.id2].x,
						y2:NODES[line.id2].y,
						color:(LinkTypeInit.LinkTypeList[line.TYPE]!=null?LinkTypeInit.LinkTypeList[line.TYPE].skindata.lineColor:0xffffff)
				};
			}
			
			var aw:int=right-left+100;
			var ah:int=down-top+100;
			
			drawMutex.lock()
			scale=Math.min(pw/aw,ph/ah);
			
			var t:int=getTimer();
			
			originBytes.clear();
			
			originBytes.writeInt(pw);
			originBytes.writeInt(ph);
			
			originBytes.writeDouble(left-50);
			originBytes.writeDouble(top-50);
			
			originBytes.writeDouble(scale);
			
			var c:int=originBytes.position;
			originBytes.writeInt(0);
			
			var i:int=0;
			
			for each (var link:Object in LINKS) {
				originBytes.writeInt(link.x1);
				originBytes.writeInt(link.y1);
				originBytes.writeInt(link.x2);
				originBytes.writeInt(link.y2);
				originBytes.writeUnsignedInt(link.color);
				i++;
			}
			
			originBytes.position=c;
			originBytes.writeInt(i);
			originBytes.position=originBytes.length;
			
			for each (var block:Object in NODES) {
				originBytes.writeInt(block.x);
				originBytes.writeInt(block.y);
				originBytes.writeUnsignedInt(block.color);
				
			}
			
			drawMutex.unlock();
			mainToWorker.send("Generate");
		}
		
		protected function onWorkerToMain(event:Event):void{
			// TODO Auto-generated method stub
			
			var msg:*= workerToMain.receive();
			
			if(msg=="DrawComplete"){
				
				if(returnMutex.tryLock()){
					
					//		trace("[Map]:EnterLock");
					imageBytes.position=0;	
					
					mapData=new BitmapData(	imageBytes.readInt(),imageBytes.readInt(),true,0);
					
					
					mapData.setPixels(mapData.rect,imageBytes);
					map.bitmapData=mapData;
					
					map.y=Height/2-map.height/2;
					map.x=Width/2-map.width/2;
					
					returnMutex.unlock();
					
					//		trace("[Map]:unlock return");
				}
			}else if(msg=="GenerateComplete"){
				
				returnMutex.lock();
				
				imageBytes.position=0;	
				
				var tmpData:BitmapData=new BitmapData(imageBytes.readInt(),imageBytes.readInt(),true,0);

				tmpData.setPixels(tmpData.rect,imageBytes);
				
				returnMutex.unlock();
				
				generateMap.bitmapData=tmpData;
			}
		}
		public static function setMap(cx,cy,cw,ch):void{
			containerW=cw;
			containerH=ch;
			centerX=cx;
			centerY=cy;
		}
		/** 
		 * refresh location
		 */
		public static function refreshLocation():void{
			if (actived&&scale>0) {
				Range.graphics.clear();
				Range.graphics.lineStyle(0,0xffffff,1);
				Range.graphics.beginFill(0x000000,0.3);
				Range.graphics.drawRect(0,0,containerW*scale/Target.scaleX,containerH*scale/Target.scaleX);
				Range.graphics.endFill();
				
				Range.x=map.x+(xx-Target.x)*scale;
				Range.y=map.y+(yy-Target.y)*scale;
			}
			
		}
		/**
		 * refresh range
		 */
		public static function refreshRange():void{
			var rect:Rectangle=Target.getRect(Target);
			
			xx=-rect.left*Target.scaleX-centerX;
			yy=-rect.top*Target.scaleX-centerY;
			
			var tmpscale:Number=Math.min(Width/Target.width,Height/Target.height);
			
			Range.graphics.clear();
			Range.graphics.lineStyle(0,0xffffff,1);
			Range.graphics.beginFill(0x000000,0.3);
			Range.graphics.drawRect(0,0,containerW*tmpscale,containerH*tmpscale);
			Range.graphics.endFill();
			
			Range.x=map.x+(xx-Target.x)*tmpscale;
			Range.y=map.y+(yy-Target.y)*tmpscale;
			
		}
		
		private var interval:uint;
		
		public function active():void
		{
			actived=true;
			refreshMap_delay();
			interval=setInterval(refreshMap_delay,100);
		}
		
		public function inactive():void
		{
			actived=false;
			clearInterval(interval);
		}
		
	}
}