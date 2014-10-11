package GUI.Scroll
{
	import flash.display.Sprite;

	public class ScrollPane extends Sprite
	{
		
		public var container:Sprite=new Sprite();
		public var scroll:Scroll;
		
		public function ScrollPane(w,h);
		{
			
		}
		
		
		public function AddChild(tar):void{
			
			container.addChild(tar);
		}
	}
}