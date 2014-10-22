package LoginAccount
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import Biology.NodeTypeInit;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.LinkTextField;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.TextInput;
	import GUI.Assembly.TitleTextField;
	import GUI.RichGrid.RichList;
	import GUI.RichUI.RichButton;
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Layout.FrontCoverSpace;
	import Layout.LayoutManager;
	
	import Style.FontPacket;
	
	import algorithm.SelectArray;
	
	import fl.events.ListEvent;
	
	
	
	public class LoginChoosePanel extends Sprite
	{
		
		private var LogoutLink:LinkTextField=new LinkTextField("Logout");
		
		private var chgpjct:LinkTextField=new LinkTextField("ChangeProject");
		
		private var LoginTitle:LabelTextField=new LabelTextField("Sign in with: ");
		
		private var Logined:LabelTextField=new LabelTextField("Logged in");
		
		private var _Project:LabelTextField=new LabelTextField("Project");
		
		private var chooseHint:LabelTextField=new LabelTextField("Choose a project\nto perview  -->");
		
		private var _title:TitleTextField=new TitleTextField("Project : ");
		
		private var detail:TextField=new TextField();
		
		private var BaiduButton:RichButton=new RichButton();
		private var GoogleButton:RichButton=new RichButton();
		private var GoButton:RichButton=new RichButton();
		private var box:SkinBox=new SkinBox();
		private var box2:SkinBox=new SkinBox();
		
		private var NameSearcher:TextInput=new TextInput(true);
		private var prolist:RichList=new RichList("name");
		
		private var hitA:HitBox=new HitBox();
		
		private var loginPanel:Panel;
		
		private var own:RichButton=new RichButton(1);
		private var others:RichButton=new RichButton(2);
		private var projects:Array;
		private var remStatus:int=-1;
		private var fields:Object=new Object();			
		
		private static var CoworkerPanel:CoWorkerList=new CoWorkerList();
		
		
		public function LoginChoosePanel()
		{
			
			LogoutLink.htmlText='<a href="event:Logout"><u>Logout</u></a>';
			
			chgpjct.htmlText='<a href="event:changeProject"><u>Change Project</u></a>';
			
			GoButton.label="Open Project";
			
			own.label="Own";
			others.label="Internet";
			
			detail.defaultTextFormat=FontPacket.WhiteTinyText;
			
			detail.multiline=true;
			
			detail.autoSize="left";
			
			detail.text="Project : \nAuthor : \nLast Modified : "
			
			detail.selectable=false;
			
			BaiduButton.setIcon(Baidu);
			GoogleButton.setIcon(Google);
			GoogleButton.label="Google Account";
			BaiduButton.label="Baidu Account";
			LayoutManager.UnifyScale(180,40,BaiduButton,GoogleButton);
			BaiduButton.addEventListener(MouseEvent.CLICK,function (e):void{
				toLogin(GlobalVaribles.BaiduLogin);
			});
			
			GoogleButton.addEventListener(MouseEvent.CLICK,function (e):void{
				toLogin(GlobalVaribles.GoogleLogin);
			});
			
			LogoutLink.addEventListener(TextEvent.LINK,Logout);
			
			chgpjct.addEventListener(TextEvent.LINK,changeProject);
			
			GoButton.addEventListener(MouseEvent.CLICK,openProject);
			
			refreshLoginStatus();
			
			NameSearcher.addEventListener("change",search);
			
			prolist.addEventListener(ListEvent.ITEM_CLICK,setProject);
			
			prolist.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,openProject);
		}
		
		protected function changeProject(event:TextEvent):void
		{
			ProjectManager.ProjectID=-1;
			refreshLoginStatus();
		}
		
		protected function Logout(event:TextEvent):void
		{
			GlobalVaribles.token=null;
			refreshLoginStatus();
		}
		
		public function refreshLoginStatus():void{
			
			var status:int;
			
			removeChildren();
			if(GlobalVaribles.token!=null&&GlobalVaribles.token!=""){
				
				hitA.setSize(400,350);
				box.setSize(400,320);
				box.y=30;
				
				addChild(hitA);
				addChild(box);
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,200,0,0,Logined);
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,400,0,0,LogoutLink);
				
				if(ProjectManager.ProjectID==-1){
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
					
					var projectLoader:AuthorizedURLLoader=new AuthorizedURLLoader(new URLRequest(GlobalVaribles.PROJECT_MY));
					projectLoader.addEventListener(Event.COMPLETE,function (e):void{
						
						trace(e.target.data);
						
						var res:Object=JSON.parse(e.target.data);
						
						prolist.dataProvider=res.results;
						
						projects=res.results;
					});
					
					status=1;
				}else{
					_title.text="Project : "+ProjectManager.ProjectName;
					
					LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,200,60,0,_title);
					
					LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,30,0,chgpjct);
					
					var details:Array=[
						{label:"name",text:ProjectManager.ProjectName},
						{label:"author",Ineditable:true,text:ProjectManager.authorName},
						{label:"co-workers",Ineditable:true,text:getworks()},
						{label:"species",text:ProjectManager.species},
						{label:"description",multiLines:true,lines:4,text:ProjectManager.describe}
					];
					
					var align:int=100;
					
					var sy:int=120;
					
					for (var i:int = 0; i < details.length; i++){
						
						var label:LabelTextField=new LabelTextField(details[i].label+" : ");
						fields[details[i].label]=new TextInput(false,details[i].multiLines,details[i].Ineditable);
						
						if(details[i].hasOwnProperty("text")){
							fields[details[i].label].text=details[i].text;
						}
						
						LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_RIGHT,align,sy+i*30,5,label);
						
						LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT_STICK,align,sy+i*30,5,380,fields[details[i].label]);
						
						if(details[i].multiLines){
							fields[details[i].label].setSize(fields[details[i].label].Width,24*details[i].lines);
						}
						fields[details[i].label].addEventListener(FocusEvent.FOCUS_OUT,save);
						
						
					}
					
					CoworkerPanel.x=fields["co-workers"].x
					CoworkerPanel.y=fields["co-workers"].y+fields["co-workers"].height;
					CoworkerPanel.setSize(fields["co-workers"].width,400-CoworkerPanel.y);
					CoworkerPanel.addEventListener("changed",function (e):void{
						fields["co-workers"].text=getworks();
					});
					fields["co-workers"].addEventListener("click",showCoworkers);
					
					
					function save(e):void{
						ProjectManager.ProjectName=fields["name"].text;
						ProjectManager.describe=fields["description"].text;
						ProjectManager.species=fields["species"].text;
					}
					status=2;
				}
				
			}else{
				hitA.setSize(200,200);
				
				LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,100,0,0,LoginTitle);
				GoogleButton.y=60;
				BaiduButton.y=130;
				GoogleButton.x=BaiduButton.x=10;
				
				addChild(hitA);
				addChild(GoogleButton);
				addChild(BaiduButton);
				
				status=0;
			}
			
			if(remStatus!=status){
				remStatus=status;
				dispatchEvent(new Event("redrawed"));
			}
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
		
		protected function hitOut(event:MouseEvent):void
		{
			if (!CoworkerPanel.hitTestPoint(stage.mouseX,stage.mouseY)&&!fields["co-workers"].hitTestPoint(stage.mouseX,stage.mouseY)) {
				removeChild(CoworkerPanel)
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,hitOut)
			};
		}
		
		protected function openProject(event):void
		{
			if(prolist.selectedItem!=null){
				trace("Project Open:",prolist.selectedItem.name);
				ProjectManager.ProjectID=prolist.selectedItem.id;
				ProjectManager.ProjectName=prolist.selectedItem.name;
				ProjectManager.authorID=prolist.selectedItem.author;
				ProjectManager.authorName=prolist.selectedItem.author;
				
				refreshLoginStatus();
			}
		}
		
		private function setProject(e:ListEvent):void{
			detail.text="Project : " +e.item.name+
				"\nAuthor : " + e.item.author+
				"\nLast Modified : "+e.item.id;
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
		
		private function toLogin(Oauth:OauthLogin):void{
			if (loginPanel==null) {
				loginPanel=new Panel("Login",new LoginPanel(Oauth));
				WindowSpace.addWindow(loginPanel);
				loginPanel.addEventListener("destory",function (e):void{
					loginPanel=null;
				});
			}
		}
	}
	
	
}