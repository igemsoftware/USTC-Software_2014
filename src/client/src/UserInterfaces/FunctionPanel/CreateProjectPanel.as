package UserInterfaces.FunctionPanel
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import Kernel.ProjectHolder.ProjectManager;
	import Kernel.ProjectHolder.SyncManager;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.ReminderManager.ReminderManager;
	
	import UserInterfaces.LoginAccount.AuthorizedURLLoader;

	public class CreateProjectPanel extends Sprite
	{
		
		private var hint:Clound_inf=new Clound_inf();
		
		private var pro_name:TextInput=new TextInput();
		
		private var ok_b:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		private var project_hint:LabelTextField=new LabelTextField("Project Name :");
		
		private var hitA:HitBox=new HitBox(hint.width+10,hint.height+60);
		
		private var upload:Boolean=false;
		
		public function CreateProjectPanel(defNam:String,upld=false)
		{
			
			pro_name.text=defNam;
			
			ok_b.label="Confirm";
			ok_b.setSize(100,pro_name.Height);
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT_STICK,10,10,5,hint.width-110,project_hint,pro_name);
			ok_b.x=pro_name.x+pro_name.Width;
			ok_b.y=pro_name.y;
			hint.x=5;
			hint.y=55;
			addChild(hitA);
			addChild(hint);
			addChild(ok_b);
			ok_b.addEventListener(MouseEvent.CLICK,click_evt);
			
			pro_name.addEventListener("Enter",click_evt);
			
			upload=upld;
			
		}
		
		protected function click_evt(event):void
		{
			if(pro_name.text.length>0&&ok_b.mouseEnabled){
				if(stage!=null){
					stage.focus=null;
				}
				ok_b.suspend();
				
				var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_MY);
				
				var urlV:URLVariables=new URLVariables();
				urlV.prj_name=pro_name.text;
				
				urequest.method=URLRequestMethod.POST;
				
				urequest.data=urlV;
				
				var uloader:AuthorizedURLLoader=new AuthorizedURLLoader();
				
				uloader.load(urequest);
				
				uloader.addEventListener(IOErrorEvent.IO_ERROR,function (e):void{
					ok_b.unsuspend();
				});
				
				uloader.addEventListener(Event.COMPLETE,function (e):void{
					
					ok_b.unsuspend();
					
					trace(e.target.data);
					
					var tmpJson:Object=JSON.parse(e.target.data.split("'").join('"'));
					
					if(tmpJson.status=="success"){
						trace("PID : ",tmpJson.pid);
						
						if(upload){
							ReminderManager.remind("Create project complete. Now synchronizating...");
							ProjectManager.ProjectID=tmpJson.pid;
							SyncManager.SYNC();
						}else{
							ReminderManager.remind("Create project complete. Now Switching Project...");
							ProjectManager.openProject(tmpJson.pid);
						}
						
						dispatchEvent(new Event("close"));
					}else{
						
						ReminderManager.remind("Fail to Upload : "+tmpJson.reason);
					}
				})
				
			}
		}
	}
}