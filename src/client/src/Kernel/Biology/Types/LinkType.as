package Kernel.Biology.Types{
	
	/**Structure for linkType
	 * Include following:
	 * construct a linkType;
	 * apply new properties for current linkType
	 * copy properties from another linkType (clone);
	 */
	public class LinkType{
		
		///Type label
		public var label:String;
		
		///Type identification
		public var Type:String;
		
		///Type icon, currently not used
		public var icon:*;
		
		///skindata for this type @see LinkSkinData.as
		public var skindata:LinkSkinData;

		/**
		 * Construct a LinkType;
		 */
		public function LinkType(typ,labe,colo,shap,strok,s,e){
			label=labe;
			Type=typ;
			skindata=new LinkSkinData(colo,shap,strok,s,e);
			
		}
		
		/**
		 * apply new properties for current linkType
		 */
		public function setLinkType(typ,labe,colo,shap,strok,s,e):void
		{
			label=labe;
			Type=typ;
			skindata.setSkinData(colo,shap,strok,s,e);
		}
		
		/**
		 * clone another linkType
		 */
		public function copyLinkType(type:LinkType):void
		{
			label=type.label;
			Type=type.Type;
			skindata.copySkinData(type.skindata);
		}
	}
}