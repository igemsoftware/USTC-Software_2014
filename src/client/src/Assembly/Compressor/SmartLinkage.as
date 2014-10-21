package Assembly.Compressor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import Assembly.BioParts.BioArrow;
	import Assembly.Canvas.Net;
	
	public class SmartLinkage extends Sprite{
		
		///Items Stored in LineSpace are Compressed Lines
		 
		private var linePicker:LinePicker;
		private var floatCanvas:Sprite;
		private var compressedCanvas:CompressedLineSpace;
		
		
		public function SmartLinkage(){
			linePicker=new LinePicker();
		}
		
		public function restore():void{
			removeChildren(0);
			
			floatCanvas=new Sprite;
			compressedCanvas=new CompressedLineSpace();
			
			compressedCanvas.addEventListener(MouseEvent.MOUSE_DOWN,Down_evt);
			compressedCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_UP,R_Down_evt);
			floatCanvas.cacheAsBitmap=true;
			
			linePicker.restore();
			
			
			addChild(compressedCanvas);
			addChild(floatCanvas);
		}
		
		protected function Down_evt(event:Event):void
		{
			for each(var arrow:CompressedLine in compressedCanvas.lineSpace) {
				if (arrow.hitTest(mouseX,mouseY)) {
					var focusedTar:CompressedLine=arrow;
					Net.WakeLine(arrow);
					focusedTar.Instance.dispatchEvent(event);
					break;
				}
			}
			event.stopPropagation();
		}
		
		protected function R_Down_evt(event:MouseEvent):void
		{
			for each(var arrow:CompressedLine in compressedCanvas.lineSpace) {
				if (arrow.hitTest(mouseX,mouseY)) {
					var focusedTar:CompressedLine=arrow;
					Net.WakeLine(arrow);
					focusedTar.Instance.showContextMenu();
					break;
				}
			}
		}
		
		
		///////////Children
		public function AddChild(line:BioArrow):void{
			floatCanvas.addChild(line);
		}
		
		public function AddCompressedChild(line:CompressedLine):void{
			compressedCanvas.addLine(line);
		}
		
		public function RemoveChild(line:CompressedLine):void{
			compressedCanvas.removeLine(line);
			if (line.Instance!=null&&floatCanvas.contains(line.Instance)) {
				floatCanvas.removeChild(line.Instance);
			}
		}
		
		public function browseMultiLines(arr:Array):void{
			compressedCanvas.browseMultiLines(arr);
			for each(var arrow:CompressedLine in arr) {
				if (arrow.Instance==null) {
					Net.WakeLine(arrow);
				}
				floatCanvas.addChild(arrow.Instance);
			}
		}
		
		public function wakeLine(arrow:CompressedLine):void{
			if (arrow.Instance==null) {
				Net.WakeLine(arrow);
			}
			floatCanvas.addChild(arrow.Instance);
		}
		//////0.3 Picker
		
		public function pickMultiLines(arr:Array):void{
			var hasLines:Boolean=false
			for each(var arrow:CompressedLine in arr) {
				if (arrow.Instance!=null&&floatCanvas.contains(arrow.Instance)){
					floatCanvas.removeChild(arrow.Instance);
					arrow.Instance=null;
				}
				hasLines=true;
			}
			
			if(hasLines){
				compressedCanvas.browseMultiLines(arr);
				linePicker.appendLines(arr);
				addChild(linePicker);
			}
		}
		
		public function placePickedLines():void{
			
			for each (var line:CompressedLine in linePicker.pickedLines) {
				compressedCanvas.addLine(line);
			}
			if(contains(linePicker)){
				removeChild(linePicker);
			}
			linePicker.clearLines();
		}
		
		public function flushPickedLines():void{
			if(!hasEventListener(Event.EXIT_FRAME)){
				addEventListener(Event.EXIT_FRAME,flushPickedLines_delay,false,1);
			}
		}
		
		public function flushPickedLines_delay(e):void{
			linePicker.redraw();
			removeEventListener(Event.EXIT_FRAME,flushPickedLines_delay);
		}
		////////
		public function compressMultiLines(arr:Array):void{
			for each(var arrow:CompressedLine in arr) {
				if (arrow.Instance!=null) {
					if (floatCanvas.contains(arrow.Instance)) {
						floatCanvas.removeChild(arrow.Instance);
					}
				}
				compressedCanvas.addLine(arrow);
				arrow.Instance=null;
			}
			trace("CompressComplete");
		}
		
		
		public function compressAllChild():void{
			var tmpLineSpace:Array=[];
			while(floatCanvas.numChildren>0){
				tmpLineSpace.push((floatCanvas.removeChildAt(0)as BioArrow).Creator);
			}
			for (var i:int = 0; i < tmpLineSpace.length; i++) {
				compressedCanvas.addLine(tmpLineSpace[i]);
				tmpLineSpace[i].Instance=null;
			}
		}
		
		public function Redraw():void{
			compressedCanvas.Redraw();
		}
		
		public function flushChild(FocusedTarget:CompressedLine):void{
			if (FocusedTarget.Instance!=null && floatCanvas.contains(FocusedTarget.Instance)) {
				FocusedTarget.Instance.redraw();
			}
			compressedCanvas.Redraw();
			
		}
		
		public function dimLight():void{
			compressedCanvas.alpha=0.5;
		}
		public function normalLight():void{
			compressedCanvas.alpha=1;
		}
		
		
	}
}