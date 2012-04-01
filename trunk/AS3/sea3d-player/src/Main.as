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

package
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.filters.BloomFilter3D;
	import away3d.filters.ColorBalanceFilter3D;
	import away3d.filters.ColorMatrixFilter3D;
	import away3d.filters.LevelsFilter3D;
	import away3d.filters.MotionBlurFilter3D;
	import away3d.filters.RadialBlurFilter3D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import sunag.controller.FreeCameraController;
	import sunag.filters.ColorMatrix;
	import sunag.player.PlayerEvent;
	import sunag.player.PlayerState;
	import sunag.progressbar.ProgressCircle;
	import sunag.sea.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.away3d.Away3D;
	import sunag.sea3d.player.Player;
	
	[SWF(width="1024", height="632", backgroundColor="0x2C2C2C", frameRate="60")]
	public class Main extends Sprite
	{
		private var player:Player;		
		private var bridge:Away3D;
		private var sea3d:SEA3D;
		private var scene:Scene3D;
		private var view:View3D;
		private var controller:FreeCameraController;
		private var defaultCamera:Camera3D;
		private var progressBar:ProgressCircle;
		private var loader:URLLoader;
		
		private var userDefaultCamera:String = "";
		private var autoPlay:Boolean = false;
		private var enabledCameraController:Boolean = true;
		private var repeatAnimation:Boolean = true;
		
		public function Main()
		{					
			System.useCodePage = true;
			
			stage.stageFocusRect = false;
			stage.showDefaultContextMenu=false;	
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			scene = new Scene3D();
			
			view = new View3D(scene);			
			view.backgroundColor = stage.color;
			view.antiAlias = 4;
			addChild(view);
								
			player = new Player();
			player.tips = "<b>C=</b>Camera, <b>0-9=</b>Presets";
			player.upload.addEventListener(PlayerEvent.UPLOAD, onUpload);
			addChild(player);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, updateAlign);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError,false,int.MAX_VALUE);
			
			readTokens(stage.loaderInfo.parameters);
			
			updateAlign();			
		}

		private function readTokens(tokens:Object):void
		{
			for(var name:String in tokens)
			{
				var isTrue:Boolean = tokens[name] == "true";
				
				switch (name)
				{					
					case "player":
						player.visible = isTrue;
						break;
					
					case "tips":
						player.tips = tokens[name];
						break;
					
					case "upload":
						player.upload.visible = isTrue;
						break;
					
					case "repeat":
						repeatAnimation = isTrue;
						break;
					
					case "autoPlay":
						autoPlay = isTrue;
						break;										
					
					case "cameraController":
						enabledCameraController = isTrue;
						break;	
					
					case "camera":
						userDefaultCamera = tokens[name];
						break;
					
					case "status":
						player.status = isTrue;
						break;
					
					case "preset":
						setPreset(parseInt(tokens[name]));
						break;
					
					case "load":
						loadSEA3D(tokens[name]);
						break;
					
					default:
						throw new Error(name + " not is valid parameter.");
						break;
				}
			}			
		}
		
		private function load(data:ByteArray):void
		{
			player.markerVisible = false;			
			player.progress = 0;
			player.target = null;
			player.error = "";			
			
			// <gc>
			if (bridge) bridge.dispose();
			if (sea3d) sea3d.dispose();
			
			System.gc();
			// </gc>
			
			bridge = new Away3D();
			
			sea3d = new SEA3D(bridge);
			sea3d.addEventListener(SEAEvent.COMPLETE, onComplete);
			sea3d.addEventListener(SEAEvent.PROGRESS, onProgress);
			sea3d.load(data);	
		}
		
		private function loadSEA3D(url:String):void
		{
			player.logo.visible = false;
			player.upload.mouseChildren = player.upload.mouseEnabled = false;
			
			progressBar = new ProgressCircle();
			progressBar.progress = NaN;
			progressBar.text = "Download SEA3D";
			addChild(progressBar);
			
			loader = new URLLoader();
			
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onCompleteDownload);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgressDownload);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorDownload);
			loader.load(new URLRequest(url));						
		}
		
		private function onCompleteDownload(e:Event):void
		{
			load(loader.data as ByteArray);			
			loader = null;			
			completeLoad();
		}
		
		private function onProgressDownload(e:ProgressEvent):void
		{
			progressBar.progress = e.bytesLoaded / e.bytesTotal;
		}
		
		private function onErrorDownload(e:IOErrorEvent):void
		{
			completeLoad();
			throw e;			
		}
		
		private function completeLoad():void
		{
			player.logo.visible = true;
			player.upload.mouseChildren = player.upload.mouseEnabled = true;
			
			removeChild(progressBar);
			progressBar = null;
		}
		
		private function onUpload(e:PlayerEvent):void
		{
			load(player.upload.data);	
		}				
		
		private function onProgress(e:SEAEvent):void
		{			
			player.progress = sea3d.position / sea3d.length;			
		}
		
		private function onComplete(e:SEAEvent):void
		{
			if (defaultCamera) 
			{
				defaultCamera.dispose();
				defaultCamera = null;
			}
			
			player.markerVisible = true;
			player.progress = 0;
			player.tips = "";
			
			var camera:Camera3D;			
			if (bridge.camera.length > 0)
			{
				if (userDefaultCamera && bridge.getCamera(userDefaultCamera))
				{
					camera = bridge.getCamera(userDefaultCamera);
				}
				else
				{				
					camera = bridge.camera[0];
				}
			}
			
			setCamera(camera);
			
			if (!repeatAnimation) 
				bridge.player.repeat = false;
			
			player.target = bridge.player;			
			scene.addChild(bridge.container);
			
			if (autoPlay)
				player.state = PlayerState.PLAYING;
		}
		
		private function setCamera(camera:Camera3D=null):void
		{
			if (!camera)
			{
				var lens:PerspectiveLens = new PerspectiveLens();
				lens.far = bridge.shadowMap ? 1000 : 100000;
				lens.near = 1;
				
				if (!defaultCamera)
				{
					defaultCamera = new Camera3D(lens);
					defaultCamera.position = new Vector3D(150, 125, 150);
					defaultCamera.lookAt(new Vector3D());
				}
				
				camera = defaultCamera;
				camera.name = "DefaultCamera"
			}
			else
			{
				bridge.skeletonAnimation
			}
			
			player.camera = camera.name;
			
			if (controller) controller.dispose();
			
			view.camera = camera;	
			
			if (enabledCameraController) 
				controller = new FreeCameraController(camera, stage);
		}
		
		private function onUncaughtError(e:UncaughtErrorEvent):void
		{			
			var msg:String = "";
			
			if (e.error is Error)
			{
				msg = String((e.error as Error).message);
			}
			else if (e.error is ErrorEvent)
			{
				msg = String((e.error as ErrorEvent).text);
			}
			else
			{
				msg = String(e.error);
			}
			
			player.error = msg;
			e.preventDefault();			
		}
		
		private function onEnterFrame(e:Event):void
		{
			player.update();			
			view.render();
		}
		
		private function setPreset(value:int):void
		{
			var levels:LevelsFilter3D, colors:ColorBalanceFilter3D;
			
			switch(value)
			{
				case 0:
					view.filters3d = [];
					break;
				
				case 1:
					view.filters3d = [new BloomFilter3D(18,18,1,1,4)];
					break;
				
				case 2:		
					view.filters3d = [new BloomFilter3D(18,18,1,2,4)];			
					break;
				
				case 3:
					levels = new LevelsFilter3D();
					levels.rgb = new Point(.1,.9)
					view.filters3d = [levels];
					break;
				
				case 4:
					colors = new ColorBalanceFilter3D(true);
					colors.shadows = new Vector3D(-.2,-.1,.60);
					colors.midtones = new Vector3D(0,.2,0);
					colors.highlights = new Vector3D(.1,.1,.20);
					colors.amount = 1;
					view.filters3d = [colors];
					break;
				
				case 5:
					colors = new ColorBalanceFilter3D(true);
					colors.shadows = new Vector3D(0,0,0);
					colors.midtones = new Vector3D(0,0,0);
					colors.highlights = new Vector3D(.4,.3,0);
					colors.amount = 1;
					view.filters3d = [colors];
					break;
				
				case 6:
					view.filters3d = [new ColorMatrixFilter3D(new ColorMatrix(.2).filter)];
					break;
				
				case 7:
					view.filters3d = [new ColorMatrixFilter3D(new ColorMatrix(2).filter)];
					break;
				
				case 8:
					view.filters3d = [new MotionBlurFilter3D(.3)];
					break;
				
				case 9:
					view.filters3d = [new RadialBlurFilter3D(1, 1)];
					break;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.NUMBER_0:
					setPreset(0);
					break;
				
				case Keyboard.NUMBER_1:
					setPreset(1);
					break;
				
				case Keyboard.NUMBER_2:		
					setPreset(2);
					break;
				
				case Keyboard.NUMBER_3:
					setPreset(3);
					break;
				
				case Keyboard.NUMBER_4:
					setPreset(4);
					break;
				
				case Keyboard.NUMBER_5:
					setPreset(5);
					break;
				
				case Keyboard.NUMBER_6:
					setPreset(6);
					break;
				
				case Keyboard.NUMBER_7:
					setPreset(7);
					break;
				
				case Keyboard.NUMBER_8:
					setPreset(8);
					break;
				
				case Keyboard.NUMBER_9:
					setPreset(9);
					break;
				
				case Keyboard.C:					
					if (bridge.camera.length > 0)
					{
						var cameraIndex:int = bridge.camera.indexOf(view.camera);
						
						if (cameraIndex+1 == bridge.camera.length) setCamera();	
						else if (cameraIndex == -1) setCamera(bridge.camera[0]);
						else setCamera(bridge.camera[(cameraIndex+1) % bridge.camera.length]);
					}							
					break;
			}				
		}
		
		private function updateAlign(e:Event=null):void
		{
			if (progressBar)
			{
				progressBar.x = Math.round(stage.stageWidth/2);
				progressBar.y = Math.round(stage.stageHeight/2);
			}
			
			player.width = stage.stageWidth;
			player.height = stage.stageHeight;
			
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			
			view.render();
		}
	}
}