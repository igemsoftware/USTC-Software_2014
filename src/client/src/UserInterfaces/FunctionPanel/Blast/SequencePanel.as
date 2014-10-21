package UserInterfaces.FunctionPanel.Blast
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	import GUI.Assembly.HitBox;
	import GUI.Assembly.LabelTextField;
	import GUI.Assembly.TextInput;
	import GUI.RichUI.RichButton;
	import Kernel.Assembly.CheckerURLLoader;
	
	
	
	
	public class SequencePanel extends Sprite
	{
		
		private var hitA:HitBox=new HitBox();
		public var sequence:TextInput=new TextInput(false,true);;
		
		
		private var post_bn:RichButton=new RichButton(0,60,30);
		
		private var seq_label:LabelTextField=new LabelTextField("Input DNA Sequence:");
		
		private var samp:MultiNodePreviewer=new MultiNodePreviewer();
		public var Height:Number;
		
		
		
		public function SequencePanel(){
			
			addChild(hitA);
			addChild(sequence);
			addChild(seq_label);
			addChild(post_bn);
			addChild(samp);
			
			
			post_bn.label="Blast";
			post_bn.setSize(60,30);
			
			post_bn.addEventListener(MouseEvent.CLICK,post);
			
			
			setSize(400,400);
		}
		
		protected function post(event:MouseEvent):void
		{
			post_bn.suspend();
			
			samp.clear();
			
			var handle:String=GlobalVaribles.SEQUENCE_INTERFACE;
			var searchRequest:URLRequest=new URLRequest(handle);
			
			var postvar:URLVariables=new URLVariables();
			
			postvar.sequence=sequence.text;
			
			searchRequest.method=URLRequestMethod.POST;
			searchRequest.data=postvar;
			
			var Loader:CheckerURLLoader=new CheckerURLLoader(searchRequest);
			
			Loader.addEventListener(Event.COMPLETE,shownode);
			
			Loader.addEventListener(IOErrorEvent.IO_ERROR,function (e):void{post_bn.unsuspend();});
		}
		
		protected function shownode(e:Event):void{
			var id:String;
			id=e.target.data;
			
			id='{"results":'+id.split("\'").join("\"")+"}";
			
			var result:Array=JSON.parse(id).results;
			
			samp.GiveNodes(result);
			
			post_bn.unsuspend();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			Height=h
			sequence.setSize(w,h-150);
			sequence.y=30;
			
			post_bn.y=-5;
			post_bn.x=w-60;
			
			hitA.setSize(w,h);
			
			samp.setSize(w);
			
			samp.y=h-115;
			
		}
		
	}
}


