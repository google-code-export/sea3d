package sunag.sea3d.away3d.render
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.textures.RenderTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;

	public class CubeMapRender
	{
		private var _camera:Camera3D = new Camera3D(new PerspectiveLens(90));		
		private var _side:Vector.<Texture> = new Vector.<Texture>(6);
		
		public function CubeMapRender()
		{
		}
		
		public function get side():Vector.<Texture>
		{
			return _side;
		}
		
		public function dispose():void 
		{
			if (_side[0] != null)
			{
				for each (var tex:Texture in _side)
					tex.dispose();
			}			
		}
		
		public function render(view:View3D, position:Vector3D):void
		{
			var camera:Camera3D = view.camera;
			var filters3d:Array = view.filters3d;
			var width:int = view.width;
			var height:int = view.height;
			
			view.camera = _camera;
			view.filters3d = [];
			view.width = view.height = 512;			
			
			_camera.position = position;
			
			dispose();
			
			for(var i:int=0;i<6;i++)
			{
				switch (i)
				{
					case 0: _camera.lookAt(position.add(new Vector3D(1)));
						break;
					case 1: _camera.lookAt(position.add(new Vector3D(-1)));
						break;
					case 2: _camera.lookAt(position.add(new Vector3D(0,1)));
						break;
					case 3: _camera.lookAt(position.add(new Vector3D(0,-1)));
						break;
					case 4: _camera.lookAt(position.add(new Vector3D(0,0,1)));
						break;
					case 5: _camera.lookAt(position.add(new Vector3D(0,0,-1)));
						break;
				}
				
				/*
				view3D.renderer.swapBackBuffer = false;
				view3D.render();
				view3D.stage3DProxy.context3D.drawToBitmapData(bmData); 
				view3D.renderer.swapBackBuffer = true;
				*/
				
				view.render();
				_side[i] = view.stage3DProxy.context3D.createTexture(512, 512, Context3DTextureFormat.BGRA, true);
			}
										
			view.camera = camera;
			view.filters3d = filters3d;	
			view.width = width;
			view.height = height;
		}
	}
}