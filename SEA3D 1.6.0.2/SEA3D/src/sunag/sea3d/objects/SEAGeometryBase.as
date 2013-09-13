package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;

	public class SEAGeometryBase extends SEAObject
	{
		public static const TYPE:String = "geom";
		
		public var attrib:uint;
		
		public var numVertex:uint;
		public var jointPerVertex:uint;
		
		public var isBig:Boolean = false;
		
		protected var readUint:Function;	
		
		public function SEAGeometryBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}	
		
		protected function readGeometryBase(data:*):void
		{
			attrib = data.readUnsignedShort();
			
			// Standard or Big Geometry
			readUint = (isBig = (attrib & 1) != 0) ? data.readUnsignedInt : data.readUnsignedShort;
			
			numVertex = readUint();
		}
	}
}