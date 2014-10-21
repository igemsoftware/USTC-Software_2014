package UserInterfaces.Dock{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import GUI.Assembly.LabelTextField;
	import GUI.ColorChooser.ColorChooser;
	import GUI.RichUI.RichButton;
	import GUI.Windows.WindowSpace;
	
	import UserInterfaces.GlobalLayout.BackGround;
	import UserInterfaces.GlobalLayout.GlobalLayoutManager;
	import UserInterfaces.GlobalLayout.LayoutManager;
	
	import Kernel.SmartCanvas.Canvas.FreePlate;
	import Kernel.SmartCanvas.Canvas.Net;
	
	import fl.controls.CheckBox;
	import fl.events.ColorPickerEvent;
	
	
	public class OptionPanel extends Sprite{
		
		private var backPIC:RichButton=new RichButton();
		private var backColor:ColorChooser=new ColorChooser();
		private var showFPS:CheckBox=new CheckBox();
		private var showIcon:CheckBox=new CheckBox();
		private var showGrid:CheckBox=new CheckBox();
		
		private var habitlabel:LabelTextField=new LabelTextField("Use which mouse button to drag:")
		private var leftbtn:RichButton=new RichButton(1);
		private var rightbtn:RichButton=new RichButton(2);
		
		public function OptionPanel(){
			
			leftbtn.label="Left";
			rightbtn.label="Right";
			
			LayoutManager.UnifyScale(80, 25, leftbtn, rightbtn);
			
			rightbtn.focused=!(leftbtn.focused=GlobalVaribles.LeftHabit);
			
			backPIC.setIcon(Icon_img);
			backPIC.setSize(50,32);
			
			showFPS.label="Show FPS"
			showFPS.selected=WindowSpace.contains(GlobalLayoutManager.fpsViewer);
			showFPS.width=150;
			
			showIcon.label="Show Node Icon"
			showIcon.selected=GlobalVaribles.showIconMap;
			showIcon.width=170;
			
			showGrid.label="Show Grid"
			showGrid.selected=FreePlate.grid.visible;
			showGrid.width=150;
			
			backColor.color=GlobalLayoutManager.BackGroundColor;
			
			LayoutManager.setHorizontalLayout(this,"left",0,0,10,new LabelTextField("Back Ground:"));
			LayoutManager.setHorizontalLayout(this,"left",0,40,10,new LabelTextField("picture:"),backPIC,new LabelTextField("color:"),backColor);
			LayoutManager.setHorizontalLayout(this,"left",0,80,10,showFPS);
			LayoutManager.setHorizontalLayout(this,"left",0,120,10,showGrid);
			LayoutManager.setHorizontalLayout(this,"left",0,160,10,showIcon);
			LayoutManager.setHorizontalLayout(this,"left",0,200,0,habitlabel);
			LayoutManager.setHorizontalLayout(this,"left",5,230,0,leftbtn,rightbtn);
			
			backColor.addEventListener(ColorPickerEvent.CHANGE,function (e:ColorPickerEvent):void{
				GlobalLayoutManager.BackGroundColor=e.color;
				BackGround.color=e.color;
			})
				
			backPIC.addEventListener(MouseEvent.CLICK,function (e):void{
				BackGround.SetBackGroundPic();
			})
			showFPS.addEventListener(Event.CHANGE,function (e):void{
				if (e.target.selected) {
					WindowSpace.addWindow(GlobalLayoutManager.fpsViewer);
				}else {
					WindowSpace.removeWindow(GlobalLayoutManager.fpsViewer);
				}
			});
			showIcon.addEventListener(Event.CHANGE,function (e):void{
				GlobalVaribles.showIconMap=showIcon.selected;
				Net.ShapeRedraw();
			})
				
			showGrid.addEventListener(Event.CHANGE,function (e):void{
				FreePlate.grid.visible=e.target.selected;
			})
				
			leftbtn.addEventListener(MouseEvent.CLICK,function (e):void{
				GlobalVaribles.LeftHabit=true;
				leftbtn.focused=true;
				rightbtn.focused=false;
				Net.setHabit();
			});
			
			rightbtn.addEventListener(MouseEvent.CLICK,function (e):void{
				GlobalVaribles.LeftHabit=false;
				leftbtn.focused=false;
				rightbtn.focused=true;
				Net.setHabit();
			});
		}
	}
}