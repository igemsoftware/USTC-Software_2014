package Biology.Types
{

	import flash.display.Sprite;
	
	import NodeShape.Circle;
	
	public class SymbolType{	
		public static var LineTypes:Array=[
			{label: "straight", icon: LINE_CONCRETE,value:1},
			{label: "dashed1", icon: LINE_DASH,value:2},
			{label: "dashed2", icon: LINE_POINTS,value:3}
		];
		public static var ArrowTypes:Array=[
			{label: "type0", icon: Sprite,value:0},
			{label: "type1", icon: ARROW_1,value:1},
			{label: "type2", icon: ARROW_2,value:2},
			{label: "type3", icon: ARROW_3,value:3},
		];
		public static var NodeTypes:Array=[
			{label:"circle",icon:NodeShape.Circle,value:1},
			{label:"triangle",icon:NodeShape.Triangle,value:2},
			{label:"square",icon:NodeShape.Square,value:3},
			{label:"hexagon",icon:NodeShape.Hexagon,value:4},
			{label:"star",icon:NodeShape.Star,value:5},
			{label:"diamond",icon:NodeShape.Diamond,value:6},
			{label:"pentagon",icon:NodeShape.Pentagon,value:7},
			{label:"cross",icon:NodeShape.Cross,value:8},
		];
	}
}



