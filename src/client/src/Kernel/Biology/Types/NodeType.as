package Kernel.Biology.Types{
	import flash.display.BitmapData;
		
	/**Structure for NodeType
	 * Include following:
	 * construct a NodeType;
	 * apply new properties for current NodeType
	 * copy properties from another NodeType (clone);
	 */
	public class NodeType {
		
		///Type label
		public var label:String;
		
		///Type identificator
		public var Type:String;
		
		///Type icon
		public var icon:BitmapData;
		
		///Scale of the type icon
		public var iconScale:Number;
		
		///The file path of the icon
		public var iconPath:String;
		
		///The skindata of this type
		public var skindata:NodeSkinData;
		
		
		/**
		 * Construct a LinkType;
		 */
		public function NodeType(Typ,ico,iconPat,labe,colo,shap,strok,lineColo,radiu)
		{
			label=labe;
			Type=Typ;
			icon=ico;
			iconPath=iconPat;
			
			iconScale=radiu*1.1/Math.max(ico.height,ico.width);
			
			skindata=new NodeSkinData(colo,shap,strok,lineColo,radiu);
		}
		
		/**
		 * apply new properties for current NodeType
		 */
		public function setBioType(Typ,ico,iconPat,labe,colo,shap,strok,lineColo,radiu):void
		{
			label=labe;
			Type=Typ;
			icon=ico;
			iconPath=iconPat;
			
			iconScale=radiu*1.1/Math.max(ico.height,ico.width);
			
			skindata.setSkinData(colo,shap,strok,lineColo,radiu);
		}
		
		/**
		 * clone another NodeType
		 */
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