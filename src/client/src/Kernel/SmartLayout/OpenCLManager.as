package Kernel.SmartLayout
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;

	public class OpenCLManager
	{
		
		private static var file:File=new File();
		private static var nativeProcessStartupInfo:NativeProcessStartupInfo;
		
		
		file=File.applicationDirectory.resolvePath("SmartLayout Socket.exe");
		nativeProcessStartupInfo = new NativeProcessStartupInfo();
		nativeProcessStartupInfo.executable = file;
		
		public static function activiteOpenCL():void
		{
			var process:NativeProcess = new NativeProcess();
			process.start(nativeProcessStartupInfo);
		}
	}
}