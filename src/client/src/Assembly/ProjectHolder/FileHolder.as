package Assembly.ProjectHolder{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import Layout.ReminderManager;
	
	
	public class FileHolder{
		
		public static var currentFile:File;
		
		public function FileHolder(){
			
		}
		
		public static function New():void{
			currentFile=null;
		}
		
		public static function open(title:String,filters:Array):File{
			var tmpFile:File=new File();
			tmpFile.browseForOpen(title,filters);
			tmpFile.addEventListener(Event.SELECT,function (e):void{
				tmpFile.load();
			});
			tmpFile.addEventListener(Event.COMPLETE,function (e):void{
			
				currentFile=tmpFile;
				
			},false,100);
			
			return tmpFile;
		}
		
		public static function save(content:String,next:Function=null):void{
			var fs:FileStream=new FileStream();
			
			if(currentFile!=null){
				try{
					fs.open(currentFile,FileMode.WRITE)
					fs.writeUTFBytes(content);
					ReminderManager.remind("Project saved.");
					if(next!=null){
						next();
					}
				}catch(error:Error) {
					saveAs(content,next);
				}
				
			}else{
				saveAs(content,next);
			}
		}
		
		public static function saveAs(content:String,next:Function=null):void{
			var filename:String;
			
			currentFile!=null?filename=currentFile.name:filename=".xml"
			
			var tmpFile:File=new File();
			tmpFile.save(content,filename);
			
			tmpFile.addEventListener(Event.COMPLETE,function (e):void{
				currentFile=tmpFile;
				ReminderManager.remind("Project saved.");
				if(next!=null){
					next();
				}
			})
		}
		
	}
}