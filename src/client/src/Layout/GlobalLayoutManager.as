package Layout{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Ask.Asker;
	
	import Assembly.Canvas.Net;
	
	import Dock.Dock;
	import Dock.SearchingPad;
	
	import GUI.DragBar.DragBar_Vertical;
	import GUI.Windows.WindowSpace;
	
	import IEvent.ScaleEvent;
	
	import IvyBoard.Ivy;
	
	import Layout.Sorpotions.Navigator;
	import Layout.Sorpotions.Sorption;
	
	import Style.Tween;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	public class GlobalLayoutManager extends Sprite{
		
		public static var fpsViewer:FPSviewer=new FPSviewer();
		
		public static var verText:VersionHint=new VersionHint(iGemNet.Version);
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
		public var ivy_panel:Ivy=new Ivy();
		public var scaleDrager:DragBar_Vertical;
		public var searchBar:SearchingPad=new SearchingPad();
		public var navigator:Sorption=new Sorption(miniMap,"Navigator");
		
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
			addChild(ivy_panel.Banner);
			addChild(navigator);
			addChild(WindowSpace.windowSpace);
			addChild(WindowSpace.halfArea);
			addChild(FrontCoverSpace.coverSpace);
			
			addChild(ReminderManager.ReminderSpace);
			
			addChild(verText);
			
			addChild(Asker.askbar);
			
			
		
			BackGround.backGround.addEventListener(Event.COMPLETE,setStage);
			
			stage.addEventListener("LayoutChange",chg_layout_evt);
			
			ivy_panel.Board.addEventListener("showBoard",showIvy);
			stage.addEventListener("hideBoard",hideIvy);
			stage.addEventListener(ScaleEvent.SCALE_CHANGE,function (event:ScaleEvent):void{
				scaleDrager.showScale(event.scale);
			});
		}
		
		public function showIvy(e=null):void{
			addChildAt(ivy_panel.Board,getChildIndex(searchBar)-1);
			SlideBoard(stage.stageWidth-IVY_WIDTH);
			ivy_panel.Board.addEventListener(Event.COMPLETE,cmp);
			ivy_panel.show=true;
			function cmp(e):void{
				ivy_panel.Board.removeEventListener(Event.COMPLETE,cmp);
				 TheNet.addEventListener(MouseEvent.CLICK,hideIvy);
			}
		}
		public function hideIvy(e=null):void{
			if (!ShowPanels) {
				SlideBoard(stage.stageWidth+1);
				ivy_panel.show=false;
				TheNet.removeEventListener(MouseEvent.CLICK,hideIvy);
				ivy_panel.Board.addEventListener(Event.COMPLETE,cmp);
				function cmp(e):void{
					ivy_panel.Board.removeEventListener(Event.COMPLETE,cmp);
					if (contains(ivy_panel.Board)) {
						removeChild(ivy_panel.Board);
					}
				}
			}
		}
		public function SlideBoard(ax):void{
			ivy_panel.Board.aimX=ax;
			Tween.Slide(ivy_panel.Board);
		}
		protected function chg_layout_evt(event:Event):void{
			ShowPanels=!ShowPanels;
			SwapWorkSpace(ShowPanels);
		}
		public function SwapWorkSpace(show:Boolean):void{
			if (show){
				R3Droll_pos=0;
				IvyX=IVY_WIDTH;
				aimX=-30;
				aimWidth=-40;
				aimAlpha=ALPHA_S2;
				if (!contains(ivy_panel.Board)) {
					addChildAt(ivy_panel.Board,getChildIndex(searchBar)-1);
					ivy_panel.Board.x=stage.stageWidth;
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
			ivy_panel.Banner.show=show;
			ivy_panel.show=show;
			R3DRoll();
		}
		private function R3DRoll():void {
			addEventListener(Event.ENTER_FRAME,R3Droll);
		}
		private function R3Droll(e):void {
			if (Math.abs(R3Droll_pos-control_panel.back.rotationX)>0.02) {
				control_panel.x = (aimX+control_panel.x * 2) / 3;
				control_panel.setSize((stage.stageWidth-aimWidth+control_panel.Width*2)/3);
				control_panel.back.rotationX = (R3Droll_pos + control_panel.back.rotationX * 2) / 3;
				control_panel.back.alpha=(control_panel.back.alpha+aimAlpha)/2
				searchBar.x=stage.stageWidth-control_panel.x-290;
				scaleDrager.x=ivy_panel.Board.x-25;
				TheNet.setCenter((ivy_panel.Board.x)/2,stage.stageHeight/2);
			}else{
				removeEventListener(Event.ENTER_FRAME,R3Droll);
				control_panel.back.alpha=aimAlpha;
				ivy_panel.Board.x=stage.stageWidth-IvyX;
				TheNet.setCenter((ivy_panel.Board.x)/2,stage.stageHeight/2);
				control_panel.back.rotationX=R3Droll_pos;
				if (!ShowPanels&&contains(ivy_panel.Board)) {
					removeChild(ivy_panel.Board);
				}
			}
			TheNet.setSize(stage.stageWidth,stage.stageHeight);
		}
		public function setStage(e=null) :void{
			
			Asker.askbar.x=stage.stageWidth/2;
			
			verText.x=stage.stageWidth/2-verText.width/2;
			
			StageHeight=stage.stageHeight;
			StageWidth=stage.stageWidth;
			
			ReminderManager.ReminderSpace.x=(stage.stageWidth-Number(ShowPanels)*IVY_WIDTH)/2
			ReminderManager.ReminderSpace.y=stage.stageHeight-DOCK_HEIGHT-30;
			
			
			
			searchBar.y=stage.stageHeight-DOCK_HEIGHT/2-searchBar.Height/2;
			searchBar.x=stage.stageWidth-control_panel.x-290;

			ivy_panel.redraw(IVY_WIDTH,stage.stageHeight-DOCK_HEIGHT);
			ivy_panel.resetLayout();
			
			if (ShowPanels){
				control_panel.setSize(stage.stageWidth+40);
				control_panel.x=-30;
				control_panel.back.alpha=ALPHA_S2;
				scaleDrager.x=ivy_panel.Board.x-25;
				
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
			
			TheNet.setSize(stage.stageWidth,stage.stageHeight);
			
			control_panel.y=stage.stageHeight;
			
			BackGround.setSize(stage.stageWidth,stage.stageHeight)
			
			scaleDrager.y=100;
			scaleDrager.setSize(stage.stageHeight-250);
			
			Navigator.refreshRange();
			
			control_panel.setCenter(stage.stageWidth/2,stage.stageHeight/2);
			WindowSpace.setStageScale(stage.stageWidth,stage.stageHeight);
			
			var p:PerspectiveProjection=new PerspectiveProjection();
			p.projectionCenter=new Point(StageWidth/2,StageHeight/2);
			this.transform.perspectiveProjection=p;
			
		}
	}
}