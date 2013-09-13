/* Copyright (c) 2013 Sunag Entertainment
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE. */

package sunag.controller 
{
    import away3d.cameras.Camera3D;
    
    import flash.display.Stage;
    import flash.events.FullScreenEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import sunag.utils.MathHelper;

	public class FreeCameraController
	{
		private var _stage : Stage;
		private var _target : Vector3D;
		private var _camera : Camera3D;
		private var _speed : Vector3D = new Vector3D();
		private var _drag:Boolean = false;
		private var _referenceX : Number = 0;
		private var _referenceY : Number = 0;
		private var _shift:Boolean = false;
		private var _ctrl:Boolean = false;
		private var _mouseLock:Boolean = false;
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
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);				
		}

	
		public function dispose() : void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);	
		}

		public function get stage():Stage
		{
			return _stage;
		}
		
		public function get target() : Vector3D
		{
			return _target;
		}

		public function set target(value : Vector3D) : void
		{
			_target = value;
		}

		public function update() : void
		{		
			if (_drag) updateTarget();
			
			var value:Number = 1;
			
			if (_ctrl) value /= 10;
			if (_shift) value *= 5;
			
			if (_keys[Keyboard.W.toString()] || _keys[Keyboard.UP.toString()])
			{
				_speed.z += value;
			}
			if (_keys[Keyboard.S.toString()] || _keys[Keyboard.DOWN.toString()])
			{
				_speed.z -= value;
			}			
			if (_keys[Keyboard.A.toString()] || _keys[Keyboard.LEFT.toString()])
			{
				_speed.w += value;
			}
			if (_keys[Keyboard.D.toString()] || _keys[Keyboard.RIGHT.toString()])
			{
				_speed.w -= value;
			}
						
			_camera.rotationY = MathHelper.angle(_camera.rotationY - _speed.x);
			_camera.rotationX = MathHelper.angle(_camera.rotationX - _speed.y);
				
			_camera.moveLeft(_speed.w);
			_camera.moveForward(_speed.z);
			
			_speed.scaleBy(.70);
			_speed.w *= .70;
		}

		private function onMouseMove(e:MouseEvent):void
		{
			if (_mouseLock)
			{
				_speed.x += (Math.abs(MathHelper.angle(_camera.rotationZ)) > 90 ? e.movementX : -e.movementX) / 30;
				_speed.y += -e.movementY / 30;
			}
			_mouseLock = stage.mouseLock;
		}
		
		private function updateTarget() : void
		{
			var mouseX : Number = _stage.mouseX;
			var mouseY : Number = _stage.mouseY;
			
			_speed.x += (_referenceX - mouseX) / (Math.abs(MathHelper.angle(_camera.rotationZ)) > 90 ? -18 : 18);
			_speed.y += (_referenceY - mouseY) / 18;
			
			_referenceX = _stage.mouseX;
			_referenceY = _stage.mouseY;
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			_shift = e.shiftKey;
			_ctrl = e.ctrlKey;
			_keys[e.keyCode.toString()] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			_shift = e.shiftKey;
			_ctrl = e.ctrlKey;
			delete _keys[e.keyCode.toString()];
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			if (_stage.mouseLock) return;
			
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
