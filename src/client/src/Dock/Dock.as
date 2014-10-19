package Dock{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import Assembly.ProjectHolder.GxmlContainer;
	import Assembly.ProjectHolder.ProjectManager;
	import Assembly.ProjectHolder.SyncManager;
	
	import Biology.TypeEditor.BioStyleEditor;
	
	import FunctionPanel.PerspectiveViewer;
	
	import GUI.Assembly.IconButton;
	import GUI.Windows.Panel;
	import GUI.Windows.WindowSpace;
	
	import ICON.NEW_BUTTON;
	import ICON.OPEN_BUTTON;
	import ICON.SAVE_BUTTON;
	
	import Layout.GlobalLayoutManager;
	
	import LoginAccount.LoginChoosePanel;
	
	public class Dock extends Sprite{
		
		
		
		public var back:DockPlate=new DockPlate();
		
		public var LeftAlign:int=60;
		
		public var back_b:IconButton=new IconButton(ICON_BACK,"Undo");
		public var forward_b:IconButton=new IconButton(ICON_FORWARD,"Redo");
		public var revert_b:IconButton=new IconButton(Icon_revert,"Revert File");
		
		public var save_b:IconButton=new IconButton(ICON.SAVE_BUTTON,"Save");
		public var saveAs_b:IconButton=new IconButton(ICON_SAVEAS_BUTTON,"Save Copy");
		public var load_b:IconButton=new IconButton(ICON.OPEN_BUTTON,"Open");
		public var new_b:IconButton=new IconButton(ICON.NEW_BUTTON,"New");
		public var print:IconButton=new IconButton(ICON_PRINT,"Print");
		public var option:IconButton=new IconButton(Option_button,"Option");
		public var layoutButton:IconButton=new IconButton(Icon_Layout,"Layout");
		public var Biotype:IconButton=new IconButton(Icon_design,"Design");
		public var login_b:IconButton=new IconButton(ICON_Login,"Login");
		public var sync_b:IconButton=new IconButton(Icon_SYNC,"Sync");
		public var upload_b:IconButton=new IconButton(Icon_upload,"Share");
		
		public var per_b:IconButton=new IconButton(Icon_Perspective,"Perspective View");
		public var FullScreen:IconButton=new IconButton(Icon_FullScreen,"Full Screen");
		
		public var DockList:Array=[new_b,load_b,save_b,saveAs_b,back_b,forward_b,revert_b,per_b,print,option,layoutButton,Biotype,login_b,sync_b,upload_b,FullScreen];
		
		public var Width:int;
		
		private var designPanel:Panel;
		
		private var loginPane:LoginChoosePanel=new LoginChoosePanel()
		
		private var latin:LatinBoard=new LatinBoard(new OptionPanel());
		private var loginlatin:LatinBoard=new LatinBoard(loginPane);
		private var persectivePanel:Panel;
		
		
		
		public function Dock(){
			
			
			back.rotationX=-30;
			addChild(back);
			
			for (var i:int = 0; i < DockList.length; i++) {
				DockList[i].x=50*i+LeftAlign;
				DockList[i].y=-GlobalLayoutManager.DOCK_HEIGHT/2;
				addChild(DockList[i]);
			}
			
			new_b.addEventListener("click",GxmlContainer.New);
			load_b.addEventListener("click",GxmlContainer.Open);
			save_b.addEventListener("click",GxmlContainer.Save);
			saveAs_b.addEventListener("click",GxmlContainer.SaveAs);
			
			revert_b.addEventListener("click",GxmlContainer.Revert);
			back_b.addEventListener("click",GxmlContainer.BackStep);
			forward_b.addEventListener("click",GxmlContainer.ForwardStep);
			
			per_b.addEventListener("click",function (e):void{
				if (persectivePanel==null) {
					persectivePanel=new Panel("Perspective View",new PerspectiveViewer());
					WindowSpace.addWindow(persectivePanel);
					persectivePanel.addEventListener("destory",function (e):void{
						persectivePanel=null;
					});
				}
			});
			
			option.addEventListener("click",opt_evt);
			login_b.addEventListener("click",function (e):void{
				loginlatin.showAt(login_b);
			});
			
			sync_b.addEventListener(MouseEvent.CLICK,SyncManager.SYNC);
			upload_b.addEventListener(MouseEvent.CLICK,upload_evt);
			
			Biotype.addEventListener(MouseEvent.CLICK,function (e):void{
				if (designPanel==null) {
					designPanel=new Panel("BioType Editor",new BioStyleEditor());
					WindowSpace.addWindow(designPanel);
					designPanel.addEventListener("destory",function (e):void{
						designPanel=null;
					});
				}
			});
			layoutButton.addEventListener(MouseEvent.CLICK,chg_layout);
			FullScreen.addEventListener(MouseEvent.CLICK,function (e):void{
				if(stage.displayState==StageDisplayState.NORMAL){
					stage.displayState=StageDisplayState.FULL_SCREEN_INTERACTIVE;
					FullScreen.Icon=Icon_Normal;
					FullScreen.label="Exit Full Screen"
				}else{
					stage.displayState=StageDisplayState.NORMAL;
					FullScreen.Icon=Icon_FullScreen;
					FullScreen.label="Full Screen"
				}
			});
		}
		
		protected function upload_evt(event:MouseEvent):void
		{
			ProjectManager.Upload();
		}
		
		protected function opt_evt(event:MouseEvent):void
		{
			latin.showAt(option);
		}
		
		protected function chg_layout(event:MouseEvent):void{
			stage.dispatchEvent(new Event("LayoutChange"));
		}
		
		public function setCenter(cx,cy):void{
			var p:PerspectiveProjection=new PerspectiveProjection();
			p.projectionCenter=new Point(cx,cy);
			back.transform.perspectiveProjection=p;
		}
		
		public function setSize(w:Number):void{
			Width=w;
			back.setSize(w);

			latin.resetLocation();
			loginlatin.resetLocation();
			
		}
	}
}