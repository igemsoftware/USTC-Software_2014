package UserInterfaces.FunctionPanel.Detail{
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	/**
	 * fetch content from json
	 */
	public class JSONContentFetcher{

		public static function fetch(tar:*):ContextSheet{
			
			var json:Object=tar.detail;
			
			var consheet:ContextSheet=new ContextSheet();
			
			var conArray:Array=[];
			
			
			var major:ContextSheetItem=new ContextSheetItem("Abstract",new MajorDetailPane(tar));
			
			var detail:ContextSheetItem=new ContextSheetItem("Detail",new SubDetailPane(tar));
			
			var tmpJson:Object=json.Description;
			
			
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