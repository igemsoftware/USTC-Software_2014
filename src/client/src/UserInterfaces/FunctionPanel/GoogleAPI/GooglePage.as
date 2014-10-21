package UserInterfaces.FunctionPanel.GoogleAPI
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import GUI.RichUI.RichButton;
	
	import UserInterfaces.Style.Tween;
	
	public class GooglePage extends Sprite
	{
		
		private var currentHeight:int=0;
		private var Width:int;
		
		
		public var html:URLLoader=new URLLoader();
		private var tempstr:String;
		private var total:Array=new Array;
		
		public var searchbn:RichButton=new RichButton(RichButton.RIGHT_EDGE);
		
		private var appender:GooglePageAppend=new GooglePageAppend();
		
		public function GooglePage(){
			appender.visible=false;
			addChild(appender);
			
			appender.addEventListener(MouseEvent.CLICK,function (e):void{
				appendSearch();
			});
		}
		
		public function clear():void{
			
			removeChildren(1);
			
			currentHeight=0;
			
			appender.visible=false;
			
		}
		public function appendBlock(block:GooglePageBlock):void{
			
			addChild(block);
			
			block.x=0;
			block.y=currentHeight
			
			block.setSize(Width);
			
			currentHeight+=block.height+5;
			
			appender.y=currentHeight;
			appender.visible=true;
			
			
			
		}
		public function setSize(w:int):void{
			
			Width=w;
			
			appender.setSize(w);
			
			
		}
		
		
		private var n:int=0,searchStr:String;
		public function search(str):void{
			clear();
			var url:URLRequest=new URLRequest("http://scholar.google.com/scholar?q="+str+"&hl=en");
			
			searchbn.suspend();
			
			html.load(url);
			html.addEventListener(Event.COMPLETE,showdata);
			
			n=0;
			
		}
		
		public function appendSearch():void{
			n+=10;
			var url:URLRequest=new URLRequest("http://scholar.google.com/scholar?start="+n+"&q="+searchStr+"&hl=en");
			
			searchbn.suspend();
			
			html.load(url);
			html.addEventListener(Event.COMPLETE,showdata);
			
			appender.suspend();

		}
		
		protected function showdata(event:Event):void
		{
			trace("Google Receive")
			tempstr=html.data;
			var len:int=tempstr.length;
			
			var search:String;
			
			var beginstr:String="<div class=\"gs_r\"><div class=\"gs_";
			var endstr:String="Fewer</a></div></div></div>";
			var begindex:Array=new Array;
			var endindex:Array=new Array;
			var index:int=0;
			var i:int=0;
			var j:int=0;
			
			
			i=tempstr.indexOf(beginstr,i);
			while(i!=-1){
				begindex[index]=i;
				index++;
				i++;
				i=tempstr.indexOf(beginstr,i);
			}
			
			index=0;
			j=tempstr.indexOf(endstr,j);
			while(j!=-1){
				endindex[index]=j;
				index++;
				j++
				j=tempstr.indexOf(endstr,j);
			}
		
			for (var i2:int = 0; i2 < index; i2++) 
			{
				total[i2]=tempstr.slice(begindex[i2],endindex[i2]);
			}
			
			for (var k:int = 0; k < index; k++) {
				
				var tmp:String=total[k];
				var begin_title:int;
				var end_title:int;
				var begin_author:int;
				var end_author:int;
				var begin_abstract:int;
				var end_abstract:int;
				var begin_cite:int;
				var end_cite:int;
				
				begin_title=tmp.indexOf("<h3 class=\"gs_rt\"><a href=",1);
				if(begin_title==-1){
					begin_title=tmp.indexOf("</span> <a href=",1);
				}
				end_title=tmp.indexOf("</a>",begin_title);
				var tmptitle:String=tmp.slice(begin_title,end_title+4);
				var a:int;
				var b:int;
				var c:int;
				var d:int;
				a=tmptitle.indexOf("a href=\"",1)+8;
				b=tmptitle.indexOf("\"",a);
				d=b=tmptitle.indexOf(">",b);
				c=tmptitle.indexOf("</a>",b);
				var url:String=tmptitle.slice(a,b-1);
				var title:String=tmptitle.slice(d+1,c);
				
				
				begin_author=tmp.indexOf("<div class=\"gs_a\">",1);
				end_author=tmp.indexOf("</div>",begin_author);
				var author:String=tmp.slice(begin_author+18,end_author);
				
				begin_abstract=tmp.indexOf("<div class=\"gs_rs\">",1);
				end_abstract=tmp.indexOf("</div>",begin_abstract);
				var abstract:String=tmp.slice(begin_abstract+19,end_abstract).split("<br>").join("");
				
				begin_cite=tmp.indexOf("Cited by ",1);
				end_cite=tmp.indexOf("</a>",begin_cite);
				var cite:String=tmp.slice(begin_cite+9,end_cite);
				
				appendBlock(new GooglePageBlock(title,url,author,abstract,cite));
			}
			searchbn.unsuspend();
			appender.unsuspend();
			dispatchEvent(new Event("redrawed"));
		}
	}
	
}