package Dock
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import GUI.Windows.WindowSpace;
	
	import Layout.FrontCoverSpace;
	import Layout.GlobalLayoutManager;
	
	import Style.FilterPacket;
	import Style.Tween;
	
	public class LatinBoard extends Sprite
	{
		public var Align:int=5;
		public var target:*;
		public var Base:Shape=new Shape();
		private var Width:Number,Height:Number;
		public var aimY:Number;
		private var Content:*;
		
		public function LatinBoard(content){
			addChild(Base);
			setContent(content);
			
			addEventListener(Event.ADDED_TO_STAGE,function (w):void{
				stage.addEventListener(MouseEvent.MOUSE_DOWN,outtest);
				aimY=GlobalLayoutManager.StageHeight-GlobalLayoutManager.DOCK_HEIGHT-Height-4;
			})
		}
		
		protected function outtest(e):void{
			
			if(!hitTestPoint(stage.mouseX,stage.mouseY)&&e.target!=target&&!FrontCoverSpace.coverSpace.hitTestPoint(stage.mouseX,stage.mouseY)){
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,outtest);
				
				Tween.floatOut(this);
				target.filters=[];
				target.mouseEnabled=true;
			}
		}
		public function showAt(tar):void{
			if(target!=tar||!WindowSpace.contains(this)){
				tar.filters=[FilterPacket.HighLightGlow];
				this.x=tar.x-50;
				target=tar;
				WindowSpace.addWindow(this);
				
				setSize(Content.width+Align*2,Content.height+Align*2);
				Tween.floatIn(this);
			}
		}
		
		public function setContent(tar):void{
			Content=tar;
			setSize(tar.width+Align*2,tar.height+Align*2);
			addChild(tar);
			tar.x=tar.y=Align;
			
			Content.addEventListener("redrawed",negRedraw);
		}
		
		public function setSize(w:Number,h:Number):void{
			Width=w;
			Height=h;
			
			redraw();
		}
		private function redraw():void{
			
			
			Base.graphics.clear();
			Base.graphics.beginFill(GlobalVaribles.SKIN_COLOR,GlobalVaribles.SKIN_ALPHA);
			Base.graphics.drawRoundRect(0,0,Width,Height,10,10);
			Base.graphics.endFill();
		}
		
				
		private function negRedraw(e):void{
			Width=Content.width+Align*2
			Height=Content.height+Align*2
			aimY=this.y=GlobalLayoutManager.StageHeight-GlobalLayoutManager.DOCK_HEIGHT-Height-4;
			
	
			redraw();

		}
		
		public function resetLocation():void{
			aimY=GlobalLayoutManager.StageHeight-GlobalLayoutManager.DOCK_HEIGHT-Height-4;
			if(target!=null){
				this.x=target.x-50;
			}
			this.y=GlobalLayoutManager.StageHeight-GlobalLayoutManager.DOCK_HEIGHT-Height-4;
			
		}
	}
}