package GUI.ContextSheet{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import GUI.FlexibleWidthObject;
	import GUI.Assembly.NetLoader;
	
	import Style.FilterPacket;
	import Style.FontPacket;
	import Style.Tween;
	
	public class ContextSheetItem extends Sprite implements FlexibleWidthObject{
		
		public var Content:*;
		public var Title:TextField=new TextField();
		public var contentList:Array=new Array();
		public var banner:Sheet_banner=new Sheet_banner();
		public var Folded:Boolean=false;
		public var roll_y:Number;
		public var Width:Number=200,Height:Number=0;
		
		public var leftAlign:int=10;
		
		private var foldmark:foldMark=new foldMark();
		
		public function ContextSheetItem(title:String,content:*){
			
			Title.defaultTextFormat=new TextFormat("微软雅黑",18);
			Title.text=title;
			Title.autoSize="left";
			
			
			if (content.constructor==Array) {
				Content=content;
			}else {
				Content=[content]
			}
			
			addChild(banner);
			addChild(Title);
			addChild(foldmark);
			
			for (var i:int = 0; i < Content.length; i++) {
				if (typeof(Content[i])=="string") {
					contentList[i]=new TextField();
					contentList[i].defaultTextFormat=FontPacket.HighDensityText;
					contentList[i].multiline=true;
					contentList[i].wordWrap=true;
					////////
					contentList[i].htmlText=Content[i];
				}else{
					contentList[i]=Content[i];
					contentList[i].addEventListener("redrawed",function (e):void{
						redraw(false);
						dispatchEvent(new Event("fold"));
					});
				}
				addChild(contentList[i]);
				Tween.smoothIn(contentList[i]);
			}
			if (Folded) {
				foldmark.gotoAndStop(1);
			}else {
				foldmark.gotoAndStop(2);
			}
			
			foldmark.scaleX=foldmark.scaleY=0.6;
			foldmark.mouseEnabled=false;
			Title.mouseEnabled=false;
			banner.addEventListener("click",fold)
			banner.addEventListener(MouseEvent.MOUSE_OVER,function (e):void{
				foldmark.filters=[FilterPacket.ThinHightLightGlow];
			})
			banner.addEventListener(MouseEvent.MOUSE_OUT,function (e):void{
				foldmark.filters=[];
			})
			
		}
		
		protected function fold(event:MouseEvent):void{
			if (Folded) {
				Folded=false;
				foldmark.gotoAndStop(2);
				for (var j:int = 0; j < Content.length;j++) {
					Tween.smoothIn(contentList[j]);
				}
				redraw();
			}else {
				Folded=true;
				foldmark.gotoAndStop(1);
				for (var i:int = 0; i < Content.length;i++) {
					Tween.fadeOut(contentList[i]);
				}
			}
			dispatchEvent(new Event("fold"));
		}
		public function setSize(w:Number):void{
			if(w!=Width){
				Width=w;
				redraw();
			}
		}
		private function redraw(pos:Boolean=true):void{
			
			Height=0;
			
			Title.width=Width;
			banner.width=Width;
			banner.height=Title.height;
			foldmark.x=9;
			Title.x=foldmark.x+14;
			foldmark.y=banner.height/2-3;
			if (!Folded) {
				var currentHeight:Number=banner.height;
				for (var i:int = 0; i < Content.length; i++) {
					if (typeof(Content[i])=="string") {
						contentList[i].y=currentHeight+2;
						contentList[i].width=Width;
						contentList[i].height=contentList[i].textHeight+5;
					}else if (contentList[i].constructor==NetLoader){
						if (contentList[i].loader.width==0) {
							contentList[i].loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e):void{redraw();dispatchEvent(new Event("fold"))});
						}else{
							contentList[i].scaleX=1;
							if (contentList[i].width>=Width-20) {
								contentList[i].width=Width-20;
								contentList[i].scaleY=contentList[i].scaleX;
							}else {
								contentList[i].scaleX=contentList[i].scaleY=1;
							}
						}
						contentList[i].x=Width/2-contentList[i].width/2;
						contentList[i].y=currentHeight+2;	
					}else if(contentList[i].constructor==HTMLLoader){
						contentList[i].x=leftAlign;
						contentList[i].y=currentHeight+2;	
						if(pos){
							contentList[i].width=Width-20;
							contentList[i].height=600;
						}
					}else{
						contentList[i].x=leftAlign;
						contentList[i].y=currentHeight+2;	
						if(pos){
							contentList[i].setSize(Width-leftAlign*2);
						}
					}
					
					if (contentList[i].hasOwnProperty("Height")) {
						currentHeight+=contentList[i].Height;
					}else {
						currentHeight+=contentList[i].height;
					}
				}
				Height=currentHeight;
			}
		}
	}
}