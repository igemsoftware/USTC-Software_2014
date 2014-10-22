package UserInterfaces.Style{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	import GUI.Windows.FreeWindow;
	import GUI.Windows.WindowSpace;
	
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	import UserInterfaces.Sorpotions.Navigator;

	/**
	 * this is a class of all the graphics effects used
	 */
	public class Tween{
		
		public static function fadeOut(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,smoothining);
			tar.addEventListener(Event.ENTER_FRAME,fadeouting);
		}
		
		private static function fadeouting(e):void{
			e.target.alpha/=1.3;
			if (e.target.alpha<0.1) {
				e.target.alpha=0;
				e.target.removeEventListener(Event.ENTER_FRAME,fadeouting);
				e.target.dispatchEvent(new Event("destory"));
			}
		}
		
		public static function smoothIn(tar):void{
			tar.visible=true;
			tar.removeEventListener(Event.ENTER_FRAME,fadeouting);
			tar.addEventListener(Event.ENTER_FRAME,smoothining)
		}
		
		private static function smoothining(e):void{
			e.target.alpha+=0.1;
			if (e.target.alpha>0.9) {
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,smoothining);
				e.target.dispatchEvent(new Event("complete"));
			}
		}
		
		
		public static var remX:int;
		
		public static function smoothLeft(tar):void{
			tar.mouseEnabled=false;
			remX=tar.x;
			tar.removeEventListener(Event.ENTER_FRAME,smoothBacking);
			tar.addEventListener(Event.ENTER_FRAME,smoothlefting)
		}
		
		private static function smoothlefting(e):void{
			e.target.x=(e.target.x*2+(20-e.target.width))/3;
			if (Math.abs(e.target.x-e.target.width)<20) {
				e.target.x=20-e.target.width;
				e.target.mouseEnabled=true;
				e.target.removeEventListener(Event.ENTER_FRAME,smoothlefting);
			}
		}
		
		public static function smoothBack(tar):void{
			tar.mouseEnabled=false;
			tar.removeEventListener(Event.ENTER_FRAME,smoothlefting);
			tar.addEventListener(Event.ENTER_FRAME,smoothBacking);
		}
		
		private static function smoothBacking(e):void{
			e.target.x=(e.target.x*2+remX)/3;
			if (Math.abs(e.target.x-remX)<1) {
				e.target.x=remX;
				e.target.mouseEnabled=true;
				e.target.removeEventListener(Event.ENTER_FRAME,smoothBacking);
			}
		}
		
		public static function smoothOut(tar):void{
			tar.visible=true;
			tar.removeEventListener(Event.ENTER_FRAME,smoothining);
			tar.addEventListener(Event.ENTER_FRAME,smoothouting)
		}
		
		private static function smoothouting(e):void{
			e.target.alpha/=1.2;
			if (e.target.alpha<0.05) {
				e.target.alpha=0;
				e.target.removeEventListener(Event.ENTER_FRAME,smoothouting);
			}
		}
		
		public static function smoothRoll(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,roll);
			tar.addEventListener(Event.ENTER_FRAME,roll);
		}
		private static function roll(e):void{
			e.target.y=(e.target.y*2+e.target.roll_y)/3;
			if (Math.abs(e.target.y-e.target.roll_y)<0.5) {
				e.target.y=e.target.roll_y;
				e.target.removeEventListener(Event.ENTER_FRAME,roll)
			}
		}
		
		public static function Slide(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,sliding);
			tar.addEventListener(Event.ENTER_FRAME,sliding);
		}
		private static function sliding(e):void{
			e.target.x=(e.target.x*2+e.target.aimX)/3;
			e.target.y=(e.target.y*2+e.target.aimY)/3;
			if (Math.abs(e.target.x-e.target.aimX)<0.5&&Math.abs(e.target.y-e.target.aimY)<0.5) {
				e.target.dispatchEvent(new Event(Event.COMPLETE));
				e.target.x=e.target.aimX;
				e.target.y=e.target.aimY;
				e.target.removeEventListener(Event.ENTER_FRAME,sliding);
			}
		}
		public static function SlideY(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,slidingY);
			tar.addEventListener(Event.ENTER_FRAME,slidingY);
		}
		private static function slidingY(e):void{
			e.target.y=(e.target.y*2+e.target.aimY)/3;
			if (Math.abs(e.target.y-e.target.aimY)<2) {
				e.target.y=e.target.aimY;
				e.target.removeEventListener(Event.ENTER_FRAME,slidingY);
			}
		}
		
		
		public static function GlideNet(x:Number,y:Number):void{
			FreePlate.lock();
			Net.ani_container.aimX=x;
			Net.ani_container.aimY=y;
			Net.ani_container.removeEventListener(Event.ENTER_FRAME,sgliding);
			Net.ani_container.addEventListener(Event.ENTER_FRAME,sgliding);
		}
		private static function sgliding(e):void{
			FreePlate.movePlateTo((FreePlate.plate.x*2+Net.ani_container.aimX)/3,(FreePlate.plate.y*2+Net.ani_container.aimY)/3);
			if (Math.abs(FreePlate.plate.y-Net.ani_container.aimY)<0.5&&Math.abs(FreePlate.plate.x-Net.ani_container.aimX)<0.5) {
				FreePlate.movePlateTo(Net.ani_container.aimX,Net.ani_container.aimY);
				Net.ani_container.removeEventListener(Event.ENTER_FRAME,sgliding);
				FreePlate.unlock();
			}
			Navigator.refreshRange();
		}
		
		public static function zoomIn(tar):void{
			tar.visible=true;
			tar.removeEventListener(Event.ENTER_FRAME,zoomingIn);
			tar.addEventListener(Event.ENTER_FRAME,zoomingIn);
		}
		private static function zoomingIn(e):void{
			e.target.alpha=e.target.scaleX=e.target.scaleY=(e.target.scaleX*2+1)/3;
			if (Math.abs(e.target.scaleX-1)<0.01) {
				e.target.alpha=e.target.scaleX=e.target.scaleY=1;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingIn);
			}
		}
		
		public static function zoomFocus(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,zoomingFocus);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingOutFocus);
			tar.addEventListener(Event.ENTER_FRAME,zoomingFocus);
		}
		private static function zoomingFocus(e):void{
			e.target.scaleX=e.target.scaleY=(e.target.scaleX*3+1)/4;
			e.target.alpha=1/e.target.scaleX/e.target.scaleX;
			if (Math.abs(e.target.scaleX-1)<0.01) {
				e.target.scaleX=e.target.scaleY=1;
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingFocus);
			}
		}
		
		public static function zoomOutFocus(tar):void{
			if (tar.scaleX<=1) {
				tar.scaleX=1;
			}
			
			tar.removeEventListener(Event.ENTER_FRAME,zoomingFocus);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingOutFocus);
			tar.addEventListener(Event.ENTER_FRAME,zoomingOutFocus);
		}
		private static function zoomingOutFocus(e):void{
			e.target.scaleX=e.target.scaleY=e.target.scaleX*1.1;
			e.target.alpha/=1.5;
			if (e.target.scaleX>3) {
				e.target.scaleX=e.target.scaleY=1;
				e.target.parent.removeChild(e.target);
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingOutFocus);
			}
		}
		public static function TweenScale(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,TweenScaling);
			tar.addEventListener(Event.ENTER_FRAME,TweenScaling);
		}
		private static function TweenScaling(e):void{
			e.target.Width=(e.target.Width*2+e.target.tweenWidth)/3;
			e.target.Height=(e.target.Height*2+e.target.tweenHeight)/3;
			e.target.redraw();
			if (Math.abs(e.target.Width-e.target.tweenWidth)<0.5&&Math.abs(e.target.Height-e.target.tweenHeight)<0.5) {
				e.target.Width=e.target.tweenWidth;
				e.target.Height=e.target.tweenHeight;
				e.target.removeEventListener(Event.ENTER_FRAME,TweenScaling);
			}
		}
		public static function zoomUp(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDownS);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDown);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingUp);
			tar.addEventListener(Event.ENTER_FRAME,zoomingUp);
		}
		private static function zoomingUp(e):void{
			e.target.scaleX=e.target.scaleY=(e.target.scaleX+1)/2;
			e.target.alpha=1-(1-e.target.scaleX)/3*2;
			if (Math.abs(e.target.scaleX-1)<0.02) {
				e.target.scaleX=e.target.scaleY=1;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingIn);
			}
		}
		public static function zoomDown(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDownS);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDown);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingUp);
			tar.addEventListener(Event.ENTER_FRAME,zoomingDown);
		}
		private static function zoomingDown(e):void{
			e.target.scaleX=e.target.scaleY=(e.target.scaleX+0.7)/2;
			e.target.alpha=1-(1-e.target.scaleX)/3*2;
			if (Math.abs(e.target.scaleX-0.9)<0.02) {
				e.target.scaleX=e.target.scaleY=0.9;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingDown);
			}
		}
		public static function zoomDownSmall(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDownS);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingDown);
			tar.removeEventListener(Event.ENTER_FRAME,zoomingUp);
			tar.addEventListener(Event.ENTER_FRAME,zoomingDownS);
		}
		private static function zoomingDownS(e):void{
			e.target.alpha=e.target.scaleX=e.target.scaleY=(e.target.scaleX+0.95)/2;
			if (Math.abs(e.target.scaleX-0.95)<0.02) {
				e.target.scaleX=e.target.scaleY=0.95;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingDownS);
			}
		}
		public static function zoomPass(tar):void{
			tar.removeEventListener(Event.ENTER_FRAME,zoomingPass);
			tar.addEventListener(Event.ENTER_FRAME,zoomingPass);
		}
		private static function zoomingPass(e):void{
			e.target.alpha=e.target.scaleX=e.target.scaleY=(e.target.scaleX+1)/2;
			if (Math.abs(e.target.scaleX-1)<0.02) {
				e.target.scaleX=e.target.scaleY=1;
				e.target.removeEventListener(Event.ENTER_FRAME,zoomingPass);
			}
		}
		public static function floatIn(tar):void{
			tar.y=tar.aimY+40;
			tar.alpha=0;
			tar.removeEventListener(Event.ENTER_FRAME,floatingIn);
			tar.addEventListener(Event.ENTER_FRAME,floatingIn);
		}
		private static function floatingIn(e):void{
			e.target.y=(e.target.aimY+e.target.y*2)/3;
			e.target.alpha=1-(e.target.y-e.target.aimY)/40;
			if (Math.abs(e.target.aimY-e.target.y)<0.5) {
				e.target.y=e.target.aimY;
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,floatingIn);
			}
		}
		
		
		/////////Amazing Window!!
		
		public static function OpenWindow(tar):void{
			tar.visible=false;
			
			var _cach:BitmapData=new BitmapData(tar.width,tar.height,true,0);
			
			_cach.draw(tar)
			
			var bitmap:Bitmap=new Bitmap(_cach)
				
			var skin:WindowOpener=new WindowOpener();
			skin.win=tar;

			skin.addChild(bitmap);
			
			bitmap.x=-bitmap.width/2;
			bitmap.y=-bitmap.height/2;
			
			skin.x=tar.x+bitmap.width/2;
			skin.y=tar.y+bitmap.height/2;
			
			skin.rotationY=120;
			skin.z=1000;
			skin.alpha=0;
			
			WindowSpace.addMask(skin,tar);

			skin.addEventListener(Event.ENTER_FRAME,OpeningWindow);
		}
		private static function OpeningWindow(e):void{
			e.target.rotationY/=1.5;
			e.target.z/=1.5;
			e.target.alpha+=0.1
			if (Math.abs(e.target.rotationY)<0.5) {
				e.target.win.visible=true;
				WindowSpace.removeWindow(e.target);
				e.target.removeEventListener(Event.ENTER_FRAME,OpeningWindow);
			}
		}
		
		public static function EmphasizeWindow(tar):void{
			
			var _cach:BitmapData=new BitmapData(tar.width,tar.height,true,0);
			
			_cach.draw(tar)
			
			var bitmap:Bitmap=new Bitmap(_cach)
			
			var skin:WindowOpener=new WindowOpener();
			skin.win=tar;
			
			skin.addChild(bitmap);
			
			bitmap.x=-bitmap.width/2;
			bitmap.y=-bitmap.height/2;
			
			skin.x=tar.x+bitmap.width/2;
			skin.y=tar.y+bitmap.height/2;
			
			skin.alpha=0.7;
			
			WindowSpace.addMask(skin);
			
			skin.addEventListener(Event.ENTER_FRAME,EmphasizingWindow);
		}
		private static function EmphasizingWindow(e):void{
			e.target.scaleX+=0.015;
			e.target.scaleY+=0.015;
			e.target.alpha/=1.35;
			if (Math.abs(e.target.alpha)<0.1) {
				WindowSpace.removeWindow(e.target);
				e.target.removeEventListener(Event.ENTER_FRAME,OpeningWindow);
			}
		}
		
		
		public static function CloseWindow(tar):void{
			
			
			var _cach:BitmapData=new BitmapData(tar.Width,tar.Height,true,0);
			
			_cach.draw(tar)
			
			var bitmap:Bitmap=new Bitmap(_cach)
			
			var skin:WindowOpener=new WindowOpener();
			skin.win=tar;
			
			skin.addChild(bitmap);
			
			bitmap.x=-bitmap.width/2;
			bitmap.y=-bitmap.height/2;
			
			skin.x=tar.x+bitmap.width/2;
			skin.y=tar.y+bitmap.height/2;
			
			WindowSpace.addMask(skin,tar);
			WindowSpace.removeWindow(tar);
			
			skin.addEventListener(Event.ENTER_FRAME,CloseingWindow);
		}
		private static function CloseingWindow(e):void{
			e.target.rotationX-=10;
			e.target.alpha/=1.5
			e.target.z+=50;
			e.target.y-=30;
			if (Math.abs(e.target.alpha)<0.1) {
				WindowSpace.removeWindow(e.target);
				e.target.removeEventListener(Event.ENTER_FRAME,CloseingWindow);
			}
		}
		
		public static function FloatDownWindow(tar):void{
			
			
			var _cach:BitmapData=new BitmapData(tar.width,tar.height,true,0);
			
			_cach.draw(tar)
			
			var bitmap:Bitmap=new Bitmap(_cach)
			
			var skin:WindowOpener=new WindowOpener();
			skin.win=tar;
			
			skin.addChild(bitmap);
			
			bitmap.x=-bitmap.width/2;
			bitmap.y=-bitmap.height/2;
			
			skin.x=tar.x+bitmap.width/2;
			skin.y=tar.y+bitmap.height/2;
			
			WindowSpace.addMask(skin,tar);
			WindowSpace.removeWindow(tar);
			
			skin.addEventListener(Event.ENTER_FRAME,FloatingDownWindow);
		}
		private static function FloatingDownWindow(e):void{
			e.target.y+=3;
			e.target.alpha/=1.4
			if (Math.abs(e.target.alpha)<0.1) {
				WindowSpace.removeWindow(e.target);
				e.target.removeEventListener(Event.ENTER_FRAME,FloatingDownWindow);
			}
		}

		
		
		public static function floatLeft(tar):void{
			tar.x=tar.aimX+40;
			tar.alpha=0;
			tar.visible=true;
			tar.removeEventListener(Event.ENTER_FRAME,floatingLeft);
			tar.addEventListener(Event.ENTER_FRAME,floatingLeft);
		}
		private static function floatingLeft(e):void{
			e.target.x=(e.target.aimX+e.target.x*2)/3;
			e.target.alpha=1-(e.target.x-e.target.aimX)/40;
			if (Math.abs(e.target.aimX-e.target.x)<0.5) {
				e.target.x=e.target.aimX;
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,floatingLeft);
			}
		}
		public static function floatOut(tar):void{
			tar.aimY=tar.y+40;
			tar.removeEventListener(Event.ENTER_FRAME,floatingIn);
			tar.removeEventListener(Event.ENTER_FRAME,floatingOut);
			tar.addEventListener(Event.ENTER_FRAME,floatingOut);
		}
		private static function floatingOut(e):void{
			e.target.y=(e.target.aimY+e.target.y*2)/3;
			e.target.alpha=(e.target.aimY-e.target.y)/40;
			if (Math.abs(e.target.aimY-e.target.y)<0.5) {
				e.target.y=e.target.aimY;
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,floatingOut);
				e.target.dispatchEvent(new Event("destory"));
			}
		}
		
		public static function Jump(tar):void{
			tar.aimY=tar.y+40;
			tar.removeEventListener(Event.ENTER_FRAME,Jumping);
			tar.addEventListener(Event.ENTER_FRAME,Jumping);
		}
		private static function Jumping(e):void{
			e.target.y=(e.target.aimY+e.target.y*2)/3;
			e.target.alpha=(e.target.aimY-e.target.y)/40;
			if (Math.abs(e.target.aimY-e.target.y)<0.5) {
				e.target.y=e.target.aimY;
				e.target.alpha=1;
				e.target.removeEventListener(Event.ENTER_FRAME,Jumping);
			}
		}
		
		
		////////////Window
		
		public static function DeployWindowFromNet(win:FreeWindow,x,y,w,h):void{
			
			var stagePoint:Point=FreePlate.plate.localToGlobal(new Point(x,y));
			
			win.x=stagePoint.x;
			win.y=stagePoint.y;
			win.width=w;
			win.height=h;
			
			win.aimX=stagePoint.x-win.aimW/2;
			win.aimY=stagePoint.y-win.aimH/2;
			
			if(win.aimX<0)win.aimX=0;
			if(win.aimX>GlobalLayoutManager.StageWidth-win.aimW)win.aimX=GlobalLayoutManager.StageWidth-win.aimW;
			if(win.aimY<0)win.aimY=0;
			if(win.aimY>GlobalLayoutManager.StageHeight-win.aimH)win.aimY=GlobalLayoutManager.StageHeight-win.aimH;
	
			win.addEventListener(Event.ENTER_FRAME,Deploying);
		}
		private static function Deploying(e:Event):void{
			e.target.x=(e.target.x*2+e.target.aimX)/3;
			e.target.y=(e.target.y*2+e.target.aimY)/3;
			e.target.scaleX=(e.target.scaleX*2+1)/3;
			e.target.scaleY=(e.target.scaleY*2+1)/3;
			
			
			if (Math.abs(e.target.x-e.target.aimX)<1) {
				e.target.x=e.target.aimX;
				e.target.y=e.target.aimY;
				e.target.scaleX=e.target.scaleY=1;
				e.target.removeEventListener(Event.ENTER_FRAME,Deploying);
			}
		}
		public static function CloseWindowToNet(win:FreeWindow,x,y,w,h):void{
			
			
			
			var stagePoint:Point=FreePlate.plate.localToGlobal(new Point(x,y));
			
			var _cach:BitmapData=new BitmapData(win.width,win.height,true,0);
			
			_cach.draw(win)
			
			var bitmap:Bitmap=new Bitmap(_cach)
			
			var skin:WindowOpener=new WindowOpener();
			skin.win=win;
			
			skin.addChild(bitmap);
			
			bitmap.x=-bitmap.width/2;
			bitmap.y=-bitmap.height/2;
			
			skin.x=win.x+bitmap.width/2;
			skin.y=win.y+bitmap.height/2;
			
			WindowSpace.addMask(skin,win);
			WindowSpace.removeWindow(win);
			
			skin.addEventListener(Event.ENTER_FRAME,FloatingDownWindow);
			
			skin.aimX=stagePoint.x
			skin.aimY=stagePoint.y;
			skin.aimW=w;
			skin.aimH=h;
			
			skin.addEventListener(Event.ENTER_FRAME,Closeing);
		}
		private static function Closeing(e:Event):void{
			e.target.x=(e.target.x*3+e.target.aimX)/4;
			e.target.y=(e.target.y*3+e.target.aimY)/4;
			e.target.width=(e.target.width*3+e.target.aimW)/4;
			e.target.height=(e.target.height*3+e.target.aimH)/4;
			e.target.alpha/=1.1;
			
			if (Math.abs(e.target.width-e.target.aimW)<1) {	
				e.target.removeEventListener(Event.ENTER_FRAME,Closeing);
				WindowSpace.removeWindow(e.target);
			}
		}
	}
}