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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class UploadButton extends Sprite
	{
		private var _color:uint = 0x101212;
		
		private var _bg:Sprite = new Sprite();
		private var _sprite:Sprite = new Sprite();
		
		private var _fileReference:FileReference = new FileReference();
		private var _fileFilter:Array;
		private var _data:ByteArray;
		
		public function UploadButton()
		{
			addEventListener(MouseEvent.CLICK, onUpload);
			
			_fileReference.addEventListener(Event.SELECT, onFileSelected);
			_fileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			
			
			addChild(_bg);
			addChild(_sprite);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			draw();
		}
		
		public function get data():ByteArray
		{
			return _data;
		}
		
		public function set fileFilter(value:Array):void
		{
			_fileFilter = value;
		}
		
		public function get fileFilter():Array
		{
			return _fileFilter;
		}
		
		private function onUpload(e:MouseEvent):void
		{
			if (_fileFilter) _fileReference.browse(_fileFilter);
		}
		
		private function onFileSelected(e:Event):void
		{
			_fileReference.load();
		}
		
		private function onFileLoaded(e:Event):void
		{
			_data = _fileReference.data;	
			dispatchEvent(new PlayerEvent(PlayerEvent.UPLOAD));			
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			_color = 0x007DFF;
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
			_bg.graphics.beginFill(_color, .6);
			_bg.graphics.drawRoundRect(0, 0, 50, 50, 5);			
			
			_sprite.graphics.clear();
			
			_sprite.x = _sprite.y = 0;
			
			var _th:int = 15;
			_sprite.graphics.beginFill(0xCCCCCC,0.8);
			_sprite.graphics.moveTo(0, 0);
			_sprite.graphics.lineTo(_th*2, 0);
			_sprite.graphics.lineTo(_th, -_th);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.drawRect(10, 0, 10, 13); 
			_sprite.x = 10;
			_sprite.y = 25;
		}
	}
}