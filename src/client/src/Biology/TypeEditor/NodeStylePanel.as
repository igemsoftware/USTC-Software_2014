package Biology.TypeEditor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import Biology.Types.NodeType;
	import Biology.Types.SymbolType;
	
	import GUI.FlexibleWidthObject;
	import GUI.Assembly.LabelTextField;
	import GUI.ColorChooser.ColorChooser;
	import GUI.RichUI.RichButton;
	import GUI.RichUI.RichComboBox;
	
	import Layout.LayoutManager;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	
	
	public class NodeStylePanel extends Sprite implements FlexibleWidthObject
	{
		private var editType:NodeType;
		
		public var _sample:NodeSample=new NodeSample();
		
		private var IconMap:BitmapData;
		
		private var shapeChooser:RichComboBox;
		
		private var slider:Slider=new Slider();
		
		private var pic_b:RichButton=new RichButton();
		
		private var Browser:File;
		
		private var color:ColorChooser=new ColorChooser();
		
		private var label_color:LabelTextField=new LabelTextField("Color:");
		private var slider_text0:LabelTextField=new LabelTextField("10");
		private var slider_text1:LabelTextField=new LabelTextField("60");
		private var slider_label:LabelTextField=new LabelTextField("Radius:");
		private var IconPath:String;
		
		public function NodeStylePanel(){
			
			slider.width=150;
			slider.minimum=10;
			slider.maximum=60;
			slider.tickInterval=5;
			slider.snapInterval=5;
			
			shapeChooser=new RichComboBox(RichComboBox.INDEPENDENT);
			shapeChooser.dataProvider=SymbolType.NodeTypes;
			shapeChooser.setSize(50,30);
			
			pic_b.setIcon(Icon_img);
			pic_b.setSize(50,30);
			
			shapeChooser.addEventListener(Event.CHANGE,sampleRedraw);
			slider.addEventListener(SliderEvent.CHANGE,sampleRedraw)
			color.addEventListener(Event.CHANGE, sampleRedraw)
					
			pic_b.addEventListener(MouseEvent.CLICK,function (e):void{
				Browser=new File();
				Browser.browseForOpen("Choose an icon",[new FileFilter("PNG","*.png")]);
				Browser.addEventListener(Event.SELECT,function (e):void{
					Browser.load();
				});
				Browser.addEventListener(Event.COMPLETE,function (event:Event):void
				{
					var IconLoader:Loader=new Loader();
					IconLoader.loadBytes(Browser.data);
					IconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function (e):void{
						var bmp:Bitmap = Bitmap(IconLoader.content);
						IconMap=BitmapData(bmp.bitmapData);
						
						
						var f:File;
						var fs:FileStream = new FileStream();
						
						IconPath=editType.label;
						f=File.applicationStorageDirectory.resolvePath(editType.label);
						fs.open(f, flash.filesystem.FileMode.WRITE);
						
						var byary:ByteArray=new ByteArray();
						IconMap.copyPixelsToByteArray(IconMap.rect,byary);
						fs.writeInt(IconMap.width);
						fs.writeInt(IconMap.height);
						fs.writeBytes(byary);
						
						fs.close();
						
						sampleRedraw();
					});
					Browser=null;
				});
			})
		}
		
		public function showType(type:NodeType):void{
			
			editType=type;
			
			IconPath=type.iconPath;
			
			shapeChooser.selectedIndex=type.skindata.shape - 1;
			slider.value=type.skindata.radius;
			color.color=type.skindata.color;
			
			IconMap=editType.icon;
			
			_sample.showSample(editType);
		}
		
		private function sampleRedraw(e=null):void{
			
			editType.icon=IconMap;
			editType.iconPath=IconPath;
			editType.skindata.color=color.color;
			editType.skindata.radius=slider.value;
			editType.skindata.shape=shapeChooser.selectedItem.value;
			editType.iconScale=slider.value*1.1/Math.max(IconMap.height,IconMap.width);
			
			_sample.showSample(editType);
		}
		
		public function setSize(w:Number):void{
			
			LayoutManager.setHorizontalLayout(this,"center",w/2,0,20,shapeChooser,color,pic_b);
			LayoutManager.setHorizontalLayout(this,"center",w/2,50,0,slider_label);
			LayoutManager.setHorizontalLayout(this,"center",w/2+5,75,10,slider_text0,slider,slider_text1);
			
		}
	}
}
