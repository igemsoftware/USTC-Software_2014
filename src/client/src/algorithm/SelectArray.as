package algorithm
{

	public class SelectArray
	{
		public function SelectArray()
		{
		}
		public static function search(a:String,b:String):Boolean{
			return a.toLowerCase().indexOf(b.toLowerCase())!=-1
		}
		public static function searchArray(tab:Array,key:String,str:String):Array {
			var searchTable:Array=new Array();
			var item:Object
			if (str.length > 0) {
				var fit:String;
				for each(item in tab) {
					fit = item[key].toLowerCase();
					if (fit.indexOf(str.toLowerCase(),0) != -1) {
						searchTable.push(item);
					}
				}
			} else {
				for each(item in tab) {
					searchTable.push(item);
				}
			}
			return searchTable;
		}
	}
}