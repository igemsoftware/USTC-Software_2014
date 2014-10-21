package UserInterfaces.Sorpotions{
	import flash.concurrent.Mutex;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	
	public class NavigatorTrackingThread extends Sprite{
		
		protected var image:BitmapData;
			
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		
		protected var drawData:ByteArray;
	
		protected var returnImage:ByteArray;
		
		private var drawMutex:Mutex;
		private var returnMutex:Mutex;
		
		public function NavigatorTrackingThread()
		{
			mainToWorker= Worker.current.getSharedProperty("mainToNavigator");
			workerToMain = Worker.current.getSharedProperty("NavigatorToMain");
			
			drawData=Worker.current.getSharedProperty("Navigator_originBytes");
			returnImage=Worker.current.getSharedProperty("Navigator_imageBytes");
			
			drawMutex=Worker.current.getSharedProperty("Navigator_drawMutex");
			returnMutex=Worker.current.getSharedProperty("Navigator_returnMutex");
			
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE,onMainToWorker);
			
		}
		
		protected function onMainToWorker(event:Event):void
		{
			// TODO Auto-generated method stub
			var msg:*= mainToWorker.receive();
	//		trace("[Navigator]:receive",msg)
			if(msg=="refresh"){
				refreshCycle();
			}else if(msg=="Generate"){
				refreshCycle(true);
			}
		}
		
		private function refreshCycle(g:Boolean=false):void{
			drawMutex.lock();
			
			drawData.position=0;
			
			if(drawData.bytesAvailable>0){
				
				var w:Number=drawData.readInt();
				var h:Number=drawData.readInt();
				var dx:Number=drawData.readDouble();
				var dy:Number=drawData.readDouble();
				var scale:Number=drawData.readDouble();
				var links:int=drawData.readInt();
				
				//trace("[NavigatorThread]:header",w,h,dx,dy,scale);
				var image:BitmapData=new BitmapData(w,h,true,0);
				
				image.lock();
				
				var sx:int,sy:int,ex:int,ey:int,dxy:int,dxx:Number,dyy:Number;
				for(var ci:int=0;ci<links&&drawData.bytesAvailable>0;ci++){
					sx=int((drawData.readInt()-dx)*scale)+2;
					sy=int((drawData.readInt()-dy)*scale)+2;
					ex=int((drawData.readInt()-dx)*scale)+2;
					ey=int((drawData.readInt()-dy)*scale)+2;
					color=drawData.readUnsignedInt();
					
					dxy=Math.max(Math.abs(sy-ey),Math.abs(sx-ex));
					dyy=(ey-sy)/dxy;
					dxx=(ex-sx)/dxy;
					
					for (var ai:Number = sx,aj:Number = sy; Math.abs(ai-ex)>2||Math.abs(aj-ey)>2; ai+=dxx,aj+=dyy) {
						image.setPixel32(ai,aj,0xff000000+color);
					}
				}
				
				var px:int,py:int,color:uint
				while(drawData.bytesAvailable>0){
					px=int((drawData.readInt()-dx)*scale);
					py=int((drawData.readInt()-dy)*scale);
					color=drawData.readUnsignedInt();
					for (var i:int = 0; i <5; i++) {
						for (var j:int = 0; j < 5; j++) {
							image.setPixel32(px+i,py+j,0xff000000+color);
						}
					}
				}
				
				image.unlock();
				
				drawMutex.unlock();
				
				returnMutex.lock();
				
				returnImage.length=0;
				
			//	trace("[Thread]:Copying byteArray");
				
				returnImage.writeInt(w);
				
				returnImage.writeInt(h);
				
				image.copyPixelsToByteArray(image.rect,returnImage);
				
				returnMutex.unlock();
				
			//	trace("[Thread]:unlock return");
				if(g){
					workerToMain.send("GenerateComplete");
				}else{
					workerToMain.send("DrawComplete");
				}
				
			}
		}
	}
}