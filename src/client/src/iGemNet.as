package{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import Assembly.Canvas.I3DPlate;
	import Assembly.ProjectHolder.FileHolder;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import Biology.LinkTypeInit;
	import Biology.NodeTypeInit;
	
	import GUI.Windows.WindowSpace;
	
	import Layout.GlobalLayoutManager;
	
	import SmartLayout.LayoutRunner;
	
	import Style.FontPacket;
	
	import fl.managers.StyleManager;
	
	
	public class iGemNet extends GlobalLayoutManager{
		
		/*Init Statics*/	
		new NodeTypeInit();
		new LinkTypeInit();
		
		new IMouseCursor();
		
		/*Show Init Logo:*/
		//new LOGO();
		
		/*Show Version*/
		
		public static const Version:String="BioPano 10 Technical Preview";
		public static const Title:String="BioPanorama 10 @ iGEM Software 2014";
		
		public var User_Data:SharedObject;
		
		new LayoutRunner;
		
		public const ForceVersion:String="3.1";
		
		
		public function iGemNet(){
			
			
			stage.nativeWindow.title=Title;
			
			/////User Appreciation
			
			User_Data=SharedObject.getLocal("UserAppreciation");
			
			if(User_Data.data.valid==ForceVersion){
				
				GlobalVaribles.showIconMap=User_Data.data.showIconMap;
				
				GlobalVaribles.LeftHabit=User_Data.data.LeftHabit;
				
				GlobalLayoutManager.BackGroundColor=User_Data.data.backGroundColor;
				
				if(User_Data.data.showFPS){
					WindowSpace.addWindow(GlobalLayoutManager.fpsViewer);
				}
				
				I3DPlate.grid.visible=User_Data.data.showGrid;
				
				GlobalVaribles.token=User_Data.data.token;
				
				GlobalVaribles.userName=User_Data.data.userName;
				
			}else{
				
				new LinkTypeInit(true);
				
				User_Data.data.valid=ForceVersion;
				
				User_Data.data.showIconMap=true;
				
				User_Data.data.LeftHabit=true;
				
				User_Data.data.backGroundColor=0x000000;
				
				User_Data.data.showFPS=false;
				
				User_Data.data.showGrid=true;
				
				User_Data.data.token="";
				
				User_Data.data.userName=""
			}
			
			stage.addEventListener(Event.DEACTIVATE,function (e):void{
				
				User_Data.data.LeftHabit=GlobalVaribles.LeftHabit;
				
				User_Data.data.showIconMap=GlobalVaribles.showIconMap;
				
				User_Data.data.backGroundColor=GlobalLayoutManager.BackGroundColor;
				
				User_Data.data.showFPS=WindowSpace.contains(GlobalLayoutManager.fpsViewer);;
				
				User_Data.data.showGrid=I3DPlate.grid.visible;
				
				////////Token
				User_Data.data.token=GlobalVaribles.token;
				
				User_Data.data.userName=GlobalVaribles.userName;
			});
			
			////////////
			
			stage.frameRate=36;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,setStage);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,key_listener);
			
			/*stage.addEventListener(MouseEvent.MOUSE_MOVE,function (e):void{
				
				trace(e.target);
			});*/
			////////Style
			
			StyleManager.setStyle("textFormat", FontPacket.LabelText);
			
			new ServerMon();
			
			super();
		}

		protected function key_listener(e:KeyboardEvent):void
		{
			//ctrl+F
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