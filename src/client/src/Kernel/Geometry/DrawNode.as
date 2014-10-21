package Kernel.Geometry
{
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	
	import UserInterfaces.Style.ColorMixer;
	
	public class DrawNode
	{
		public function DrawNode()
		{
			
		}
		
		//node1:circle
		//node2:triangle
		//node3:square
		//node4:6 edge
		//node5:5PointStstar
		//node6:diamond
		//node7:5 edge
		//node8:cross
		
		public static function drawNode(tar:Object,dx:Number,dy:Number,scale:Number):Vector.<IGraphicsData>
		{
			
			var radius:Number=tar.radius * scale;
			
			var myFill:GraphicsGradientFill=new GraphicsGradientFill();
			myFill.type=GradientType.LINEAR;
			myFill.colors=[ColorMixer.MixColor(tar.color,0xbbbbbb),tar.color,ColorMixer.DecColor(tar.color,0x777777)];
			myFill.alphas=[1, 1,1];
			myFill.ratios=[0, 160,255];
			myFill.matrix=new Matrix();
			myFill.matrix.createGradientBox(radius, radius, Math.PI/2, dx-radius / 2,dy -radius / 2);
			
			var Stroke:GraphicsStroke=new GraphicsStroke(tar.stroke*scale);
			var tmatrix:Matrix=new Matrix();
			tmatrix.createGradientBox(radius, radius, Math.PI/2, dx-radius / 2,dy -radius / 2);
			Stroke.fill=new GraphicsGradientFill(GradientType.LINEAR,[ColorMixer.DecColor(tar.lineColor,0),ColorMixer.DecColor(tar.lineColor,0x111111)],[1, 1],[0, 255],tmatrix);
			
			if (tar.shape == 1)
			{
				
				var path:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				var r:Number=radius*0.5;
				//三次贝赛尔曲线逼近圆
				var t:Number=0.55;
				path.commands.push(1, 6, 6, 6, 6);
				path.data.push(0+dx, r+dy,
					t * r+dx, r+dy, r+dx, t * r+dy, r+dx, 0+dy,
					r+dx, -t * r+dy, t * r+dx, -r+dy, 0+dx, -r+dy,
					-t * r+dx, -r+dy, -r+dx, -t * r+dy, -r+dx, 0+dy,
					-r+dx, t * r+dy, -t * r+dx, r+dy, 0+dx, r+dy)
				
				var skin:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin.push(myFill, Stroke, path);
				return skin 
				
			}
				
			else if (tar.shape == 2)
			{
				
				var path2:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				var len:Number=radius;
				var r2:Number=len / (Math.sqrt(3));
				path2.commands.push(1, 2, 2, 2);
				path2.data.push(0+dx, -r2+dy,
					-len / 2+dx, r2 / 2+dy,
					len / 2+dx, r2 / 2+dy,
					0+dx, -r2+dy);
				
				var skin2:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin2.push(myFill, Stroke, path2);
				return(skin2);
				
				
			}
				
				
				
				
				
				
			else if (tar.shape == 3)
			{
				
				
				
				var path3:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				var command:Vector.<int>=new Vector.<int>();
				path3.commands.push(1, 2, 2, 2, 2);
				var sidelen:Number=radius*0.5;
				path3.data.push(sidelen+dx, sidelen+dy,
					sidelen+dx, -sidelen+dy,
					-sidelen+dx, -sidelen+dy,
					-sidelen+dx, sidelen+dy,
					sidelen+dx, sidelen+dy);
				
				var skin3:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin3.push(myFill, Stroke, path3);
				return(skin3);
				
				
			}
				
				
				
				
			else if (tar.shape == 4)
			{
				
				
				var path4:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				path4.commands.push(1, 2, 2, 2, 2, 2, 2);
				var r4:Number=radius*0.6;
				path4.data.push(r4+dx, dy);
				for (var i:int=1; i <= 6; i++)
				{
					var angle:Number=2 * Math.PI / 6 * i;
					path4.data.push(r4 * Math.cos(angle)+dx, r4 * Math.sin(angle)+dy);
					
				}
				
				var skin4:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin4.push(myFill, Stroke, path4);
				return(skin4);
				
				
			}
				
				
				
				
			else if (tar.shape == 5)
			{
				
				
				var path5:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				path5.commands.push(1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2);
				var r5:Number=radius*0.7;
				path5.data.push(0+dx, -r5+dy);
				for (var i3:int=1; i3 < 11; i3++)
				{
					var rInner:Number=r5;
					if (i3 % 2 > 0)
					{
						//alternate the radius to make spikes every other line
						rInner=r5 * 0.382;
					}
					var angle5:Number=Math.PI * 2 / 10 * i3 + Math.PI / 2;
					path5.data.push(Math.cos(angle5) * rInner+dx, -Math.sin(angle5) * rInner+dy);
				}
				
				
				var skin5:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin5.push(myFill, Stroke, path5);
				return(skin5);
				
				
				
			}
				
				
				
				
			else if (tar.shape == 6)
			{
				
				
				var path6:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				path6.commands.push(1, 2, 2, 2, 2);
				var r6:Number=radius*0.6;
				path6.data.push(r6+dx, dy);
				for (var i4:int=1; i4 <= 4; i4++)
				{
					var angle6:Number=2 * Math.PI / 4 * i4;
					path6.data.push(r6 * Math.cos(angle6)+dx, r6 * Math.sin(angle6)+dy);
					
				}
				
				var skin6:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin6.push(myFill, Stroke, path6);
				return(skin6);
				
				
			}
				
				
				
				
			else if (tar.shape == 7)
			{
				
				var path7:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				path7.commands.push(1, 2, 2, 2, 2, 2);
				var r7:Number=radius*0.6;
				path7.data.push(r7+dx, dy);
				for (var i2:int=1; i2 <= 5; i2++)
				{
					var angle7:Number=2 * Math.PI / 5 * i2;
					path7.data.push(r7 * Math.cos(angle7)+dx, r7 * Math.sin(angle7)+dy);
					
				}
				
				var skin7:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin7.push(myFill, Stroke, path7);
				return(skin7);

			}
				
				
				
			else if (tar.shape == 8)
			{
				
				
				var path8:GraphicsPath=new GraphicsPath(new Vector.<int>, new Vector.<Number>);
				path8.commands.push(1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2);
				var l:Number=radius*0.2;
				path8.data.push(+3 * l+dx, -l+dy,
					+l+dx, -l+dy,
					+l+dx, -3 * l+dy,
					-l+dx, -3 * l+dy, 
					-l+dx, -l+dy, 
					-3 * l+dx, -l+dy, 
					-3 * l+dx, +l+dy,
					-l+dx, +l+dy, 
					-l+dx, +3 * l+dy,
					+l+dx, +3 * l+dy,
					+l+dx, +l+dy,
					+3 * l+dx, +l+dy,
					+3 * l+dx, -l+dy);
				
				var skin8:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();
				skin8.push(myFill, Stroke, path8);
				return(skin8);
				
				
			}
			return skin
		}
		
	}
}

