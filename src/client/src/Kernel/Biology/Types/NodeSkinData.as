package Kernel.Biology.Types{
	
	
	/**Structure for the skin data of a certain type of nodes
	 * Include following:
	 * construct a skindata;
	 * apply new properties for current skindata
	 * copy properties from another skindata (clone);
	 */
	
	public class NodeSkinData {
		
		///Color of node
		public var color:uint;
		
		///Shape of node @see SymbolType.as
		public var shape:int;
		
		///Width of the outline of node 
		public var stroke:int;
		
		///Color of the outline of node
		public var lineColor:uint;
		
		///Radius of node
		public var radius:Number;
		
		/**
		 * Construct a Node skindata;
		 */
		public function NodeSkinData(colo,shap,strok,lineColo,radiu){
			color=colo;
			shape=shap;
			stroke=strok;
			lineColor=lineColo;
			radius=radiu;
			
		}
		
		
		/**
		 * Apply new properties
		 */
		public function setSkinData(colo,shap,strok,lineColo,radiu):void{
			
			color=colo;
			shape=shap;
			stroke=strok;
			lineColor=lineColo;
			radius=radiu;
		}
		
		/**
		 * Clone another Node skindata;
		 * @param skin Skindata to clone
		 */
		public function copySkinData(skin:NodeSkinData):void{
			
			color=skin.color;
			shape=skin.shape;
			stroke=skin.stroke;
			lineColor=skin.lineColor;
			radius=skin.radius;
		}
	}
}