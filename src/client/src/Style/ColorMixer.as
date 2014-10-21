package Style
{
	public class ColorMixer
	{
		public function ColorMixer(){
		}
		public static function MixColor(a,b):uint {
			var ra:uint=(a&0xff0000)/0x010000;
			var ga:uint=(a&0x00ff00)/0x000100;
			var ba:uint=(a&0x0000ff)/0x000001;
			
			var rb:uint=(b&0xff0000)/0x010000;
			var gb:uint=(b&0x00ff00)/0x000100;
			var bb:uint=(b&0x0000ff)/0x000001;
			
			var rm:uint=Math.round((ra+rb)-ra*rb/255);
			var gm:uint=Math.round((ga+gb)-ga*gb/255);
			var bm:uint=Math.round((ba+bb)-ba*bb/255);
			return rm*0x010000+gm*0x000100+bm*0x000001;
		}
		public static function DecColor(a,b):uint {
			var ra:uint=(a&0xff0000)/0x010000;
			var ga:uint=(a&0x00ff00)/0x000100;
			var ba:uint=(a&0x0000ff)/0x000001;
			
			var rb:uint=(b&0xff0000)/0x010000;
			var gb:uint=(b&0x00ff00)/0x000100;
			var bb:uint=(b&0x0000ff)/0x000001;
			
			var rm:uint=Math.round(ra-ra*rb/255);
			var gm:uint=Math.round(ga-ga*gb/255);
			var bm:uint=Math.round(ba-ba*bb/255);
			return rm*0x010000+gm*0x000100+bm*0x000001;
		}
	}
}