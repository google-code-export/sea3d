package away3d.lights
{
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.PointLight;
	
	import flash.geom.Vector3D;

	public class ThreePointLight extends ObjectContainer3D
	{
		public var lightKey:PointLight;
		public var lightFill:PointLight;
		public var lightBack:PointLight;
		
		public function ThreePointLight(a:Number=1, b:Number=1, c:Number=.7)
		{
			lightKey = new PointLight();
			lightKey.position = new Vector3D(1000000,1000000,1000000);
			lightKey.color = 0xC7CDC0;
			lightKey.specular = lightKey.diffuse = a;
			lightKey.ambient = 0;
			//lightKey.ambientColor = 0xFFFFFF;
			addChild(lightKey);
			
			lightFill = new PointLight();
			lightFill.position = new Vector3D(0,1000000,-1000000);
			//lightFill.color = 0x7E753F;
			lightFill.color = 0xFFFFFF;
			lightFill.specular = lightFill.diffuse = b;
			lightFill.ambient = 1;
			lightFill.ambientColor = 0xFFFFFF;
			addChild(lightFill);
			
			lightBack = new PointLight();
			lightBack.position = new Vector3D(-1000000,-1000000,0);
			lightBack.color = 0xDF965B;
			lightBack.specular = lightBack.diffuse = c;
			lightBack.ambient = 0;
			//lightBack.ambientColor = 0xFFFFFF;
			addChild(lightBack);
		}
		
		public function toArray():Array
		{
			return [lightKey,lightFill,lightBack];
		}
	}
}