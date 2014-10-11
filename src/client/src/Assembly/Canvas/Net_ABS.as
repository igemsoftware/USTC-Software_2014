// ActionScript file
public var ABS_space:Array=new Array();

protected function hideABS_evt(e):void{
	if (ABS_space[e.target.num]!=null) {
		ABS_space[e.target.num].fadeOut();
	}
}
protected function destory_abs(e):void{
	//plate.removeChild(e.target);
}

protected function abs_evt(e):void{
	if (ABS_space[e.target.num]==null) {
		ABS_space[e.target.num]=new DirectPanel(e.target,e.target.title.text,"this is a test of <b>htmlText</b> support and <i>Direct Detail Pannel,</i> have fun.");
		ABS_space[e.target.num].addEventListener("destory",destory_abs);
	}else{
		ABS_space[e.target.num].title.text=e.target.title.text;
	}
	try {
		plate.removeChild(ABS_space[e.target.num]);
	}catch(e){}
	plate.addChild(ABS_space[e.target.num]);
	ABS_space[e.target.num].showUp();
}