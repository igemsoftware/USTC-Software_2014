package UserInterfaces.IvyBoard
{
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;
	
	public class InspectorLoader
	{
		public function InspectorLoader(){
		}
		public static function fetch(arr:Array):ContextSheet{
			var consheet:ContextSheet=new ContextSheet();
			var conArray:Array=[];
			for (var i:int = 0; i < arr.length; i++) {
				var a0:ContextSheetItem=new ContextSheetItem(arr[i].label,arr[i].Object);
				a0.leftAlign=5;
				conArray.push(a0);
			}
			consheet.contextSheetList=conArray;
			return consheet;
		}
	}
}