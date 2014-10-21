package Assembly.Compressor{
	
	public class CloudItemStatus {
		
		
		//synchroniaed, don't need to do any thing when SYNC
		public static const SYNCHRONIAED:int=0;
		
		//added from Cloud, Upload x,y,Name, Require ref_id when SYNC <refer_add>
		public static const UNSYNCHRONIAED:int=1;
		
		//added by user, upload Name,Type,Detail, x,y, Require ref_id <add>
		public static const NEW:int=2;
		
	}
}