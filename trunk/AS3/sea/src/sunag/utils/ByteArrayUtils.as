package sunag.utils
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class ByteArrayUtils
	{
		public static function readVector3D(data:ByteArray):Vector3D
		{
			return new Vector3D
			(
				data.readFloat(),
				data.readFloat(),
				data.readFloat()
			);
		}
		
		public static function readColor(data:ByteArray):uint
		{
			var r:int = data.readUnsignedByte();
			var g:int = data.readUnsignedByte();
			var b:int = data.readUnsignedByte();
			
			return r << 16 | g << 8 | b;
		}
		
		public static function readQuaternion(data:ByteArray):Vector3D
		{
			var quat:Vector3D = new Vector3D
			(
				data.readFloat(),
				data.readFloat(),
				data.readFloat()
			);
			
			var t : Number = 1 - quat.x * quat.x - quat.y * quat.y - quat.z * quat.z;
			quat.w = t < 0 ? 0 : -Math.sqrt(t);
			
			return quat;
		}
		
		public static function readUTFTiny(data:ByteArray):String
		{
			var length:uint = data.readByte();
			return data.readUTFBytes(length);
		}
		
		public static function readUTFShort(data:ByteArray):String
		{
			var length:uint = data.readUnsignedInt();
			return data.readUTFBytes(length);
		}
		
		public static function readUTFLong(data:ByteArray):String
		{
			var length:uint = data.readUnsignedInt();
			return data.readUTFBytes(length);
		}
		
		public static function split(data:ByteArray, position:uint=0, length:uint=0):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(data, position, length);
			bytes.position = 0;
			return bytes;
		}
	}
}