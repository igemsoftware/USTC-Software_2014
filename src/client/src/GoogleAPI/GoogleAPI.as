package GoogleAPI
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import GUI.Scroll.Scroll;
	
	import Layout.FrontCoverSpace;
	
	public class GoogleAPI
	{
		
		public var html:URLLoader=new URLLoader();
		private var tempstr:String;
		public static var total:Array=new Array;
		public static var url:Array=new Array;
		public static var title:Array=new Array;
		public static var author:Array=new Array;
		public static var abstract:Array=new Array;
		public static var cite:Array=new Array;
		public var paper:Array=new Array;
		private var tmptitle:Array=new Array;
		
		

		
		public function GoogleAPI(str:String)
		{
			search(str);		
		}
		
		public function search(str):void{
			var url:URLRequest=new URLRequest("http://scholar.google.com/scholar?hl=en&q="+str+"&btnG=&hl=en&as_sdt=0%2C5");
			html.load(url);
			html.addEventListener(Event.COMPLETE,showdata);
		}
		
		protected function showdata(event:Event):void
		{
			tempstr=html.data;
			var search:String;
			var index:int=0;
			var len:int=tempstr.length;
			var i:int=1;
			var beginstr:String="<div class=\"gs_r\"><div class=\"gs_";
			var endstr:String="Fewer</a></div></div></div>";
			var begindex:Array=new Array;
			var endindex:Array=new Array;
			
			while(i!=0){
				i=tempstr.indexOf(beginstr,i);
				begindex[index]=i;
				index++;
				i++;
			}
			var j:int=1;
			index=0;
			while(j!=0){
				j=tempstr.indexOf(endstr,j);
				endindex[index]=j+endstr.length;
				index++;
				j++;
			}
			
			index=0;
			while(index<10){
				total[index]=tempstr.slice(begindex[index],endindex[index]);
				index++;
			}

			index=0;
			while(index<10){
				var tmp:String=total[index];
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
				tmptitle[index]=tmp.slice(begin_title,end_title+4);
				var a:int;
				var b:int;
				var c:int;
				var d:int;
				a=tmptitle[index].indexOf("a href=\"",1)+8;
				b=tmptitle[index].indexOf("\"",a);
				d=b=tmptitle[index].indexOf(">",b);
				c=tmptitle[index].indexOf("</a>",b);
				url[index]=tmptitle[index].slice(a,b);
				title[index]=tmptitle[index].slice(d+1,c);
				trace(url[index])
				trace(title[index])
				
				
				begin_author=tmp.indexOf("<div class=\"gs_a\">",1);
				end_author=tmp.indexOf("</div>",begin_author);
				author[index]=tmp.slice(begin_author+18,end_author);
				
				begin_abstract=tmp.indexOf("<div class=\"gs_rs\">",1);
				end_abstract=tmp.indexOf("</div>",begin_abstract);
				abstract[index]=tmp.slice(begin_abstract+19,end_abstract);
				abstract[index]=(abstract[index].split("<br>")).join("\n");
				
				begin_cite=tmp.indexOf("Cited by ",1);
				end_cite=tmp.indexOf("</a>",begin_cite);
				cite[index]=tmp.slice(begin_cite+9,end_cite);
				
				index++;
			}
			
			paper.push(title,url,author,abstract,cite);

			var gui:GoogleGUI;
			if(gui==null){
				gui=new GoogleGUI(600);
				gui.iconField=paper;
				//gui.Height=800;
				var scroll:Scroll=new Scroll(gui,600,400);
				FrontCoverSpace.addChild(scroll);
				scroll.x=50;
				scroll.y=100;
				scroll.setSize(600,400);
			}
			else{
				FrontCoverSpace.removeChild(scroll);
				gui=new GoogleGUI(600);
				gui.iconField=paper;
				
				var scroll:Scroll=new Scroll(gui,600,400);
				scroll.x=50;
				scroll.y=100;
				FrontCoverSpace.addChild(scroll);
				scroll.setSize(600,400);
			}
			
			
			

		}
	}
}