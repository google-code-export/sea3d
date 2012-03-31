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

package sunag.controller 
{
    import away3d.cameras.Camera3D;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

	public class FreeCameraController
	{
		private var _stage : Stage;
		private var _target : Vector3D;
		private var _camera : Camera3D;
		private var _speed : Vector3D = new Vector3D();
		private var _drag:Boolean = false;
		private var _referenceX : Number = 0;
		private var _referenceY : Number = 0;
		private var _keys:Array = [];

		public function FreeCameraController(camera : Camera3D, stage : Stage)
		{
			_stage = stage;
			_target = new Vector3D();
			_camera = camera;

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function dispose() : void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            _stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function get target() : Vector3D
		{
			return _target;
		}

		public function set target(value : Vector3D) : void
		{
			_target = value;
		}

		private function onEnterFrame(event : Event) : void
		{
			if (_drag) updateTarget();
			
			if (_keys[Keyboard.W.toString()])
			{
				_speed.z += 1;
			}
			else if (_keys[Keyboard.S.toString()])
			{
				_speed.z -= 1;
			}
			
			if (_keys[Keyboard.A.toString()])
			{
				_speed.w += 1;
			}
			else if (_keys[Keyboard.D.toString()])
			{
				_speed.w -= 1;
			}
			
			_camera.rotationY -= _speed.x;
			_camera.rotationX -= _speed.y;
			
			_camera.moveLeft(_speed.w);
			_camera.moveForward(_speed.z);
			
			_speed.scaleBy(.70);
			_speed.w *= .70;
		}

		private function updateTarget() : void
		{
			var mouseX : Number = _stage.mouseX;
			var mouseY : Number = _stage.mouseY;
			
			_speed.x += (_referenceX - mouseX) / 18;
			_speed.y += (_referenceY - mouseY) / 18;
			
			_referenceX = _stage.mouseX;
			_referenceY = _stage.mouseY;
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			_keys[e.keyCode.toString()] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			delete _keys[e.keyCode.toString()];
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			_drag = true;
			_referenceX = _stage.mouseX;
			_referenceY = _stage.mouseY;
		}

		private function onMouseUp(event : MouseEvent) : void
		{
			_drag = false;
		}

        private function onMouseWheel(event:MouseEvent) : void
        {
            _speed.z = event.delta;
        }
	}
}
