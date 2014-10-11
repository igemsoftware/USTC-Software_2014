package Assembly.ExpandThread{
	import Assembly.Compressor.CompressedNode;
	
	public class ExpandBranch {
		
		public var link_id:String;
		public var father:CompressedNode;
		public var node_id:String;
		public var NAME:String;
		public var TYPE:String;
		public var DIRECT:int;
		public var aimx:Number;
		public var aimy:Number
		public var LinkType:String;
		
		
		public function ExpandBranch(link,fatherNode,node,name,type,link_tp,direc)
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