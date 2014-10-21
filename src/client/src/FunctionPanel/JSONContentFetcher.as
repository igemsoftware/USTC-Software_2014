package FunctionPanel{
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	
	import fl.data.DataProvider;
	
	public class JSONContentFetcher{
		public function JSONContentFetcher()
		{
		}
		public static function fetch(json:String):ContextSheet{
			var consheet:ContextSheet=new ContextSheet();
			var conArray:Array=[];
			var tmpstr:String="";
			var t:DataProvider=new DataProvider();
			var tmpJson:Object=JSON.parse(json);
			for (var s:String in tmpJson) {
				if (s=="Information") {
					conArray.push(new ContextSheetItem(s,tmpJson[s]));
				}else {
					tmpstr+=s+" : "+tmpJson[s]+"\n";
				}
			}
			conArray.unshift(new ContextSheetItem("Detail",tmpstr));
			consheet.contextSheetList=conArray;
			return consheet;
		}
	}
}