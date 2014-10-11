package FunctionPanel{
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	
	public class JSONContentFetcher{

		public static function fetch(tar:*):ContextSheet{
			
			var json:String=tar.detail;
			
			var consheet:ContextSheet=new ContextSheet();
			
			var conArray:Array=[];
			
			
			var major:ContextSheetItem=new ContextSheetItem("Abstract",new MajorDetailPane(tar));
			
			var detail:ContextSheetItem=new ContextSheetItem("Detail",new SubDetailPane(tar));
			
			var tmpJson:String=JSON.parse(json).Description;
			
			
			conArray=[major,detail];
			if(tmpJson!=null){
				var info:ContextSheetItem=new ContextSheetItem("Description",tmpJson);
				conArray.push(info);
			}
			
			consheet.contextSheetList=conArray;
			return consheet;
		}
	}
}