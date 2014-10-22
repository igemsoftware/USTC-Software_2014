package GUI.Assembly{
	import flash.display.Sprite;
	
	public class ContainerBox extends Sprite{
		
		public var Width:int,Height:int;
		
		public function ContainerBox(w=100,h=100){
			setSize(w,h);
		}
		
		public function setSize(w:Number,h:Number=0):void{
			if(h==0){
				h=Height
			}else{
				Height=h;
			}
			Width=w;
			
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
}