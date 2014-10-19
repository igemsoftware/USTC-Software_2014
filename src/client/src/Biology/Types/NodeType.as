package Biology.Types{
	import flash.display.BitmapData;
	
	import Assembly.Canvas.I3DPlate;
	
	public class NodeType {
		
		public var label:String;
		public var Type:String;
		public var icon:BitmapData;
		
		public var iconScale:Number;
		
		public var iconPath:String;
		
		public var skindata:NodeSkinData;
		
		public function NodeType(Typ,ico,iconPat,labe,colo,shap,strok,lineColo,radiu)
		{
			label=labe;
			Type=Typ;
			icon=ico;
			iconPath=iconPat;
			
			iconScale=radiu*1.1/Math.max(ico.height,ico.width);
			
			skindata=new NodeSkinData(colo,shap,strok,lineColo,radiu);
		}
		public function setBioType(Typ,ico,iconPat,labe,colo,shap,strok,lineColo,radiu):void
		{
			label=labe;
			Type=Typ;
			icon=ico;
			iconPath=iconPat;
			
			iconScale=radiu*1.1/Math.max(ico.height,ico.width);
			
			skindata.setSkinData(colo,shap,strok,lineColo,radiu);
		}
		public function copyBioType(type:NodeType):void
		{
			label=type.label;
			Type=type.Type;
			icon=type.icon;
			iconPath=type.iconPath;
			
			skindata.copySkinData(type.skindata);
			
			iconScale=skindata.radius*1.1/Math.max(icon.height,icon.width);
		}
	}
}