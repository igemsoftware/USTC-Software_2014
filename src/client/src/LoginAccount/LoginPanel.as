package LoginAccount{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import GUI.FlexibleLayoutObject;
	import GUI.Assembly.SkinBox;
	
	import Style.Tween;
	
	public class LoginPanel extends Sprite implements FlexibleLayoutObject{
		
		public var base:SkinBox=new SkinBox();
		
		public var tLoader:HTMLLoader=new HTMLLoader();
		
		public var Height:Number,Width:Number;
		
		private var msk:Shape=new Shape();
		private var msk2:Shape=new Shape();
		
		private var loginBack:Login_Back=new Login_Back();
		private var loginAuth:Login_Author=new Login_Author();
		private var loginSucc:Login_success=new Login_success();
		private var loginWait:Login_Wait=new Login_Wait();
		private var loginFail:Login_Fail=new Login_Fail();
		
		public function LoginPanel(Oauth:OauthLogin)
		{
			
			setSize(380,500);
			
			
			addChild(msk);
			addChild(msk2);
			
			addChild(loginBack);
			addChild(loginWait);
			
			mask=msk;
			
			loginAuth.alpha=0;
			loginFail.alpha=0;
			loginSucc.alpha=0;
			
			tLoader.load(new URLRequest(Oauth.OAuthUrl));
			
			tLoader.addEventListener(Event.COMPLETE,function (e:Event):void{
				if(tLoader.location.indexOf(Oauth.CheckUrl)==0){
					addChildAt(tLoader,getChildIndex(msk2));
					Tween.fadeOut(loginBack);
					Tween.fadeOut(loginWait);
					
					loginBack.addEventListener("destory",function (e):void{
						if(contains(loginBack)){
							removeChild(loginBack);
						}
					});
					loginWait.addEventListener("destory",function (e):void{
						if(contains(loginWait)){
							removeChild(loginWait);
						}
					});
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
					addChild(loginSucc);
					addChild(loginFail);
					
					Tween.smoothIn(loginBack);
					Tween.smoothIn(loginAuth);
					
					loginCheck(e.location);
				}
			});
		}
		
		public function loginCheck(str:String):void{
			var urlloader:URLLoader=new URLLoader(new URLRequest(str));
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				trace(String(urlloader.data));
				var tmpJson:Object=JSON.parse(String(urlloader.data).split("'").join("\""));
				trace(tmpJson);
				Tween.fadeOut(loginAuth);
				if(tmpJson.status=="success"){
					Tween.smoothIn(loginSucc);
					
					dispatchEvent(new Event("closeDelay"));
					
					GlobalVaribles.token=tmpJson.token;
					
				}else{
					Tween.smoothIn(loginFail);
				}
			});
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