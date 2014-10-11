package KShortest{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	import IgemPartAPI.BlastResult;
	
	import Style.FontPacket;
	
	
	
	public class KShortestNodePreviewer extends Sprite{
		
		public var aimX:Number;
		
		private var displayBoard:SkinBox=new SkinBox();
		
		public var node1:BlastResult,node2:BlastResult;
		
		private var a1:Icon_Asker=new Icon_Asker();
		private var a2:Icon_Asker=new Icon_Asker();
		
		private var dg:LabelTextField=new LabelTextField("Search route: ");
		private var shint:LabelTextField=new LabelTextField("Select two nodes from project to search");
		
		private var banner:Kshortest=new Kshortest();
		private var Width:int;
		
		private var dx:int=10;
		
		
		public function KShortestNodePreviewer(){
			
			addChild(displayBoard);	
			
			addChild(banner);
			
			addChild(dg);
			addChild(shint);
			
			addChild(a1);
			addChild(a2)
			
			dg.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			dg.text="Search route: ";
			
			dg.y=40;
			
			dg.x=3;
			
		}
		public function GiveNodes(n1:CompressedNode=null,n2:CompressedNode=null):void{
			if(node1!=null&&contains(node1)){
				removeChild(node1)
			}
			if(n1!=null){
				node1=new BlastResult(n1.Name,n1.Type.Type,n1.ID);
				addChild(node1);
				shint.visible=false;
			}else{
				
				shint.visible=true;
			}
			if(node2!=null&&contains(node2)){
				removeChild(node2)
			}
			if(n2!=null){
				node2=new BlastResult(n2.Name,n2.Type.Type,n2.ID);
				addChild(node2);
			}
			if(node1!=null){
				node1.x=Width/2-105-dx;
				node1.y=-5;
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
			
			shint.y=115-24;
			shint.x=w/2-shint.width/2-dx;
		}
	}
}