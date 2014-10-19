package Biology.TypeEditor{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import Biology.LinkTypeInit;
	import Biology.NodeTypeInit;
	import Biology.Types.LinkType;
	import Biology.Types.NodeType;
	
	import GUI.FlexibleLayoutObject;
	import GUI.Assembly.ContentBox;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.TitleTextField;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import Layout.GlobalLayoutManager;
	import Layout.LayoutManager;
	
	import Assembly.Canvas.Net;
	
	import Style.ColorMixer;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	
	public class BioStyleEditor extends Sprite implements FlexibleLayoutObject{
		private const LIST_WIDTH:int=160;
		
		private var nodebtn:RichButton=new RichButton(1, 60, 30);
		private var linkbtn:RichButton=new RichButton(2, 60, 30);
		
		private var _box:ContentBox=new ContentBox();
		private var _boxRange:SkinBox=new SkinBox();
		private var _box2:Shape=new Shape();
		
		private var _nodePanel:NodeStylePanel=new NodeStylePanel();
		private var _linePanel:LinkStylePanel=new LinkStylePanel();
		
		private var _list:RichList=new RichList();
		private var _title:TitleTextField=new TitleTextField("Choose a type");
		

		
		private var dp:DataProvider;
		
		private var ok_b:RichButton=new RichButton();
		private var cancel_b:RichButton=new RichButton();
		private var apply_b:RichButton=new RichButton();
		
		private var currentNodeType:int=-1;
		private var currentLineType:int=-1;
		
		
		public var backUpData:Array;
		public var nodeApplyData:Array;
		public var lineBackUp:Array;
		public var lineApplyData:Array;
		
		public var Height:int;
		
		public function BioStyleEditor(){
			backUpData=NodeTypeInit.BiotypeProvider;
			nodeApplyData=NodeTypeInit.BiotypeProvider;
			lineBackUp=LinkTypeInit.LinktypeProvider;
			lineApplyData=LinkTypeInit.LinktypeProvider;
			
			nodebtn.label="Node";
			linkbtn.label="Link";
			
			LayoutManager.UnifyScale(80, 25, nodebtn, linkbtn);
			
			
			ok_b.label="Confirm";
			cancel_b.label="Cancel";
			apply_b.label="Apply";
			
			LayoutManager.UnifyScale(80,25,ok_b,cancel_b,apply_b);
			
			_list.dataProvider=nodeApplyData;
			
			_title.x=LIST_WIDTH+20;
			
			addChild(_boxRange);
			addChild(_box2);
			//addChild(_box);
			addChild(_list);
			addChild(_title);
	
			setSize(500,330);
			
			_list.addEventListener(ListEvent.ITEM_CLICK,setSelection);
			
			nodebtn.addEventListener(MouseEvent.CLICK,function (e):void{Mode=1});
			linkbtn.addEventListener(MouseEvent.CLICK,function (e):void{Mode=2});
			
			cancel_b.addEventListener(MouseEvent.CLICK,function (e):void{
				applyData(true)
				dispatchEvent(new Event("close"));
			})
			ok_b.addEventListener(MouseEvent.CLICK,function (e):void{
				applyData()
				
				NodeTypeInit.saveBioType();
				LinkTypeInit.saveLinkType();
				
				dispatchEvent(new Event("close"));
			})
			apply_b.addEventListener(MouseEvent.CLICK,function (e):void{
				applyData();
			})
			
			Mode=1;
		}
		
		protected function applyData(backUp=false):void{
			var aimNodeData:Array;
			var aimLineData:Array;
			if(backUp){
				aimNodeData=backUpData;
				aimLineData=lineBackUp;
			}else{
				aimNodeData=nodeApplyData;
				aimLineData=lineApplyData;
			}
			for each(var item:NodeType in aimNodeData){
				(NodeTypeInit.BiotypeList[item.Type] as NodeType).copyBioType(item);
			}
			for each(var LItem:LinkType in aimLineData){
				(LinkTypeInit.LinkTypeList[LItem.Type] as LinkType).copyLinkType(LItem);
			}
			Net.ShapeRedraw();
		}
		
		private var _mode:int=0;
		private function set Mode(n:int):void{
			if(n!=_mode){
				if (n==1){
					if(contains(_linePanel._sample)){
						removeChild(_linePanel._sample);
						removeChild(_linePanel);
					}
					
					_list.dataProvider=nodeApplyData;
					
					nodebtn.focused=true;
					linkbtn.focused=false;
					
					addChild(_nodePanel.focusCir);
					addChild(_nodePanel._sample);
					addChild(_nodePanel);
					
					
					_list.selectedIndex=currentNodeType;
				}else{
					if(contains(_nodePanel.focusCir)){
						removeChild(_nodePanel.focusCir);
						removeChild(_nodePanel);
						removeChild(_nodePanel._sample);
					}
					
					_list.dataProvider=lineApplyData;
					nodebtn.focused=false;
					linkbtn.focused=true;
					
					addChild(_linePanel._sample);
					addChild(_linePanel);
					
					_list.selectedIndex=currentLineType;
					
				}
				if(_list.selectedItem!=null){
					_title.text=_list.selectedItem.label;
				}else{
					_title.text="Choose a type"
				}
			}
		}
		
		private function setSelection(e:ListEvent):void{
			if(e.item.constructor==NodeType){
				
				_title.text=e.item.label;
				
				currentNodeType=e.index;
				
				
				
				_nodePanel.showType(e.item as NodeType);
				
			}else{
				_title.text=e.item.label;
				
				currentLineType=e.index;
				
				_linePanel.showType(e.item as LinkType);
			}
		}
		
		public function setSize(w:Number,h:Number):void{
			_list.x=5;
			_list.y=32;
			
			_box2.graphics.clear();
			_box2.graphics.lineStyle(2,GlobalVaribles.SKIN_LINE_COLOR);
			var Fillmatrix:Matrix=new Matrix();
			Fillmatrix.createGradientBox(120,120,Math.PI/3,0,0);
			_box2.graphics.beginGradientFill(GradientType.LINEAR,[ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x303030),ColorMixer.MixColor(GlobalLayoutManager.BackGroundColor,0x101010)],[1,1],[100,255],Fillmatrix);
			_box2.graphics.drawRoundRect(0,0,120,120,6,6);
			
			_box2.x=(w+LIST_WIDTH)/2-_box2.width/2;
			_box2.y=_title.height+10;
			
			var cy:Number=_box2.y+_box2.height;
			
			_nodePanel.setSize((w+LIST_WIDTH)/2);
			_linePanel.setSize((w+LIST_WIDTH)/2);
			
			_linePanel.y=_nodePanel.y=cy+20;
			_nodePanel.x=LIST_WIDTH+5
			_linePanel.x=LIST_WIDTH+5;
			
			LayoutManager.setHorizontalLayout(this,"center",LIST_WIDTH/2+4,4,0,nodebtn,linkbtn);
			LayoutManager.setHorizontalLayout(this,"center",(w+LIST_WIDTH)/2,h-30,10,ok_b,apply_b,cancel_b);
			
			_nodePanel.focusCir.x=_nodePanel._sample.x=_linePanel._sample.x=(w+LIST_WIDTH)/2;
			_nodePanel.focusCir.y=_nodePanel._sample.y=_linePanel._sample.y=_title.height+10+_box2.height/2;
			
			_boxRange.setSize(w,h);
			_box.setSize(LIST_WIDTH,h);
			_list.setSize(LIST_WIDTH-2,h-38)
			
			Height=h;
		}
	}
}