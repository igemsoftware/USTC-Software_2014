package Kernel.Biology{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import Kernel.Biology.Types.LinkType;
	
	/**
 	* This Class initial the parameters for LinkTypes
	 * If the settings have not been changed by the user, these parameters are read from local storage file. (/BioNexusType.xml)
	 * If the settings are changed, the parameters will be read from user save file (appstroage dictionary)
 	*/
	public class LinkTypeInit{
		
		///Type list, accessed by type identificator
		public static var LinkTypeList:Array=new Array();
		
		///Type list (indexed), accessed by index
		public static var LinkTypeIndexList:Array=new Array();
		
		
		/**
		 * Init Link types
		 * @param force if force is true, types will read default parameters. User setting will be ignored.
		 */
		public function LinkTypeInit(force:Boolean=false){
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
			
			///this loads all the LinkTypes.
			for each(var txml:XML in xml) {
					
				var biotp:LinkType=new LinkType(xml[i].@Name,xml[i].label,xml[i].lineColor,xml[i].shape,xml[i].stroke,xml[i].start,xml[i].end);
				LinkTypeList[xml[i].@Name]=biotp;
				LinkTypeIndexList[i]=biotp;
				i++
			}
		}
		
		/**
		 * getter::To get a clone (deep clone) of the Indexed type list
		 * @return the clone
		 */
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
		
		/**
		 * Save user type setting.
		 * types are saved in XML format.
		 * saved file locates in appData folder (different by operation system)
		 */
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
		
		/**
		 * This is the writer for the XML of a user type to be saved,
		 * @param type The LinkType to be saved. 
		 * @return XML of the type
		 */
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