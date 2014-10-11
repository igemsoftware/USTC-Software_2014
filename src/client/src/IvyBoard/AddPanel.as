package IvyBoard
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Biology.NodeTypeInit;
	
	import GUI.SampleSheet;
	
	import Assembly.Canvas.Net;

	public class AddPanel extends Sprite
	{
		
		private var Sheet:SampleSheet=new SampleSheet(200);
		
		public function AddPanel()
		{
			Sheet.iconField=NodeTypeInit.BiotypeIndexList;
			addChild(Sheet);
			Sheet.addEventListener(MouseEvent.MOUSE_DOWN,function (e:MouseEvent):void{
				e.stopPropagation();
				stage.dispatchEvent(new Event("hideBoard"));
				Net.addBlock("","",Sheet.SelectedItem.Type);
			})
			
			GlobalVaribles.eventDispatcher.addEventListener("SampleRedraw",function (e):void{Sheet.redraw()});
		}
		public function setSize(w):void{
			Sheet.setSize(w);
		}
	}
}