package IgemPartAPI{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Assembly.Canvas.Net;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	
	
	public class MultiNodePreviewer extends Sprite{
		
		public var aimX:Number;
		
		private var displayBoard:SkinBox=new SkinBox();
		
		
		private var _id:String,_nam:String,_tp:String;
		
		private var nodes:Array=[]
		
		private var Error_Value:LabelTextField=new LabelTextField("Error Value :");
		
		private var dg:LabelTextField=new LabelTextField("Results :");
		
		private var No_res_hint:LabelTextField=new LabelTextField("No result");
		
		
		public function MultiNodePreviewer(){
			
			addChild(displayBoard);	
			
			addChild(Error_Value);
			
			addChild(dg);
			
			addChild(No_res_hint);
			
			dg.y=50;
			
			dg.x=3;
			
			No_res_hint.y=50
			No_res_hint.x=80;
			
			No_res_hint.visible=false;
			
			Error_Value.x=3
			
		}
		public function GiveNodes(arr:Array):void{
			nodes=[];
			if(arr.length==0){
				No_res_hint.visible=true;
			}else{
				No_res_hint.visible=false;
				for (var i:int = 0; i < arr.length; i++) {
					nodes.push(new BlastResult(arr[i].NAME,arr[i].TYPE,arr[i].id,arr[i].evalue));
				}
			}
			redraw();
		}
		
		public function clear():void{
			removeChildren(4);
			No_res_hint.visible=false;
		}
		public function setSize(w:Number):void{
			displayBoard.setSize(w,115);
		}
		public function redraw():void{
			removeChildren(4);
			for (var i:int = 0; i < nodes.length; i++) 
			{
				var node:BlastResult=nodes[i];
				addChild(node);
				
				node.addEventListener(MouseEvent.MOUSE_DOWN,function (e:MouseEvent):void{
					e.stopPropagation();
					Net.addBlock(e.currentTarget.ID,e.currentTarget.Name,e.currentTarget.Type);
				})
				
				nodes[i].y=0;
				nodes[i].x=i*80+120;
			}
		}
	}
}