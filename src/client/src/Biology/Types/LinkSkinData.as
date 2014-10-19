package Biology.Types{
	
	public class LinkSkinData {
		
		public var lineColor:uint;
		public var lineType:int;
		public var stroke:int;
		public var startArrowType:int;
		public var endArrowType:int;
		
		public function LinkSkinData(colo,type,strok,start,end){
			lineColor=colo;
			lineType=type;
			stroke=strok;
			startArrowType=start;
			endArrowType=end;
		}
		
		public function setSkinData(colo,type,strok,start,end):void{
			
			lineColor=colo;
			lineType=type;
			stroke=strok;
			startArrowType=start;
			endArrowType=end;
		}
		
		public function copySkinData(skin:LinkSkinData):void{
			
			lineColor=skin.lineColor;
			lineType=skin.lineType;
			stroke=skin.stroke;
			startArrowType=skin.startArrowType;
			endArrowType=skin.endArrowType;
		}
		
	}
}