package Assembly.ProjectHolder{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import Ask.Asker;
	
	import Assembly.Canvas.I3DPlate;
	import Assembly.Canvas.Net;
	import Assembly.Compressor.CompressedLine;
	import Assembly.Compressor.CompressedNode;
	import Assembly.ExpandThread.ExpandManager;
	
	import FunctionPanel.PerspectiveViewer;
	
	import Layout.Sorpotions.Navigator;
	
	import Style.TweenX;
	
	
	public class GxmlContainer extends I3DPlate{
		
		
		public static var Block_space:Array=new Array();
		public static var Linker_space:Array=new Array();
		
		public static var Loader_space:Array=new Array();
		
		public static var ProjectName:String="USTCsoftware";
		
		public static var GXMLVersion:int=1;
		
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
				loadXMLNet(XML(String(currentProject.data)));
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
					loadXMLNet(XML(String(FileHolder.revertFile())));
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
				<Net NetName={ProjectName} Version={GXMLVersion}>
				</Net>;
			blockxml=
				<Blocks></Blocks>;
			linkxml=
				<Links></Links>;
			for each (var tar:CompressedNode in Block_space) {
				blockxml.appendChild(
					<Block id={tar.ID}>
						<refID>{tar.refID}</refID>
						<NAME>{tar.Name}</NAME>
						<TYPE>{tar.Type.Type}</TYPE>
						<x>{tar.remPosition[0]}</x>
						<y>{tar.remPosition[1]}</y>
						<detail>{tar.detail}</detail>
					</Block>
				);
			}
			for each (var line:CompressedLine in Linker_space) {
				linkxml.appendChild(
					<Linkage id={line.ID}>
						<refID>{tar.refID}</refID>
						<Name>{line.Name}</Name>
						<start>{line.linkObject[0].ID}</start>
						<end>{line.linkObject[1].ID}</end>
						<TYPE>{line.Type.Type}</TYPE>
						<detail>{line.detail}</detail>
					</Linkage>
				);
			}
			Gxml.appendChild(blockxml);
			Gxml.appendChild(linkxml);
			return Gxml;
		}
		
		private static function loadXMLNet(Gxml:XML):void {
			Net.restore();
			var blocks:XMLList=Gxml.child("Blocks").children();
			var links:XMLList=Gxml.child("Links").children();
			var i:int=0;
			for each(var block:XML in  blocks){
				Net.loadCompressedBlock(block.@id,block.refID,block.NAME,block.x,block.y,block.TYPE,block.detail);
				i++;
			}
			trace(i,"Nodes Loaded");
			i=0;
			for each(var linkage:XML in  links){
				i++;
				if(linkage.hasOwnProperty("Name")){
					Net.loadLink(linkage.@id,linkage.refID,linkage.Name,Block_space[linkage.start],Block_space[linkage.end],linkage.TYPE,linkage.detail);
				}else{
					Net.loadLink(linkage.@id,linkage.refID,LinkTypeInit.LinkTypeList[linkage.TYPE].label,Block_space[linkage.start],Block_space[linkage.end],linkage.TYPE,linkage.detail);
				}
			}
			trace(i,"Links Loaded");
			
			Net.toCenterPosition();
			
			PerspectiveViewer.refreshPerspective();
			
			Navigator.refreshMap();
			
		}
		
		public static function loadJsonNet(Gjson:String):void {
			Net.restore();
			
			var Gobj:Object=JSON.parse(Gjson);
			
			var nodes:Array=Gobj.node;
			var lines:Array=Gobj.link;
			
			
			for each(var node:Object in  nodes){
				Net.loadCompressedBlock(node._id,node.ref_id,node.NAME,node.x,node.y,node.TYPE);
			}
			
			
			for each(var line:Object in  lines){
				Net.loadLink(line._id,line.NAME,line.ref_id,Block_space[line.id1],Block_space[line.id2],line.TYPE,line.detail);
			}
			
			Net.toCenterPosition();
			
			PerspectiveViewer.refreshPerspective();
			
			Navigator.refreshMap();
			
		}
	}
}