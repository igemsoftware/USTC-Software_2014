package UserInterfaces.GlobalLayout{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import GUI.DragBar.DragBar_Vertical;
	import GUI.Windows.WindowSpace;
	
	import Kernel.Events.ScaleEvent;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.AskManager.AskManager;
	import UserInterfaces.Dock.Dock;
	import UserInterfaces.Dock.SearchingPad;
	import UserInterfaces.IvyBoard.Ivy;
	import UserInterfaces.ReminderManager.ReminderManager;
	import UserInterfaces.Sorpotions.Navigator;
	import UserInterfaces.Sorpotions.Sorption;
	import UserInterfaces.Style.Tween;
	
	public class GlobalLayoutManager extends Sprite{
		
		public static var fpsViewer:FPSviewer=new FPSviewer();
		/////
		
		public static const DOCK_HEIGHT:int=50;
		public static var StageHeight:int,StageWidth:int;
		public static var BackGroundColor:uint=0x000000;
		public static const IVY_WIDTH:int=260;
		
		
		private const ALPHA_S1:Number=0.6;
		private const ALPHA_S2:Number=1;
		
		public var miniMap:Navigator=new Navigator();
		public static var TheNet:Net=new Net();

		public var control_panel:Dock=new Dock();
		public var scaleDrager:DragBar_Vertical;
		public var searchBar:SearchingPad=new SearchingPad();
		public var navigator:Sorption=new Sorption(miniMap,"Thumbnail");
		
		////////RunTimes
		private var R3Droll_pos:Number;
		private var ShowPanels:Boolean=false;
		private var IvyX:int;
		private var aimWidth:int;
		private var aimX:Number;
		private var aimAlpha:Number;
		
		public function GlobalLayoutManager(){
			
			BackGround.color=BackGroundColor;
			
			scaleDrager=new DragBar_Vertical(stage.stageHeight-250);
			
			searchBar.setSize(250,38);
			
			BackGround.backGround.x=-10;
			BackGround.backGround.y=-10;
			
			setStage();
			
			addChild(BackGround.backGround);
			addChild(TheNet);
			addChild(scaleDrager);
			addChild(control_panel);
			addChild(searchBar);
			addChild(Ivy.Banner);
			addChild(navigator);
			addChild(WindowSpace.windowSpace);
			addChild(WindowSpace.halfArea);
			addChild(FrontCoverSpace.coverSpace);
			
			addChild(ReminderManager.ReminderSpace);
			
			addChild(AskManager.askbar);
		
			BackGround.backGround.addEventListener(Event.COMPLETE,setStage);
			
			stage.addEventListener("LayoutChange",chg_layout_evt);
			
			Ivy.Board.addEventListener("showBoard",showIvy);
			stage.addEventListener("hideBoard",hideIvy);
			stage.addEventListener(ScaleEvent.SCALE_CHANGE,function (event:ScaleEvent):void{
				scaleDrager.showScale(event.scale);
			});
			
			searchBar.addEventListener("FocusIn",function (e):void{
				addChild(searchBar);
				searchBar.alpha=1;
			});
			
			searchBar.addEventListener("FocusOut",function (e):void{
				addChildAt(searchBar,getChildIndex(control_panel)+1);
				if(!ShowPanels&&stage.stageWidth<1240){
					searchBar.alpha=0.8;
				}
			});
		}
	
		
		public function showIvy(e=null):void{
			addChildAt(Ivy.Board,getChildIndex(searchBar)+1);
			SlideBoard(stage.stageWidth-IVY_WIDTH);
			Ivy.Board.addEventListener(Event.COMPLETE,cmp);
			Ivy.show=true;
			function cmp(e):void{
				Ivy.Board.removeEventListener(Event.COMPLETE,cmp);
				 TheNet.addEventListener(MouseEvent.CLICK,hideIvy);
			}
		}
		public function hideIvy(e=null):void{
			if (!ShowPanels) {
				SlideBoard(stage.stageWidth+1);
				Ivy.show=false;
				Ivy.clearSelection();
				TheNet.removeEventListener(MouseEvent.CLICK,hideIvy);
				Ivy.Board.addEventListener(Event.COMPLETE,cmp);
				function cmp(e):void{
					Ivy.Board.removeEventListener(Event.COMPLETE,cmp);
					if (contains(Ivy.Board)) {
						removeChild(Ivy.Board);
					}
				}
			}
		}
		public function SlideBoard(ax):void{
			Ivy.Board.aimX=ax;
			Tween.Slide(Ivy.Board);
		}
		protected function chg_layout_evt(event:Event):void{
			ShowPanels=!ShowPanels;
			SwapWorkSpace(ShowPanels);
		}
		public function SwapWorkSpace(show:Boolean):void{
			if (show){
				R3Droll_pos=0;
				IvyX=IVY_WIDTH;
				aimX=-25;
				aimWidth=-40;
				aimAlpha=ALPHA_S2;
				if (!contains(Ivy.Board)) {
					addChildAt(Ivy.Board,getChildIndex(searchBar)+1);
					Ivy.Board.x=stage.stageWidth;
				}
				TheNet.removeEventListener(MouseEvent.CLICK,hideIvy);
			}else{
				R3Droll_pos=-30;
				IvyX=-5;
				aimX=20;
				aimWidth=40;
				aimAlpha=ALPHA_S2;
			}
			
			ReminderManager.ReminderSpace.x=(stage.stageWidth-Number(show)*IVY_WIDTH)/2
			SlideBoard(stage.stageWidth-IvyX);
			Ivy.Banner.show=show;
			Ivy.show=show;
			R3DRoll();
			if(ShowPanels&&stage.stageWidth<1160){
				searchBar.y=StageHeight-DOCK_HEIGHT-39;
				searchBar.alpha=1;
			}else if(!ShowPanels&&stage.stageWidth<1240){
				searchBar.y=StageHeight-DOCK_HEIGHT-39;
				if(!searchBar.focused){
					searchBar.alpha=0.8
				}
			}else{
				searchBar.y=stage.stageHeight-DOCK_HEIGHT/2-searchBar.Height/2;
				searchBar.alpha=1
			}
		}
		private function R3DRoll():void {
			addEventListener(Event.ENTER_FRAME,R3Droll);
		}
		private function R3Droll(e):void {
			if (Math.abs(R3Droll_pos-control_panel.back.rotationX)>0.02) {
				control_panel.x = (aimX+control_panel.x * 2) / 3;
				control_panel.setSize((stage.stageWidth-aimWidth+control_panel.Width*2)/3);
				control_panel.back.rotationX = (R3Droll_pos + control_panel.back.rotationX * 2) / 3;
				control_panel.back.alpha=(control_panel.back.alpha+aimAlpha)/2;
				if(ShowPanels&&stage.stageWidth<1160){
					searchBar.x=Ivy.Board.x-searchBar.Width-2;
				}else if(!ShowPanels&&stage.stageWidth<1240){
					searchBar.x=Ivy.Board.x-searchBar.Width-10;
					if(!searchBar.focused){
						searchBar.alpha=0.8
					}
				}else{
					searchBar.x=stage.stageWidth-control_panel.x-285;
				}
				scaleDrager.x=Ivy.Board.x-25;
				TheNet.setCenter((Ivy.Board.x)/2,stage.stageHeight/2);
			}else{
				removeEventListener(Event.ENTER_FRAME,R3Droll);
				control_panel.back.alpha=aimAlpha;
				Ivy.Board.x=stage.stageWidth-IvyX;
				TheNet.setCenter((Ivy.Board.x)/2,stage.stageHeight/2);
				control_panel.back.rotationX=R3Droll_pos;
				if (!ShowPanels&&contains(Ivy.Board)) {
					removeChild(Ivy.Board);
				}
			}
			TheNet.setSize(stage.stageWidth,stage.stageHeight);
		}
		public function setStage(e=null) :void{
			
			AskManager.askbar.x=stage.stageWidth/2;
			
			StageHeight=stage.stageHeight;
			StageWidth=stage.stageWidth;
			
			ReminderManager.ReminderSpace.x=(stage.stageWidth-Number(ShowPanels)*IVY_WIDTH)/2
			ReminderManager.ReminderSpace.y=stage.stageHeight-DOCK_HEIGHT-30;

			Ivy.redraw(IVY_WIDTH,stage.stageHeight-DOCK_HEIGHT);
			Ivy.resetLayout();
			
			if (ShowPanels){
				control_panel.setSize(stage.stageWidth+40);
				control_panel.x=-25;
				control_panel.back.alpha=ALPHA_S2;
				scaleDrager.x=Ivy.Board.x-25;
				
				Navigator.setMap((stage.stageWidth-IVY_WIDTH)/2,stage.stageHeight/2,stage.stageWidth-IVY_WIDTH,stage.stageHeight);
				TheNet.setCenter((stage.stageWidth-IVY_WIDTH)/2,stage.stageHeight/2);
				
			}else{
				control_panel.setSize(stage.stageWidth-40);
				control_panel.x=20;
				control_panel.back.alpha=ALPHA_S1;
				scaleDrager.x=stage.stageWidth-25;
				
				Navigator.setMap(stage.stageWidth/2,stage.stageHeight/2,stage.stageWidth,stage.stageHeight);
				TheNet.setCenter(stage.stageWidth/2,stage.stageHeight/2);
				
			}
			searchBar.x=stage.stageWidth-control_panel.x-285;
			
			if(ShowPanels&&stage.stageWidth<1160){
				searchBar.x=Ivy.Board.x-searchBar.Width-2;
				searchBar.y=StageHeight-DOCK_HEIGHT-39
				searchBar.alpha=1;
			}else if(!ShowPanels&&stage.stageWidth<1240){
				searchBar.x=Ivy.Board.x-searchBar.Width-10;
				searchBar.y=StageHeight-DOCK_HEIGHT-39;
				if(!searchBar.focused){
					searchBar.alpha=0.8
				}
			}else{
				searchBar.x=stage.stageWidth-control_panel.x-285;
				searchBar.y=stage.stageHeight-DOCK_HEIGHT/2-searchBar.Height/2;
				searchBar.alpha=1
			}
			
			TheNet.setSize(stage.stageWidth,stage.stageHeight);
			
			control_panel.y=stage.stageHeight;
			
			BackGround.setSize(stage.stageWidth,stage.stageHeight)
			
			scaleDrager.y=100;
			scaleDrager.setSize(stage.stageHeight-250);
			
			Navigator.refreshRange();
			
			Net.NodeSpace.setArea();
			
			control_panel.setCenter(stage.stageWidth/2,stage.stageHeight/2);
			WindowSpace.setStageScale(stage.stageWidth,stage.stageHeight);
			
			var p:PerspectiveProjection=new PerspectiveProjection();
			p.projectionCenter=new Point(StageWidth/2,StageHeight/2);
			this.transform.perspectiveProjection=p;
			
		}
	}
}