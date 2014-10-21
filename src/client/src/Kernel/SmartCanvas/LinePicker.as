package Kernel.SmartCanvas{
	
	import flash.concurrent.Mutex;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import Kernel.SmartCanvas.Canvas.FreePlate;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	public class LinePicker extends Sprite{
		
		private var _data:BitmapData;
		private var _map:Bitmap=new Bitmap();
		public var pickedLines:Array=[];
		
		//////MultiThread
		private var DrawThread:Worker;
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		protected var returnBytes:ByteArray;
		protected var originBytes:ByteArray;
		protected var drawMutex:Mutex=new Mutex();
		protected var returnMutex:Mutex=new Mutex();
		
		public function LinePicker(){
			
			DrawThread= WorkerDomain.current.createWorker(Workers.Kernel_SmartCanvas_PickThread);
			
			mainToWorker= Worker.current.createMessageChannel(DrawThread);
			workerToMain= DrawThread.createMessageChannel(Worker.current);
			
			DrawThread.setSharedProperty("LinePicker_drawMutex",drawMutex);
			DrawThread.setSharedProperty("LinePicker_returnMutex",returnMutex);
			
			DrawThread.setSharedProperty("mainToLinePicker",mainToWorker);
			DrawThread.setSharedProperty("LinePickerToMain",workerToMain);
			
			returnBytes= new ByteArray();
			originBytes= new ByteArray();
			
			returnBytes.shareable= true;
			originBytes.shareable= true;
			
			DrawThread.setSharedProperty("LinePicker_imageBytes",returnBytes);
			DrawThread.setSharedProperty("LinePicker_originBytes",originBytes);
			
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE,onWorkerToMain);
			
			DrawThread.start();
			
			
			addChild(_map);
			
		}
		protected function onWorkerToMain(event:Event):void{
			// TODO Auto-generated method stub
			
			var msg:*= workerToMain.receive();
			
			if(msg=="DrawComplete"){
				
				if(returnMutex.tryLock()){
					
					//	trace("[LinePicker]:EnterLock");
					returnBytes.position=0;	
					
					x=returnBytes.readInt();
					y=returnBytes.readInt();
					
					var w:int=returnBytes.readInt();
					var h:int=returnBytes.readInt();
					
					_data=new BitmapData(w,h,true,0);
						
					_data.setPixels(new Rectangle(0,0,w,h),returnBytes);
					
					_map.bitmapData=_data;
					
					returnMutex.unlock();
					
					//	trace("[LinePicker]:unlock return");
				}
			}
		}
		
		public function restore():void{
			_map.bitmapData=new BitmapData(1,1,true,0);
		}
		
		public function appendLines(arr:Array):void{
			
			for each (var line:CompressedLine in arr) {
				pickedLines[line.ID]=line;
			}
			redraw();
		}
		
		public function clearLines():void{
			
			pickedLines=[];
			
		}
		
		public function redraw():void{
			
			if(drawMutex.tryLock()){
				
				originBytes.clear();
				
				var hasLine:Boolean=false;
				
				var left:Number=Infinity,top:Number=Infinity,right:Number=-Infinity,buttom:Number=-Infinity
				
				originBytes.writeInt(left);
				originBytes.writeInt(top);
				originBytes.writeInt(right);
				originBytes.writeInt(buttom);
				
				originBytes.writeInt(left);
				originBytes.writeInt(top);
				originBytes.writeInt(right);
				originBytes.writeInt(buttom);
				
				for each (var line:CompressedLine in pickedLines) {
					if(line.SX<left)left=line.SX;
					if(line.SX>right)right=line.SX;
					
					
					if(line.SY<top)top=line.SY;
					if(line.SY>buttom)buttom=line.SY;
					
					if(line.EX<left)left=line.EX;
					if(line.EX>right)right=line.EX;
					
					
					if(line.EY<top)top=line.EY;
					if(line.EY>buttom)buttom=line.EY;
					
					originBytes.writeInt(line.SX);
					originBytes.writeInt(line.SY);
					originBytes.writeInt(line.EX);
					originBytes.writeInt(line.EY);
					originBytes.writeUnsignedInt(line.skindata.lineColor);
					
					hasLine=true;
				}
				
				
				if(hasLine){
					
					originBytes.position=0;
					
					originBytes.writeInt(left);
					originBytes.writeInt(top);
					originBytes.writeInt(right);
					originBytes.writeInt(buttom);
					
					var spt:Point=new Point(0,0);
					
					var ept:Point=new Point(GlobalLayoutManager.StageWidth,GlobalLayoutManager.StageHeight);
					
					spt=FreePlate.plate.globalToLocal(spt);
					ept=FreePlate.plate.globalToLocal(ept);
					
					originBytes.writeInt(Math.max(left,spt.x));
					originBytes.writeInt(Math.max(top,spt.y));
					originBytes.writeInt(Math.min(right,ept.x));
					originBytes.writeInt(Math.min(buttom,ept.y));
					
					drawMutex.unlock();
					
					mainToWorker.send("refresh");
					
				}else{
					drawMutex.unlock();
				}
				
			}
		}
	}
}