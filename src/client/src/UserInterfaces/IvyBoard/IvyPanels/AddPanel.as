package UserInterfaces.IvyBoard.IvyPanels
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Kernel.Biology.NodeTypeInit;
	
	import GUI.Assembly.SampleSheet;
	
	import Kernel.SmartCanvas.Canvas.Net;

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
				Net.addNode("","",Sheet.SelectedItem.Type);
			})
			
			GlobalVaribles.FocusEventDispatcher.addEventListener("SampleRedraw",function (e):void{Sheet.redraw()});
		}
		public function setSize(w):void{
			Sheet.setSize(w);
		}
	}
}