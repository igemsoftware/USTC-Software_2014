package FunctionPanel
{
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	import GUI.Assembly.NetLoader;
	import GUI.ContextSheet.ContextSheet;
	import GUI.ContextSheet.ContextSheetItem;

	public class XMLContentFetcher
	{
		
		public function XMLContentFetcher(){
		}
		public static function fetch(xml:XML):ContextSheet{
			var consheet:ContextSheet=new ContextSheet();
			var conArray:Array=[];
			var tmpstr:String;
			var tmpxml:XMLList=xml.children();
			for each(var plot:XML in  tmpxml){
				var txml:XMLList=plot.*;
				var c:Array=[];
				for each (var cont:XML in txml){
					if(cont.toXMLString().indexOf("<text>")!=-1){
						tmpstr=String(cont);
						tmpstr=(tmpstr.split("#[$")).join("<");
						tmpstr=(tmpstr.split("#]$")).join(">");
						c.push(tmpstr);
					}else if (cont.toXMLString().indexOf("<url>")!=-1) {
						var tmploader:NetLoader=new NetLoader();
						tmploader.load(new URLRequest(cont));
						c.push(tmploader);
					}else if (cont.toXMLString().indexOf("<html>")!=-1) {
						var htmlloader:HTMLLoader=new HTMLLoader();
						htmlloader.load(new URLRequest(cont));
						c.push(htmlloader);
					}
				}
				var a0:ContextSheetItem=new ContextSheetItem(String(plot.@Label),c);
				conArray.push(a0);
			}
			consheet.contextSheetList=conArray;
			return consheet;
		}
		public static function fetchAStext(xml:XML):String{
			var res:String="";
			trace(xml);
			var tmpxml:XMLList=xml.children();
			for each(var plot:XML in  tmpxml){
				var txml:XMLList=plot.*;
				res+="[plot]"+String(plot.@Label)+"\n";
				for each (var cont:XML in txml){
					if(cont.toXMLString().indexOf("<text>")!=-1){
						var tmps:String=String(cont);
						res+=tmps;
					}else if (cont.toXMLString().indexOf("<url>")!=-1) {
						res+="[url]"+String(cont)+"\n";
					}else if (cont.toXMLString().indexOf("<html>")!=-1) {
						res+="[html]"+String(cont)+"\n";
					}
				}
			}
			return res;
		}
		public static function saveASXML(str:String):XML{
			trace(str);
			var xmlChild:XMLList=XMLList(str)
			var tmpxml:XML;
			var tmpstr:String;
			var t:int;
			var res:XML=new XML();
			res=<Content></Content>;
			for each (var xml:XML in xmlChild) {
				tmpstr=String(xml.children());
				trace(tmpstr);
				if ((t=tmpstr.indexOf("[plot]"))!=-1) {
					if (tmpxml!=null) {
						res.appendChild(tmpxml);
					}
					tmpxml=
						<Plot Label={tmpstr.slice(t+6)}>
						</Plot>;
				}else if ((t=tmpstr.indexOf("[url]"))!=-1) {
					tmpxml.appendChild(<url>{tmpstr.slice(t+5)}</url>);
				}else if ((t=tmpstr.indexOf("[html]"))!=-1) {
					tmpxml.appendChild(<html>{tmpstr.slice(t+6)}</html>);
				}else{
					tmpstr=(xml.normalize()).toString();
					tmpstr=tmpstr.split(/>\s+/).join("> ");
					tmpstr=tmpstr.split(/\s+</).join(" <");
					tmpstr=tmpstr.split(/>\s+</).join("><");
					trace(tmpstr);
					tmpxml.appendChild(<text>{tmpstr}</text>);
				}
			}
			trace(tmpxml,"\n");
			res.appendChild(tmpxml);
			return res;
		}
	}
}