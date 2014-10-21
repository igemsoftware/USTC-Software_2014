package UserInterfaces.IvyBoard.IvyPanels
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	
	import UserInterfaces.FunctionPanel.TypeEditor.LinkSample;
	import UserInterfaces.FunctionPanel.TypeEditor.NodeSample;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	
	import UserInterfaces.Style.ColorMixer;
	import UserInterfaces.Style.FontPacket;
	
	public class QuickINF extends Sprite
	{
		
		private const Scale:int=65;
		
		public var _nodesample:NodeSample=new NodeSample();
		public var _linesample:LinkSample=new LinkSample();
		
		public var _name:TextField=new TextField();
		
		private var _box2:Shape=new Shape();
		private var Width:Number;
		
		public function QuickINF(tar:*=null)
		{
			_box2.graphics.clear();
			_box2.graphics.lineStyle(2,GlobalVaribles.SKIN_LINE_COLOR);
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(Scale,Scale,Math.PI/3,0,0);
			_box2.graphics.beginGradientFill(GradientType.LINEAR,[ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x303030),ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x101010)],[1,1],[100,255],Fillmatrix);
			_box2.graphics.drawRoundRect(0,0,Scale,Scale,6,6);
			
			_name.autoSize="left";
			
			_name.defaultTextFormat=FontPacket.WhiteTinyTinyText;
			
			_name.wordWrap=true
			
			addChild(_box2);
			addChild(_name);
			addChild(_nodesample);
			addChild(_linesample);
			
			target=tar;
		}
		
		public function set target(tar:*):void{
			if(tar==null){
				_name.text="Name : "+"---"+"\n"+"Type : "+"---"+"\n"+"Links : "+"---"
				_nodesample.visible=false;
				_linesample.visible=false;
			}else	if(tar.constructor==CompressedNode){
				_nodesample.showSample(tar.Type);
				_name.text="Name : "+tar.Name+"\n"+"Type : "+tar.Type.label+"\n"+"Links : "+tar.Edges;
				_nodesample.visible=true;
				_linesample.visible=false;
			}else{
				var line:CompressedLine=tar as CompressedLine;
				_linesample.showSample(tar.Type);
				_name.htmlText="Link : "+line.linkObject[0].Name+" -> "+line.linkObject[1].Name+"\nName : "+tar.Name+"\n"+"Type : "+tar.Type.label;
				_nodesample.visible=false;
				_linesample.visible=true;
			}
			
		}
		
		public function setSize(w:Number=0):void{
			
			if(w==0){
				w=Width;
			}else{
				Width=w;
			}
			
			_box2.y=5;
			_box2.x=5;
			
			_name.x=_box2.width+15;
			_name.y=5
			_name.width=w-_box2.width-10;
			
			_linesample.x=_nodesample.x=_box2.x+_box2.width/2;
			_linesample.y=_nodesample.y=_box2.y+_box2.height/2;
			
		}
	}
}