package IgemPartAPI
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	
	public class IgemAPI extends URLLoader
	{
		
		public var part_id:String;
		public var part_name:String;
		public var part_desc:String;
		public var part_type:String;
		public var part_url:String;
		public var part_sequence:String;
		public var part_twins:String;
		public var categories:String;
		
		public var text:String
		
			
		public function IgemAPI(str:String)
		{
			var url:URLRequest=new URLRequest("http://parts.igem.org/cgi/xml/part.cgi?part="+str);
			super(url);
			addEventListener(Event.COMPLETE,showdata);
			
			
		}
		
		public function search(str:String):void
		{
			var url:URLRequest=new URLRequest("http://parts.igem.org/cgi/xml/part.cgi?part="+str);
			super.load(url);
			addEventListener(Event.COMPLETE,showdata);
		}
		
		
		protected function showdata(event:Event):void
		{
			var resXML:XML=XML(data);
			
			
			part_id=resXML.part_list.part.part_id;
			part_name=resXML.part_list.part.part_name;
			part_desc=resXML.part_list.part.part_short_desc;
			part_type=resXML.part_list.part.part_type;
			part_url='<font color="#0000ff"><u><a href="'+resXML.part_list.part.part_url+'">'+resXML.part_list.part.part_url+"</a></u></font>"
			part_sequence=resXML.part_list.part.sequences.seq_data;
			var tmpXML:XMLList=resXML.part_list.part.twins.children();
			part_twins="";
			for each (var n:XML in tmpXML) 
			{
				part_twins+=n+"\n"
			}
			categories=resXML.part_list.part.categories.categorie;


			
			
		/*	var gui:IgemGUI;
			
			if(gui==null){
				gui=new IgemGUI(600);
				gui.iconField=text;
				//gui.Height=800;
				var scroll:Scroll=new Scroll(gui,600,400);
				FrontCoverSpace.addChild(scroll);
				scroll.x=50;
				scroll.y=100;
				scroll.setSize(600,400);
			}
			else{
				FrontCoverSpace.removeChild(scroll);
				gui=new IgemGUI(600);
				gui.iconField=text;
				
				var scroll:Scroll=new Scroll(gui,600,400);
				scroll.x=50;
				scroll.y=100;
				FrontCoverSpace.addChild(scroll);
				scroll.setSize(600,400);
			}*/
		}
	}
}