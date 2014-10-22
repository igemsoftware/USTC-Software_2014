package UserInterfaces.LoginAccount
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.MonitorPane;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import Kernel.Assembly.SelectArray;
	import Kernel.Biology.NodeTypeInit;
	import Kernel.ProjectHolder.ProjectManager;
	import Kernel.ProjectHolder.SyncManager;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.ReminderManager.ReminderManager;
	import UserInterfaces.Sorpotions.Navigator;
	import UserInterfaces.Style.FontPacket;
	
	import fl.controls.CheckBox;
	import fl.events.ListEvent;
	
	public class ProjectManagePanel extends Sprite
	{
		private const PREVIEW_SCALE:int=160;
		
		public var Height:int=380;
		
		private var hitA:HitBox=new HitBox();
		
		private var own:RichButton=new RichButton(1);
		private var others:RichButton=new RichButton(2);
		private var projects:Array;
		private var box:SkinBox=new SkinBox();
		private var box2:MonitorPane=new MonitorPane(PREVIEW_SCALE,PREVIEW_SCALE);
		
		private var GoButton:RichButton=new RichButton(RichButton.LEFT_EDGE);
		private var UploadButton:RichButton=new RichButton(RichButton.MIDDLE);
		private var DeleteButton:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		private var NewButton:RichButton=new RichButton(RichButton.MIDDLE);
		
		private var autoSync:CheckBox=new CheckBox();
		private var Sync:RichButton=new RichButton();
		
		private var detail:TextField=new TextField();
		
		private var NameSearcher:TextInput=new TextInput(true);
		private var prolist:RichList=new RichList("name",false,false,true);
		
		public static var _Project:LabelTextField=new LabelTextField("Project");
		private var chooseHint:LabelTextField=new LabelTextField("Choose a project\nto perview  -->");
		
		
		private var usr_img:Icon_User=new Icon_User();
		private var usr:LabelTextField=new LabelTextField("");
		
		private var logout:RichButton=new RichButton();
		
		private var previewer:Bitmap=new Bitmap(null,"auto",false);
		
		
		public function ProjectManagePanel(){
			
			UploadButton.setIcon(Cloud_Upload);
			GoButton.setIcon(Cloud_Open);
			DeleteButton.setIcon(Cloud_Del);
			NewButton.setIcon(Cloud_ADD)
			
			logout.label="Logout";
			
			own.label="Own";
			others.label="Internet";
			
			autoSync.label="Auto Synchronize";
			autoSync.setSize(160,22);
			
			Sync.label="Sync Now"
			Sync.setIcon(Icon_SYNC);
			Sync.setSize(150,35)
			
			detail.defaultTextFormat=FontPacket.WhiteTinyText;
			detail.multiline=true;
			detail.autoSize="left";
			detail.text="Project : \nAuthor : "
			detail.selectable=false;
			
			prolist.addEventListener(ListEvent.ITEM_CLICK,setProject);
			
			prolist.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,openProject);
			
			GoButton.addEventListener(MouseEvent.CLICK,openProject);		
			DeleteButton.addEventListener(MouseEvent.CLICK,del_project);
			NewButton.addEventListener(MouseEvent.CLICK,function (e):void{ProjectManager.Create()});
			UploadButton.addEventListener(MouseEvent.CLICK,function (e):void{ProjectManager.Upload()});
			
			Sync.addEventListener(MouseEvent.CLICK,SyncManager.SYNC);

			
			
			NameSearcher.addEventListener("change",search);
			
			logout.addEventListener(MouseEvent.CLICK,logout_evt);
			
			addChild(hitA);
			
			setSize(405,380);
			
			if(GlobalVaribles.token!=null&&GlobalVaribles.token!=""){
				refreshList();
			}
			
		}
		
		protected function logout_evt(event:MouseEvent):void
		{
			GlobalVaribles.token=null;
			GlobalVaribles.userName=null;
			dispatchEvent(new Event("close"));
		}
		
		protected function del_project(event:MouseEvent):void
		{
			if(prolist.selectedItem!=null){
				
				DeleteButton.suspend();
				
				var uloader:AuthorizedURLLoader=new AuthorizedURLLoader();
				
				var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_INTERFACE+prolist.selectedItem.pid+"/");
				
				urequest.method=URLRequestMethod.DELETE;
				
				uloader.load(urequest);
				
				uloader.addEventListener(Event.COMPLETE,function (e):void{
					trace(e.target.data);
					ReminderManager.remind("Project Deleted");
					refreshList();
				})
					
				uloader.addEventListener(IOErrorEvent.IO_ERROR,function (e):void{DeleteButton.unsuspend();});
			}
		}
		
		public function refreshList():void{
			usr.text=GlobalVaribles.userName;
			
			var projectLoader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest(GlobalVaribles.PROJECT_MY));
			
			projectLoader.addEventListener(Event.COMPLETE,function (e):void{
				
				trace(e.target.data);
				
				var res:Object=JSON.parse(e.target.data);
				
				prolist.dataProvider=res.results;
				
				projects=res.results;
				
				DeleteButton.unsuspend();
			});
			
		}
		
		protected function openProject(event):void
		{
			if(prolist.selectedItem!=null){
				ReminderManager.remind("Opening project...");
				ProjectManager.openProject(prolist.selectedItem.pid);
			}
		}
		
		private function setProject(e:ListEvent):void{
			detail.text="Project : " +e.item.name+
				"\nAuthor : " + e.item.author;
			previewProject(e.item.pid);
		}
		
		
		protected function search(event:Event):void
		{
			var stable:Array = SelectArray.searchArray(projects,"name",NameSearcher.text);
			prolist.dataProvider = stable;
			if (stable.length != NodeTypeInit.BiotypeList.length&&stable.length>0) {
				prolist.selectedIndex = 0;
				prolist.scrollToSelected();
			}
		}
		
		private function previewProject(pid:String):void
		{
			var projectLoader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest("http://"+GlobalVaribles.SERVER_ADDRESS+"/data/project/"+pid+"/"));
			
			projectLoader.addEventListener(Event.COMPLETE,openProject_cmp);
		}
		
		
	
		
		private function openProject_cmp(e):void{
			
			var project:Object=JSON.parse(e.target.data);
			
			Navigator.generateMapFromJSON(e.target.data,previewer,PREVIEW_SCALE,PREVIEW_SCALE);
			
			chooseHint.visible=false;
		}
		
		public function setSize(w:Number,h:Number):void{
			
			const ah:int=60;
			const hw:int=95;
			
			const qw:int=190;
			
			trace(autoSync.height);
			
			hitA.setSize(w,h);
			
			own.focused=true;
			others.focused=false;

			prolist.setSize(208,220);
			
			logout.setSize(80,30);
			NameSearcher.setSize(208,24);
			LayoutManager.UnifyScale(104,30,own,others);
			LayoutManager.UnifyScale(52,35,DeleteButton,NewButton,GoButton,UploadButton);
			
			
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,10,20,10,usr_img,usr);
			usr_img.y-=15;
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w-5,15,5,logout);
			
			graphics.lineStyle(0,GlobalVaribles.SKIN_LINE_COLOR);
			graphics.moveTo(5,ah-5);
			graphics.lineTo(w-5,ah-5);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,hw,ah,0,_Project);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_CENTER,10,_Project,box2);
			
			
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,box2,detail);

			LayoutManager.setVerticalLayout(this,LayoutManager.LAYOUT_ALIGN_TOP,15,detail.y+detail.height+5,8,autoSync,Sync);
			
			LayoutManager.setAlign(this,LayoutManager.LAYOUT_ALIGN_CENTER,box2,chooseHint);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,box2.x,box2.y,0,previewer);

			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,qw,ah,0,own,others);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,qw,ah+35,5,NameSearcher);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,NameSearcher,prolist);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,qw,prolist.height+prolist.y+5,0,GoButton,UploadButton,NewButton,DeleteButton);
			
		}
	}
}