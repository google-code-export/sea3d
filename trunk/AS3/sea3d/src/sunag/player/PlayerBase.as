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

	public class PlayerBase extends Sprite
	{			
		public static const PLAYING:String = "playing";
		public static const PAUSED:String = "paused";
		public static const DRAGGING:String = "dragging";
		
		private var _playerTools:Sprite = new Sprite();
		
		private var _playButton:PlayButton = new PlayButton();
		private var _progressBar:ProgressBar = new ProgressBar();
		private var _fullScreenButton:FullScreenButton = new FullScreenButton();
		private var _marker:ProgressMarker = new ProgressMarker();
		private var _uploadButton:UploadButton = new UploadButton();
		private var _console:PlayerConsole = new PlayerConsole();
		private var _logo:SEA3DLogo = new SEA3DLogo();
		
		private var _width:int = 600;
		private var _height:int = 400;
		
		private var _length:uint;
		
		public function PlayerBase()
		{				
			addChild(_logo);
			_logo.alpha = .1;
			
			// Tools
			addChild(_playerTools);			
			_playerTools.addChild(_playButton);
			_playerTools.addChild(_progressBar);
			_playerTools.addChild(_fullScreenButton);
			_playerTools.addChild(_marker);			
			
			// Utils
			addChild(_console);
			addChild(_uploadButton);			
					
			_progressBar.addEventListener(PlayerEvent.DRAGGING, onDragging);
			
			length = 0;
			position = 0;
			
			update();
			updateProgress();
		}
		
		private function onDragging(e:PlayerEvent):void
		{
			updateProgress();
		}
		
		public function get state():String
		{
			if (_progressBar.dragging)
			{
				return DRAGGING;
			}			
			else if (_playButton.state == PlayButton.PLAY)
			{
				return PAUSED;
			}
			else
			{
				return PLAYING;
			}
		}
		
		public function set htmlText(value:String):void
		{
			_console.textField.htmlText = value;
		}
		
		public function get htmlText():String
		{
			return _console.textField.htmlText;
		}		
		
		public function set text(value:String):void
		{
			_console.textField.text = value;
		}
		
		public function get text():String
		{
			return _console.textField.text;
		}
		
		public function get console():PlayerConsole
		{
			return _console;
		}
		
		public function get play():PlayButton
		{
			return _playButton;
		}
		
		public function get progressBar():ProgressBar
		{
			return _progressBar;
		}
		
		public function get fullScreen():FullScreenButton
		{
			return _fullScreenButton;
		}
		
		public function get marker():ProgressMarker
		{
			return _marker;
		}
		
		public function get upload():UploadButton
		{
			return _uploadButton;
		}
		
		public function get progress():Number
		{
			return _progressBar.progress;
		}
		
		public function set progress(value:Number):void
		{
			_progressBar.progress = value;	
		}
		
		public function set length(value:uint):void
		{
			_length = value;			
			markerVisible = _length > 0;			
			updateProgress();
		}
		
		public function get length():uint
		{
			return _length;
		}
		
		public function set position(value:Number):void
		{
			_progressBar.position = value;
			updateMarker();
			updateProgress();
		}
		
		public function get position():Number
		{
			return _progressBar.position;
		}
		
		public function update():void
		{
			_logo.x = (_width/2) - (_logo.width/2);
			_logo.y = (_height/2) - (_logo.height/2);
			
			_console.width = _width;				 
			_console.height = _uploadButton.height + 40;
			
			_uploadButton.x = 20;
			_uploadButton.y = 20;
			
			_playerTools.y = _height - (_playButton.height + 40);
			
			// draw bg
			_playerTools.graphics.clear();
			_playerTools.graphics.beginFill(0x101212, .3);
			_playerTools.graphics.drawRect(0,0,_width,_height - _playerTools.y);
			
			_playButton.x = 20;
			_playButton.y = 20;
			
			_progressBar.x = _playButton.x + _playButton.width + 20;
			_progressBar.y = Math.round((_playButton.height / 2) - (_progressBar.height/2)) + 20;
			
			_fullScreenButton.x = _width - (_fullScreenButton.width + 20);
			_fullScreenButton.y = Math.round((_playButton.height / 2) - (_fullScreenButton.height/2)) + 20;
			
			_progressBar.width = _fullScreenButton.x - (_progressBar.x + 20);
			
			updateMarker();
		}
		
		public function set markerVisible(value:Boolean):void
		{
			_playButton.mouseChildren = 
				_playButton.mouseEnabled = value ;			
			
			_playButton.alpha = value ? 1 : .6;
			
			_marker.visible = value;
			
			_logo.visible = !value;
		}
		
		public function get markerVisible():Boolean
		{
			return _marker.visible;
		}
		
		private function updateMarker():void
		{
			_marker.x = _progressBar.x + Math.round(_progressBar.position * _progressBar.width);
			_marker.y = _progressBar.y;
		}
		
		private function updateProgress():void
		{
			var tip:Array = [];
			
			var lengthMs:Number = _length;
			var positionMs:Number = int(_progressBar.position * _length);
			
			if (lengthMs > 1000)
			{
				tip[0] = String(positionMs / 1000);
				tip[1] = String(lengthMs / 1000);
			}
			else
			{
				tip[0] = String(positionMs);
				tip[1] = String(lengthMs);
			}
								
			_marker.htmlText = tip.join("/");
		}
		
		public override function set width(value:Number):void { _width = value; update(); }
		public override function get width():Number { return _width; }
		
		public override function set height(value:Number):void { _height = value; update(); }
		public override function get height():Number { return _height; }
	}
}