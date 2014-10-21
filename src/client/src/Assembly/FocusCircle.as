package Assembly
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	

	public class FocusCircle extends Sprite{
		
		private var cirileShape:Shape=new Shape();
		
		public function FocusCircle(r){
			cacheAsBitmap=true;
			redraw(r);
			addChild(cirileShape);
			addEventListener(Event.ENTER_FRAME,cyc);
		}
		
		protected function cyc(event:Event):void{
			cirileShape.rotation+=1.5;
		}
		public function redraw(r):void{
			var dceta:Number=2/r;
			var dc:Number=Math.floor(Math.PI*r*2/15/2)*2;
			var ceta:Number=2*Math.PI/dc;
			var tceta:Number=ceta/dceta;
			cirileShape.graphics.clear();
			cirileShape.graphics.lineStyle(2,0xffff00);
			for (var i:int = 0; i < dc; i+=2) {
				cirileShape.graphics.moveTo(r*Math.cos(ceta*i),r*Math.sin(ceta*i));
				for (var j:int = 0; j < tceta; j++) {
					cirileShape.graphics.lineTo(r*Math.cos(ceta*i+dceta*j),r*Math.sin(ceta*i+dceta*j));
				}
			}
		}
	}
}