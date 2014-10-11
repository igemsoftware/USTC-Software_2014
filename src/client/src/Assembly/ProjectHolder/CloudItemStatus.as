package Assembly.ProjectHolder{
	
	public class CloudItemStatus {
		
		//When SYNC, these should be concerned:
		//Is the Node Added from List? --> ADD
		//The Node is added from Cloud(opened or added) -->
		//		x,y change --> reference Patch
		//		detail change (include name/type) --> Delete_ref and Add
		
		
		//Just Loaded from cloud project
		public static const SYNCHRONIAED:int=0;
		
		//Just Loaded from Search List  -->  ref
		public static const UNSYNCHRONIAED:int=1;
		
		//added by user  -->  add
		public static const NEW:int=2;
		
		//Modified --> Delete and Add
		public static const MODIFIED:int=3;
		
		
	}
}