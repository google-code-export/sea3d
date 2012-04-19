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

package sunag.sea3d.away3d.animation
{
	import away3d.lights.LightBase;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationSequence;
	
	public class LightAnimationBase extends Animation
	{
		protected var _light:LightBase;
		
		public var defaultPosition:Vector3D;	
		public var defaultColor:uint;
		public var defaultMultiplier:Number;
		
		public function LightAnimationBase(light:LightBase, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultColor:uint, defaultMultiplier:Number)
		{
			super(data, light);
			_light = light;	
			
			this.defaultPosition = defaultPosition;
			this.defaultColor = defaultColor;	
			this.defaultMultiplier = defaultMultiplier;
		}
		
		public function get light():LightBase
		{
			return _light;
		}
		
		public override function update():void
		{
			throw new Error("Abstract method.");
		}
	}
}