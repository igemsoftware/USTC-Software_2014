package Style
{
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;

	public class FilterPacket
	{
		
		public static var ShadowBlur:BlurFilter=new BlurFilter(15,15,2);
		public static var blueGlow:GlowFilter=new GlowFilter(0x00ccee,0.8,7,7,1.5,1);
		public static var ThinShadowBlur:BlurFilter = new BlurFilter(10,10,1);
		
		public static var HighLightGlow:GlowFilter=new GlowFilter(0x0033ff,1,7,7,2,2);
		public static var ThinHightLightGlow:GlowFilter=new GlowFilter(0x3399ff,1,3,3,1,2);
		public static var TextGlow:GlowFilter=new GlowFilter(0x000000,1,5,5,2,2);
		
		public function FilterPacket()
		{
		}
	}
}