package Assembly.Compressor{
	import flash.display.BitmapData;
	
	
	public class BitMapGraphics extends BitmapData {
		public function BitMapGraphics(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
		
		public function drawLine(sx,sy,ex,ey,w=1,RGBcolor=0xffffff):void{
			
			var dxy:int,dxx:Number,dyy:Number;

			dxy=Math.max(Math.abs(sy-ey),Math.abs(sx-ex));
			dyy=(ey-sy)/dxy;
			dxx=(ex-sx)/dxy;
			
			for (var i:int = 0; i < w; i++) {
				
				for (var ai:Number = sx,aj:Number = sy; Math.abs(ai-ex)>2||Math.abs(aj-ey)>2; ai+=dxx,aj+=dyy) {
					this.setPixel32(ai,aj,0xff000000+RGBcolor);
				}
			}
	
		}
		
	}
}