package UserInterfaces.Style{
	import flash.text.TextFormat;
	
	/**
	 * this is a class to unify all the fonts used in the program
	 */
	public class FontPacket{
		
		private static const Font:String="微软雅黑";
		
		public static var ButtonText:TextFormat=new TextFormat(Font,16,0x000000);
		
		public static var BlackTitleText:TextFormat=new TextFormat(Font,29,0x000000);
		
		public static var BlockText:TextFormat=new TextFormat(Font,22,0x000000);
		
		public static var BlackTitleTextLv2:TextFormat=new TextFormat(Font,19,0x000000);
		
		public static var BlackTitleTextLv3:TextFormat=new TextFormat(Font,18,0x000000);
		
		public static var ContentText:TextFormat=new TextFormat(Font,16,0x000000);
		ContentText.leading=4;	
		
		public static var TinyHintText:TextFormat=new TextFormat(Font,12,0x000000);
		
		public static var WhiteContentText:TextFormat=new TextFormat(Font,16,0xffffff);
		
		public static var WhiteTinyText:TextFormat=new TextFormat(Font,14,0xffffff);
		WhiteTinyText.leading=4;	
		
		public static var WhiteTinyTinyText:TextFormat=new TextFormat(Font,12,0xffffff);
		WhiteTinyText.leading=4;	
		
		public static var WhiteMediumTitleText:TextFormat=new TextFormat(Font,20,0xffffff);
		
		
		public static var WhiteTitleText:TextFormat=new TextFormat(Font,26,0xffffff);
		
		public static var SmallContentText:TextFormat=new TextFormat(Font,12,0x000000);
		
		public static var DisabledContentText:TextFormat=new TextFormat(Font,16,0xcccccc);
		
		public static var HintText:TextFormat=new TextFormat(Font,18,0xffffff);
		
		public static var LabelHintText:TextFormat=new TextFormat(Font,14,0x808080);
		
		public static var HighDensityText:TextFormat=new TextFormat(Font,14,0x000000);
		
		public static var LabelText:TextFormat=new TextFormat(Font,14,0xffffff);
		
		public static var LinkLabelText:TextFormat=new TextFormat(Font,14,0xffffff,false,false,true);
		
	}
}