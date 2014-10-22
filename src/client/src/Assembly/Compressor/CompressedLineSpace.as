package Assembly.Compressor
{
	import flash.display.Sprite;
	
	import Assembly.BioParts.BioArrow;
	
	public class CompressedLineSpace extends Sprite
	{
		
		public var lineSpace:Array=[];
		public function CompressedLineSpace(){
			cacheAsBitmap=true;
		}
		
		public var focusedLine:BioArrow;
		
		public function addLine(line:CompressedLine):void{
			if(lineSpace[line.ID]==null){
				lineSpace[line.ID]=line;
				appendLine(line);
			}
		}
		public function removeLine(line:CompressedLine):void{
			graphics.clear();
		
			delete lineSpace[line.ID];

			Redraw();

		}
		public function browseMultiLines(lines:Array):void{
			graphics.clear();
			for each(var arrow:CompressedLine in lineSpace) {
				if (lines[arrow.ID]!=null) {
					delete lineSpace[arrow.ID];
				}else{
					appendLine(arrow);
				}
			}
		}
		public function appendLine(line:CompressedLine):void{
			line.drawSkin(this.graphics);
		}
		
		public function Redraw():void{
			graphics.clear();
			for each(var arrow:CompressedLine in lineSpace) {
				appendLine(arrow);
			}
		}
	}
}