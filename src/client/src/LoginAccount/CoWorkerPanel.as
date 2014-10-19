package LoginAccount
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import Assembly.ProjectHolder.ProjectManager;
	import Assembly.ProjectHolder.WorkerInfo;
	
	import GUI.FlexibleLayoutObject;
	import GUI.Assembly.ContainerBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.SkinBox;
	import GUI.Assembly.SkinTextField;
	import GUI.Assembly.TextInput;
	import GUI.Scroll.Scroll;
	
	import Layout.ReminderManager;
	
	
	
	public class CoWorkerPanel extends Sprite implements FlexibleLayoutObject{
		
		private var Align:int=5;
		
		private var back:SkinBox=new SkinBox();
		private var back2:SkinBox=new SkinBox();
		
		private var workerSpace:Array=[];
		private var scroller:ContainerBox=new ContainerBox();
		private var scroller2:ContainerBox=new ContainerBox();
		private var scroll:Scroll=new Scroll(scroller);
		private var scroll2:Scroll=new Scroll(scroller2);
		
		private var hint2:LabelTextField=new LabelTextField("Find your Colleague:");
		private var hint:LabelTextField=new LabelTextField("Current Colleague:");
		private var hint3:SkinTextField=new SkinTextField("You can add colleagues to build a project together, thus they will get most of the authorities including adding, deleting, modifing an object. But they will not be able to delete or rename this project or edit this page.");
		
		public var Width:Number;
		public var Height:Number;
		
		private var searchBox:TextInput=new TextInput(true);
		private var HalfWidth:Number;
		
		public function CoWorkerPanel(){		
			
			addChild(hint2);
			addChild(searchBox);
			addChild(back2);
			addChild(scroll2);
			
			addChild(hint)
			addChild(back);
			addChild(scroll);
			
			addChild(hint3);
			
			setSize(550,300);
			
			searchBox.hintText="Type your Colleague's name"
			
			searchBox.addEventListener(Event.CHANGE,search);
			
			
			flushWorkerList();
		}
		
		
		public function flushWorkerList():void{
			
			workerSpace=[];
			for(var i:int=0;i<ProjectManager.co_works.length;i++){
				var worker:WorkerInfo=ProjectManager.co_works[i]
				var cw:CoWorkerInfo=new CoWorkerInfo(CoWorkerInfo.INFO_REMOVE,worker)
				workerSpace.push(cw);
				
				cw.addEventListener("clicked",function (e):void{
					removecoworker(e.target.workerinfo);
				});
			}
			
			redraw();
		}
		
		private function search(e):void{
			
			var urlV:URLVariables=new URLVariables();
			urlV.name=searchBox.text;
			
			var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_SEARCH_USER);
			urequest.method="post";
			urequest.data=urlV;
			
			var loader:AuthorizedURLLoader=new AuthorizedURLLoader();
			loader.load(urequest);
			
			loader.addEventListener(Event.COMPLETE,searchRes);
		}
		
		public function addcoworker(worker:WorkerInfo):void{
			
			var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_USER+worker.ID+"/");
			urequest.method="post";
			
			var loader:AuthorizedURLLoader=new AuthorizedURLLoader();
			loader.load(urequest);
			
			loader.addEventListener(Event.COMPLETE,function (e):void{
				for (var j:int = 0; j < ProjectManager.co_works.length; j++) {
					if((ProjectManager.co_works[j] as WorkerInfo).ID==worker.ID){
						ReminderManager.remind("Co-worker already exist");
						return;
					}	
				}
				ProjectManager.co_works.push(worker);
				
				flushWorkerList();
				
				scroll.rollToButtom();
			});
		}
		
		public function removecoworker(worker:WorkerInfo):void{
			
			var urequest:URLRequest=new URLRequest(GlobalVaribles.PROJECT_USER+worker.ID+"/");
			urequest.method=URLRequestMethod.DELETE;
			
			var loader:AuthorizedURLLoader=new AuthorizedURLLoader();
			loader.load(urequest);
			
			loader.addEventListener(Event.COMPLETE,function (e):void{
				if(loader.data.indexOf("success")!=-1){
					for (var i:int = 0; i < ProjectManager.co_works.length; i++) 
					{
						if(ProjectManager.co_works[i]==worker){
							ProjectManager.co_works.splice(i,1);
							flushWorkerList();
							ReminderManager.remind("Delete Success");
							return;
						}
					}
				}else{
					ReminderManager.remind("Delete Failed");
				}
			});
		}
		
		public function searchRes(e):void{
			
			var rawRes:Array=JSON.parse(e.target.data).results;
			
			scroller2.removeChildren();
			
			for (var i:int = 0; i < rawRes.length; i++){
				var cw:CoWorkerInfo=new CoWorkerInfo(CoWorkerInfo.INFO_ADD,new WorkerInfo(rawRes[i].username,rawRes[i].id,new BitmapData(10,10)));
				
				cw.addEventListener("clicked",function (e):void{
					
					for (var j:int = 0; j < ProjectManager.co_works.length; j++) {
						if((ProjectManager.co_works[j] as WorkerInfo).ID==e.target.workerinfo.ID){
							ReminderManager.remind("Co-worker already exist");
							return;
						}	
					}
					addcoworker(e.target.workerinfo);
				});
				
				cw.x=Align;
				
				cw.y=i*65+5;
				
				cw.setSize(Width/2-12);
				
				scroller2.addChild(cw);
				
			}
			scroll2.negativeRedraw();
		}
		
		private function redraw():void
		{
			scroller.removeChildren();
			for (var i:int = 0; i < workerSpace.length; i++) {
				
				workerSpace[i].x=Align;
				
				workerSpace[i].y=i*65+5;
				
				workerSpace[i].setSize(Width/2-14);
				
				scroller.addChild(workerSpace[i]);
				
			}
			
			scroller.setSize(HalfWidth,workerSpace.length*65+5);
			scroll.negativeRedraw();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			
			
			Height=h;
			Width=w;
			
			HalfWidth=Width/2-4;
			
			back2.setSize(HalfWidth,h-55);
			scroll2.setSize(HalfWidth,h-55);
			
			searchBox.setSize(HalfWidth,26);
			
			searchBox.y=25;
			
			back2.y=55;
			scroll2.y=55;
			
			back.setSize(HalfWidth,h-25);
			scroll.setSize(HalfWidth,h-25);
			
			hint.x=back.x=scroll.x=Width/2+2;
			back.y=scroll.y=25;
			
			hint3.setSize(w);
			
			hint3.y=Height;
			
			Height+=hint3.height;
			
			redraw();
			
		}
		
	}
}

