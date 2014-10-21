package UserInterfaces.LoginAccount
{
	public class OauthLogin
	{
		
		public var OAuthSite:String;
		public var CheckUrl:String;
		
		public var OAuthUrl:String;
		public var CompleteUrl:String;
		
		public function OauthLogin(site:String,chk:String)
		{
			OAuthSite=site;
			CheckUrl=chk;
			
			
			OAuthUrl="http://api.biopano.org/auth/oauth/"+OAuthSite+"/login";
			CompleteUrl="http://api.biopano.org/auth/oauth/"+OAuthSite+"/complete";
			
		}
	}
}