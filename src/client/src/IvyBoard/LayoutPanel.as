package IvyBoard
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Assembly.BioParts.BioBlock;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import GUI.Assembly.LabelTextField;
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;
	
	import SmartLayout.LayoutRunner;
	
	import Style.TweenX;
	
	public class LayoutPanel extends Sprite
	{
		
		public var Height:int=200;
		private var Width:Number;
		
		private var Align_left:RichButton=new RichButton(RichButton.LEFT_EDGE);
		private var Align_center:RichButton=new RichButton(RichButton.MIDDLE);
		private var Align_right:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		private var Align_up:RichButton=new RichButton(RichButton.LEFT_EDGE);
		private var Align_center2:RichButton=new RichButton(RichButton.MIDDLE);
		private var Align_down:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		private var Interval_x:RichButton=new RichButton(RichButton.LEFT_EDGE);
		private var Interval_y:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		private var even_align:RichButton=new RichButton(RichButton.MIDDLE);
		
		private var Mag:RichButton=new RichButton(RichButton.LEFT_EDGE);
		private var round:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		//private var _align:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		private var HintLabel:LabelTextField=new LabelTextField("Select Nodes to fit layout");
		private var globalLayouHint:LabelTextField=new LabelTextField("Apply Global Layout");
		
		
		public function LayoutPanel()
		{
			
			Align_left.setIcon(icon_align_left);
			Align_left.tabIndex=1;
			Align_right.setIcon(icon_align_left, true);
			Align_right.tabIndex=2;
			Align_center.setIcon(icon_align_Center, false, false, 90);
			Align_center.tabIndex=3;
			
			Align_up.setIcon(icon_align_left, false, false, 90);
			Align_up.tabIndex=4;
			Align_down.setIcon(icon_align_left, true, false, 90);
			Align_down.tabIndex=5;
			Align_center2.setIcon(icon_align_Center, false, false);
			Align_center2.tabIndex=6;
			
			Interval_x.setIcon(Icon_rangeX);
			Interval_x.tabIndex=1;
			Interval_y.setIcon(Icon_rangeX, false, false, 90);
			Interval_y.tabIndex=2;
			even_align.setIcon(Icon_grid);
			
			Mag.setIcon(Icon_Align_Mag);
			Mag.tabIndex=1;
			round.setIcon(Icon_Cricle);
			round.tabIndex=2;
			//_align.setIcon(Icon_grid);
			
			LayoutManager.UnifyScale(50, 40, Align_left, Align_center, Align_center2, Align_down, Align_right, Align_up, Interval_x, Interval_y, even_align,Mag,round)
			
			
			Align_left.addEventListener(MouseEvent.CLICK, align);
			Align_right.addEventListener(MouseEvent.CLICK, align);
			Align_center.addEventListener(MouseEvent.CLICK, align);
			Align_up.addEventListener(MouseEvent.CLICK, align);
			Align_down.addEventListener(MouseEvent.CLICK, align);
			Align_center2.addEventListener(MouseEvent.CLICK, align);
			
			Interval_x.addEventListener(MouseEvent.CLICK, interval);
			Interval_y.addEventListener(MouseEvent.CLICK, interval);
			even_align.addEventListener(MouseEvent.CLICK, interval);
			
			Mag.addEventListener(MouseEvent.CLICK, attractAlign);
			round.addEventListener(MouseEvent.CLICK, circleAlign);
			//_align.addEventListener(MouseEvent.CLICK, even);
		}
		
		protected function align(event:MouseEvent):void
		{
			
			var left:Number=Infinity, right:Number=-Infinity, top:Number=Infinity, down:Number=-Infinity, centerX:Number=0, centerY:Number=0;
			var pnode:CompressedNode;
			var hasNode:Boolean=false;
			var nodes:int=0;
			
			for each (var node:BioBlock in Net.PickList)
			{
				nodes++;
				hasNode=true;
				
				pnode=node.NodeLink;
				if (pnode.Position[0] < left)
					left=pnode.Position[0];
				if (pnode.Position[0] > right)
					right=pnode.Position[0];
				if (pnode.Position[1] < top)
					top=pnode.Position[1];
				if (pnode.Position[1] > down)
					down=pnode.Position[1];
				
				centerX+=pnode.Position[0];
				centerY+=pnode.Position[1];
			}
			if (hasNode)
			{
				centerX/=nodes;
				centerY/=nodes;
				
				switch (event.target.tabIndex)
				{
					case 1:
					{
						for each (node in Net.PickList)
						{
							node.setPositionX(left);
						}
						break;
					}
						
					case 2:
					{
						for each (node in Net.PickList)
						{
							node.setPositionX(right);
						}
						break;
					}
					case 3:
					{
						for each (node in Net.PickList)
						{
							node.setPositionX(centerX);
						}
						break;
					}
					case 4:
					{
						for each (node in Net.PickList)
						{
							node.setPositionY(top);
						}
						break;
					}
					case 5:
					{
						for each (node in Net.PickList)
						{
							node.setPositionY(down);
						}
						break;
					}
					case 6:
					{
						for each (node in Net.PickList)
						{
							node.setPositionY(centerY);
						}
						break;
					}
				}
				
			}
		}
		
		private function PositionX(a:BioBlock, b:BioBlock):Number
		{
			var ax:Number=a.NodeLink.Position[0];
			var bx:Number=b.NodeLink.Position[0];
			if (ax > bx)
			{
				return 1;
			}
			else if (ax < bx)
			{
				return -1;
			}
			else
			{
				
				return 0;
			}
		}
		
		private function PositionY(a:BioBlock, b:BioBlock):Number
		{
			var ay:Number=a.NodeLink.Position[1];
			var by:Number=b.NodeLink.Position[1];
			if (ay > by)
			{
				return 1;
			}
			else if (ay < by)
			{
				return -1;
			}
			else
			{
				
				return 0;
			}
		}
		
		
		
		protected function interval(event:MouseEvent):void{
			
			var left:Number=Infinity, right:Number=-Infinity, top:Number=Infinity, down:Number=-Infinity, centerX:Number=0, centerY:Number=0;
			var pnode:CompressedNode;
			var hasNode:Boolean=false;
			var nodes:int=0;
			var interval_x:int=0;
			var interval_y:int=0;
			var ar_node:Array=new Array();
			var ar_y:Array=[];
			
			for each (var node:BioBlock in Net.PickList)
			{
				nodes++;
				hasNode=true;
				ar_node.push(node);
				pnode=node.NodeLink;
				
				if (pnode.Position[0] < left)
					left=pnode.Position[0];
				if (pnode.Position[0] > right)
					right=pnode.Position[0];
				if (pnode.Position[1] < top)
					top=pnode.Position[1];
				if (pnode.Position[1] > down)
					down=pnode.Position[1];
			}
			if (hasNode)
			{
				interval_x=(right - left) / (nodes - 1);
				interval_y=(down - top) / (nodes - 1);
				
				var i:int=0;
				
				switch (event.target.tabIndex)
				{
					
					
					case 1:
					{
						ar_node.sort(PositionX);
						for (i=0; i < nodes; i++)
						{
							ar_node[i].setPositionX(left + interval_x * i);
						}
						break;
					}
						
					case 2:
					{
						ar_node.sort(PositionY);
						
						for (i=0; i < nodes; i++)
						{
							ar_node[i].setPositionY(top + interval_y * i);
							
						}
						break;
					}
				}
			}
		}
		
		protected function attractAlign(event:MouseEvent):void{
			
			
			var Node:Array=new Array();
			
			var node:CompressedNode;
			
			LayoutRunner.runLayout();
			
			
		}
		
		protected function circleAlign(event:MouseEvent):void
		{
			var Node:Array=new Array();
			var len:Number;
			var curtheta:Number=0;
			
			for each (var node:CompressedNode in GxmlContainer.Block_space)
			{
				Node.push(node);
			}
			Node.sort(function ByType(a:CompressedNode, b:CompressedNode):Number
			{
				var ay:String=a.Type.Type;
				var by:String=b.Type.Type;
				if (ay > by)
				{
					return 1;
				}
				else if (ay < by)
				{
					return -1;
				}
				else
				{
					
					return 0;
				}
			});
			len=100 + Node.length * 15;
			for (var i:int=0; i < Node.length; i++)
			{
				curtheta=2 * Math.PI * i / (Node.length)
				Node[i].remPosition[0]=Node[i].aimPosition[0]=len * Math.cos(curtheta);
				Node[i].remPosition[1]=Node[i].aimPosition[1]=len * Math.sin(curtheta);
				TweenX.GlideNodes(Node);
				
			}
			
			
		}
		
		
		protected function even(event:MouseEvent):void
		{
			
			var left:Number=Infinity, right:Number=-Infinity, top:Number=Infinity, down:Number=-Infinity, centerX:Number=0, centerY:Number=0;
			var pnode:CompressedNode;
			var hasNode:Boolean=false;
			var nodes:int=0;
			var interval_x:int=0;
			var interval_y:int=0;
			var ratio:Number;
			var ar_node:Array=new Array();
			var nx:int=1;
			var ny:int=1;
			
			
			for each (var node:BioBlock in Net.PickList)
			{
				nodes++;
				hasNode=true;
				ar_node.push(node);
				pnode=node.NodeLink;
				
				if (pnode.Position[0] < left)
					left=pnode.Position[0];
				if (pnode.Position[0] > right)
					right=pnode.Position[0];
				if (pnode.Position[1] < top)
					top=pnode.Position[1];
				if (pnode.Position[1] > down)
					down=pnode.Position[1];
			}
			if (hasNode)
			{
				
				ratio=(right - left) / (down - top);
				
				while (nx * ny < nodes)
				{
					if (nx / ny < ratio)
					{
						nx++;
					}
					else
					{
						ny++;
					}
				}
				//trace(nx, ny,nodes);
				interval_x=(right - left) / (nx - 1);
				interval_y=(down - top) / (ny - 1);
				
				ar_node.sort(PositionY);
				var tmp:Array=new Array();
				for (var k:int=0; k < ny; k++)
				{
					tmp.push((ar_node.slice(k * nx, (k + 1) * nx)).sort(PositionX));
					//trace(tmp);
				}
				for (var j:int=0; j < ny; j++)
				{
					for (var i:int=0; i < nx; i++)
					{
						if ((nx * j + i) > nodes - 1)
						{
							break;
						}
						tmp[j][i].setPositionXY(left + interval_x * i, top + interval_y * j);
						
					}
				}
			}
		}
		
		
		public function setSize(w):void
		{
			Width=w;
			
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 10, 0, HintLabel);
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 40, 0, Align_left, Align_center, Align_right);
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 90, 0, Align_up, Align_center2, Align_down);
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 140, 0, Interval_x, even_align, Interval_y);
			
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 190, 0, globalLayouHint);
			LayoutManager.setHorizontalLayout(this, LayoutManager.LAYOUT_ALIGN_CENTER, w / 2, 220, 0, Mag, round);
			
		}
	}
}
