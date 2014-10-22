package Assembly.Compressor
{
	
	import flash.display.BitmapData;
	
	import Biology.Types.NodeSkinData;
	import Biology.Types.NodeType;

	import Assembly.BioParts.BioBlock;
	import Assembly.Canvas.I3DPlate;
	
	public class CompressedNode
	{
		
		///////////Saving Attribution
		public var ID:String;
		public var Name:String;
		private var _Type:NodeType;
		
		public var detail:String;
		
		public var Position:Vector.<Number>=new <Number>[0,0];
		public var aimPosition:Vector.<Number>=new <Number>[0,0];
		public var remPosition:Vector.<Number>=new <Number>[0,0];
		
		public var centerRadius:Number=200;
		
		//////////Cloud
		public var state:int;
		
		/////////////Runtime
		
		public var skindata:NodeSkinData;
		
		public var Instance:BioBlock;
		
		public var x:int;
		public var y:int;
		
		public var visible:Boolean=true;
		
		public var modified:Boolean=false;
		public var TextMap:BitmapData=new BitmapData(1,1);
		public var textX:Number=0,textY:Number=0;
		
		public var Edges:int=0;
		
		
		//////Linkage
		public var Linklist:Array=[];
		public var LinkOutlist:Array=[];
		public var LinkInlist:Array=[];
		public var Arrowlist:Array=[];
		
		//////Tree
		public var centerBlock:CompressedNode;
		
		
		public function CompressedNode(id:String,titl:String,biotype:NodeType,px:Number,py:Number,det=null){
			x=px*I3DPlate.scaleXY;
			y=py*I3DPlate.scaleXY;
			
			remPosition[0]=aimPosition[0]=Position[0]=px;
			remPosition[1]=aimPosition[1]=Position[1]=py;
			
			ID=id;
			Name=titl;
			Type=biotype;
			skindata=biotype.skindata;
			
			detail=det;
		}
		
		public function get Type():NodeType{
			return _Type;
		}

		public function set Type(value:NodeType):void{
			_Type = value;
			skindata=value.skindata;
		}

		public function get ContentURL():String{
			return GlobalVaribles.NODE_INTERFACE+ID+"/";
		}
		
		public function AimToRemPostion():void{
			aimPosition[0]=remPosition[0];
			aimPosition[1]=remPosition[1];
		}
		
		public function SetRemPostion():void{
			remPosition[0]=Position[0];
			remPosition[1]=Position[1];
		}
	}
}