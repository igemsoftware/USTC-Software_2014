package Kernel.Biology.Types{
	
	
	/**Structure for the skin data of a certain type of links
	 * Include following:
	 * construct a skindata;
	 * apply new properties for current skindata
	 * copy properties from another skindata (clone);
	 */
	public class LinkSkinData {
		
		///Line color
		public var lineColor:uint;
		
		///Line Type, @see SymbolType.as
		public var lineType:int;
		
		///Line Width
		public var stroke:int;
		
		///Start Arrow Type
		public var startArrowType:int;
		
		///End Arrow Type
		public var endArrowType:int;
		
		/**
		 * Construct a Line skindata;
		 */
		public function LinkSkinData(colo,type,strok,start,end){
			lineColor=colo;
			lineType=type;
			stroke=strok;
			startArrowType=start;
			endArrowType=end;
		}
		
		/**
		 * Apply new Link skindata;
		 */
		public function setSkinData(colo,type,strok,start,end):void{
			
			lineColor=colo;
			lineType=type;
			stroke=strok;
			startArrowType=start;
			endArrowType=end;
		}
		
		/**
		 * Clone another Link skindata;
		 * @param skin Skindata to clone
		 */
		public function copySkinData(skin:LinkSkinData):void{
			
			lineColor=skin.lineColor;
			lineType=skin.lineType;
			stroke=skin.stroke;
			startArrowType=skin.startArrowType;
			endArrowType=skin.endArrowType;
		}
		
	}
}