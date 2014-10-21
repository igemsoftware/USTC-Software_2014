package Kernel.ProjectHolder{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import Kernel.ExpandThread.ExpandManager;
	import Kernel.SmartCanvas.CompressedLine;
	import Kernel.SmartCanvas.CompressedNode;
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import UserInterfaces.AskManager.AskManager;
	import UserInterfaces.FunctionPanel.PerspectiveViewer;
	import UserInterfaces.IvyBoard.IvyPanels.ProjectDetailPanel;
	import UserInterfaces.Sorpotions.Navigator;
	import UserInterfaces.Style.TweenX;
	
	
	public class GxmlContainer extends Sprite{
		
		
		public static var Node_Space:Array=new Array();
		public static var Link_Space:Array=new Array();
		
		public static var GXMLVersion:int=2;
		
		private static var restoreData:Object={Type:"New"};
		
		public static var FileListener:EventDispatcher=new EventDispatcher;
		
		
		include"Gxml_StepRecorder.as"
		
		////ver 0.2 MultiThread
		
		new ExpandManager();
		
		public function GxmlContainer(){
			
			FileHolder.New();
			
		}
		
		public static function New(e=null):void{
			
			if(modified){
				AskManager.ask("Do you want to save your current project?",function ():void{
					FileHolder.save(saveCotent(),toNew);
				},toNew);
			}else{
				toNew();
			}
		}
		
		private static function toNew():void{
			FileHolder.New();
			
			ProjectManager.New();
			
			restoreData={Type:"New"};
			
			Net.restore();
			
			RestoreRecord();
		}
		
		
		public static function search(t:String):Array{
			var db:Array=[]
			
			if (t.length>0) {
				for each (var node:CompressedNode in Node_Space) {
					if (node.Name.toLowerCase().indexOf(t.toLowerCase())!=-1) {
						db.push({label:node.Name,Item:node});
					}
				}
			}
			return db;
		}
		
		public static function Open(e=null):void{
			
			if(modified){
				AskManager.ask("Do you want to save your current project?",function ():void{
					FileHolder.save(saveCotent(),toOpen);
				},toOpen);
			}else{
				toOpen();
			}
			
		}
		
		public static function toOpen():void{
			
			ProjectManager.New();
			
			var currentProject:File=FileHolder.open("Open Project",[new FileFilter("xml文件","*.xml")]);
			currentProject.addEventListener(Event.COMPLETE,function (e):void{
				trace("Loading...");
				loadXMLNet(XML(String(e.target.data)));
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
			if(currentStep!=0&&restoreData!=null){
				AskManager.ask("Your project will return to the original status which can not be undone, are you sure?",function ():void{
					
					if(restoreData.Type=="New"){
						Net.restore();
					}else if(restoreData.Type=="XML"){
						loadXMLNet(restoreData.Net);
					}else{
						loadJsonNet(restoreData.Net);
					}
					
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
				<Net Version={GXMLVersion}>
					<Project>
						<ProjectName>{ProjectManager.ProjectName}</ProjectName>
						<ProjectID>{ProjectManager.ProjectID}</ProjectID>
						<species>{ProjectManager.species}</species>
						<describe>{ProjectManager.describe}</describe>
					</Project>
				</Net>;
			blockxml=
				<Blocks></Blocks>;
			linkxml=
				<Links></Links>;
			for each (var tar:CompressedNode in Node_Space) {
				blockxml.appendChild(
					<Block id={tar.ID}>
						<refID>{tar.refID}</refID>
						<NAME>{tar.Name}</NAME>
						<TYPE>{tar.Type.Type}</TYPE>
						<x>{tar.remPosition[0]}</x>
						<y>{tar.remPosition[1]}</y>
						<detail>{JSON.stringify(tar.detail)}</detail>
					</Block>
				);
			}
			for each (var line:CompressedLine in Link_Space) {
				linkxml.appendChild(
					<Linkage id={line.ID}>
						<refID>{tar.refID}</refID>
						<Name>{line.Name}</Name>
						<start>{line.linkObject[0].ID}</start>
						<end>{line.linkObject[1].ID}</end>
						<TYPE>{line.Type.Type}</TYPE>
						<detail>{JSON.stringify(line.detail)}</detail>
					</Linkage>
				);
			}
			Gxml.appendChild(blockxml);
			Gxml.appendChild(linkxml);
			return Gxml;
		}
		
		private static function loadXMLNet(Gxml:XML):void {
			Net.restore();
			
			restoreData={Type:"XML",Net:Gxml}
			
			var project:XMLList=Gxml.Project;
			var blocks:XMLList=Gxml.child("Blocks").children();
			var links:XMLList=Gxml.child("Links").children();
			var i:int=0;
			
			ProjectManager.ProjectName=project.ProjectName;
			if(String(project.ProjectID).length!=24){
				ProjectManager.ProjectID=project.ProjectID;
			}else{
				ProjectManager.ProjectID="";
			}
			ProjectManager.species=project.species;
			ProjectManager.describe=project.describe;
			
			ProjectDetailPanel.refreshDetail();
			
			for each(var block:XML in  blocks){
				Net.loadCompressedBlock(block.@id,block.refID,block.NAME,block.x,block.y,block.TYPE,block.detail);
				i++;
			}
			trace(i,"Nodes Loaded");
			i=0;
			for each(var linkage:XML in  links){
				i++;
				if(linkage.hasOwnProperty("Name")){
					Net.loadLink(linkage.@id,linkage.refID,linkage.Name,Node_Space[linkage.start],Node_Space[linkage.end],linkage.TYPE,linkage.detail);
				}else{
					Net.loadLink(linkage.@id,linkage.refID,LinkTypeInit.LinkTypeList[linkage.TYPE].label,Node_Space[linkage.start],Node_Space[linkage.end],linkage.TYPE,linkage.detail);
				}
			}
			trace(i,"Links Loaded");
			
			Net.toCenterPosition();
			
			PerspectiveViewer.refreshPerspective();
			
			Navigator.refreshMap();
			
		}
		
		public static function loadJsonNet(Gjson:String):void {
			Net.restore();
			
			restoreData={Type:"JSON",Net:Gjson}
			
			var Gobj:Object=JSON.parse(Gjson);
			
			var nodes:Array=Gobj.node;
			var lines:Array=Gobj.link;
			
			
			for each(var node:Object in  nodes){
				Net.loadCompressedBlock(node._id,node.ref_id,node.NAME,node.x,node.y,node.TYPE);
			}
			
			
			for each(var line:Object in  lines){
				Net.loadLink(line._id,line.ref_id,line.NAME,Node_Space[line.id1],Node_Space[line.id2],line.TYPE);
			}
			
			Net.toCenterPosition();
			
			PerspectiveViewer.refreshPerspective();
			
			Navigator.refreshMap();
			
		}
	}
}