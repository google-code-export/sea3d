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

package sunag.utils
{
	import flash.geom.Vector3D;

	public class MathHelper
	{
		public static const DEGREES : Number = 180 / Math.PI;
		public static const RADIANS : Number = Math.PI / 180;
		
		public static function upperPowerOfTwo(num:uint):uint
		{
			//  if(num == 1) return 2;
			
			num--;
			num |= num >> 1;
			num |= num >> 2;
			num |= num >> 4;
			num |= num >> 8;
			num |= num >> 16;
			
			num++;
			
			return num;
		}
		
		public static function angle(value:Number):Number			
		{
			var angle:Number = 180;
			var invert:Boolean = value < 0;
			
			value = (invert ? -value : value) % 360;
			
			if (value > angle)			
			{
				value = -angle + (value - angle);
			}
			
			return (invert ? -value : value);			
		}
		
		public static function valueAt(value:Number, target:Number, percent:Number):Number
		{
			return value + ((target - value) * percent);
		}
		
		public static function colorAt(value:uint, target:uint, percent:Number):uint
		{
			var colorA:Vector3D = colorToVector(value);
			var colorB:Vector3D = colorToVector(target);
			
			colorA.x = valueAt(colorA.x, colorB.x, percent);
			colorA.y = valueAt(colorA.y, colorB.y, percent);
			colorA.z = valueAt(colorA.z, colorB.z, percent);
			//colorA.w = valueAt(colorA.w, colorB.w, percent);
			
			return MathHelper.vectorToColor(colorA);
		}
		
		public static function colorToVector(value:uint):Vector3D
		{
			var alpha:uint = value >> 24 & 0xff;
			var red:uint =  value >> 16 & 0xff;
			var green:uint = value >> 8 & 0xff;
			var blue:uint = value & 0xff;
			
			return new Vector3D(red,green,blue,alpha);
		}
		
		public static function vectorToColor(value:Vector3D):uint
		{
			return value.w << 24 | value.x << 16 | value.y << 8 | value.z;
		}
		
		public static function angleAt(value:Number, target:Number, percent:Number):Number			
		{				
			if (Math.abs(value - target) > 180)
			{
				if (value > target) 
				{		
					target += 360;				
				}
				else 
				{
					target -= 360;				
				}
			}
			
			value += (target - value) * percent;
			
			return angle(value);
		}
		
		public static function interpolation(value:Vector.<Number>, target:Vector.<Number>, percent:Number=.5):void 
		{
			for(var i:int = 0;i < value.length;i++)
			{
				value[i] += (target[i] - value[i]) * percent;
			}
		}
		
		public static function interpolationAngle(value:Vector.<Number>, target:Vector.<Number>, percent:Number=.5):void
		{
			for(var i:int = 0;i < value.length;i++)
			{
				value[i] = angleAt(value[i], target[i], percent);
			}
		}
						
		public static function interpolationColor(value:Vector.<Number>, target:Vector.<Number>, percent:Number=.5):void
		{
			for(var i:int = 0;i < value.length;i++)
			{
				value[i] = colorAt(value[i], target[i], percent);
			}
		}
		
		public static function interpolationEuler(value:Vector.<Number>, target:Vector.<Number>, percent:Number=.5):void
		{				
			var q1:Quaternion = new Quaternion();
			q1.fromEulerAngles(value[0], value[1], value[2]);
			
			var q2:Quaternion = new Quaternion();
			q2.fromEulerAngles(target[0], target[1], target[2]);
			
			q1.lerp(q1, q2, percent);
			q1.toVectorEulerAngles(value);	
		}
	}
}
import flash.geom.Vector3D;

import sunag.utils.MathHelper;

class Quaternion
{
	/** *
		* Source: away3d.core.math.Quaternion.as <http://www.away3d.com>
	 * **/		
	
	public var x:Number = 0;
	public var y:Number = 0;
	public var z:Number = 0;
	public var w:Number = 1;
	
	public function fromEulerAngles(ax:Number, ay:Number, az:Number):void
	{
		ax *= MathHelper.RADIANS;
		ay *= MathHelper.RADIANS;
		az *= MathHelper.RADIANS;
		
		var halfX : Number = ax*.5, halfY : Number = ay*.5, halfZ : Number = az*.5;
		var cosX : Number = Math.cos(halfX), sinX : Number = Math.sin(halfX);
		var cosY : Number = Math.cos(halfY), sinY : Number = Math.sin(halfY);
		var cosZ : Number = Math.cos(halfZ), sinZ : Number = Math.sin(halfZ);
		
		w = cosX*cosY*cosZ + sinX*sinY*sinZ;
		x = sinX*cosY*cosZ - cosX*sinY*sinZ;
		y = cosX*sinY*cosZ + sinX*cosY*sinZ;
		z = cosX*cosY*sinZ - sinX*sinY*cosZ;
	}
	
	public function lerp(qa : Quaternion, qb : Quaternion, t : Number) : void
	{
		var w1 : Number = qa.w, x1 : Number = qa.x, y1 : Number = qa.y, z1 : Number = qa.z;
		var w2 : Number = qb.w, x2 : Number = qb.x, y2 : Number = qb.y, z2 : Number = qb.z;
		var len : Number;
		
		// shortest direction
		if (w1 * w2 + x1 * x2 + y1 * y2 + z1 * z2 < 0) {
			w2 = -w2;
			x2 = -x2;
			y2 = -y2;
			z2 = -z2;
		}
		
		w = w1 + t * (w2 - w1);
		x = x1 + t * (x2 - x1);
		y = y1 + t * (y2 - y1);
		z = z1 + t * (z2 - z1);
		
		len = 1.0 / Math.sqrt(w * w + x * x + y * y + z * z);
		w *= len;
		x *= len;
		y *= len;
		z *= len;
	}
	
	public function toVectorEulerAngles(target:Vector.<Number>):void
	{
		target[0] = Math.atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y)) * MathHelper.DEGREES;
		target[1] = Math.asin(2 * (w * y - z * x)) * MathHelper.DEGREES;
		target[2] = Math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z)) * MathHelper.DEGREES;		
	}
}