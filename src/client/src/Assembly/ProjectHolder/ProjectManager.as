package Assembly.ProjectHolder
{
	import flash.display.BitmapData;

	public class ProjectManager
	{
		
		public static var ProjectID:int=0;
		public static var ProjectName:String="ZL";
		
		public static var authorID:String;
		public static var authorName:String="ZL";
		
		public static var co_works:Array=[{Name:"Zhaosensen1",ID:7,image:new BitmapData(200,200)},{Name:"Zhaosensen2",ID:7,image:new BitmapData(200,200)},{Name:"Zhaosensen3",ID:7,image:new BitmapData(200,200)},{Name:"Zhaosensen4",ID:6,image:new BitmapData(200,200)},{Name:"Boss Jin",ID:7,image:new BitmapData(200,200)}];
		
		
		public static var image:BitmapData=new BitmapData(200,200);
		
		public static var describe:String="no";
		public static var species:String="Ecoli";
		
		
		
		public function ProjectManager()
		{
		}
	}
}