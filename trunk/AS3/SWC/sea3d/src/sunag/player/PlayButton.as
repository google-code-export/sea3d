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
	import flash.events.MouseEvent;
	
	public class PlayButton extends Sprite
	{
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		
		private var _state:String = PLAY;
		private var _color:uint = 0x101212;
		
		private var _bg:Sprite = new Sprite();
		private var _sprite:Sprite = new Sprite();
		
		public function PlayButton()
		{
			addChild(_bg);
			addChild(_sprite);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			draw();
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			draw();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (_state == PLAY) _state = PAUSE;
			else if (_state == PAUSE) _state = PLAY;
			
			draw();
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
			_bg.graphics.drawRoundRect(0, 0, 60, 60, 5);			
			
			_sprite.graphics.clear();
			
			if (_state == PLAY)
			{
				var _th:int = 20;
				_sprite.x = 22;
				_sprite.y = 10;				
				_sprite.graphics.beginFill(0xCCCCCC, .8);
				_sprite.graphics.moveTo(0, 0);
				_sprite.graphics.lineTo(_th, _th);
				_sprite.graphics.lineTo(0, _th*2);
				_sprite.graphics.lineTo(0, 0);
			}
			else if (_state == PAUSE)
			{		
				_sprite.x = _sprite.y = 0;
				_sprite.graphics.beginFill(0xCCCCCC, .8);
				_sprite.graphics.drawRect(20,13,6,35);
				_sprite.graphics.drawRect(40-6,13,6,35);
			}
		}
	}
}