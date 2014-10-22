package{
	import flash.desktop.NativeApplication;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import GUI.Assembly.IMouseCursor;
	import GUI.Windows.WindowSpace;
	
	import Kernel.Assembly.ServerMon;
	import Kernel.Biology.LinkTypeInit;
	import Kernel.Biology.NodeTypeInit;
	import Kernel.ProjectHolder.FileHolder;
	import Kernel.ProjectHolder.GxmlContainer;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartLayout.LayoutRunner;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	import UserInterfaces.Style.FontPacket;
	
	import fl.managers.StyleManager;
	
	
	public class iGemNet extends GlobalLayoutManager{
		
		
		///Init NodeType
		///@see NodeTypeInit.as
		new NodeTypeInit();
		
		///Init LinkType
		///@see LinkTypeInit.as
		new LinkTypeInit();
		
		///Init MouseCursor
		///@see IMouseCursor.as
		new IMouseCursor();
		
		///Init Layour Runner
		///@see LayoutRunner.as
		new LayoutRunner();
		
		///Init server monitor
		///@see ServerMon.as
		new ServerMon();
		
		///Show Init Logo:
		new LOGO();
		
		///Window Title 
		public static const Title:String="BioPano Release @ iGEM Software 2014";
		
		///Local appearciation storage <for option>
		public var User_Data:SharedObject;
		
		///Version check for local storage, if the version is lower than ForceVersion, some of the data may needs to be modified. <for updates>
		public const ForceVersion:String="3.1";
		
		public function iGemNet(){
			
			///For back stage processes. true means these processes will quit when the main Program quit.
			NativeApplication.nativeApplication.autoExit=true;
			
			///set window title
			stage.nativeWindow.title=Title;
			
			
			/////below handles local user appreciation storage
			
			User_Data=SharedObject.getLocal("UserAppreciation");

			if(User_Data.data.valid==ForceVersion){
				
				
				GlobalVaribles.showIconMap=User_Data.data.showIconMap;
				
				GlobalVaribles.LeftHabit=User_Data.data.LeftHabit;
				
				GlobalLayoutManager.BackGroundColor=User_Data.data.backGroundColor;
				
				if(User_Data.data.showFPS){
					WindowSpace.addWindow(GlobalLayoutManager.fpsViewer);
				}
				
				FreePlate.grid.visible=User_Data.data.showGrid;
				
				///These two are account information
				GlobalVaribles.token=User_Data.data.token;
				
				GlobalVaribles.userName=User_Data.data.userName;
				
			}else{
				
				showGuide=true;
				
				new LinkTypeInit(true);
				
				User_Data.data.valid=ForceVersion;
				
				User_Data.data.showIconMap=true;
				
				User_Data.data.LeftHabit=true;
				
				User_Data.data.backGroundColor=0x000000;
				
				User_Data.data.showFPS=false;
				
				User_Data.data.showGrid=true;
				
				///These two are account information
				User_Data.data.token="";
				
				User_Data.data.userName=""
			}
			
			
			///Save user appreciation when exiting
			stage.addEventListener(Event.DEACTIVATE,function (e):void{
				
				User_Data.data.LeftHabit=GlobalVaribles.LeftHabit;
				
				User_Data.data.showIconMap=GlobalVaribles.showIconMap;
				
				User_Data.data.backGroundColor=GlobalLayoutManager.BackGroundColor;
				
				User_Data.data.showFPS=WindowSpace.contains(GlobalLayoutManager.fpsViewer);;
				
				User_Data.data.showGrid=FreePlate.grid.visible;
				
				///These two are account information
				User_Data.data.token=GlobalVaribles.token;
				
				User_Data.data.userName=GlobalVaribles.userName;
			});
			
			
			///Below set the stage attribution
			stage.frameRate=36;												//Max frameRate
			stage.scaleMode=StageScaleMode.NO_SCALE;		//Scale mode, stage scale shouldn't change
			stage.align=StageAlign.TOP_LEFT;								//Layout from left-top.
			stage.addEventListener(Event.RESIZE,setStage);			//re-arrange layout when window scale is changed.
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,key_listener);		//listener for hot key.
			
			/*stage.addEventListener(MouseEvent.MOUSE_MOVE,function (e):void{
				
				trace(e.target);
			});*/
			
			
			///Style for Flash UI Components
			StyleManager.setStyle("textFormat", FontPacket.LabelText);

			super();
		}

		
		protected function key_listener(e:KeyboardEvent):void
		{			
			/**Listener for ctrl-based hot keys*/
			if(e.ctrlKey&&e.keyCode==Keyboard.F){
				searchBar.setFocus();
			}
			if(e.ctrlKey&&e.keyCode==Keyboard.S){
				GxmlContainer.Save();
			}
			if(e.ctrlKey&&e.keyCode==Keyboard.Z){
				GxmlContainer.BackStep();
			}
			if(e.ctrlKey&&e.keyCode==Keyboard.Y){
				GxmlContainer.ForwardStep();
			}
			if(e.ctrlKey&&e.keyCode==Keyboard.O){
				GxmlContainer.Open();
			}
			if(e.ctrlKey&&e.keyCode==Keyboard.N){
				GxmlContainer.New();
			}
		}
		
		public static function setWindowLabel():void{
			/**for setting window label, used for showing current file
			 * @see Kernel.ProjectHolder.FileHolder
			 * */
			
			if(FileHolder.currentFile!=null){
				if(GxmlContainer.modified){
					TheNet.stage.nativeWindow.title=Title+" - "+FileHolder.currentFile.name+"*";
				}else{
					TheNet.stage.nativeWindow.title=Title+" - "+FileHolder.currentFile.name;
				}
			}else{
				TheNet.stage.nativeWindow.title=Title;
			}
			
		}
		
	}
}