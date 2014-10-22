package Kernel.SmartLayout
{
	
	import Kernel.SmartCanvas.CompressedNode;

	public class CenterLayout
	{
		public function CenterLayout()
		{
		}
		private static function cmp(p1,p2,p0):Boolean{
			var cross:Number=(p1.Position[0]-p0.Position[0])*(p2.Position[1]-p0.Position[1])-(p1.Position[1]-p0.Position[1])*(p2.Position[0]-p0.Position[0]);
			return (cross>1e-10);
		}
		private static function sort(a,s,t,centeredBlock:CompressedNode):void{
			var i:int=s,j:int=t,u:CompressedNode=centeredBlock.Linklist[a[(s+t)>>1]],v:String;
			while (i<=j){
				while (i<=j && cmp(centeredBlock.Linklist[a[i]],u,centeredBlock)) i++;
				while (i<=j && cmp(u,centeredBlock.Linklist[a[j]],centeredBlock)) j--;
				if (i<=j) {
					v=a[i];
					a[i]=a[j];
					a[j]=v;
					i++;
					j--;
				}
			}
			if (s<j) sort(a,s,j,centeredBlock);
			if (i<t) sort(a,i,t,centeredBlock);
		}
		public static function CUL_Center(centeredBlock:CompressedNode):Object{
			var radius:Number=centeredBlock.centerRadius;
			var tmp:Array = new Array();
			var i:int=0;
			for (var str:String in centeredBlock.Linklist){
				tmp[i] = str;
				i++;
			}
			var rad:Number=Math.PI*2/i;
			sort(tmp,0,i-1,centeredBlock);
			var dis:Number=1e100;
			var preAngle:Number = 0;
			for (var c:int = 0; c < 180; c++){
				var tempPreAngle:Number = 2*c*Math.PI/180;
				var tmpDis:Number=0;
				for (var j:int = 0; j < i; j++){
					var deltaX:Number=(Math.cos(tempPreAngle+rad*j)*radius+centeredBlock.Position[0]-centeredBlock.Linklist[tmp[j]].Position[0]);
					var deltaY:Number=(Math.sin(tempPreAngle+rad*j)*radius+centeredBlock.Position[1]-centeredBlock.Linklist[tmp[j]].Position[1]);
					tmpDis+=Math.sqrt(deltaX*deltaX+deltaY*deltaY);
				}
				if (tmpDis<dis){
					dis=tmpDis;
					preAngle=tempPreAngle;
				}
			}
			var res:Object={preAngle:preAngle,tmp:tmp};
			return (res);
		}
		public static function cal_Position(res:Object,centeredBlock:CompressedNode,px:*=null,py:*=null):Array{
			
			if(px==null){
				px=centeredBlock.Position[0];
				py=centeredBlock.Position[1]
			}
			
			var rad:Number=Math.PI*2/res.tmp.length;
			var radius:Number=centeredBlock.centerRadius;
			var aimP:Array=new Array();
			var i:int=0;
			for (var str:String in centeredBlock.Linklist) {
				var tmp:Vector.<Number>=new <Number>[Math.cos(res.preAngle+rad*i)*radius+px,Math.sin(res.preAngle+rad*i)*radius+py];
				aimP[res.tmp[i]]=tmp;
				i++
			}
			return aimP;
		}
	}
}