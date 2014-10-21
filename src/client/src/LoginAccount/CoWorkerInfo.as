package LoginAccount
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Assembly.ProjectHolder.ProjectManager;
	
	import GUI.FlexibleWidthObject;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	public class CoWorkerInfo extends Sprite implements FlexibleWidthObject
	{
		
		private const cardH:int=60;
		private const cardAlign:int=5;
		
		
		private var back:SkinBox=new SkinBox();
		
		private var box:SkinBox=new SkinBox();
		private var box2:SkinBox=new SkinBox();
		private var img:Bitmap=new Bitmap(null,"auto",true);
		private var NameLabel:LabelTextField=new LabelTextField(" ");
		private var del:Icon_ADD_COWORKER=new Icon_ADD_COWORKER();
		
		public var num:int;
		
		
		public function CoWorkerInfo(i,nam:String,pic:BitmapData)
		{
			num=i;
			
			img.bitmapData=pic;
			NameLabel.text=nam;
			
			addChild(back);
			addChild(box);
			addChild(box2);
			addChild(img);
			addChild(NameLabel);
			addChild(del);
			
			del.addEventListener("click",function (e):void{
				ProjectManager.co_works.splice(num,1);
				dispatchEvent(new Event("destory"));
			});
		}
		
		public function setSize(w:Number):void
		{
		
			box2.x=box2.y=img.x=img.y=cardAlign;
			box.x=box.y=box2.x;
			img.width=img.height=50;
			
			
			
			NameLabel.y=cardH/2-NameLabel.height/2;
			del.y=cardH/2;
			
			NameLabel.x=img.x+img.width+cardAlign;
			
			del.x=w-del.width/2-cardAlign;
			
			img.mask=box2;
			
			back.setSize(w,cardH);
			
			box.setSize(50,50);
			box2.setSize(w,cardH);
		}
		
	}
}