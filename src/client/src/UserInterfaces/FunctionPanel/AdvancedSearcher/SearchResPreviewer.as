package UserInterfaces.FunctionPanel.AdvancedSearcher{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	import Kernel.Biology.NodeTypeInit;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.FunctionPanel.NodeSampler;
	import UserInterfaces.FunctionPanel.TypeEditor.NodeSample;
	
	/**
	 * search result previewer
	 */
	public class SearchResPreviewer extends Sprite{
		
		private var displayBoard:SkinBox=new SkinBox();
		
		private var _id:String,_nam:String,_tp:String;
		
		public var _text:LabelTextField=new LabelTextField("");

		
		private var sampNode:NodeSample=new NodeSample();
		
		private var dg:LabelTextField=new LabelTextField("Import :");
		
		
		public function SearchResPreviewer(){
			
			addChild(displayBoard);	
			
			addChild(dg);
			
			addChild(_text);
			
			addChild(sampNode);
			
			dg.y=28;
			
			dg.x=3;
			
			sampNode.x=100;
			sampNode.y=40;
			
			_text.x=140;
			_text.multiline=true;
			_text.wordWrap=true;
			
			sampNode.addEventListener(MouseEvent.MOUSE_DOWN,function (e:MouseEvent):void{
				e.stopPropagation();
				Net.addNode(_id,_nam,_tp);
			})
			
		}
		/**
		 * give the sample node
		 */
		public function GiveNode(node):void{

			sampNode.showSample(NodeTypeInit.BiotypeList[node.Type]);
			_text.text=node.Type+" : "+node.Name;
			
			_text.y=40-_text.height/2;
			
			_id=node.id;
			_nam=node.Name;
			_tp=node.Type;
		}
		/**
		 * redraw
		 */
		public function setSize(w:Number):void{
			
			_text.width=w-_text.x-5;
			displayBoard.setSize(w,80);
		}
	}
}