package IgemPartAPI
{
	import flash.display.Sprite;
	
	import Biology.NodeTypeInit;
	import Biology.TypeEditor.NodeSample;
	
	import GUI.Assembly.LabelTextField;

	public class BlastResult extends Sprite
	{
		
		public var Name:String,Type:String,ID:String,evalue:String;
		public var Sample:NodeSample=new NodeSample();
		public var _text:LabelTextField=new LabelTextField("");
		
		public var evaT:LabelTextField=new LabelTextField("");
		
		public function BlastResult(nam:String,type:String,id:String,eva:String="")
		{
			Type=type;
			Name=nam;
			ID=id;
			Sample.showSample(NodeTypeInit.BiotypeList[type]);
			Sample.y=60;
			
			_text.text=nam;
			_text.y=90;
			_text.x=-_text.width/2;
			
			evaT.text=eva;
			evaT.y=0;
			evaT.x=-evaT.width/2;
			
			addChild(evaT);
			addChild(Sample);
			addChild(_text);
		}
	}
}