package LoginAccount
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
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
	
	import Style.FontPacket;
	
	import fl.events.ListEvent;

	public class ProjectDetailPanel extends Sprite
	{
		
		private static var CoworkerPanel:CoWorkerList=new CoWorkerList();
		
		private var addCoWorker:Icon_ADD_COWORKER=new Icon_ADD_COWORKER();
		
		
		private var coworkerPane:CoWorkerPanel=new CoWorkerPanel();
		private var coPanel:Panel=new Panel("Co-worker",coworkerPane)
			
		private var _title:TitleTextField=new TitleTextField("Project : ");
		private var chgpjct:LinkTextField=new LinkTextField("ChangeProject");
		
		private var fields:Object=new Object();
		
		public function ProjectDetailPanel()
		{
			
			chgpjct.htmlText='<a href="event:changeProject"><u>Change Project</u></a>';

			chgpjct.addEventListener(TextEvent.LINK,changeProject);
			

		}
		
		protected function changeProject(event:TextEvent):void
		{
			ProjectManager.ProjectID=-1;
		}
		
		public function setSize(w:Number):void{
			_title.text="Project : "+ProjectManager.ProjectName;
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,0,0,_title);
			
			var details:Array=[
				{label:"name",text:ProjectManager.ProjectName},
				{label:"author",Ineditable:true,text:ProjectManager.authorName},
				{label:"co-workers",Ineditable:true,text:getworks()},
				{label:"species",text:ProjectManager.species},
				{label:"description",multiLines:true,lines:4,text:ProjectManager.describe}
			];
			
			var align:int=100;
			
			var sy:int=40;
			
			for (var i:int = 0; i < details.length; i++){
				
				var label:LabelTextField=new LabelTextField(details[i].label+" : ");
				fields[details[i].label]=new TextInput(false,details[i].multiLines,details[i].Ineditable);
				
				if(details[i].hasOwnProperty("text")){
					fields[details[i].label].text=details[i].text;
				}
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,sy+i*60,5,label);
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT_STICK,10,sy+i*60+30,5,w,fields[details[i].label]);
				
				if(details[i].multiLines){
					fields[details[i].label].setSize(fields[details[i].label].Width,30*details[i].lines);
				}
				
			}
			
			addChild(addCoWorker);
			
			fields["co-workers"].setSize(fields["co-workers"].Width-30,fields["co-workers"].height);
			
			addCoWorker.x=fields["co-workers"].x+fields["co-workers"].width+addCoWorker.width/2+3;
			addCoWorker.y=fields["co-workers"].y+fields["co-workers"].height/2;
			
			
			CoworkerPanel.x=fields["co-workers"].x;
			CoworkerPanel.y=fields["co-workers"].y+fields["co-workers"].height;
			CoworkerPanel.setSize(fields["co-workers"].width,400-CoworkerPanel.y);
			CoworkerPanel.addEventListener("changed",function (e):void{
				fields["co-workers"].text=getworks();
			});
			fields["co-workers"].addEventListener("click",showCoworkers);
			addCoWorker.addEventListener("click",addCoWorkerEvt);
			
			fields["name"].addEventListener(FocusEvent.FOCUS_OUT,save);
			fields["species"].addEventListener(FocusEvent.FOCUS_OUT,save);
			fields["description"].addEventListener(FocusEvent.FOCUS_OUT,save);
			
			function save(e):void{
				if(ProjectManager.ProjectName!=fields["name"].text||ProjectManager.describe!=fields["description"].text||ProjectManager.species!=fields["species"].text){
					ProjectManager.ProjectName=fields["name"].text;
					ProjectManager.describe=fields["description"].text;
					ProjectManager.species=fields["species"].text;
					
					sycProject();
				}
			}
		}
		private function addCoWorkerEvt(e):void
		{
			coworkerPane.flushWorkerList();
			WindowSpace.addWindow(coPanel);
			
		}
		
		private function getworks():String{
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
					ReminderManager.remind("Project Attribution Saved");
				}
			});
		}
		protected function hitOut(event:MouseEvent):void
		{
			
			if (!CoworkerPanel.contains(event.target as DisplayObject)&&!fields["co-workers"].hitTestPoint(stage.mouseX,stage.mouseY)) {
				removeChild(CoworkerPanel)
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,hitOut)
			};
		}
	}
}