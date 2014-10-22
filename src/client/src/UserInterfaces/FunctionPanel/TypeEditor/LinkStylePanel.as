package UserInterfaces.FunctionPanel.TypeEditor
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Kernel.Biology.Types.LinkType;
	
	import GUI.Assembly.FlexibleWidthObject;
	import GUI.Assembly.LabelTextField;
	import GUI.ColorChooser.ColorChooser;
	import GUI.RichUI.RichComboBox;
	
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import fl.controls.Slider;
	import fl.events.ColorPickerEvent;
	import fl.events.SliderEvent;
	import Kernel.Biology.Types.SymbolType;
	
	
	
	public class LinkStylePanel extends Sprite implements FlexibleWidthObject
	{
		
		private var editType:LinkType;
		
		public var _sample:LinkSample=new LinkSample();
		
		private var lineColor:ColorChooser=new ColorChooser();
		private var LineChooser:RichComboBox;
		private var startArrowChooser:RichComboBox;
		private var endArrowChooser:RichComboBox;
		private var slider :Slider=new Slider();
		
		private var label_color:LabelTextField=new LabelTextField("Line Color:");
		private var slider_text0:LabelTextField=new LabelTextField("1");
		private var slider_text1:LabelTextField=new LabelTextField("10");
		private var slider_label:LabelTextField=new LabelTextField("Line Width:");
		
		public function LinkStylePanel(){
			///////init
			LineChooser=new RichComboBox(RichComboBox.MIDDLE,false);
			endArrowChooser=new RichComboBox(RichComboBox.RIGHT_EDGE,false);
			startArrowChooser=new RichComboBox(RichComboBox.LEFT_EDGE,false,true,true);
			
			LineChooser.dataProvider=SymbolType.LineTypes;
			startArrowChooser.dataProvider=SymbolType.ArrowTypes;
			endArrowChooser.dataProvider=SymbolType.ArrowTypes;
			
			LineChooser.setSize(60,30);
			startArrowChooser.setSize(30,30);
			endArrowChooser.setSize(30,30);
			
			slider.minimum=1;
			slider.maximum=10;
			slider.tickInterval=1;
			slider.snapInterval=1;
			slider.width=150;
			
			///////////events
			LineChooser.addEventListener(Event.CHANGE,sampleRedraw);
			startArrowChooser.addEventListener(Event.CHANGE, sampleRedraw);
			endArrowChooser.addEventListener(Event.CHANGE,sampleRedraw);
			slider.addEventListener(SliderEvent.CHANGE,sampleRedraw);
			lineColor.addEventListener(ColorPickerEvent.CHANGE,sampleRedraw);
		}
		
		public function showType(type:LinkType):void{
			
			editType=type;
			
			LineChooser.selectedIndex=type.skindata.lineType - 1;
			slider.value=type.skindata.stroke;
			lineColor.color=type.skindata.lineColor;
			startArrowChooser.selectedIndex=type.skindata.startArrowType;
			endArrowChooser.selectedIndex=type.skindata.endArrowType;
			
			_sample.showSample(editType);
		}
		
		private function sampleRedraw(e=null):void{
			if(editType!=null){
				editType.skindata.lineColor=lineColor.color;
				editType.skindata.stroke=slider.value;
				editType.skindata.lineType=LineChooser.selectedItem.value;
				editType.skindata.startArrowType=startArrowChooser.selectedItem.value;
				editType.skindata.endArrowType=endArrowChooser.selectedItem.value;
				_sample.showSample(editType);
			}
		}
		
		public function setSize(w:Number):void{
			LayoutManager.setHorizontalLayout(this,"center",w/2,0,0,startArrowChooser,LineChooser,endArrowChooser);
			LayoutManager.setHorizontalLayout(this,"left",endArrowChooser.x+endArrowChooser.width+30,0,20,lineColor);
			LayoutManager.setHorizontalLayout(this,"center",w/2,50,0,slider_label);
			LayoutManager.setHorizontalLayout(this,"center",w/2+5,75,10,slider_text0,slider,slider_text1);
		}
	}
}
