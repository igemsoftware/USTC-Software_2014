package FunctionPanel
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.RichUI.RichButton;
	import GUI.Scroll.Scroll;
	import GUI.Windows.FreeWindow;
	import GUI.Windows.WindowSpace;
	
	import Layout.LayoutManager;
	import Layout.ReminderManager;
	
	import Style.Tween;
	
	public class WindowsDispatcher
	{
		new WindowSpace();
		
		private static var WindowList:Array=[];
		
		
		private static var TmpTarget:*
		public static function LaunchXMLSheet(tar,editable=false):void{
			TmpTarget=tar;
			if (TmpTarget.detail==null) {
				var loader:URLLoader=new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE,function (event):void{LaunchJSONContent(String(event.target.data),editable,tar)})
				loader.load(new URLRequest(tar.ContentURL));
			}else{
				LaunchJSONContent(TmpTarget.detail,true,TmpTarget);
			}
		}
		
		public static function LaunchJSONContent(json,editable,node:CompressedNode):void{
			
			if(WindowList[node.ID]==null){
				var c:ContextSheet=JSONContentFetcher.fetch(node.detail);
				var scroll:Scroll=new Scroll(c);
				WindowList[node.ID]=new FreeWindow(node.Name,scroll);
				WindowList[node.ID].addEventListener("destory",function (e):void{
					WindowList[node.ID]=null;
				});
				
				if (editable) {
					var ok_b:RichButton=new RichButton();
					var cancel_b:RichButton=new RichButton();
					var edit:RichButton=new RichButton();
					var editPanel:ContentEditPanel=new ContentEditPanel(node);
					edit.setIcon(Icon_editx);
					
					ok_b.setIcon(Icon_apply);
					
					cancel_b.setIcon(Icon_cancel);
					
					LayoutManager.UnifyScale(30,30,edit,ok_b,cancel_b);
					
					
					edit.addEventListener(MouseEvent.CLICK,function (e):void{
						
						editPanel.setContent();
						var scroll:Scroll=new Scroll(editPanel);
						WindowList[node.ID].setContent(scroll);
						WindowList[node.ID].ButtonField=[ok_b,cancel_b];
					})
					ok_b.addEventListener(MouseEvent.CLICK,function (e):void{
						node.modified=true;
						
						GxmlContainer.RecordNodeDetail(node);
						
						node.detail=editPanel.json;
						
						ReminderManager.remind("Detail Saved");
						
						trace("saveJson",node.detail);
						var c:ContextSheet=JSONContentFetcher.fetch(node.detail);
						var scroll:Scroll=new Scroll(c);
						WindowList[node.ID].setContent(scroll);
						WindowList[node.ID].ButtonField=[edit];
					})
					cancel_b.addEventListener(MouseEvent.CLICK,function (e):void{
						WindowList[node.ID].setContent(scroll);
						WindowList[node.ID].ButtonField=[edit];
					})
					WindowList[node.ID].ButtonField=[edit];
				}
				WindowSpace.addWindow(WindowList[node.ID],function (e):void{Tween.CloseWindowToNet(WindowList[node.ID],node.x,node.y,node.skindata.radius,node.skindata.radius)});
				Tween.DeployWindowFromNet(WindowList[node.ID],node.x,node.y,node.skindata.radius,node.skindata.radius);
			}
		}
	}
}