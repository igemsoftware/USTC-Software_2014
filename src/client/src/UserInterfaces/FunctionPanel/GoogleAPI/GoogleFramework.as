package UserInterfaces.FunctionPanel.GoogleAPI
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichUI.RichButton;
	import GUI.Scroll.Scroll;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.Style.FontPacket;
	import Kernel.Assembly.CheckerURLLoader;
	
	public class GoogleFramework extends Sprite
	{
	
		
		
		private var hitA:HitBox=new HitBox();
		
		
		
		public var searchtxt:TextInput=new TextInput();
		
		private var googleP:GooglePage=new GooglePage();
		
		private var scroll:Scroll=new Scroll(googleP);
		
		private var nodataHint:LabelTextField=new LabelTextField("No result found");
		private var Loader:CheckerURLLoader=new CheckerURLLoader();
		
		public function GoogleFramework(searchStr="")
		{
			
			
			addChild(hitA);	
			addChild(scroll);
			
			addChild(nodataHint);
			
			nodataHint.visible=false;
			nodataHint.defaultTextFormat=FontPacket.ContentText;
			nodataHint.text="No result found"
			
			googleP.searchbn.label="Search";
			googleP.searchbn.setSize(60,30);
			
			searchtxt.hintText="by Google Scholar";
			
			searchtxt.addEventListener("Enter",search);
			
			googleP.searchbn.addEventListener(MouseEvent.CLICK,search);
			
			setSize(400,400)
			
			if(searchStr!=""){
				searchtxt.text=searchStr;
				search();
			}
		}
		
		private function search(e=null):void{
			googleP.search(searchtxt.text);
		}
		
		public function setSize(w:Number,h:Number):void{
			
			googleP.setSize(w);
			
			searchtxt.setSize(w-60,30)
			hitA.setSize(w,h);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,5,0,searchtxt,googleP.searchbn);
			scroll.x=0;
			scroll.y=40;
			scroll.setSize(w,h-35);
			nodataHint.x=w/2-nodataHint.width/2;
			nodataHint.y=scroll.y+30;
		}
	}
}

