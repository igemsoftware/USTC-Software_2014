package UserInterfaces.FunctionPanel.GoogleAPI
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import UserInterfaces.Style.FontPacket;

	/**
	 * the google page block
	 */
	public class GooglePageBlock extends Sprite
	{
		
		public var title:String,url:String,author:String,abstract:String,cite:String;
		
		private var titleText:TextField=new TextField();
		private var contentText:TextField=new TextField();
		private var authorText:TextField=new TextField();
		private var citeText:TextField=new TextField();
		
		private var back:Shape=new Shape();
		/**
		 * set up google page block
		 * @param t title
		 * @param u url
		 * @param a author
		 * @param abs abstract
		 * @param cit cite
		 */
		public function GooglePageBlock(t,u,a,abs,cit){
			
			cacheAsBitmap=true;
			
			title=t;url=u;author=a;cite=cit;
			
			trace(url);
			
			titleText.defaultTextFormat=FontPacket.BlackTitleTextLv3;
			titleText.multiline=true;
			titleText.wordWrap=true;
			var tr:String='<font color="#0033ff"><a href="'+url+'">'+title+"</a></font>"
			titleText.htmlText=tr;
			
			contentText.defaultTextFormat=FontPacket.ContentText;
			contentText.multiline=true;
			contentText.wordWrap=true;
			contentText.htmlText=abstract=abs;
			
			authorText.defaultTextFormat=citeText.defaultTextFormat=FontPacket.TinyHintText
			authorText.htmlText=author;
			authorText.multiline=true;
			authorText.wordWrap=true;
			authorText.autoSize="left";
			
			citeText.text="Cited by "+cite;
			citeText.autoSize="left";
				
			addChild(back);
			addChild(titleText);
			addChild(contentText);
			addChild(authorText);
			addChild(citeText);
			
		}
		/**
		 * redraw
		 */
		public function setSize(w):void{
			titleText.x=titleText.y=5;
			titleText.width=w-10;
			titleText.height=titleText.textHeight+5;
			
			authorText.x=5;
			authorText.y=titleText.height+3;
			authorText.width=w;
			authorText.height=authorText.textHeight+5;

			citeText.y=authorText.y+authorText.height;
				
			citeText.x=w-5-citeText.width
			
			contentText.y=citeText.y+20;
			contentText.width=w-10;
			contentText.height=contentText.textHeight+5;
			
			back.graphics.clear();
			
			back.graphics.lineStyle(0,0xddddddd);
			back.graphics.beginFill(0xffffff);
			back.graphics.drawRect(0,0,w,contentText.y+contentText.height+5);
			back.graphics.endFill();
			back.graphics.moveTo(5,authorText.y-2);
			back.graphics.lineTo(w-5,authorText.y-2);
			
		}
		
		
	}
}