package FunctionPanel
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	import GUI.RichGrid.RichGrid;
	import GUI.RichUI.RichTextField;
	
	import Assembly.Compressor.CompressedNode;
	
	public class ContentEditPanel extends Sprite
	{
		public var cts:ContextSheet=new ContextSheet();
		public var rtg:RichGrid=new RichGrid(true);
		public var rtf:RichTextField=new RichTextField();
		
		public var Height:Number;
		
		public var Target:CompressedNode;
		private var Width:Number;
		
		public function ContentEditPanel(tar:CompressedNode)
		{
			
			Target=tar;
			
			setContent();
			
			rtg.setSize(100,250);
			
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
				if (s=="Information") {
					rtf.text=tmpJson[s];
				}else {
					t.push({Feature:s,Description:tmpJson[s]});
				}
			}
			rtg.dataProvider=t;
			rtg.columns=["Feature","Description"];
			rtg.columnWidths=[200,200];
			var a1:ContextSheetItem=new ContextSheetItem("Instruction",rtf);
			conArray.push(a1);
			
			cts.contextSheetList=conArray;
		}
		
		public function get json():String{
			var rs:String='{';
			var ta:Array=rtg.dataProvider;
			for (var i:int = 0; i < ta.length; i++) {
				rs+='"'+ta[i].Feature+'":"'+ta[i].Description+'"';
				if (i!=ta.length-1) {
					rs+=','
				}
			}
			var loadtext:String=rtf.text;
			loadtext=loadtext.split('\"').join('\\"');
			rs+=',"Information":"'+loadtext+'"'
			rs+='}';
			
			trace(rs);
			return rs;
		}
		public function setSize(w:Number):void{
			Width=w;
			cts.setSize(w);
			Height=cts.Height;
		}
	}
}