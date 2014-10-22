package Kernel.ProjectHolder
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Kernel.ProjectHolder.CoworkerManager.WorkerInfo;
	
	import UserInterfaces.FunctionPanel.CreateProjectPanel;
	import UserInterfaces.IvyBoard.IvyPanels.ProjectDetailPanel;
	import UserInterfaces.LoginAccount.AuthorizedURLLoader;
	import UserInterfaces.LoginAccount.ProjectManagePanel;
	import UserInterfaces.ReminderManager.ReminderManager;
	
	public class ProjectManager
	{
		
		public static var ProjectID:String="";
		public static var ProjectName:String="new Project";
		
		public static var authorID:String;
		public static var authorName:String="";
		
		public static var co_works:Array=[];
		
		
		public static var image:BitmapData=new BitmapData(200,200);
		
		public static var describe:String="";
		public static var species:String="";
		
		
		public function ProjectManager()
		{
		}
		
		public static function Upload():void{
			
			WindowSpace.addWindow(new Panel("Upload Project to Cloud",new CreateProjectPanel(ProjectName,true)));
			
		}
		
		public static function New():void{
			ProjectManager.ProjectName="new Project"
			ProjectManager.ProjectID="";
			ProjectManager.authorID=""
			ProjectManager.authorName=""
			ProjectManager.species=""
			ProjectManager.describe=""
			
			ProjectManager.co_works=[];
			
			ProjectDetailPanel.refreshDetail();
		}
		
		public static function Create():void{
			
			WindowSpace.addWindow(new Panel("Create a Project on Cloud",new CreateProjectPanel("new Project")));
			
		}
		
		public static function openProject(pid:String):void
		{
			trace(GlobalVaribles.PROJECT_INTERFACE+pid+"/");
			var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_INTERFACE+pid+"/");
			
			var loader:AuthorizedURLLoader=new AuthorizedURLLoader();
			loader.load(urequest);
			loader.addEventListener(Event.COMPLETE,openProject_cmp);
		}
		
		private static function openProject_cmp(e):void{
			
			var project:Object=JSON.parse(e.target.data);
			
			trace("Project Open:",project.result.prj_name);
			
			ProjectManager.ProjectName=project.result.prj_name;
			ProjectManager.ProjectID=project.result.pid;
			ProjectManager.authorID=project.result.authorid;
			ProjectManager.authorName=project.result.author;
			ProjectManager.species=project.result.species;
			ProjectManager.describe=project.result.description;
			
			ProjectManager.co_works=[];
			
			for each (var worker:Object in project.result.collaborators)
			{
				ProjectManager.co_works.push(new WorkerInfo(worker.username,worker.uid,new BitmapData(200,200)));
			}
			
			ProjectDetailPanel.refreshDetail();
			
			ProjectManagePanel._Project.text="Editing : "+ProjectName;
			ProjectManagePanel._Project.x=105-ProjectManagePanel._Project.width/2


			ReminderManager.remind("Now synchronizing...")
			var projectLoader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest(GlobalVaribles.PROJECT_LOAD_PROJECT))
			projectLoader.addEventListener(Event.COMPLETE,loadProject);
		}
		
		protected static function loadProject(event:Event):void
		{
			trace(event.target.data);
			
			GxmlContainer.loadJsonNet(event.target.data);
			ReminderManager.remind("Synchronizing Complete")
		}
	}
}