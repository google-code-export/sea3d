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
	}
}