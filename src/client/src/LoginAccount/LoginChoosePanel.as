package LoginAccount
{
	import flash.display.Sprite;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.LinkTextField;
	import GUI.RichUI.RichButton;
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import Layout.LayoutManager;
	
	
	public class LoginChoosePanel extends Sprite{
		
		private var LogoutLink:LinkTextField=new LinkTextField("Logout");
		
		private var LoginTitle:LabelTextField=new LabelTextField("Sign in with: ");
		
		private var Logined:LabelTextField=new LabelTextField("Logged in");
		
		private var _Project:LabelTextField=new LabelTextField("Project");
		
		private var BaiduButton:RichButton=new RichButton();
		private var GoogleButton:RichButton=new RichButton();
		
		
		private var hitA:HitBox=new HitBox();
		
		private var loginPanel:Panel;
		
		
		public function LoginChoosePanel()
		{
			
			LogoutLink.htmlText='<a href="event:Logout"><u>Logout</u></a>';
			
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
			
		}
		
		

		protected function Logout(event:TextEvent):void
		{
			GlobalVaribles.token=null;
		}
		
		public function setSize():void{
			
			var status:int;
			
			hitA.setSize(200,200);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_CENTER,100,0,0,LoginTitle);
			GoogleButton.y=60;
			BaiduButton.y=130;
			GoogleButton.x=BaiduButton.x=10;
			
			addChild(hitA);
			addChild(GoogleButton);
			addChild(BaiduButton);
			
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