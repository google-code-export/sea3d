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

package sunag.display
{
	import flash.display.Sprite;

	public class BlackSprite extends Sprite
	{
		private var _width:int = 32;
		private var _height:int = 32;
		
		public function BlackSprite()
		{
			// SE Standards
			alpha = .2;
		}
		
		public override function set width(value:Number):void
		{
			_width = value
			draw();
		}
		
		public override function set height(value:Number):void
		{
			_height = value;
			draw();
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, _width, _height);
		}
	}
}