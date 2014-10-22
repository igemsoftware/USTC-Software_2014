package Dock{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Biology.NodeTypeInit;
	import Biology.TypeEditor.NodeSample;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	import Assembly.Canvas.Net;
	
	public class NodePreviewer extends Sprite{
		
		public const W:int=120,H:int=130;
		
		public var aimX:Number;
		
		private var displayBoard:SkinBox=new SkinBox(W,H);
		private var _sample:NodeSample=new NodeSample();
		
		private var _id:String,_nam:String,_tp:String;
		
		private var label:LabelTextField=new LabelTextField("Add to Net");
		private var label2:LabelTextField=new LabelTextField("");
		
		public function NodePreviewer(){
			
			label.x=W/2-label.width/2;
			label.y=5;
			
			_sample.x=W/2;
			_sample.y=H/2+5;
			
			addChild(displayBoard);
			addChild(_sample);
			addChild(label);
			addChild(label2);
			
			_sample.addEventListener(MouseEvent.MOUSE_DOWN,function (e):void{
				e.stopPropagation();
				Net.addBlock(_id,_nam,_tp);
				dispatchEvent(new Event("close"));
			})
		}
		public function GiveNode(id:String,nam:String,tp:String):void{
			_tp=tp;
			_nam=nam;
			_id=id;
			label2.text=nam;
			label2.x=W/2-label2.width/2;
			_sample.showSample(NodeTypeInit.BiotypeList[tp]);
			label2.y=_sample.y+_sample.height/2+2;
		}
	}
}