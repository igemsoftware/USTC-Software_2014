package FunctionPanel
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import Ask.Asker;
	
	import Assembly.Compressor.CompressedNode;
	import Assembly.ProjectHolder.GxmlContainer;
	
	import GUI.ContextSheet.ContextSheet;
	import GUI.RichUI.RichButton;
	import GUI.Scroll.Scroll;
	import GUI.Windows.FreeWindow;
	import GUI.Windows.WindowSpace;
	
	import Layout.LayoutManager;
	import Layout.ReminderManager;
	
	import LoginAccount.AuthorizeEvent;
	import LoginAccount.AuthorizedURLLoader;
	
	import Style.Tween;
	
	public class DetailDispatcher
	{
		
		private static var WindowList:Array=[];
		private static var DetailList:Object=new Object();
		
		public static function LauchDetail(tar):void{
			if(tar.detail==null||tar.detail==""){
				if(DetailList[tar.ID]==null){
					DetailList[tar.ID]=new AuthorizedURLLoader(new URLRequest(tar.ContentURL));
					DetailList[tar.ID].addEventListener(Event.COMPLETE,function (event):void{
						trace(event.target.data);
						tar.detail=String(event.target.data);
						DetailDispatcher.LaunchJSONContent(tar,true);
						ReminderManager.remind("loading detail from cloud");
					});
					DetailList[tar.ID].addEventListener(AuthorizeEvent.AUTHORIZE_FAILED,function (e):void{loadfailed(tar)});
					DetailList[tar.ID].addEventListener(IOErrorEvent.IO_ERROR,function (e):void{loadfailed(tar)});
				}else{
					ReminderManager.remind("is already loading detail");
				}
			}else{
				LaunchJSONContent(tar,true);		
			}
		}
		
		private static function loadfailed(tar):void{
			Asker.ask("Fail to load detail from online database, do you want to edit it yourself?",function ():void{
				tar.detail=JSON.stringify({
					NAME:tar.Name,
					TYPE:tar.Type.label,
					Description:"Fail to load detail from online database, click Edit to add your description."
				});
				DetailDispatcher.LaunchJSONContent(tar,true);
			},function ():void{
				delete DetailList[tar.ID];
			},false);
		}
		
		
		public static function LaunchJSONContent(tar:*,editable):void{
			
			//tar: CompressedLine/CompressNode
			
			if(WindowList[tar.ID]==null){
				var c:ContextSheet=JSONContentFetcher.fetch(tar);
				var scroll:Scroll=new Scroll(c);
				WindowList[tar.ID]=new FreeWindow(tar.Name,scroll);
				WindowList[tar.ID].addEventListener("destory",function (e):void{
					WindowList[tar.ID]=null;
				});
				
				if (editable) {
					var ok_b:RichButton=new RichButton();
					var cancel_b:RichButton=new RichButton();
					var edit:RichButton=new RichButton();
					var editPanel:ContentEditPanel=new ContentEditPanel(tar);
					edit.setIcon(Icon_editx);
					
					ok_b.setIcon(Icon_apply);
					
					cancel_b.setIcon(Icon_cancel);
					
					LayoutManager.UnifyScale(30,30,edit,ok_b,cancel_b);
					
					
					edit.addEventListener(MouseEvent.CLICK,function (e):void{
						
						editPanel.setContent();
						var scroll:Scroll=new Scroll(editPanel);
						WindowList[tar.ID].setContent(scroll);
						WindowList[tar.ID].ButtonField=[ok_b,cancel_b];
					})
					ok_b.addEventListener(MouseEvent.CLICK,function (e):void{
						tar.modified=true;
						
						if(tar.constructor==CompressedNode){
							GxmlContainer.RecordNodeDetail(tar);
						}else{
							GxmlContainer.RecordLineDetail(tar);
						}
						
						tar.detail=editPanel.json;
						
						ReminderManager.remind("Detail Saved");
						
						trace("saveJson",tar.detail);
						var c:ContextSheet=JSONContentFetcher.fetch(tar);
						var scroll:Scroll=new Scroll(c);
						WindowList[tar.ID].setContent(scroll);
						WindowList[tar.ID].ButtonField=[edit];
					})
					cancel_b.addEventListener(MouseEvent.CLICK,function (e):void{
						WindowList[tar.ID].setContent(scroll);
						WindowList[tar.ID].ButtonField=[edit];
					})
					WindowList[tar.ID].ButtonField=[edit];
				}				
				if(tar.constructor==CompressedNode){
					WindowSpace.addWindow(WindowList[tar.ID],function (e):void{Tween.CloseWindowToNet(WindowList[tar.ID],tar.x,tar.y,tar.skindata.radius,tar.skindata.radius)});
					
					Tween.DeployWindowFromNet(WindowList[tar.ID],tar.x,tar.y,tar.skindata.radius,tar.skindata.radius);
				}else{
					WindowSpace.addWindow(WindowList[tar.ID],function (e):void{Tween.CloseWindowToNet(WindowList[tar.ID],tar.x,tar.y,50,50)});
					
					Tween.DeployWindowFromNet(WindowList[tar.ID],tar.x,tar.y,50,50);
				}
			}
		}
	}
}