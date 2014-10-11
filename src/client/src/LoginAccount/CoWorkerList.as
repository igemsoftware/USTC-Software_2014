package LoginAccount
{
	import flash.display.Sprite;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import GUI.FlexibleLayoutObject;
	import GUI.Assembly.ContainerBox;
	import GUI.Assembly.SkinBox;
	import GUI.Scroll.Scroll;
	
	public class CoWorkerList extends Sprite implements FlexibleLayoutObject{
		
		private var Align:int=5;
		
		private var back:SkinBox=new SkinBox();
		private var workerSpace:Array=[];
		private var scroller:ContainerBox=new ContainerBox();
		private var scroll:Scroll=new Scroll(scroller);
		private var Width:Number;
		private var Height:Number;
		
		public function CoWorkerList(){
			
			addChild(back);
			addChild(scroll);
			

		}
		
		
		public function flushWorkerList():void{
			
			workerSpace=[];
			for (var i:int = 0; i < ProjectManager.co_works.length; i++){
				var cw:CoWorkerInfo=new CoWorkerInfo(CoWorkerInfo.NONE,ProjectManager.co_works[i])
				workerSpace.push(cw);
			}
			
			Height=Math.min(ProjectManager.co_works.length*65+5,400-y);
			
			back.setSize(Width,Height);
			scroll.setSize(Width,Height);
			
			redraw();
		}
		
		private function redraw():void
		{
			scroller.removeChildren();
			for (var i:int = 0; i < workerSpace.length; i++) 
			{
				workerSpace[i].x=Align;
				
				workerSpace[i].y=i*65+5;
				
				workerSpace[i].setSize(Width-10);
				
				scroller.addChild(workerSpace[i]);
				
			}
			
			scroller.setSize(Width,workerSpace.length*65+5);
			scroll.negativeRedraw();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			Height=Math.min(ProjectManager.co_works.length*65+5,400-y);
			Width=w;
			
			back.setSize(Width,h);
			scroll.setSize(Width,h);
			
			redraw();
			
		}
		
	}
}

