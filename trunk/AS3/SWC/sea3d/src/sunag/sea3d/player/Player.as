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

package sunag.sea3d.player
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import sunag.player.PlayButton;
	import sunag.player.PlayerBase;
	import sunag.player.PlayerEvent;
	import sunag.player.PlayerState;
	import sunag.sea3d.animation.AnimationPlayer;
	import sunag.utils.TimeStep;
	
	public class Player extends PlayerBase
	{
		private var _target:AnimationPlayer;		
		private var _interval:uint = getTimer();
		private var _timeStep:TimeStep = new TimeStep();
		private var _error:String;
		private var _camera:String;
		private var _tips:String;
		private var _status:Boolean = true;
		
		public function Player()
		{
			super();
			upload.fileFilter = [new FileFilter("Sunag Entertainment Assets (*.sea)","*.sea")];
		}
				
		public function set target(value:AnimationPlayer):void
		{
			_target = value;
			play.state = PlayButton.PLAY;			
			
			if (_target)
			{
				length = value.length * value.frameRate;
				position = 0;
			}
			else
			{
				length = 0;
				position = 0;
			}
			
			logo.visible = _target == null;
			
			update();
		}
				
		public function get target():AnimationPlayer
		{
			return _target;
		}
		
		public function set camera(value:String):void
		{
			_camera = value;
			updateConsole();
		}
		
		public function get camera():String
		{
			return _camera;
		}
		
		public function set error(value:String):void
		{
			_error = value;		
			updateConsole();
		}
		
		public function get error():String
		{
			return _error;
		}
		
		public function set tips(value:String):void
		{
			_tips = value;		
			updateConsole();
		}
		
		public function get tips():String
		{
			return _tips;
		}
		
		public function set status(value:Boolean):void
		{
			_status = value;
			updateConsole();
		}
		
		public function get status():Boolean
		{
			return _status;
		}
		
		public function updateConsole():void
		{
			var stringBuilder:Array = [];
			
			stringBuilder.push("SEA3D Player 1.1\n");
			
			if (_status)
			{
				stringBuilder.push('<b>FPS:</b> ' + Math.round(_timeStep.getAverageFrameRate()));
				stringBuilder.push('<b>Memory:</b> ' + compactNumberString(((System.totalMemory)/1024)/1024) + "MB\n");
			}
									
			if (_camera) stringBuilder.push('<b><font color="#00FF99">Camera:</font></b> ' + _camera);
			if (_error) stringBuilder.push('<b><font color="#FF9900">Error:</font></b> ' + _error);			
			if (_tips) stringBuilder.push('<b><font color="#0099FF">Tips:</font></b> ' + _tips);
			
			htmlText = stringBuilder.join("\n");
		}
		
		public override function update():void
		{
			_timeStep.update();
									
			if (getTimer() - _interval > 500)
			{
				updateConsole();
				
				_interval = getTimer();
			}							
			
			if (_target)
			{
				switch(state)
				{
					case PlayerState.DRAGGING:
						_target.resetTime();	
						_target.position = position;
						_target.update();
						break
					
					case PlayerState.PLAYING:						
						_target.updateTime();						
						_target.update();
						position = _target.position; 
						break;
					
					case PlayerState.PAUSED:
						_target.resetTime();						
						position = _target.position; 
						break;
				}
			}
			
			super.update();
		}
		
		private function compactNumberString(value:Number):String
		{
			var str:String = value.toString();
			var index:int = str.indexOf('.');
			
			if (index > 0)
			{
				str = str.substr(0, index+2);
			}
			else
			{
				str += ".0";
			}
			
			return str;
		}
	}
}