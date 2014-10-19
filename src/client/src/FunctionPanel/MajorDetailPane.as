package FunctionPanel
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	
	import Biology.TypeEditor.LinkSample;
	import Biology.TypeEditor.NodeSample;
	
	import GUI.FlexibleWidthObject;
	
	import Layout.GlobalLayoutManager;
	
	import Style.ColorMixer;
	import Style.FontPacket;
	
	public class MajorDetailPane extends Sprite implements FlexibleWidthObject
	{
		
		private const Scale:int=100;
		
		public var _nodesample:NodeSample=new NodeSample();
		public var _linesample:LinkSample=new LinkSample();
		
		public var _name:TextField=new TextField();
		
		public var Height:int=120;
		
		private var _box2:Shape=new Shape();
		
		public function MajorDetailPane(tar:*)
		{
			_box2.graphics.clear();
			_box2.graphics.lineStyle(2,GlobalVaribles.SKIN_LINE_COLOR);
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(Scale,Scale,Math.PI/3,0,0);
			_box2.graphics.beginGradientFill(GradientType.LINEAR,[ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x303030),ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x101010)],[1,1],[100,255],Fillmatrix);
			_box2.graphics.drawRoundRect(0,0,Scale,Scale,6,6);
			
			_name.autoSize="left";
			
			_name.defaultTextFormat=FontPacket.ContentText;
			
			if(tar.constructor==CompressedNode){
				_nodesample.showSample(tar.Type);
				_name.text="Name : "+tar.Name+"\n"+"Type : "+tar.Type.label+"\n"+"Edges : "+tar.Edges;
				_nodesample.visible=true;
				_linesample.visible=false;
			}else{
				var line:CompressedLine=tar as CompressedLine;
				_linesample.showSample(tar.Type);
				_name.text="Link : "+line.linkObject[0].Name+" -> "+line.linkObject[1].Name+"\nName : "+tar.Name+"\n"+"Type : "+tar.Type.label;
				_nodesample.visible=false;
				_linesample.visible=true;
			}
			
			addChild(_box2);
			addChild(_name);
			addChild(_nodesample);
			addChild(_linesample);
		}
		
		public function setSize(w:Number):void{
			
			_box2.y=10;
			_box2.x=5;
			
			_name.x=_box2.width+15;
			_name.y=_box2.y+_box2.height/2-_name.height/2-2;
			
			_linesample.x=_nodesample.x=_box2.x+_box2.width/2;
			_linesample.y=_nodesample.y=_box2.y+_box2.height/2;
			
		}
	}
}