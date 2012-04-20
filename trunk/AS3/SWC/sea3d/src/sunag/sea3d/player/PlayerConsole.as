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
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.controls.Text;

	public class PlayerConsole extends Sprite
	{
		private var _bg:Sprite = new Sprite();
		
		private var _width:int = 600;
		private var _height:int = 100;
		
		private var _field:TextField = new TextField();
		
		protected static const format:TextFormat = new TextFormat('Verdana',11,0xCCCCCC,null,null,null,null,null,TextAlign.RIGHT);
		
		public function PlayerConsole()
		{
			_field.defaultTextFormat = format;
			_field.mouseEnabled = false;
			
			addChild(_bg);
			addChild(_field);
		}
		
		public function get textField():TextField
		{
			return _field;
		}
		
		public function update():void
		{
			_bg.graphics.clear();
			var m:Matrix = new Matrix;
			m.createGradientBox(_width, _height, Math.PI/2);
			_bg.graphics.beginGradientFill(GradientType.LINEAR, [0x101212,0x101212], [0.6,0.0],[0,255], m);
			_bg.graphics.drawRect(0, 0, _width, _height);
			_bg.graphics.endFill();
			
			_field.x = 2;
			_field.width = _width - 4;
			_field.height = _height + 20;
		}
		
		public override function set width(value:Number):void { _width = value; update(); }
		public override function get width():Number { return _width; }
		
		public override function set height(value:Number):void { _height = value; update(); }
		public override function get height():Number { return _height; }
	}
}