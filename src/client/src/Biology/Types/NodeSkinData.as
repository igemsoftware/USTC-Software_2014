package Biology.Types{
	
	public class NodeSkinData {
		
		public var color:uint;
		public var shape:int;
		public var stroke:int;
		public var lineColor:uint;
		public var radius:Number;
		
		public function NodeSkinData(colo,shap,strok,lineColo,radiu){
			color=colo;
			shape=shap;
			stroke=strok;
			lineColor=lineColo;
			radius=radiu;
			
		}
		
		public function setSkinData(colo,shap,strok,lineColo,radiu):void{
			
			color=colo;
			shape=shap;
			stroke=strok;
			lineColor=lineColo;
			radius=radiu;
		}
		
		public function copySkinData(skin:NodeSkinData):void{
			
			color=skin.color;
			shape=skin.shape;
			stroke=skin.stroke;
			lineColor=skin.lineColor;
			radius=skin.radius;
		}
	}
}