package Assembly.ExpandThread{
	
	public class ExpandLayout {
		
		
		public function ExpandLayout()
		{
		}
		
		public static function Arrange(n:int):Number{
			switch(n)
			{
				
				case 3:
				{
					return Math.PI/6;
					break;
				}
					
				case 4:
				{
					return Math.PI/4;
					break;
				}
				
				case 1:
				case 2:
				{
					return 0;
					break;
				}
					
				default:
				{
					return Math.PI/2;;
					break;
				}
			}
		}
	}
}