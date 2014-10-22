package UserInterfaces.FunctionPanel.KShortest{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	import Kernel.SmartCanvas.CompressedNode;
	
	import UserInterfaces.FunctionPanel.NodeSampler;
	import UserInterfaces.Style.FontPacket;
	
	
	
	public class KShortestNodePreviewer extends Sprite{
		
		public var aimX:Number;
		
		private var displayBoard:SkinBox=new SkinBox();
		
		public var node1:NodeSampler,node2:NodeSampler;
		
		private var a1:Icon_Asker=new Icon_Asker();
		private var a2:Icon_Asker=new Icon_Asker();
		
		private var dg:LabelTextField=new LabelTextField("Search route: ");
		private var shint1:LabelTextField=new LabelTextField("Click to select node");
		private var shint2:LabelTextField=new LabelTextField("Click to select node");
		
		private var banner:Kshortest=new Kshortest();
		private var Width:int;
		
		private var dx:int=10;
		
		
		public function KShortestNodePreviewer(){
			
			addChild(displayBoard);	
			
			addChild(banner);
			
			addChild(dg);
			addChild(shint1);
			addChild(shint2);
			
			addChild(a1);
			addChild(a2);
			
			dg.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			dg.text="Search route: ";
			
			dg.y=40;
			
			dg.x=3;
			
			a1.addEventListener(MouseEvent.CLICK,function (e):void{
				dispatchEvent(new Event("PickNode1"));
			});
			
			a2.addEventListener(MouseEvent.CLICK,function (e):void{
				dispatchEvent(new Event("PickNode2"));
			});
			
		}
		public function GiveNode1(n1:CompressedNode=null):void{
			if(node1!=null&&contains(node1)){
				removeChild(node1)
			}
			if(n1!=null){
				node1=new NodeSampler(n1.Name,n1.Type.Type,n1.ID);
				addChild(node1);
				a1.visible=false;
				shint1.visible=false;
			}else{
				a1.visible=true;
				shint1.visible=true;
			}
			if(node1!=null){
				node1.x=Width/2-105-dx;
				node1.y=-5;
				
				
			}
		}
		public function GiveNode2(n2:CompressedNode=null):void{
			if(node2!=null&&contains(node2)){
				removeChild(node2)
			}
			if(n2!=null){
				node2=new NodeSampler(n2.Name,n2.Type.Type,n2.ID);
				addChild(node2);
				a2.visible=false;
				shint2.visible=false;
			}else{
				a2.visible=true;
				shint2.visible=true;
			}
			if(node2!=null){
				node2.y=-5
				node2.x=Width/2+105-dx;
			}
		}
		
		public function setSize(w:Number):void{
			Width=w;
			banner.y=55;
			banner.x=w/2-dx;
			displayBoard.setSize(w,115);
			a2.y=a1.y=55;
			a1.x=Width/2-105-dx;
			a2.x=Width/2+105-dx;
			
			shint1.x=a1.x-shint1.width/2;
			shint2.x=a2.x-shint2.width/2;
			shint2.y=shint1.y=115-24;
		}
	}
}