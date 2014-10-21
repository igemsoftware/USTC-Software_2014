package Kernel.ProjectHolder.CoworkerManager
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	import GUI.Assembly.FlexibleWidthObject;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	
	public class CoWorkerInfo extends Sprite implements FlexibleWidthObject
	{
		
		private const cardH:int=60;
		private const cardAlign:int=5;
		
		public static const INFO_ADD:int=0;
		public static const INFO_REMOVE:int=1;
		public static const NONE:int=2;
		
		
		private var back:SkinBox=new SkinBox();
		
		private var box:SkinBox=new SkinBox();
		private var box2:SkinBox=new SkinBox();
		private var img:Bitmap=new Bitmap(null,"auto",true);
		private var NameLabel:LabelTextField=new LabelTextField(" ");
		private var operateIcon:*;
		
		public var num:int;
		public var workerinfo:WorkerInfo;
		
		
		public function CoWorkerInfo(type,work:WorkerInfo)
		{
			
			switch(type)
			{
				case INFO_ADD:
				{
					operateIcon=new Icon_ADD_COWORKER();
					break;
				}
				case INFO_REMOVE:
				{
					operateIcon=new Icon_REMOVE_COWORKER();
					break;
				}
				case NONE:
				{
					operateIcon=new Shape();
					break;
				}

			}
			
			workerinfo=work
			
			img.bitmapData=work.image;
			NameLabel.text=work.Name;
			
			addChild(back);
			addChild(box);
			addChild(box2);
			addChild(img);
			addChild(NameLabel);
			addChild(operateIcon);
			
			operateIcon.addEventListener("click",function (e):void{
				
				dispatchEvent(new Event("clicked"));
			});
		}
		
		public function setSize(w:Number):void
		{
		
			box2.x=box2.y=img.x=img.y=cardAlign;
			box.x=box.y=box2.x;
			img.width=img.height=50;
			
			
			
			NameLabel.y=cardH/2-NameLabel.height/2;
			operateIcon.y=cardH/2;
			
			NameLabel.x=img.x+img.width+cardAlign;
			
			operateIcon.x=w-operateIcon.width/2-cardAlign;
			
			img.mask=box2;
			
			back.setSize(w,cardH);
			
			box.setSize(50,50);
			box2.setSize(w,cardH);
		}
		
	}
}