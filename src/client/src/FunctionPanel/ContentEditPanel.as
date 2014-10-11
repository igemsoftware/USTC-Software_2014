package FunctionPanel
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Assembly.Compressor.CompressedLine;
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichTextField;
	
	public class ContentEditPanel extends Sprite
	{
		public var cts:ContextSheet=new ContextSheet();
		public var rtg:RichGrid=new RichGrid(true,true,false,false,true);
		public var rtf:RichTextField=new RichTextField();
		
		public var Height:Number;
		
		public var Target:*;
		private var Width:Number;
		
		public function ContentEditPanel(tar)
		{
			
			Target=tar;
			
			setContent();
			
			addChild(cts);
			
			
			cts.addEventListener("redrawed",function (e):void{
				Height=cts.Height;
				dispatchEvent(new Event("redrawed"));
			});
		}
		
		public function setContent():void{
			var conArray:Array=[];
			var a0:ContextSheetItem=new ContextSheetItem("Detail",rtg);
			conArray.push(a0);
			var t:Array=[];
			var tmpJson:Object=JSON.parse(Target.detail);
			for (var s:String in tmpJson) {
				if (s=="Description") {
					rtf.text=tmpJson[s];
				}else if(s!="NAME"&&s!="TYPE"){
					t.push({Feature:s,Description:tmpJson[s]});
				}
			}
			rtg.dataProvider=t;
			rtg.columns=["Feature","Description"];
			rtg.columnWidths=[200,200];
			var a1:ContextSheetItem=new ContextSheetItem("Description",rtf);
			conArray.push(a1);
			
			cts.contextSheetList=conArray;
		}
		
		public function get json():String{
			var ta:Array=rtg.dataProvider;
			
			var saveObj:Object=new Object();
			for (var i:int = 0; i < ta.length; i++) {
				
				saveObj[ta[i].Feature]=ta[i].Description;

			}
			
			saveObj["NAME"]=Target.Name;
			saveObj["TYPE"]=Target.Type.Type;
			
			saveObj["Description"]=rtf.text;
			
			return JSON.stringify(saveObj);
		}
		public function setSize(w:Number):void{
			Width=w;
			cts.setSize(w);
			Height=cts.Height;
		}
	}
}