package IgemPartAPI
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	
	import Layout.LayoutManager;

	public class BioBrickHelper extends Sprite
	{
		
		private var hitA:HitBox=new HitBox();
		
		private var data:Array=[];
		private var igem:IgemAPI;
		public var searchbn:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		private var visit_bn:RichButton=new RichButton(0,100,30);
		public var searchtxt:TextInput=new TextInput();
		private var grid:RichGrid=new RichGrid(false,true,false,false,false,true);
		
		public function BioBrickHelper()
		{
			addChild(hitA);	
			addChild(grid);
			
			searchbn.label="Search";
			searchbn.setSize(60,30);
			
			grid.columns=["Type","Value"];
			grid.columnWidths=[85,200];
		
			grid.addEventListener("redrawed",function (e):void{
				dispatchEvent(new Event("redrawed"));
			});
			
			searchtxt.hintText="BBa_";
			
			searchtxt.addEventListener("Enter",search);
			
			visit_bn.label="Visit Website";
			visit_bn.setSize(100,30);
			
			searchbn.addEventListener(MouseEvent.CLICK,search);
			visit_bn.addEventListener(MouseEvent.CLICK,visit);
			
			setSize(400,400)
		}
		
		protected function visit(event:MouseEvent):void
		{
			var urlreq:URLRequest=new URLRequest(igem.part_url)
			navigateToURL(urlreq,"_self");
		}
		
		protected function search(event):void
		{
			if(stage!=null){
				stage.focus=null;
			}
			var str:String=searchtxt.text;
			if(igem==null){
				igem=new IgemAPI(str);
			}
			else{
				igem.search(str);
			}
			igem.addEventListener(Event.COMPLETE,push);
		}
		
		
		
		protected function push(event:Event):void
		{
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
			
			searchtxt.setSize(w-60,30)
			hitA.setSize(w,h);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,5,0,searchtxt,searchbn);
			grid.x=0;
			grid.y=40;
			grid.setSize(w,h-40);
		}
	}
}