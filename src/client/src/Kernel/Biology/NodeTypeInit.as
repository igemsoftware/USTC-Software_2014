package Kernel.Biology{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import Kernel.Assembly.LoaderWithNum;
	import Kernel.Biology.Types.NodeType;
	
	/**
	 * This Class initial the parameters for NodeTypes
	 * If the settings have not been changed by the user, these parameters are read from local storage file. (/BioType.xml)
	 * If the settings are changed, the parameters will be read from user save file (appstroage dictionary)
	 */
	public class NodeTypeInit{
		
		///Type list, accessed by type identificator
		public static var BiotypeList:Array=[];
		
		///Type list (indexed), accessed by index
		public static var BiotypeIndexList:Array=[];
		
		
		/**
		 * Init Node types
		 */
		public function NodeTypeInit(){
			var f:File;
			var fs:FileStream = new FileStream();
			
			try{
				
				f=File.applicationStorageDirectory.resolvePath("bioType.xml");
				fs.open(f, flash.filesystem.FileMode.READ);
				trace("Load user Type");
			}catch(error:Error) {
				trace("No user Type");
				f=File.applicationDirectory.resolvePath("bioType.xml");
				fs.open(f, flash.filesystem.FileMode.READ);
			}
			
			var xml:XMLList = XML(fs.readUTFBytes(fs.bytesAvailable)).children();
			fs.close();
			
			var loadnum:int=0;
			var key:Array=[];
			
			var i:int=0;
			
			///this loads all the LinkTypes.
			for each (var typexml:XML in xml) {
				key[i]=typexml;
				var iconloader:LoaderWithNum=new LoaderWithNum(i,key[i].iconPath);
				iconloader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
					var bmp:Bitmap = Bitmap(event.target.content);
					var j:int=event.currentTarget.loader.num;
					var IconMap:BitmapData=BitmapData(bmp.bitmapData);
					
					var biotp:NodeType=new NodeType(key[j].@Name,IconMap,key[j].iconPath,key[j].label,key[j].color,key[j].shape,3,0xeeeeee,key[j].radius);
					BiotypeList[key[j].@Name]=biotp;
					BiotypeIndexList[j]=biotp;
					
				});
				
				iconloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function iconloader_ioErrorHandler(event):void
				{
					var f2:File=File.applicationStorageDirectory.resolvePath(event.currentTarget.loader.url);
					var fs2:FileStream=new FileStream();
					var IconMap:BitmapData
					
					try{
						fs2.open(f2, flash.filesystem.FileMode.READ);
						var j:int=event.currentTarget.loader.num
						var bytes:ByteArray=new ByteArray();
						var w:int=fs2.readInt();
						var h:int=fs2.readInt();
						fs2.readBytes(bytes);
						IconMap=new BitmapData(w,h,true,0);
						IconMap.setPixels(new Rectangle(0,0,w,h),bytes);
					}finally{
						
						IconMap=new BitmapData(10,10,true,0);
						
					}
					
					
					var biotp:NodeType=new NodeType(key[j].@Name,IconMap,key[j].iconPath,key[j].label,key[j].color,key[j].shape,3,0xeeeeee,key[j].radius);
					
					BiotypeList[key[j].@Name]=biotp;
					BiotypeIndexList[j]=biotp;
				});
				
				i++;
			}
			
		}
		
		
		/**
		 * getter::To get a clone (deep clone) of the Indexed type list
		 * @return the clone
		 */
		public static function get BiotypeProvider():Array{
			var item:NodeType;
			var tmpdp:Array=new Array();
			for(var i:int;i<BiotypeIndexList.length;i++) {
				item=BiotypeIndexList[i];
				var biotp:NodeType=new NodeType(item.Type,item.icon,item.iconPath,item.label,item.skindata.color,item.skindata.shape,item.skindata.stroke,item.skindata.lineColor,item.skindata.radius);
				tmpdp.push(biotp);
			}
			return tmpdp;
		}
		
		
		/**
		 * Save user type setting.
		 * types are saved in XML format.
		 * saved file locates in appData folder (different by operation system)
		 */
		public static function saveBioType():void{
			var f:File;
			var fs:FileStream = new FileStream();
			
			f=File.applicationStorageDirectory.resolvePath("bioType.xml");
			fs.open(f, flash.filesystem.FileMode.WRITE);
			
			var resXML:XML=<Types></Types>
			
			for (var i:int = 0; i < BiotypeIndexList.length; i++) {
				
				resXML.appendChild(mergeType(BiotypeIndexList[i]));
				
			}
			
			fs.writeUTFBytes(resXML.toXMLString());
			
			fs.close();
			
		}
		
		
		/**
		 * This is the writer for the XML of a user type to be saved,
		 * @param type The NodeType to be saved. 
		 * @return XML of the type
		 */
		private static function mergeType(type:NodeType):XML{
			var tmpxml:XML=
				<type Name={type.Type}>
						<label>{type.label}</label>
						<iconPath>{type.iconPath}</iconPath>
						<color>{type.skindata.color}</color>
						<shape>{type.skindata.shape}</shape> 
						<radius>{type.skindata.radius}</radius>
				</type>
			return tmpxml;
		}
		
	}
}