package Assembly.ProjectHolder{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import Ask.AskBar;
	import Ask.Asker;
	
	import IEvent.ExpandEvent;
	
	import Layout.Sorpotions.Navigator;
	import FunctionPanel.PerspectiveViewer;
	
	import Assembly.ExpandThread.ExpandLayout;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ExpandThread.ExpandManager;
	
	import Style.TweenX;
	import Assembly.ExpandThread.ExpandBranch;
	import Assembly.Canvas.I3DPlate;
	import Assembly.Canvas.Net;
	
	
	public class GxmlContainer extends I3DPlate{
		
		
		public static var Block_space:Array=new Array();
		public static var Linker_space:Array=new Array();
		
		public static var Loader_space:Array=new Array();
		
		public static var ProjectName:String="USTCsoftware";
		
		public static var GXMLVersion:int=1
		
		public static var currentProject:File;
		
		public static var FileListener:EventDispatcher=new EventDispatcher;
		
		
		include"Gxml_StepRecorder.as"
		
		////ver 0.2 MultiThread
		
		new ExpandManager();
		
		public function GxmlContainer(){
			
			FileHolder.New();
			
		}
		
		public static function New(e=null):void{
			
			if(modified){
				Asker.ask("Do you want to save your current project?",function ():void{
					FileHolder.save(saveCotent(),toNew);
				},toNew);
			}else{
				toNew();
			}
		}
		
		private static function toNew():void{
			FileHolder.New();
			
			Net.restore();
			
			RestoreRecord();
		}
		
		
		public static function search(t:String):Array{
			var db:Array=[]
			
			if (t.length>0) {
				for each (var node:CompressedNode in Block_space) {
					if (node.Name.toLowerCase().indexOf(t.toLowerCase())!=-1) {
						db.push({label:node.Name,Item:node});
					}
				}
			}
			return db;
		}
		
		public static function Open(e=null):void{
			
			if(modified){
				Asker.ask("Do you want to save your current project?",function ():void{
					FileHolder.save(saveCotent(),toOpen);
				},toOpen);
			}else{
				toOpen();
			}
			
		}
		
		public static function toOpen():void{
			
			currentProject=FileHolder.open("Open Project",[new FileFilter("xml文件","*.xml")]);
			currentProject.addEventListener(Event.COMPLETE,function (e):void{
				trace("Loading...");
				loadNet(XML(String(currentProject.data)));
				RestoreRecord();
			},false,0);
		}
		
		public static function Save(e=null):void{
			if(modified){
				FileHolder.save(saveCotent(),saveComplete);
			}
		}
		
		public static function SaveAs(e=null):void{
			FileHolder.saveAs(saveCotent(),saveComplete);
			
		}
		
		public static function saveComplete():void{
			saveStep=currentStep;
		}
		
		public static function Revert(e=null):void{
			if(currentStep!=0){
				Asker.ask("Your project will return to the original status and you will not be able to undo this operation, are you sure?",function ():void{
					loadNet(XML(String(FileHolder.revertFile())));
					RestoreRecord();
				},function ():void{},false);
			}
		}
		
		
		
		private static function saveCotent():XML{
			var Gxml:XML=new XML();
			var blockxml:XML=new XML();
			var tmpxml:XML=new XML();
			var linkxml:XML=new XML();
			Gxml=
				<Net NetName={ProjectName} Verson={GXMLVersion}>
				</Net>;
			blockxml=
				<Blocks></Blocks>;
			linkxml=
				<Links></Links>;
			for each (var tar:CompressedNode in Block_space) {
				blockxml.appendChild(mergeBlock(tar));
			}
			for each (var line:CompressedLine in Linker_space) {
				linkxml.appendChild(mergeLine(line));
			}
			Gxml.appendChild(blockxml);
			Gxml.appendChild(linkxml);
			return Gxml;
		}
		
		public static function mergeBlock(tar:CompressedNode):XML{
			var tmpxml:XML=
				<Block id={tar.ID}>
					<NAME>{tar.Name}</NAME>
					<TYPE>{tar.Type.Type}</TYPE>
					<x>{tar.remPosition[0]}</x>
					<y>{tar.remPosition[1]}</y>
				</Block>;
			if (tar.detail!=null) {
				tmpxml.appendChild(<detail>{tar.detail}</detail>);
			}
			return tmpxml;
		}
		
		private static function mergeLine(line:CompressedLine):XML{
			var tmpxml:XML=
				<Linkage id={line.ID}>
					<Name>{line.Name}</Name>
					<start>{line.linkObject[0].ID}</start>
					<end>{line.linkObject[1].ID}</end>
					<TYPE>{line.Type.Type}</TYPE>
					<Direc>{int(line.DoubleDirec)}</Direc>
				</Linkage>
			return tmpxml;
		}
		
		private static function loadNet(Gxml:XML):void {
			Net.restore();
			var blocks:XMLList=Gxml.child("Blocks").children();
			var links:XMLList=Gxml.child("Links").children();
			var Item:Array=new Array();
			var i:int=0;
			for each(var block:XML in  blocks){
				Item[i]=[];
				Item[i][0]=Net.loadCompressedBlock(block.@id,block.NAME,block.x,block.y,block.TYPE,block.detail);
				Item[i][1]=block.Father;
				i++;
			}
			trace(i,"Nodes Loaded");
			i=0;
			for each(var linkage:XML in  links){
				i++;
				if(linkage.hasOwnProperty("Name")){
					Net.loadLink(linkage.@id,linkage.Name,Block_space[linkage.start],Block_space[linkage.end],linkage.TYPE,Boolean(int(linkage.Direc)));
				}else{
					Net.loadLink(linkage.@id,LinkTypeInit.LinkTypeList[linkage.TYPE].label,Block_space[linkage.start],Block_space[linkage.end],linkage.TYPE,Boolean(int(linkage.Direc)));
				}
			}
			trace(i,"Links Loaded");
			
			
			Navigator.refreshMap();
			
			PerspectiveViewer.refreshPerspective();
			
		}
		
		public static function Post(tar):void{
			var xml:XML=new XML();
			var address:String;
			if (tar.constructor==CompressedNode) {
				address=GlobalVaribles.NODE_INTERFACE;
				xml=mergeBlock(tar);
			}else {
				address=GlobalVaribles.LINK_INTERFACE;
				xml=mergeLine(tar);
			}
			var posturl:URLRequest=new URLRequest(address);
			var postvar:URLVariables=new URLVariables();
			postvar.zhaosensen=xml.toXMLString();
			posturl.method="post";
			posturl.data=postvar;
			var urlloader:URLLoader=new URLLoader();
			urlloader.load(posturl);
			urlloader.addEventListener(Event.COMPLETE,function (e):void{
				delete Block_space[tar.ID];
				tar.ID=String(urlloader.data);
				Block_space[tar.ID]=tar;
				trace("getID:",tar.ID);
				if (tar.modified) {
					PostManager.post(address+"_id/"+tar.ID+"/detail/",tar.detail);
				}
			})
		}
		
		
		///////Expand
		public static function Expand(target:CompressedNode):void{
			var receiver:EventDispatcher=ExpandManager.Expand(target);
			receiver.addEventListener(ExpandEvent.EXPAND_COMPLETE,function (e:ExpandEvent):void{
				if(e.ExpandList.length>0){
					trace("[Main]:Now Explode");
					Explode(e.ExpandTarget,e.ExpandList);
				}
			});
			
		}
		
		
		public static function PreExpand(target:CompressedNode):void{
			var receiver:EventDispatcher=ExpandManager.Expand(target);
			receiver.addEventListener(ExpandEvent.EXPAND_COMPLETE,function (e:ExpandEvent):void{
				if(e.ExpandList.length>0){
					
					var hasAutoline:Boolean=false;
					trace("[Main]:PreExpandReceive");
					for each (var branch:ExpandBranch in e.ExpandList) {
						
						if(Block_space[branch.node_id]!=null){
							if(branch.DIRECT==0){
								Net.loadLink(branch.link_id,branch.LinkType,Block_space[branch.node_id],branch.father,branch.LinkType);
							}else{
								Net.loadLink(branch.link_id,branch.LinkType,branch.father,Block_space[branch.node_id],branch.LinkType);
							}
							hasAutoline=true;
						}
					}
					
					if(hasAutoline){
						Navigator.refreshMap();
						PerspectiveViewer.refreshPerspective();
						//recordStep();
					}
				}
			});
		}
		private static var explodeArray:Array=[];
		private static var explodeManager:Sprite=new Sprite();
		
		public static function Explode(tar,branches):void{
			
			var c:int=0
			var r0:Number=tar.centerRadius;
			var n0:int=int(r0*2*Math.PI/60);
			if (n0>branches.length) {
				n0=branches.length;
			}
			var dceta:Number=(Math.PI*2)/n0;
			var sa:Number=ExpandLayout.Arrange(n0);
			
			for (var i:int = 0; i < branches.length; i++) {
				
				if (c==n0) {
					c=0;
					r0=r0+80;
					n0=int(r0*2*Math.PI/60);
					if (n0>branches.length-i) {
						n0=branches.length-i
					}
					dceta=(Math.PI*2)/n0;
					sa=ExpandLayout.Arrange(n0);
				}
				branches[i].aimx=tar.Position[0]+r0*(Math.cos(dceta*c+sa));
				branches[i].aimy=tar.Position[1]+r0*(Math.sin(dceta*c+sa));
				c++;
			}
			
			explodeArray=explodeArray.concat(branches);
			
			if(!explodeManager.hasEventListener(Event.ENTER_FRAME)){
				explodeManager.addEventListener(Event.ENTER_FRAME,buffer);
			}
			
		}
		private static function buffer(e):void{
			
			var t:int=getTimer();
			var branch:ExpandBranch;
			var tar:CompressedNode;
			
			var tmpArr:Array=[];
			
			while(getTimer()-t<18&&explodeArray.length>0){
				branch=explodeArray.shift();
				
				
				if (GxmlContainer.Block_space[branch.node_id]==null) {
					
					tar=Net.loadBlock(branch.node_id,branch.NAME,branch.father.Position[0],branch.father.Position[1],branch.TYPE);
					tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);
					tmpArr.push(tar);
					trace("[main]:Create Node:",tar.Name);
				}else{
					tar=Block_space[branch.node_id];
					tar.remPosition[0]=tar.aimPosition[0]=branch.aimx;
					tar.remPosition[1]=tar.aimPosition[1]=branch.aimy;
					TweenX.GlideNode(tar);
					trace("[main]:Repeated Node:",tar.Name);
				}
				
				
				try{
					if(branch.DIRECT==0){
						Net.loadLink(branch.link_id,branch.LinkType,Block_space[branch.node_id],branch.father,branch.LinkType,false,true);
					}else{
						Net.loadLink(branch.link_id,branch.LinkType,branch.father,Block_space[branch.node_id],branch.LinkType,false,true);
					}
					trace("[main]:Create Link:",branch.link_id);
				}catch(error:Error) {
					trace("-----------------[Error @ main]:Fail to Create Link:",branch.link_id,branch.LinkType);
				}
				
			}
			
			RecordMultiNodeExistance(tmpArr,ADD_NODE);
			Navigator.refreshMap();
			PerspectiveViewer.refreshPerspective();
			if(explodeArray.length==0){
				explodeManager.removeEventListener(Event.ENTER_FRAME,buffer);
			}
			
		}
		
		private var ExpandList:Array=[];
		
		
		protected function expendlist(event:Event):void{
			
		}
		
		
	}
}