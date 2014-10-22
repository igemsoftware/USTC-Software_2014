package Kernel.SmartCanvas
{
	import flash.display.Graphics;
	
	import Kernel.SmartCanvas.Parts.BioArrow;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	
	import Kernel.Biology.Types.LinkSkinData;
	import Kernel.Biology.Types.LinkType;
	
	import Kernel.Geometry.DrawArrow;

	
	/**
	 * Compressed Link Instance
	 * only process parameters, no UI elements
	 */
	
	public class CompressedLine
	{
		
		///Saving Parameters
		public var linkObject:Array=[];
		private var _Type:LinkType;
		public var Name:String;
		public var ID:String;
		public var refID:String="";
		public var skindata:LinkSkinData;
		public var detail:Object;
		
		///Runtime Parameters
		public var Instance:BioArrow;
		
		private var HIT_TEST_RANGE:int=8;
		private var A:Number,B:Number,D:Number;
		
		///for Geometry
		private var X1:Number,X2:Number,Y1:Number,Y2:Number;
		public var SX:Number,SY:Number,EX:Number,EY:Number;		
		public var x:Number,y:Number;
		
		///for SyncManager
		public var modified:Boolean=false;

		/**
		 * Compressed Link Instance
		 */
		public function CompressedLine(id:String ,nam:String,obj1:CompressedNode,obj2:CompressedNode,type:LinkType,_detail:String="{}")
		{
			Name=nam;
			ID=id;
			linkObject = [obj1,obj2];
			Type=type;
			skindata=type.skindata;
			
			if(_detail==""||_detail==null){
				detail=new Object();
			}else{
				detail=JSON.parse(_detail);
			}
			setLine();
		}
		
		public function get ContentURL():String{
			return GlobalVaribles.LINK_INTERFACE+ID+"/";
		}
		
		public function get Type():LinkType{
			return _Type;
		}
		
		public function set Type(value:LinkType):void{
			_Type = value;
			skindata=value.skindata;
		}

		public function hitTest(x,y):Boolean{
			if (X1<x+5&&X2>x-5&&Y1<y+5&&Y2>y-5&&Math.abs(A*x+B*y-1)/D<HIT_TEST_RANGE) {
				return true;
			}else  {
				return false;
			}
		}
		
		public function drawSkin(graphic:Graphics,highlight=null):void{
			if (highlight!=null) {
				graphic.lineStyle(HIT_TEST_RANGE,highlight,0.3);
			}else{
				graphic.lineStyle(HIT_TEST_RANGE,skindata.lineColor,0.1);
			}
			
			graphic.moveTo(SX,SY);
			graphic.lineTo(EX,EY);
			
			graphic.lineStyle(skindata.stroke,skindata.lineColor);
			DrawArrow.drawArrow(graphic,this);
		}
		
		public function setLine():void{
			var obj1:CompressedNode=linkObject[0];
			var obj2:CompressedNode=linkObject[1];
			
			var Rotation:Number=(Math.atan((obj2.y-obj1.y)/(obj2.x-obj1.x))/Math.PI*180+(180*((obj2.x-obj1.x)>=0?0:1)))/180*Math.PI;
			
			if (isNaN(Rotation)){
				Rotation=0;
			}
			
			SX=obj1.x+Math.cos(Rotation)*obj1.skindata.radius/2*FreePlate.scaleXY*1.1;
			SY=obj1.y+Math.sin(Rotation)*obj1.skindata.radius/2*FreePlate.scaleXY*1.1;
			EX=obj2.x-Math.cos(Rotation)*obj2.skindata.radius/2*FreePlate.scaleXY*1.1;
			EY=obj2.y-Math.sin(Rotation)*obj2.skindata.radius/2*FreePlate.scaleXY*1.1;
			
			X1=Math.min(obj1.x,obj2.x);
			X2=Math.max(obj1.x,obj2.x);
			
			Y1=Math.min(obj1.y,obj2.y);
			Y2=Math.max(obj1.y,obj2.y);
			
			x=(obj1.x+obj2.x)/2
			y=(obj1.y+obj2.y)/2
				
			var deta:Number=obj1.x*obj2.y-obj1.y*obj2.x;
			var deta2:Number=obj1.x-obj2.x;
			var deta3:Number=obj2.y-obj1.y;
			
			A=deta3/deta;
			B=deta2/deta;
			
			D=Math.sqrt(Math.pow(A,2)+Math.pow(B,2));
			
			if (Instance!=null) {
				Instance.redraw();
			}
		}
	}
}