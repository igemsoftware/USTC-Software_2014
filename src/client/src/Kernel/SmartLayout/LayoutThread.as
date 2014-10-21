package Kernel.SmartLayout{
	import flash.concurrent.Mutex;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	
	public class LayoutThread extends Sprite {
		
		
		private var sendMutex:Mutex=new Mutex();
		private var receiveMutex:Mutex=new Mutex();
		
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		
		private var layout_send_bytes:ByteArray;
		private var layout_receive_bytes:ByteArray;
		
		public function LayoutThread()
		{
			
			sendMutex=Worker.current.getSharedProperty("LayoutRunner_SendMutex");
			receiveMutex=Worker.current.getSharedProperty("LayoutRunner_returnMutex");
			
			layout_send_bytes=Worker.current.getSharedProperty("LayoutRunner_Send");
			layout_receive_bytes=Worker.current.getSharedProperty("LayoutRunner_Receive");
			
			mainToWorker= Worker.current.getSharedProperty("mainToBackStage");
			workerToMain = Worker.current.getSharedProperty("BackStageToMain");
			
			mainToWorker.addEventListener(Event.CHANNEL_MESSAGE,onMainToWorker);
					
		}
		
		protected function onMainToWorker(event:Event):void
		{
			while(true){
				var msg:*= mainToWorker.receive(true);
				
				cul_thread();
				
			}
		}
		
		
		protected function cul_thread():void{
			var Force:Object=new Object;
			
			var ref_Nodes:Object= new Object();
			var Nodes:Vector.<Object> = new Vector.<Object>();
			var Lines:Vector.<Object> = new Vector.<Object>();
			
			var id:String,id1:String,id2:String,px:Number,py:Number;
			
			sendMutex.lock();
			
			layout_send_bytes.position=0;
			
			while(true){
				id=layout_send_bytes.readUTF();
				
				if(id=="LINE")break;
				
				px=layout_send_bytes.readDouble();
				py=layout_send_bytes.readDouble();
				
				ref_Nodes[id]={ID:id,x:px,y:py};
				Nodes.push(ref_Nodes[id]);
				Force[id]={x:0,y:0};
			}
			
			while(layout_send_bytes.bytesAvailable>0){
				id=layout_send_bytes.readUTF();
				
				id1=layout_send_bytes.readUTF();
				id2=layout_send_bytes.readUTF();
				
				Lines.push({node1:ref_Nodes[id1],node2:ref_Nodes[id2]});
				
			}
			
			layout_send_bytes.length=0;
			
			sendMutex.unlock();
			
			
			var time:int=getTimer();
			
			var k:Number=0.1;
			var q:Number=200000;
			var i:int=0,j:int=0,t:int=0,fx:Number,fy:Number;
			
			var dx:Number,dy:Number,d:Number;
			
			var node1:Object,node2:Object;
			
			for (t=0; t < 50; t++){
				
				for each (var force:Object in Force)
				{
					force.x=0;
					force.y=0;
				}
				
				for (i=0;  i< Nodes.length;i ++){
					
					node1=Nodes[i];
					
					for (j = i+1; j < Nodes.length; j++){
						
							node2=Nodes[j];

							dx=node1.x - node2.x;
							dy=node1.y - node2.y;
							d=Math.sqrt(dx*dx + dy*dy);
							
							var d3:Number=q/d/d/d;
							
							fx=dx*d3;
							fy=dy*d3;
							
							Force[node1.ID].x+=fx;
							Force[node1.ID].y+=fy;
							
							Force[node2.ID].x-=fx;
							Force[node2.ID].y-=fy;

					}
				}
				
				for each (var link:Object in Lines) 
				{
					dx=link.node1.x - link.node2.x;
					dy=link.node1.y - link.node2.y;
					
					fx=k * dx;
					fy=k * dy;
					
					
					Force[link.node1.ID].x-=fx;
					Force[link.node1.ID].y-=fy;
					Force[link.node2.ID].x+=fx;
					Force[link.node2.ID].y+=fy;
				}
				
				for each (var node:Object in Nodes)
				{
					Force[node.ID].x>0?node.x+=10*Math.log(Force[node.ID].x/10+1):node.x+=-10*Math.log(-Force[node.ID].x/10+1);
					Force[node.ID].y>0?node.y+=10*Math.log(Force[node.ID].y/10+1):node.y+=-10*Math.log(-Force[node.ID].y/10+1);
				}
			}
			
			trace("[Layout]:Calculation Complete. Time taking:",getTimer()-time);
			
			receiveMutex.lock();
			
			layout_receive_bytes.length=0;
			
			for each (node1 in Nodes)	{
				layout_receive_bytes.writeUTF(node1.ID);
				layout_receive_bytes.writeDouble(node1.x);
				layout_receive_bytes.writeDouble(node1.y);
			}
			
			receiveMutex.unlock();
			
			workerToMain.send("Complete");
			
		}
	}
}