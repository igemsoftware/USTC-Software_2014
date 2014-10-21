package Kernel.ExpandThread{
	import Kernel.SmartCanvas.CompressedNode;
	
	
	/**
	 * An ExpandBranch records detailed information of a branch (node->link->node) when Expand
	 * @ see ExpandManager.as
	 */
	
	public class ExpandBranch {
		
		/**
		 * A full branch contains two nodes and a link.
		 */
		
		///node that expanded from
		public var father:CompressedNode;
		
		///Information of the node going to be imported
		public var node_id:String;
		public var NAME:String;
		public var TYPE:String;
			
		///Object ID of the link
		public var link_id:String;
		///Direction of the link
		public var DIRECT:int;
		///Type of the link
		public var LinkType:String;
		
		///target expand position
		public var aimx:Number;
		public var aimy:Number;
		
		
		
		/**
		 * Record all the information
		 */
		public function ExpandBranch(link:String,fatherNode:CompressedNode,node,name,type,link_tp,direc)
		{
			link_id=link;
			father=fatherNode;
			node_id=node;
			NAME=name;
			TYPE=type;
			DIRECT=direc;
			LinkType=link_tp;
			
		}
	}
}