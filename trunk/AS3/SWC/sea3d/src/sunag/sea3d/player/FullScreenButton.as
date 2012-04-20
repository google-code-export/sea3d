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

package sunag.player
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	public class FullScreenButton extends Sprite
	{
		private var _color:uint = 0x101212;
		
		private var _bg:Sprite = new Sprite();
		private var _sprite:Sprite = new Sprite();
		
		public function FullScreenButton()
		{
			addChild(_bg);
			addChild(_sprite);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onInvalidateMouse);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			draw();
		}
		
		private function onInvalidateMouse(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;					
			}			
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			_color = 0x0077FF;
			draw();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			_color = 0x101212;
			draw();
		}
		
		private function draw():void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color, .8);
			_bg.graphics.drawRoundRect(0, 0, 50, 50, 5);			
			
			_sprite.graphics.clear();
			
			_sprite.x = _sprite.y = 0;
			_sprite.graphics.beginFill(0xCCCCCC,.8);
			_sprite.graphics.drawRect(10,10,30,30);
			_sprite.graphics.drawRect(12,12,26,26);
			
			_sprite.graphics.drawRect(20,10,10,2);			
			_sprite.graphics.drawRect(20,38,10,2);
			
			_sprite.graphics.drawRect(10,20,2,10);
			_sprite.graphics.drawRect(38,20,2,10);
		}
	}
}