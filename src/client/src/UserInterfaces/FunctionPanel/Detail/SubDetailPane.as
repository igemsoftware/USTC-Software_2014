package UserInterfaces.FunctionPanel.Detail
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import GUI.Assembly.FlexibleWidthObject;
	import GUI.Assembly.HitBox;
	import GUI.RichGrid.RichGrid;
	
	public class SubDetailPane extends Sprite implements FlexibleWidthObject
	{
		
		private var back:HitBox=new HitBox();
		
		public var Height:int;
		
		private var grid:RichGrid=new RichGrid(false,true,false,false,true);
		
		public function SubDetailPane(tar)
		{
			
			addChild(grid);
			
			grid.addEventListener("redrawed",function (e):void{
				dispatchEvent(new Event("redrawed"));
			});
			
			setContent(tar);
			
		}
		
		
		public function setContent(tar):void{
			
			
			var t:Array=[];
			var tmpJson:Object=tar.detail;
			for (var s:String in tmpJson) {
				if(s!="NAME"&&s!="TYPE"&&s!="Description"){
					t.push({Feature:s,Description:tmpJson[s]});
				}
			}
			grid.columns=["Feature","Description"];
			grid.dataProvider=t;
			grid.columnWidths=[200,200];
		}
		
		public function setSize(w:Number):void
		{
			
			grid.setSize(w);
			Height=grid.Height;
			
		}
		
	}
}