package LoginAccount
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import Biology.NodeTypeInit;
	
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;
	
	import Style.FontPacket;
	
	import algorithm.SelectArray;
	
	import fl.events.ListEvent;
	
	public class ProjectManagePanel extends Sprite
	{
		private var own:RichButton=new RichButton(1);
		private var others:RichButton=new RichButton(2);
		private var projects:Array;
		private var box:SkinBox=new SkinBox();
		private var box2:SkinBox=new SkinBox();
		private var GoButton:RichButton=new RichButton();
		
		private var detail:TextField=new TextField();
		
		private var NameSearcher:TextInput=new TextInput(true);
		private var prolist:RichList=new RichList("name");
		
		private var _Project:LabelTextField=new LabelTextField("Project");
		private var chooseHint:LabelTextField=new LabelTextField("Choose a project\nto perview  -->");
		
		
		public function ProjectManagePanel(){
			
			GoButton.label="Open Project";
			own.label="Own";
			others.label="Internet";
			
			detail.defaultTextFormat=FontPacket.WhiteTinyText;
			detail.multiline=true;
			detail.autoSize="left";
			detail.text="Project : \nAuthor : \nLast Modified : "
			detail.selectable=false;
			
			prolist.addEventListener(ListEvent.ITEM_CLICK,setProject);
			
			prolist.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,openProject);
			
			GoButton.addEventListener(MouseEvent.CLICK,openProject);
				
			NameSearcher.addEventListener("change",search);

		}
		
		public function refreshList():void{
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
				"\nAuthor : " + e.item.author+
				"\nLast Modified : "+e.item.pid;
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
		
		public function setSize():void{
			own.focused=true;
			others.focused=false;
			
			box2.setSize(160,160);
			prolist.setSize(190,240);
			NameSearcher.setSize(190,24);
			LayoutManager.UnifyScale(90,30,own,others);
			GoButton.setSize(120,30);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,100,35,0,_Project);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_CENTER,10,_Project,box2);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,5,box2,detail);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_CENTER,detail.height+10,box2,GoButton);
			
			LayoutManager.setAlign(this,LayoutManager.LAYOUT_ALIGN_CENTER,box2,chooseHint);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,300,35,0,own,others);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,300,70,5,NameSearcher);
			
			LayoutManager.setVerticalFollow(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,NameSearcher,prolist);
			
		}
	}
}