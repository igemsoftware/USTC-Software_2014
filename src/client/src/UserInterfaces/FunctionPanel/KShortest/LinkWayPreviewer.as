package UserInterfaces.FunctionPanel.KShortest{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Kernel.SmartCanvas.Canvas.Net;
	import Kernel.ExpandThread.ExpandManager;
	import Kernel.ProjectHolder.GxmlContainer;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.FunctionPanel.NodeSampler;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.ReminderManager.ReminderManager;
	
	import UserInterfaces.Style.FontPacket;
	
	/**
	 * to preview the linked way
	 */
	public class LinkWayPreviewer extends Sprite{
		
		public var aimX:Number;
		
		private var LoadLinkWay_b:RichButton=new RichButton();
		
		private var displayBoard:SkinBox=new SkinBox();
		
		
		private var _id:String,_nam:String,_tp:String;
		
		private var nodes:Array=[]
		
		private var dg:LabelTextField=new LabelTextField("Route :");
		private var Width:Number;
		
		/**
		 * to preview the linked way
		 */
		public function LinkWayPreviewer(){
			
			addChild(displayBoard);	
			
			addChild(dg);
			
			addChild(LoadLinkWay_b);
			
			LoadLinkWay_b.label="Import Route"
			
			LoadLinkWay_b.setSize(120,30);
			
			dg.defaultTextFormat=FontPacket.WhiteMediumTitleText;
			
			dg.text="Route :";
			
			dg.x=5;
			dg.y=5;
			
			dg.visible=false;
			
			LoadLinkWay_b.addEventListener(MouseEvent.CLICK,LoadRoute_evt);
			
		}
		/**
		 * the event to load the route
		 */
		protected function LoadRoute_evt(event:MouseEvent):void
		{
			if(GxmlContainer.Node_Space[nodes[0].ID]!=null&&GxmlContainer.Node_Space[nodes[nodes.length-1].ID]!=null){
				
				var sx:Number=GxmlContainer.Node_Space[nodes[0].ID].Position[0];
				var sy:Number=GxmlContainer.Node_Space[nodes[0].ID].Position[1];
				
				var ex:Number=GxmlContainer.Node_Space[nodes[nodes.length-1].ID].Position[0];
				var ey:Number=GxmlContainer.Node_Space[nodes[nodes.length-1].ID].Position[1];
				
				var dx:Number=(ex-sx)/(nodes.length-1);
				var dy:Number=(ey-sy)/(nodes.length-1);
				
				for (var i:int = 1; i < nodes.length-1; i++) {
					ExpandManager.Expand(Net.loadCompressedBlock(nodes[i].ID,"",nodes[i].Name,sx+dx*i,sy+dy*i,nodes[i].Type),ExpandManager.LINKLINES);
				}
			}else{
				ReminderManager.remind("Import failed because the edges no longer exist");
			}
		}
		/**
		 * give the n nodes
		 * @param arr the array which saves the nodes
		 */
		public function GiveNodes(arr:Array):void{
			nodes=[];
			for (var i:int = 0; i < arr.length; i++) {
				nodes.push(new NodeSampler(arr[i].NAME,arr[i].TYPE,arr[i]._id));
			}
			dg.visible=true;
			LoadLinkWay_b.visible=true;
			redraw();
		}
		/**
		 * clear all
		 */
		public function clear():void{
			graphics.clear();
			removeChildren(3);
			dg.visible=false;
			LoadLinkWay_b.visible=false;
		}
		public function setSize(w:Number):void{
			Width=w;
			displayBoard.setSize(w,140);
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w,5,5,LoadLinkWay_b);
		}
		public function redraw():void{
			graphics.clear();
			graphics.lineStyle(3,0xffffff);
			removeChildren(3);
			var dw:int=(Width-70)/(nodes.length-1);
			for (var i:int = 0; i < nodes.length; i++) 
			{
				var node:NodeSampler=nodes[i];
				addChild(node);
				
				node.addEventListener(MouseEvent.MOUSE_DOWN,function (e:MouseEvent):void{
					e.stopPropagation();
					Net.addNode(e.currentTarget.ID,e.currentTarget.Name,e.currentTarget.Type);
				})
				
				nodes[i].y=20;
				nodes[i].x=dw*i+35;
				
				if(i == nodes.length-1)break;
				
				graphics.moveTo(nodes[i].x+40,80);
				graphics.lineTo(nodes[i].x+dw-40,80);
			}
		}
	}
}