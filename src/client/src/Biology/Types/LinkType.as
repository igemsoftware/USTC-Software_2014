package Biology.Types{
	
	public class LinkType{
		
		public var label:String;
		public var Type:String;
		public var icon:*;
		
		public var skindata:LinkSkinData;

		public function LinkType(typ,labe,colo,shap,strok,s,e){
			label=labe;
			Type=typ;
			skindata=new LinkSkinData(colo,shap,strok,s,e);
			
		}
		public function setLinkType(typ,labe,colo,shap,strok,s,e):void
		{
			label=labe;
			Type=typ;
			skindata.setSkinData(colo,shap,strok,s,e);
		}
		public function copyLinkType(type:LinkType):void
		{
			label=type.label;
			Type=type.Type;
			skindata.copySkinData(type.skindata);
		}
	}
}