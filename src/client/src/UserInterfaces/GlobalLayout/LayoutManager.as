package UserInterfaces.GlobalLayout{

	public class LayoutManager{
		public static const LAYOUT_ALIGN_LEFT:String="left";
		public static const LAYOUT_ALIGN_LEFT_STICK:String="left_stick";
		public static const LAYOUT_ALIGN_RIGHT:String="right";
		public static const LAYOUT_ALIGN_CENTER:String="center";
		public static const LAYOUT_ALIGN_STRICT:String="strict";
		public static const LAYOUT_ALIGN_TOP:String="top";
		
		public function LayoutManager(){
		}
		
		public static function setHorizontalLayout(tar,align,x,y,dw,...args):void{
			var currentW:Number=0;
			var i:int;
			switch(align)
			{
				case LAYOUT_ALIGN_LEFT:
				{
					for (i = 0; i < args.length; i++) {
						args[i].x=currentW+x;
						args[i].y=y;
						currentW+=args[i].width+dw;
						tar.addChild(args[i]);
					}
					break;
				}
				
				case LAYOUT_ALIGN_LEFT_STICK:
				{
					var w:int=args[0];
					for (i = 1; i < args.length; i++) {
						args[i].x=currentW+x;
						args[i].y=y;
						currentW+=args[i].width+dw;
						tar.addChild(args[i]);
					}
					args[args.length-1].setSize(w-args[args.length-1].x-dw,args[args.length-1].height);
					break;
				}
				
				case LAYOUT_ALIGN_RIGHT:
				{
					for (i = 0; i < args.length; i++) {
						currentW+=args[i].width+dw;
					}
					//currentW-=dw;
					x=x-currentW;
					currentW=0;
					for (i = 0; i < args.length; i++) {
						args[i].x=currentW+x;
						args[i].y=y;
						currentW+=args[i].width+dw;
						tar.addChild(args[i]);
					}
					break;
				}
				case LAYOUT_ALIGN_CENTER:
				{
					
					for (i = 0; i < args.length; i++) {
						currentW+=args[i].width+dw;
					}
					currentW-=dw;
					var x:Number=x-currentW/2;
					currentW=0;
					for (i = 0; i < args.length; i++) {
						args[i].x=currentW+x;
						args[i].y=y;
						currentW+=args[i].width+dw;
						tar.addChild(args[i]);
					}
					break;
				}
				case LAYOUT_ALIGN_STRICT:
				{
					
					dw=dw/(args.length+1);
					for (i = 0; i < args.length; i++) {
						args[i].x=dw*(i+1)-args[i].width/2+x;
						args[i].y=y;
						tar.addChild(args[i]);
					}
					break;
				}
			}
			
		}
		public static function setVerticalLayout(tar,align,x,y,dh,...args):void{
			var currentH:int=0;
			var i:int;
			switch(align)
			{
				case LAYOUT_ALIGN_TOP:
				{
					for (i = 0; i < args.length; i++) {
						args[i].x=x
						args[i].y=currentH+y;
						if(args[i].hasOwnProperty("Height")){
							currentH+=args[i].Height+dh;
						}else{
							currentH+=args[i].height+dh;
						}
						tar.addChild(args[i]);
					}
					break;
				}
			}
			
		}
		public static function setVerticalFollow(tar,align,dh,...args):void{
			var currentH:Number=0;
			var i:int;
			
			var x:int;
			var y:int;
			
			switch(align)
			{
				
				case LAYOUT_ALIGN_LEFT:
				{
					
					x=args[0].x;
					y=args[0].y;
					
					for (i = 0; i < args.length; i++) {
						args[i].x=x
						args[i].y=currentH+y;
						if(args[i].hasOwnProperty("Height")){
							currentH+=args[i].Height+dh;
						}else{
							currentH+=args[i].height+dh;
						}
						tar.addChild(args[i]);
					}
					break;
				}
				case LAYOUT_ALIGN_CENTER:
				{
					
					x=args[0].x+args[0].width/2;
					y=args[0].y;
					
					for (i = 0; i < args.length; i++) {
						args[i].x=x-args[i].width/2;
						args[i].y=currentH+y;
						if(args[i].hasOwnProperty("Height")){
							currentH+=args[i].Height+dh;
						}else{
							currentH+=args[i].height+dh;
						}
						tar.addChild(args[i]);
					}
					break;
				}
			}
			
		}
		
		public static function setAlign(tar,align,...args):void{
			var i:int;
			
			var x:int;
			var y:int;
			
			switch(align)
			{
				
				case LAYOUT_ALIGN_CENTER:
				{
					
					x=args[0].x+args[0].width/2;
					y=args[0].y+args[0].height/2;
					
					for (i = 0; i < args.length; i++) {
						args[i].x=x-args[i].width/2;
						args[i].y=y-args[i].height/2;
						tar.addChild(args[i]);
					}
					break;
				}
			}
			
		}
		public static function UnifyScale(w:Number,h:Number,...args):void{
			for (var i:int = 0; i < args.length; i++) {
				args[i].setSize(w,h);
			}
		}
	}
}