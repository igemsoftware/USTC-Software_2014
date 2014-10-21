package Assembly.Compressor{
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	
	public class Compressor extends Sprite {
		
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		protected var originBytes:ByteArray;
		protected var returnImage:ByteArray;
		
		protected var _data:BitMapGraphics;
		
		private var drawMutex:Mutex;
		private var returnMutex:Mutex;
		
		public function Compressor(){
			mainToWorker= Worker.current.getSharedProperty("mainToLinePicker");
			workerToMain = Worker.current.getSharedProperty("LinePickerToMain");
			
			originBytes=Worker.current.getSharedProperty("LinePicker_originBytes");
			returnImage=Worker.current.getSharedProperty("LinePicker_imageBytes");
			
			drawMutex=Worker.current.getSharedProperty("LinePicker_drawMutex");
			returnMutex=Worker.current.getSharedProperty("LinePicker_returnMutex");
			
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE,onMainToWorker);
		}
		protected function onMainToWorker(event:Event):void
		{
			// TODO Auto-generated method stub
			var msg:*= mainToWorker.receive();
			//	trace("[Compressor]:receive",msg)
			if(msg=="refresh"){
				drawMutex.lock();
				
				originBytes.position=0;
				
				var left:int=originBytes.readInt();
				var top:int=originBytes.readInt();
				var right:int=originBytes.readInt();
				var buttom:int=originBytes.readInt();
				
				_data=new BitMapGraphics(right-left+1,buttom-top+1,true,0);
				
				_data.lock();
				
				while (originBytes.bytesAvailable>0) {
					_data.drawLine(originBytes.readInt()-left,originBytes.readInt()-top,originBytes.readInt()-left,originBytes.readInt()-top,1,originBytes.readUnsignedInt());
				}
				
				_data.unlock();
				
				drawMutex.unlock();
				
				//			trace("[Compressor]:Draw Complete")
				
				returnMutex.lock();
				
				returnImage.length=0;
				
				returnImage.writeInt(left);
				
				returnImage.writeInt(top);
				
				returnImage.writeInt(_data.width);
				
				returnImage.writeInt(_data.height);
				
				_data.copyPixelsToByteArray(_data.rect,returnImage);
				
				//			trace("[Compressor]:Copy Complete")
				
				returnMutex.unlock();
				
				workerToMain.send("DrawComplete");
			}
		}
	}
}