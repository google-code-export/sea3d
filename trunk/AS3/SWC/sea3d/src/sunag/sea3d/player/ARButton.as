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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class ARButton extends Sprite
	{
		private var _color:uint = 0x101212;
		
		private var _bg:Sprite = new Sprite();
		private var _bitmap:Bitmap;
		private var _selected:Boolean = false;
		private var _over:Boolean = false;
		
		private var _fileReference:FileReference = new FileReference();
		private var _fileFilter:Array;
		
		private static var _data:BitmapData;
				
		public function ARButton()
		{
			addEventListener(MouseEvent.CLICK, onClick);
			
			if (!_data)
			{
				var _field:TextField = new TextField()
				_field.autoSize = TextFieldAutoSize.LEFT;
				_field.defaultTextFormat = new TextFormat('Verdana',28,0xEEEEEE,null,null,null,null,null,'center');
				_field.text = "AR";
				
				_data = new BitmapData(_field.textWidth, _field.textHeight, true, 0);
				_data.draw(_field);
			}
			
			addChild(_bg);
			addChild(_bitmap=new Bitmap(_data));
			
			_bitmap.alpha = .6;
			_bitmap.x = 5;
			_bitmap.y = 5;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			draw();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			selected = !_selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected === value) return;
			
			_selected = value;
			
			var e:Event = new Event(Event.CHANGE, false, true);			
			dispatchEvent(e);
			
			if (e.isDefaultPrevented())
			{
				_selected = !_selected;
			}
			
			if (_over) onMouseOver();
			else onMouseOut();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function onMouseOver(e:MouseEvent=null):void
		{
			_over = true;
			_color = _selected ? 0x77FF77 : 0x0077FF;
			draw();
		}
		
		private function onMouseOut(e:MouseEvent=null):void
		{
			_over = false;
			_color = _selected ? 0x77FF77 : 0x101212;
			draw();
		}
		
		private function draw():void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color, .8);
			_bg.graphics.drawRoundRect(0, 0, 50, 50, 5);						
		}
	}
}