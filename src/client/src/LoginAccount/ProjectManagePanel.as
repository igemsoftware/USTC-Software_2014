package LoginAccount
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import Biology.NodeTypeInit;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;
	import Layout.ReminderManager;
	
	import Style.FontPacket;
	
	import algorithm.SelectArray;
	
	import fl.events.ListEvent;
	
	public class ProjectManagePanel extends Sprite
	{
		private var hitA:HitBox=new HitBox();
		
		private var own:RichButton=new RichButton(1);
		private var others:RichButton=new RichButton(2);
		private var projects:Array;
		private var box:SkinBox=new SkinBox();
		private var box2:SkinBox=new SkinBox();
		private var GoButton:RichButton=new RichButton();
		private var DeleteButton:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		private var NewButton:RichButton=new RichButton(RichButton.LEFT_EDGE);
		
		private var detail:TextField=new TextField();
		
		private var NameSearcher:TextInput=new TextInput(true);
		private var prolist:RichList=new RichList("name",false,false,true);
		
		private var _Project:LabelTextField=new LabelTextField("Project");
		private var chooseHint:LabelTextField=new LabelTextField("Choose a project\nto perview  -->");
		
		
		private var usr_img:Icon_User=new Icon_User();
		private var usr:LabelTextField=new LabelTextField("");
		
		private var logout:RichButton=new RichButton();
		
		
		public function ProjectManagePanel(){
			
			GoButton.label="Open Project";
			DeleteButton.label="Delete";
			NewButton.label="New";
			logout.label="Logout";
			
			own.label="Own";
			others.label="Internet";
			
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
			
			NameSearcher.addEventListener("change",search);
			
			logout.addEventListener(MouseEvent.CLICK,logout_evt);
			
			addChild(hitA);
			
			setSize(400,380);
			
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
				
				var uloader:AuthorizedURLLoader=new AuthorizedURLLoader();
				
				var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_INTERFACE+prolist.selectedItem.pid+"/");
				
				urequest.method=URLRequestMethod.DELETE;
				
				uloader.load(urequest);
				
				uloader.addEventListener(Event.COMPLETE,function (e):void{
					trace(e.target.data);
					ReminderManager.remind("Project Deleted");
					refreshList();
				})
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
			});
		}
		
		protected function openProject(event):void
		{
			if(prolist.selectedItem!=null){
				ProjectManager.openProject(prolist.selectedItem.pid);
				
			}
		}
		
		private function setProject(e:ListEvent):void{
			detail.text="Project : " +e.item.name+
				"\nAuthor : " + e.item.author;
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
		
		public function setSize(w:Number,h:Number):void{
			
			const ah:int=60;
			
			hitA.setSize(w,h);
			
			own.focused=true;
			others.focused=false;
			
			box2.setSize(160,160);
			prolist.setSize(190,220);
			
			logout.setSize(80,30);
			NameSearcher.setSize(190,24);
			LayoutManager.UnifyScale(95,30,own,others);
			GoButton.setSize(120,30);
			LayoutManager.UnifyScale(95,30,DeleteButton,NewButton);
			
			
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,10,20,10,usr_img,usr);
			usr_img.y-=15;
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,w-5,15,5,logout);
			
			graphics.lineStyle(0,GlobalVaribles.SKIN_LINE_COLOR);
			graphics.moveTo(5,ah-5);
			graphics.lineTo(w-5,ah-5);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,w/4,ah,0,_Project);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_CENTER,10,_Project,box2);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,box2,detail);
			
			LayoutManager.setVerticalLayout(this,LayoutManager.LAYOUT_ALIGN_TOP,25,detail.y+detail.height+5,10,GoButton);
			
			LayoutManager.setAlign(this,LayoutManager.LAYOUT_ALIGN_CENTER,box2,chooseHint);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,w*3/4,ah,0,own,others);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,w*3/4,ah+35,5,NameSearcher);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,NameSearcher,prolist);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,w*3/4,prolist.height+prolist.y+5,0,NewButton,DeleteButton);
			
		}
	}
}