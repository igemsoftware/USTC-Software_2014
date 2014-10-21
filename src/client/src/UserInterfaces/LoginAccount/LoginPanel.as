package UserInterfaces.LoginAccount{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import GUI.Assembly.FlexibleLayoutObject;
	import GUI.Assembly.SkinBox;
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import UserInterfaces.Style.Tween;
	
	public class LoginPanel extends Sprite implements FlexibleLayoutObject{
		
		private var BaiduButton:RichButton=new RichButton();
		private var GoogleButton:RichButton=new RichButton();
		
		public var base:SkinBox=new SkinBox();
		
		public var tLoader:HTMLLoader=new HTMLLoader();
		
		public var Height:Number,Width:Number;
		
		private var msk:Shape=new Shape();
		private var msk2:Shape=new Shape();
		
		private var loginAsk:Login_Ask=new Login_Ask();
		private var loginBack:Login_Back=new Login_Back();
		private var loginAuth:Login_Author=new Login_Author();
		private var loginSucc:Login_success=new Login_success();
		private var loginWait:Login_Wait=new Login_Wait();
		private var loginFail:Login_Fail=new Login_Fail();
		
		
		
		public function LoginPanel()
		{
			
			setSize(380,500);
			
			
			addChild(loginBack);
			addChild(loginAsk);
			
			
			addChild(msk);
			addChild(msk2);
			
			loginBack.mouseEnabled=false;
			loginWait.mouseEnabled=false;
			loginAuth.mouseEnabled=false;
			loginAsk.mouseEnabled=false;
			loginSucc.mouseEnabled=false;
			loginFail.mouseEnabled=false;
			
			mask=msk;
			
			loginAuth.alpha=0;
			loginFail.alpha=0;
			loginSucc.alpha=0;
			
			BaiduButton.setIcon(Baidu);
			GoogleButton.setIcon(Google);
			GoogleButton.label="Google Account";
			BaiduButton.label="Baidu Account";
			LayoutManager.UnifyScale(180,40,BaiduButton,GoogleButton);
			
			GoogleButton.y=360;
			BaiduButton.y=GoogleButton.y+60;
			GoogleButton.x=BaiduButton.x=105;
			
			addChild(GoogleButton);
			addChild(BaiduButton);
			
			GoogleButton.addEventListener(MouseEvent.CLICK,function (e):void{
				Login(GlobalVaribles.GoogleLogin);
			});
			
			BaiduButton.addEventListener(MouseEvent.CLICK,function (e):void{
				Login(GlobalVaribles.BaiduLogin);
			});
			
			loginBack.addEventListener("destory",desItem);
			loginWait.addEventListener("destory",desItem);
			loginAsk.addEventListener("destory",desItem);
			
			BaiduButton.addEventListener("destory",desItem);
			GoogleButton.addEventListener("destory",desItem);
		}
		
		protected function desItem(event:Event):void
		{
			if(contains(event.target as DisplayObject)){
				removeChild(event.target as DisplayObject);
			}
		}
		
		public function reset():void{
			if(contains(loginFail)){
				removeChild(loginFail);
			}
			if(contains(loginSucc)){
				removeChild(loginSucc);
			}
			
			loginAsk.alpha=1;
			loginWait.alpha=1;
			loginAuth.alpha=0;
			loginFail.alpha=0;
			loginSucc.alpha=0;
			
			addChild(loginBack);
			addChild(loginAsk);
			addChild(GoogleButton);
			addChild(BaiduButton);
			
			Tween.smoothIn(BaiduButton);
			
			Tween.smoothIn(GoogleButton);
			
			Tween.smoothIn(loginAsk);
			
			Tween.fadeOut(loginFail);
			
			Tween.fadeOut(loginSucc);
			
		}
		
		public function loginCheck(str:String,oauth:OauthLogin):void{
			var urlloader:URLLoader=new URLLoader(new URLRequest(str));
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				trace(String(urlloader.data));
				var tmpJson:Object=JSON.parse(String(urlloader.data).split("'").join("\""));
				trace(tmpJson);
				Tween.fadeOut(loginAuth);
				if(tmpJson.status=="success"){
					
					addChild(loginSucc);
					
					Tween.smoothIn(loginSucc);
					
					dispatchEvent(new Event("closeDelay"));
					
					GlobalVaribles.token=tmpJson.token;
					
					if(oauth.OAuthSite=="baidu"){
						GlobalVaribles.userName=tmpJson.baiduName;
					}else if(oauth.OAuthSite=="google"){
						GlobalVaribles.userName=tmpJson.googleid;
					}
					close_delay();
				}else{
					fail();
				}
			});
			
			
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,fail);
		}
		
		
		private var ticks:uint=0;
		protected function close_delay():void{
			ticks=0;
			addEventListener(Event.ENTER_FRAME,tick_evt);	
		}
		protected function tick_evt(event:Event):void{
			ticks++;
			if (ticks>50) {
				removeEventListener(Event.ENTER_FRAME,tick_evt);
				dispatchEvent(new Event("close"));
				reset();
			}
		}
		
		
		public function Login(Oauth:OauthLogin):void{
			
			addChildAt(loginWait,getChildIndex(loginAsk));
			
			Tween.fadeOut(loginAsk);
			Tween.fadeOut(GoogleButton);
			Tween.fadeOut(BaiduButton);
			
			tLoader.load(new URLRequest(Oauth.OAuthUrl));
			
			tLoader.addEventListener(Event.COMPLETE,function (e:Event):void{
				if(tLoader.location.indexOf(Oauth.CheckUrl)==0){
					addChildAt(tLoader,getChildIndex(loginBack));
					loginBack.mouseEnabled=false;
					Tween.fadeOut(loginBack);
					Tween.fadeOut(loginWait);
				}
			});
			
			tLoader.addEventListener(LocationChangeEvent.LOCATION_CHANGING,function (e:LocationChangeEvent):void{
				trace(e.location);
				
				if(e.location.indexOf(Oauth.CheckUrl)==0&&Oauth.OAuthSite=="baidu"){
					tLoader.load(new URLRequest(e.location+"&display=mobile"));
				}
				if(e.location.indexOf(Oauth.CompleteUrl)==0){
					if(contains(tLoader)){
						removeChild(tLoader);
					}
					
					Tween.fadeOut(loginWait);
					
					addChild(loginBack);
					addChild(loginAuth);
					
					Tween.smoothIn(loginBack);
					Tween.smoothIn(loginAuth);
					
					loginCheck(e.location,Oauth);
				}
			});
			tLoader.addEventListener(IOErrorEvent.IO_ERROR,fail);
		}
		
		private function fail(e=null):void{
			addChild(loginFail);
			Tween.smoothIn(loginFail);
			Tween.fadeOut(loginAuth);
			Tween.fadeOut(loginWait);
			Tween.smoothIn(loginBack);
			close_delay();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			Width=w;
			Height=h;
			
			msk.graphics.clear();
			
			msk.graphics.beginFill(0);
			msk.graphics.drawRoundRect(0,0,w,h,8,8);
			msk.graphics.endFill();
			
			msk2.graphics.clear();
			
			msk2.graphics.lineStyle(0,0xaaaaaa,1,true)
			msk2.graphics.drawRoundRect(0,0,w,h,8,8);
			
			tLoader.width=w;
			tLoader.height=h;
			
			tLoader.mask=msk;
		}
		
	}
}