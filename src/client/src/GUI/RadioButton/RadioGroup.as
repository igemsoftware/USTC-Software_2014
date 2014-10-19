package GUI.RadioButton
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class RadioGroup extends EventDispatcher
	{
		public var SelectedMember:*
			
		public function RadioGroup()
		{
		}
		public function setSelection(member):void{
			if (member!=SelectedMember) {
				if (SelectedMember!=null) {
					SelectedMember.selected=false;
				}
				dispatchEvent(new Event(Event.CHANGE));
				SelectedMember=member;
			}
		}
	}
}