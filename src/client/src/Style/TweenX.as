package Style{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	

	import Layout.Sorpotions.Navigator;
	
	import Assembly.Canvas.I3DPlate;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	
	public class TweenX {
		
		private static var AniProcessor:Sprite=new Sprite();
		
		private static var AniList:Array=[];
		
		
		private static const SPF:int=25;
		private static const DPF:Number=0.75;
		
		private static const VPT:Number=Math.pow(DPF,1/SPF);
		private static var AniBufferNum:int=0;
		private static var runtime:int;
		
		public static function GlideNode(tar:CompressedNode,toPreExpand=false):void{
			if(	AniList[tar.ID]==null){
				AniList[tar.ID]=tar;
				AniBufferNum++;
				//trace("[TweenX]:Current Animation:",AniBufferNum);
				if(!AniProcessor.hasEventListener(Event.ENTER_FRAME)){
					runtime=getTimer();
					AniProcessor.addEventListener(Event.ENTER_FRAME,gliding);
				}
				Net.LineSpace.pickMultiLines(tar.Arrowlist);
			}
		}
		
		public static function GlideNodes(arr:Array,toPreExpand=false):void{
			for each (var node:CompressedNode in arr) 
			{
				if(	AniList[node.ID]==null){
					AniList[node.ID]=node;
					AniBufferNum++;
					//trace("[TweenX]:Current Animation:",AniBufferNum);
					if(!AniProcessor.hasEventListener(Event.ENTER_FRAME)){
						runtime=getTimer();
						AniProcessor.addEventListener(Event.ENTER_FRAME,gliding);
					}
					Net.LineSpace.pickMultiLines(node.Arrowlist);
				}
			}

		}
		
		private static function gliding(event:Event):void{
			
			var cmpList:Array=[];
			
			var arrow:CompressedLine;
			var ct:int=getTimer();
			
			var t:int=ct-runtime;
			
			runtime=ct;
			
			var d:Number=Math.pow(VPT,t);
			
			Net.BlockSpace.removeMultiChild(AniList);
			
			for each (var node:CompressedNode in AniList) {
				
				node.Position[0]=node.Position[0]*d+node.aimPosition[0]*(1-d);
				node.Position[1]=node.Position[1]*d+node.aimPosition[1]*(1-d);	
				
				if (Math.abs(node.Position[0]-node.aimPosition[0])<1&&Math.abs(node.Position[1]-node.aimPosition[1])<1) {
					node.Position[0]=node.aimPosition[0];
					node.Position[1]=node.aimPosition[1];	
					
					cmpList.push(node);
					delete AniList[node.ID];
					AniBufferNum--;
					//trace("[TweenX]:Current Animation:",AniBufferNum);
				}
				
				node.x=node.Position[0]*I3DPlate.scaleXY;
				node.y=node.Position[1]*I3DPlate.scaleXY;
				
				if(node.Instance!=null){
					with(node.Instance){
						x=node.x;
						y=node.y;
						
						if (focusCircle!=null) {
							focusCircle.x=x;
							focusCircle.y=y;
						}
					}
				}
				for each(arrow in node.Arrowlist) {
					arrow.setLine();
				}
			}
			
			Net.LineSpace.flushPickedLines();
			Net.BlockSpace.AddMulitCompressedChild(AniList);
			Net.BlockSpace.AddMulitCompressedChild(cmpList);
			
			if(AniBufferNum==0){
				AniProcessor.removeEventListener(Event.ENTER_FRAME,gliding);
				Navigator.refreshMap();
				Net.LineSpace.placePickedLines()
			}
		}
	}
}