package Kernel.SmartCanvas
{
	
	import flash.display.BitmapData;
	
	import Kernel.SmartCanvas.Parts.BioNode;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	
	import Kernel.Biology.Types.NodeSkinData;
	import Kernel.Biology.Types.NodeType;
	
	public class CompressedNode
	{
		
		///////////Saving Attribution
		public var ID:String;
		public var refID:String="";
		public var Name:String;
		private var _Type:NodeType;
		
		public var detail:Object;
		
		public var Position:Vector.<Number>=new <Number>[0,0];
		public var aimPosition:Vector.<Number>=new <Number>[0,0];
		public var remPosition:Vector.<Number>=new <Number>[0,0];
		
		public var centerRadius:Number=200;
		
		//////////Cloud
		public var CloudState:int;
		
		/////////////Runtime
		
		public var CLID:int;
		
		public var skindata:NodeSkinData;
		
		public var Instance:BioNode;
		
		public var x:int;
		public var y:int;
		
		public var visible:Boolean=true;
		
		public var modified:Boolean=false;
		public var moved:Boolean=false;
		
		public var TextMap:BitmapData=new BitmapData(1,1);
		public var textX:Number=0,textY:Number=0;
		
		public var isLoadingDetail:Boolean=false;
		
		public var Edges:int=0;
		
		
		//////Linkage
		public var Linklist:Array=[];
		public var Arrowlist:Array=[];
		
		
		public var centerBlock:CompressedNode;
		
		
		public function CompressedNode(id:String,titl:String,biotype:NodeType,px:Number,py:Number,_detail="{}"){
			x=px*FreePlate.scaleXY;
			y=py*FreePlate.scaleXY;
			
			remPosition[0]=aimPosition[0]=Position[0]=px;
			remPosition[1]=aimPosition[1]=Position[1]=py;
			
			ID=id;
			Name=titl;
			Type=biotype;
			skindata=biotype.skindata;
			
			if(_detail==""||_detail==null){
				detail=new Object();
			}else{
				detail=JSON.parse(_detail);
			}
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