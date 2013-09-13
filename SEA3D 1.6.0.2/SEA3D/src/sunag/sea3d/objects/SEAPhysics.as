package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;
	
	public class SEAPhysics extends SEAObject
	{
		public static const TYPE:String = "phys";
		
		public function SEAPhysics(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}
	}
}