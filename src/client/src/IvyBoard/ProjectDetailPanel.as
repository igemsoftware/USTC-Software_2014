package IvyBoard
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.LinkTextField;
	import GUI.Assembly.TextInput;
	import GUI.Assembly.TitleTextField;
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Layout.LayoutManager;
	import Layout.ReminderManager;
	
	import LoginAccount.AuthorizedURLLoader;
	import LoginAccount.CoWorkerList;
	import LoginAccount.CoWorkerPanel;
	
	public class ProjectDetailPanel extends Sprite
	{
		
		private static var CoworkerPanel:CoWorkerList=new CoWorkerList();
		
		private static var addCoWorker:Icon_ADD_COWORKER=new Icon_ADD_COWORKER();
		
		
		private static var coworkerPane:CoWorkerPanel=new CoWorkerPanel();
		private static var coPanel:Panel;
		
		private static var _title:TitleTextField=new TitleTextField("");
		private static var chgpjct:LinkTextField=new LinkTextField("ChangeProject");
		
		private static var fields:Object=new Object();
		private var Width:Number;
		
		private var details:Array=[
			{label:"name",text:ProjectManager.ProjectName},
			{label:"author",Ineditable:true,text:ProjectManager.authorName},
			{label:"colleagues",Ineditable:true,text:getworks()},
			{label:"species",text:ProjectManager.species},
			{label:"description",multiLines:true,lines:8,text:ProjectManager.describe}
		];
		
		public function ProjectDetailPanel()
		{
			var align:int=100;
			
			var sy:int=40;
			
			for (var i:int = 0; i < details.length; i++){
				
				var label:LabelTextField=new LabelTextField(details[i].label+" : ");
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,sy+i*60,5,label);
				
				fields[details[i].label]=new TextInput(false,details[i].multiLines,details[i].Ineditable);
				
				if(details[i].hasOwnProperty("text")){
					fields[details[i].label].text=details[i].text;
				}
				
				if(details[i].label=="colleagues"){
					addCoWorker.y=label.y+addCoWorker.height/2
				}
				
			}
			
			addChild(addCoWorker);
			
			
			CoworkerPanel.addEventListener("changed",function (e):void{
				fields["colleagues"].text=getworks();
			});
			
			fields["colleagues"].addEventListener("click",showCoworkers);
			addCoWorker.addEventListener("click",addCoWorkerEvt);
			
			fields["name"].addEventListener(FocusEvent.FOCUS_OUT,save);
			fields["species"].addEventListener(FocusEvent.FOCUS_OUT,save);
			fields["description"].addEventListener(FocusEvent.FOCUS_OUT,save);
			
			function save(e):void{
				
				if(ProjectManager.ProjectName!=fields["name"].text||ProjectManager.describe!=fields["description"].text||ProjectManager.species!=fields["species"].text){
					
					ProjectManager.ProjectName=fields["name"].text;
					ProjectManager.describe=fields["description"].text;
					ProjectManager.species=fields["species"].text;
					
					_title.text=ProjectManager.ProjectName;
					if(ProjectManager.ProjectID!=-1){
						sycProject();
					}
				}
			}
		}
		
		public static function refreshDetail():void
		{
			
			_title.text=ProjectManager.ProjectName;
			
			fields["name"].text=ProjectManager.ProjectName;
			fields["author"].text=ProjectManager.authorName;
			fields["colleagues"].text=getworks();
			fields["species"].text=ProjectManager.species;
			fields["description"].text=ProjectManager.describe;
		}
		
		public function setSize(w:Number):void{
			
			Width=w;
			
			_title.text=ProjectManager.ProjectName;
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,0,0,_title);
			
			var sy:int=37;
			
			for (var i:int = 0; i < details.length; i++){
				
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT_STICK,10,sy+i*60+30,5,w,fields[details[i].label]);
				
				if(details[i].multiLines){
					fields[details[i].label].setSize(fields[details[i].label].Width,24*details[i].lines);
				}
				
			}
			
			addCoWorker.x=w-addCoWorker.width/2-5;
			
			CoworkerPanel.x=fields["colleagues"].x;
			CoworkerPanel.y=fields["colleagues"].y+fields["colleagues"].height;
			CoworkerPanel.setSize(fields["colleagues"].width,600-CoworkerPanel.y);
			
		}
		private function addCoWorkerEvt(e):void
		{
			if(ProjectManager.ProjectID!=-1){
				coworkerPane.flushWorkerList();
				if(coPanel==null){
					coPanel=new Panel("Co-worker",coworkerPane)
				}
				WindowSpace.addWindow(coPanel);
			}else{
				ReminderManager.remind("Only online Porject can modify colleagues")
			}
		}
		
		private static function getworks():String{
			var Coworkers:String="";
			
			if(ProjectManager.co_works.length>0){
				
				Coworkers=ProjectManager.co_works[0].Name;
				
				for (var j:int = 1; j < ProjectManager.co_works.length; j++){
					Coworkers+=", "+ProjectManager.co_works[j].Name;
				}
			}
			return Coworkers;
		};
		
		protected function showCoworkers(event):void{
			addChild(CoworkerPanel);
			CoworkerPanel.flushWorkerList();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,hitOut);
		}
		public function sycProject():void{
			
			var urlVar:URLVariables=new URLVariables();
			
			urlVar.name=ProjectManager.ProjectName;
			urlVar.species=ProjectManager.species;
			urlVar.description=ProjectManager.describe;
			
			var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_CURRENT);
			urequest.method=URLRequestMethod.PUT;
			
			urequest.data=urlVar;
			
			var loader:AuthorizedURLLoader=new AuthorizedURLLoader();
			loader.load(urequest);
			
			loader.addEventListener(Event.COMPLETE,function (e):void{
				if((e.target.data).indexOf("success")!=-1){
					ReminderManager.remind("Project information saved");
				}
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR,function (e):void{
				ReminderManager.remind("Cannot save project information to cloud");
			});
		}
		protected function hitOut(event:MouseEvent):void
		{
			
			if (!CoworkerPanel.contains(event.target as DisplayObject)&&!fields["colleagues"].hitTestPoint(stage.mouseX,stage.mouseY)) {
				removeChild(CoworkerPanel)
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,hitOut)
			};
		}
	}
}