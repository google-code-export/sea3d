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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ProgressMarker extends Sprite
	{
		private var _mark:Sprite = new Sprite();
		private var _messageField:TextField;
		private var _message:Shape;
		
		protected static const format:TextFormat = new TextFormat('Verdana',11,0xEEEEEE,null,null,null,null,null,'center');
		
		public function ProgressMarker()
		{
			addChild(_mark);
			
			var _th:int = 7;
			_mark.graphics.beginFill(0x101212,0.9);
			_mark.graphics.moveTo(0, 0);
			_mark.graphics.lineTo(_th*2, 0);
			_mark.graphics.lineTo(_th, _th);
			_mark.graphics.lineTo(0, 0);
			_mark.x = -_th;
			_mark.y = -_th;
		}
		
		public function get text():String
		{
			return _messageField.htmlText;
		}
		
		public function set text(value:String):void
		{					
			_setText(value, false);
		}
		
		public function get htmlText():String
		{
			return _messageField.htmlText;
		}
		
		public function set htmlText(value:String):void
		{					
			_setText(value, true);
		}
		
		private function _setText(value:String, isHtml:Boolean):void
		{
			if (!_message && value) 			
			{
				_message = new Shape();
				addChild(_message);
				
				_messageField = new TextField();			
				
				with(_messageField)
				{			
					defaultTextFormat=format;
					width=height=0;			
					autoSize='center';					
					type='dynamic';					
					mouseEnabled=false;		
				}
				
				addChild(_messageField);
			}
			else if (_message && !value) 
			{
				removeChild(_message);
				removeChild(_messageField);
				_message = null;
				_messageField = null;
			}	
			
			if (value)
			{
				isHtml ? _messageField.htmlText = value : _messageField.text = value;								
				
				var w:int = _messageField.textWidth + 16;
				var h:int = _messageField.textHeight + 8;
				
				_message.x = -w/2;
				_message.y = -_mark.height - h;
				
				_messageField.x = _message.x + 6;
				_messageField.y = _message.y + 2;
				
				with(_message.graphics)
				{
					clear();
					beginFill(0x101212,0.9);
					drawRoundRect(0,0,w,h,9);
				}				
			}
		}
	}
}