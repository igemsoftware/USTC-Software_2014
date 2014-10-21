package UserInterfaces.FunctionPanel.AdvancedSearcher
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichButton;
	import GUI.RichUI.RichComboBox;
	
	import Kernel.Biology.NodeTypeInit;
	
	import UserInterfaces.GlobalLayout.LayoutManager;
	import UserInterfaces.Style.FontPacket;
	
	import fl.controls.CheckBox;
	import fl.events.ListEvent;
	import Kernel.Assembly.CheckerURLLoader;
	
	public class AdvancedSearcher extends Sprite
	{
		
		private var Case:CheckBox=new CheckBox();
		
		private var Prescise:CheckBox=new CheckBox();
		
		private var Prescise_Title:CheckBox=new CheckBox();
		
		
		private var hitA:HitBox=new HitBox();
		
		private var data:Array=[];
		public var searchbn:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		
		public var searchtxt:TextInput=new TextInput();
		public var aimType:RichComboBox=new RichComboBox(RichComboBox.LEFT_EDGE,true,false);
		
		
		
		private var grid:RichGrid=new RichGrid();
		
		private var nodataHint:LabelTextField=new LabelTextField("No result found");
		private var Loader:CheckerURLLoader=new CheckerURLLoader();
		
		private var Samp:SearchResPreviewer=new SearchResPreviewer();
		
		public function AdvancedSearcher()
		{
			
			
			addChild(hitA);	
			addChild(grid);
			addChild(Samp);
			
			addChild(nodataHint);
			
			var def:Object={label:"---"};
			
			aimType.dataProvider=[def].concat(NodeTypeInit.BiotypeIndexList);
			
			aimType.setSize(120,30);
			
			aimType.selectedIndex=0;
			
			Case.label="Match cases"
			
			Prescise.label="Precise"
			
			Prescise_Title.label="Left align"
			
			nodataHint.visible=false;
			nodataHint.defaultTextFormat=FontPacket.ContentText;
			nodataHint.text="No result found"
			
			searchbn.label="Search";
			searchbn.setSize(60,30);
			
			grid.columns=["Type","Name","Source","Cited"];
			grid.columnWidths=[118,200,100,50];
			
			grid.addEventListener("redrawed",function (e):void{
				dispatchEvent(new Event("redrawed"));
			});
			
			grid.addEventListener(ListEvent.ITEM_CLICK,function (e:ListEvent):void{
				Samp.GiveNode(e.item);
			});
			
			searchtxt.hintText="Input key words split by space";
			
			searchtxt.addEventListener("Enter",search);
			
			searchbn.addEventListener(MouseEvent.CLICK,search);
			
			setSize(500,400)
		}
		
		
		private function search(e):void{
			
			if (searchtxt.text.length<1) {
				return;
			}
			searchbn.suspend();
			
			var searchRequest:URLRequest=new URLRequest(GlobalVaribles.SEARCH_INTERFACE);
			
			var SearchJson_AND:Array=[]
				
			var keys:Array=[];
			
			if(!Prescise.selected&&!Prescise_Title.selected){
				keys=searchtxt.text.split(/\s+/);
			}else{
				keys=[searchtxt.text];
			}
			
			var searchName:Object=new Object();
			searchName.NAME=new Object();
			for (var i:int = 0; i < keys.length; i++) {
				if(Prescise.selected){
					searchName.NAME.$regex="^"+keys[i]+"$"
				}else if(Prescise_Title.selected){
					searchName.NAME.$regex="^"+keys[i];
				}else{
					searchName.NAME.$regex=keys[i];
				}
				if(!Case.selected){
					searchName.NAME.$options="i";
				}
				SearchJson_AND.push(searchName);
			}
			
			if(aimType.selectedItem.label!="---"){
				SearchJson_AND.push({TYPE:aimType.selectedItem.Type})
			}
			
			var SearchJson:Object={$and:SearchJson_AND}
			
			var postvar:URLVariables=new URLVariables();
			postvar.spec=JSON.stringify(SearchJson);
			//postvar.fields='{}';
			postvar.skip=0;
			postvar.limit =30;
			
			searchRequest.method=URLRequestMethod.POST;
			searchRequest.data=postvar;
			
			Loader.removeEventListener(Event.COMPLETE,Loader_CMP);
			
			Loader.load(searchRequest);
			
			Loader.addEventListener(Event.COMPLETE,Loader_CMP,false,0,true)
			
			Loader.addEventListener(IOErrorEvent.IO_ERROR,IOreport,false,0,true)
		}
		
		protected function IOreport(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			searchbn.unsuspend();
		}
		
		protected function Loader_CMP(event:Event):void
		{
			
			var res:Array=[];
			
			var results:Array=JSON.parse(event.target.data).result;
			trace(event.target.data);
			for each(var item:Object in  results){
				if (String(item._id).length==24) {
					res.push({Name:item.NAME,Type:item.TYPE,Source:item.author,Cited:item.cite,id:item._id});
				}
			}
			
			grid.dataProvider=res;
			
			if(res.length==0){
				nodataHint.visible=true;
			}else{
				nodataHint.visible=false;
			}
			searchbn.unsuspend();
		}
		
		public function setSize(w:Number,h:Number):void{
			
			searchtxt.setSize(w-180,30)
			hitA.setSize(w,h);			
			
			LayoutManager.UnifyScale(120,26,Case,Prescise_Title,Prescise);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,40,0,Case,Prescise,Prescise_Title);
			
			LayoutManager.setHorizontalLayout(this,LayoutManager.LAYOUT_ALIGN_LEFT,0,5,0,aimType,searchtxt,searchbn);
			
			grid.x=0;
			grid.y=70;
			grid.setSize(w,h-120);
			
			Samp.y=grid.y+grid.Height+5;
			
			Samp.setSize(w);
			
			nodataHint.x=w/2-nodataHint.width/2;
			nodataHint.y=grid.y+30;
		}
	}
}