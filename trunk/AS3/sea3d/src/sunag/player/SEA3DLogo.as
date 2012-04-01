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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SEA3DLogo extends Sprite
	{
		private static var _data:BitmapData;
		
		public function SEA3DLogo()
		{
			if (!_data)
			{
				var _field:TextField = new TextField()
				_field.autoSize = TextFieldAutoSize.LEFT;
				_field.defaultTextFormat = new TextFormat('Verdana',11,0xEEEEEE,null,null,null,null,null,'center');
				_field.htmlText = "<font size='90'>SEA3D</font>";
				
				_data = new BitmapData(_field.textWidth, _field.textHeight, true, 0);
				_data.draw(_field);
			}
		
			addChild(new Bitmap(_data));
		}
	}
}