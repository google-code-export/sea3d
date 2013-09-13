package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;
	
	public class SEARigidBody extends SEAPhysics
	{
		public static const TYPE:String = "rb";
		
		public var target:SEAObject3D;
		
		public function SEARigidBody(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}
		
		override public function load():void
		{
			
		}
	}
}