package Assembly
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class BioGroup extends Sprite{
		
		public var Surrounding:Shape=new Shape();
		
		public var GroupList:Array=new Array();
		
		
		public var Folded:Boolean=false;
		
		public function BioGroup(){
			
		}
		public function Include(Group):void{
			GroupList=Group;
			redraw();
		}
		public function redraw():void{
			
			Surrounding.graphics.clear();
			
			if (Folded) {
				
			}else{
				Surrounding.graphics.lineStyle(7,0xff33ff);
				
				//////Surround
				Surrounding.graphics.moveTo(GroupList[0].x,GroupList[0].y);
				for (var i:int=1;i<GroupList.length;i++){
					Surrounding.graphics.lineTo(GroupList[i].x,GroupList[i].y);
				}
				/////////
				
			}
		}
	}
}