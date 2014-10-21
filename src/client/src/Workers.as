/*******************************************************************************************************************************************
 * This is an automatically generated class. Please do not modify it since your changes may be lost in the following circumstances:
 *     - Members will be added to this class whenever an embedded worker is added.
 *     - Members in this class will be renamed when a worker is renamed or moved to a different package.
 *     - Members in this class will be removed when a worker is deleted.
 *******************************************************************************************************************************************/

package 
{
	
	import flash.utils.ByteArray;
	
	public class Workers
	{
		
		
		[Embed(source="../workerswfs/UserInterfaces/Sorpotions/NavigatorTrackingThread.swf", mimeType="application/octet-stream")]
		private static var UserInterfaces_Sorpotions_NavigatorTrackingThread_ByteClass:Class;
		
		[Embed(source="../workerswfs/Kernel/SmartCanvas/PickThread.swf", mimeType="application/octet-stream")]
		private static var Kernel_SmartCanvas_PickThread_ByteClass:Class;
		
		[Embed(source="../workerswfs/Kernel/SmartLayout/LayoutThread.swf", mimeType="application/octet-stream")]
		private static var Kernel_SmartLayout_LayoutThread_ByteClass:Class;
		
		
		
		
		public static function get UserInterfaces_Sorpotions_NavigatorTrackingThread():ByteArray
		{
			return new UserInterfaces_Sorpotions_NavigatorTrackingThread_ByteClass();
		}
		
		public static function get Kernel_SmartCanvas_PickThread():ByteArray
		{
			return new Kernel_SmartCanvas_PickThread_ByteClass();
		}
		
		public static function get Kernel_SmartLayout_LayoutThread():ByteArray
		{
			return new Kernel_SmartLayout_LayoutThread_ByteClass();
		}
		
		
		
		
		
		
		
	}
}
