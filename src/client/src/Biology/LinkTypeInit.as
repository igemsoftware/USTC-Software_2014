package Biology{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import Biology.Types.LinkType;
	
	
	public class LinkTypeInit{
		
		public static var LinkTypeList:Array=new Array();
		public static var LinkTypeIndexList:Array=new Array();
		
		public function LinkTypeInit(force=false){
			var f:File;
			var fs:FileStream = new FileStream();
			
			if(force){
				trace("Force restore Default");
				try{
					f=File.applicationStorageDirectory.resolvePath("bioNexusType.xml");
					f.deleteFile();
				}catch(error:Error) {
				}
				f=File.applicationDirectory.resolvePath("bioNexusType.xml");
				fs.open(f, flash.filesystem.FileMode.READ);
			}else{
				try{
					f=File.applicationStorageDirectory.resolvePath("bioNexusType.xml");
					fs.open(f, flash.filesystem.FileMode.READ);
					trace("Load user Line Type");
				}catch(error:Error) {
					trace("No user Line Type");
					f=File.applicationDirectory.resolvePath("bioNexusType.xml");
					fs.open(f, flash.filesystem.FileMode.READ);
				}
			}
			
			var xml:XMLList = XML(fs.readUTFBytes(fs.bytesAvailable)).children();
			
			fs.close();
			
			var i:int=0;
			for each(var txml:XML in xml) {
				var biotp:LinkType=new LinkType(xml[i].@Name,xml[i].label,xml[i].lineColor,xml[i].shape,xml[i].stroke,xml[i].start,xml[i].end);
				LinkTypeList[xml[i].@Name]=biotp;
				LinkTypeIndexList[i]=biotp;
				i++
			}
		}
		public static function get LinktypeProvider():Array{
			var item:LinkType;
			var tmpdp:Array=new Array();
			for(var i:int;i<LinkTypeIndexList.length;i++) {
				item=LinkTypeIndexList[i];
				var icon:BitmapData;
				var linktp:LinkType=new LinkType(item.Type,item.label,
					item.skindata.lineColor,item.skindata.lineType,item.skindata.stroke,
					item.skindata.startArrowType,item.skindata.endArrowType);
				tmpdp.push(linktp);
			}
			return tmpdp;
		}
		
		public static function saveLinkType():void{
			var f:File;
			var fs:FileStream = new FileStream();
			
			f=File.applicationStorageDirectory.resolvePath("bioNexusType.xml");
			fs.open(f, flash.filesystem.FileMode.WRITE);
			
			var resXML:XML=<Types></Types>
			
			for (var i:int = 0; i < LinkTypeIndexList.length; i++) {
				
				resXML.appendChild(mergeType(LinkTypeIndexList[i]));
				
			}
			
			fs.writeUTFBytes(resXML.toXMLString());
			
			fs.close();
			
		}
		private static function mergeType(type:LinkType):XML{
			var tmpxml:XML=
				<type Name={type.Type}>
						<label>{type.label}</label>
						<lineColor>{type.skindata.lineColor}</lineColor>
						<shape>{type.skindata.lineType}</shape> 
						<stroke>{type.skindata.stroke}</stroke>
						<start>{type.skindata.startArrowType}</start>
						<end>{type.skindata.endArrowType}</end>
				</type>
			return tmpxml;
		}
	}
}