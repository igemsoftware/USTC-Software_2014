package GUI.ColorChooser{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import Layout.FrontCoverSpace;
	import Layout.GlobalLayoutManager;
	
	import fl.events.ColorPickerEvent;
	
	
	public class ColorChooser extends Sprite{
		
		private var colorIndicator:ColorIndicator=new ColorIndicator();
		private var colorField:ColorField=new ColorField();
		
		private var remColor:uint;
		
		public var selectedColor:uint;
		
		public function ColorChooser()
		{
			
			addChild(colorIndicator);
			colorIndicator.addEventListener(MouseEvent.CLICK,function (e):void{
				if (FrontCoverSpace.contains(colorField)) {
					FrontCoverSpace.removeChild(colorField);
					colorIndicator.color=remColor;
				}else {
					FrontCoverSpace.addChild(colorField);
					var locPoint:Point=new Point();
					var absPoint:Point=localToGlobal(locPoint);
					if (absPoint.x+colorField.width>GlobalLayoutManager.StageWidth) {
						locPoint.x=colorIndicator.width-colorField.width;
					}else {
						locPoint.x=0;
					}
					
					if (absPoint.y+colorField.height>GlobalLayoutManager.StageHeight) {
						locPoint.y=-colorField.height;
					}else {
						locPoint.y=colorIndicator.height;
					}
					absPoint=localToGlobal(locPoint);
					colorField.x=absPoint.x;
					colorField.y=absPoint.y;
				}
			});
			colorField.addEventListener(MouseEvent.CLICK,function (e):void{
				colorIndicator.color=colorField.selectedColor;
				remColor=colorField.selectedColor;
				FrontCoverSpace.removeChild(colorField);
				dispatchEvent(new ColorPickerEvent(Event.CHANGE,colorField.selectedColor));
			});
			colorIndicator.addEventListener(Event.REMOVED_FROM_STAGE,function (e):void{
				FrontCoverSpace.removeChild(colorField);
			})
			colorField.addEventListener(Event.CHANGE,function (e):void{
				colorIndicator.color=colorField.selectedColor;
			});
			colorIndicator.addEventListener(MouseEvent.MOUSE_OVER,function (e):void{
				colorIndicator.color=remColor;
			});
		}
		public function set color(c):void{
			colorIndicator.color=c;
			remColor=c;
		}
		public function get color():uint{
			return remColor;
		}
	}
}