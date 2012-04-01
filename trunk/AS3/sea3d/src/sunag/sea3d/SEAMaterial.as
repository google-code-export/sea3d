/* Copyright (C) 2012 Sunag Entertainment
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

package sunag.sea3d
{
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.sea3d.token.Token;
	import sunag.utils.ByteArrayUtils;
	
	public class SEAMaterial extends SEAObject
	{
		public static const TYPE:String = "material";
		
		public var fresnel:Boolean = false;
		public var fresnelColor:uint = 0x00;
		public var fresnelPower:Number = 5;
		public var fresnelAmount:Number = 1;
		
		public var ambient:uint = 0x00;
		public var ambientMapAmount:Number = 0;
		public var ambientMap:String;		
		
		public var diffuse:uint = 0x969696;
		public var diffuseMapAmount:Number = 0;
		public var diffuseMap:String;		
		
		public var gloss:Number = 10;		
		public var specular:Number = 0;
		public var specularColor:uint = 0xE6E6E6;
		public var specularMap:String;
		public var specularMapAmount:Number = 0;
		
		public var reflectionMapAmount:Number = 0;
		public var reflectionMap:String
		
		public var refractionMapAmount:Number = 0;
		public var refractionMap:String;
		
		public var opacity:Number = 255;
		public var opacityMapAmount:Number = 0;
		public var opacityMap:String;
		
		public var bumpMapAmount:Number = 0;
		public var bumpMap:String;
		
		public var normalMapAmount:Number = 0;
		public var normalMap:String;				
		
		public var selfIllumAmount:Number = 0;		
		public var selfIllumColor:uint = 0;	
		public var selfIllumMapAmount:Number = 0;
		public var selfIllumMap:String;
		
		public var wire:Boolean = false;
		public var bothSides:Boolean = false;
		public var smooth:Boolean = true;
		
		public function SEAMaterial(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			Token.read(this, data);
						
			selfIllumAmount /= 255;			
			
			ambientMapAmount /= 100;
			diffuseMapAmount /= 100;
			specularMapAmount /= 100;
			reflectionMapAmount /= 100;
			refractionMapAmount /= 100;	
			selfIllumMapAmount /= 100;
			opacity /= 100;
			opacityMapAmount /= 100;
			bumpMapAmount /= 100;
			normalMapAmount /= 100;											
		}
	}
}