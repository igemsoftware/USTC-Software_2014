package UserInterfaces.FunctionPanel.BioBrick
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import UserInterfaces.Style.FontPacket;
	
	public class BioBrickHelper extends Sprite
	{
		
		private var hitA:HitBox=new HitBox();
		
		private var data:Array=[];
		private var igem:IgemAPI;
		public var searchbn:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		public var searchtxt:TextInput=new TextInput();
		private var grid:RichGrid=new RichGrid(false,true,false,false,false,true);
		
		private var nodataHint:LabelTextField=new LabelTextField("Part not found");
		
		public function BioBrickHelper()
		{
			addChild(hitA);	
			addChild(grid);
			
			addChild(nodataHint);
			
			nodataHint.visible=false;
			nodataHint.defaultTextFormat=FontPacket.ContentText;
			nodataHint.text="Part not found";
			
			
			searchbn.label="Search";
			searchbn.setSize(60,30);
			
			grid.columns=["Type","Value"];
			grid.columnWidths=[85,200];
			
			grid.addEventListener("redrawed",function (e):void{
				dispatchEvent(new Event("redrawed"));
			});
			
			searchtxt.hintText="BBa_";
			
			searchtxt.addEventListener("Enter",search);
			
			searchbn.addEventListener(MouseEvent.CLICK,search);
			
			setSize(400,400)
		}
		
		protected function visit(event:MouseEvent):void
		{
			var urlreq:URLRequest=new URLRequest(igem.part_url)
			navigateToURL(urlreq,"_self");
		}
		
		protected function search(event):void
		{
			if(searchtxt.text.length>4&&searchbn.mouseEnabled){
				if(stage!=null){
					stage.focus=null;
				}
				var str:String=searchtxt.text;
				if(igem==null){
					igem=new IgemAPI(str);
				}else{
					igem.search(str);
				}
				searchbn.suspend();
				igem.addEventListener("GetData",push);
				igem.addEventListener("NoData",pushN);
				igem.addEventListener(IOErrorEvent.IO_ERROR,function ():void{
					searchbn.unsuspend();
				});
			}
		}
		
		protected function pushN(event:Event):void
		{
			nodataHint.visible=true;
			
			searchbn.unsuspend();

			grid.dataProvider=[];
		}
		
		protected function push(event:Event):void
		{
			nodataHint.visible=false;
			
			searchbn.unsuspend();
			
			data=[];
			data.push({Type:"id",Value:igem.part_id});
			data.push({Type:"name",Value:igem.part_name});
			data.push({Type:"type",Value:igem.part_type});
			data.push({Type:"describe",Value:igem.part_desc});
			data.push({Type:"sequence",Value:igem.part_sequence});
			data.push({Type:"url",Value:igem.part_url});
			data.push({Type:"twins",Value:igem.part_twins});
			data.push({Type:"categories",Value:igem.categories});
			grid.dataProvider=data;
		}
		
		public function setSize(w:Number,h:Number):void{
			
			nodataHint.x=w/2-nodataHint.width/2;
			nodataHint.y=70;
			
			searchtxt.setSize(w-60,30)
			hitA.setSize(w,h);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,5,0,searchtxt,searchbn);
			grid.x=0;
			grid.y=40;
			grid.setSize(w,h-40);
		}
	}
}