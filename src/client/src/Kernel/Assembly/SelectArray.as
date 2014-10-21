package Kernel.Assembly
{

	/**Useful functions for runtime
	 * Include following:
	 * 
	 * SelectArray: Search method for selecting certain string of a certain key from a Array, return matched Objects (Array). 
	*/
	public class SelectArray
	{
		/**
		 * select objects from a Array
		 * @param array Array from which to select
		 * @param key seaching by which key
		 * @param str The string to match
		 * @return searchResult An array include all matched objects
		 */
		public static function searchArray(array:Array,key:String,str:String):Array {
			var searchResult:Array=new Array();
			var item:Object
			if (str.length > 0) {
				var fit:String;
				for each(item in array) {
					fit = item[key].toLowerCase();
					if (fit.indexOf(str.toLowerCase(),0) != -1) {
						searchResult.push(item);
					}
				}
			} else {
				for each(item in array) {
					searchResult.push(item);
				}
			}
			return searchResult;
		}
	}
}