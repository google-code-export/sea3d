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
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	import away3d.filters.BloomFilter3D;
	import away3d.filters.ColorBalanceFilter3D;
	import away3d.filters.ColorMatrixFilter3D;
	import away3d.filters.LevelsFilter3D;
	import away3d.filters.MotionBlurFilter3D;
	import away3d.filters.RadialBlurFilter3D;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import sunag.controller.FreeCameraController;
	import sunag.display.BlackSprite;
	import sunag.filters.ColorMatrix;
	import sunag.player.PlayerEvent;
	import sunag.player.PlayerState;
	import sunag.progressbar.ProgressCircleLoader;
	import sunag.sea.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.away3d.Away3D;
	import sunag.sea3d.player.Player;
	import sunag.ui.away3d.ArgumentRealityAway3D;
	import sunag.utils.MathHelper;
	
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class Main extends Sprite
	{
		private var player:Player;		
		private var bridge:Away3D;
		private var sea3d:SEA3D;
		private var scene:Scene3D;
		private var view:View3D;
		private var controller:FreeCameraController;
		private var defaultCamera:Camera3D;
		private var progressBar:ProgressCircleLoader;
		private var argumentReality:ArgumentRealityAway3D;
		private var lastCamera:Camera3D;
		private var bs:BlackSprite = new BlackSprite();
		
		private var actualCamera:String = "";
		private var autoPlay:Boolean = false;
		private var enabledCameraController:Boolean = true;
		private var repeatAnimation:Boolean = true;
		private var defaultLight:PointLight;
		
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
			
			defaultLight = new PointLight();
			defaultLight.position = new Vector3D(100000,100000,100000);
			defaultLight.ambient = 1;
			defaultLight.ambientColor = 0xFFFFFF;
			defaultLight.diffuse = 1;			
			
			player = new Player();
			player.tips = "<b>C=</b>Camera, <b>0-9=</b>Presets";
			player.upload.addEventListener(PlayerEvent.UPLOAD, onUpload);
			player.ar.addEventListener(Event.CHANGE, onARChange);
			addChild(player);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, updateAlign);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			if (ExternalInterface.available)
			{				
				ExternalInterface.addCallback("browserURLChange", onBrowserURLChange);
			}
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError,false,int.MAX_VALUE);
			
			readTokens(stage.loaderInfo.parameters);									
			
			updateAlign();		
		}
		
		private function onBrowserURLChange(url:String):void
		{
			trace(url);
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
						actualCamera = tokens[name];
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
			lastCamera = null;
			
			System.gc();
			// </gc>
			
			// <BlackScreen>
			if (argumentReality)
			{
				stage.addChildAt(bs, 0);
				bs.alpha = .5;
				updateBS();
			}
			// </BlackScreen>
			
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
			
			progressBar = new ProgressCircleLoader();
			progressBar.text = "Loading SEA3D";			
					
			progressBar.loader.addEventListener(Event.COMPLETE, onCompleteDownload);
			progressBar.loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorDownload);
			progressBar.load(new URLRequest(url), stage);						
		}
			
		private function initAR():void
		{
			argumentReality = new ArgumentRealityAway3D(stage);	
			argumentReality.width = player.width;
			argumentReality.height = player.height;
			argumentReality.references = Vector.<ByteArray>([progressBar.data]);
			argumentReality.addEventListener(Event.COMPLETE, onARComplete);
			argumentReality.init();
			
			view.background = argumentReality.texture;
			
			player.ar.mouseChildren = player.ar.mouseEnabled = false;
		}
		
		private function applyAR():void
		{
			player.offset = new Point(80);
			
			view.camera = new Camera3D(argumentReality.lens);
			
			if (bridge)
			{
				if (bridge.getEnvironment())			
					bridge.container.removeChild(bridge.getEnvironment());
			}
		}
		
		private function disposeAR():void
		{
			player.offset = new Point();
			
			argumentReality.dispose();
			argumentReality = null;
							
			view.background = null;		
						
			if (bridge)
			{				
				bridge.container.visible = true;
				bridge.container.transform = new Matrix3D();
				
				view.camera = lastCamera || getDefaultCamera(); 
				
				if (bridge.getEnvironment())		
					bridge.container.addChild(bridge.getEnvironment());
			}
			else 
			{
				view.camera = getDefaultCamera();	
			}						
		}
		
		private function onARComplete(e:Event):void
		{
			argumentReality.removeEventListener(Event.COMPLETE, onARComplete);
			
			player.ar.mouseChildren = player.ar.mouseEnabled = true;
			
			applyAR();			
		}
		
		private function onARCompleteDownload(e:Event):void
		{
			progressBar.loader.removeEventListener(Event.COMPLETE, onARCompleteDownload);			
						
			initAR();
									
			progressBar.dispose();
			progressBar = null;
		}
		
		private function onCompleteDownload(e:Event):void
		{
			load(progressBar.data);				
			completeLoad();
		}
		
		private function onErrorDownload(e:IOErrorEvent):void
		{
			completeLoad();
			throw e;			
		}
		
		private function completeLoad():void
		{
			progressBar.loader.removeEventListener(Event.COMPLETE, onCompleteDownload);
			progressBar.loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorDownload);
						
			player.logo.visible = true;
			player.upload.mouseChildren = player.upload.mouseEnabled = true;
						
			progressBar.dispose();
			progressBar = null;
		}
		
		private function onARChange(e:Event):void
		{
			if (!Camera.isSupported)
			{
				player.error = "Camera is not supported.";
				e.preventDefault();
				return;
			}
			else if (Camera.names.length == 0)
			{
				player.error = "No camera found.";
				e.preventDefault();
				return;
			}
			
			if (player.ar.selected)
			{
				progressBar = new ProgressCircleLoader();
				progressBar.text = "Loading Argument Reality";				
				
				progressBar.loader.addEventListener(Event.COMPLETE, onARCompleteDownload);
				progressBar.load(new URLRequest("ass/def_data.ass"), stage);		
								
				player.logo.visible = false;								
			}
			else
			{
				disposeAR();
			}
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
			// Remove BlackScreen
			if (stage.contains(bs))
				stage.removeChild(bs);
			
			// Add light if necessary
			if (bridge.light.length == 0)
			{
				(bridge.lightPicker as StaticLightPicker).lights = [defaultLight];
				bridge.container.addChild(defaultLight);
			}			
			
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
				if (actualCamera && bridge.getCamera(actualCamera))
				{
					camera = bridge.getCamera(actualCamera);
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
			
			if (argumentReality)
				applyAR();
		}
		
		private function setCamera(camera:Camera3D=null):void
		{
			if (!camera)
			{
				if (!defaultCamera)
				{
					defaultCamera = getDefaultCamera();
					
					if (bridge.shadowMap) 
						defaultCamera.lens.far = 1000;
				}
				
				camera = defaultCamera;				
			}
			
			player.camera = camera.name;
			
			if (controller) controller.dispose();
			
			view.camera = lastCamera = camera;	
			
			if (enabledCameraController) 
				controller = new FreeCameraController(camera, stage);
		}
		
		private function getDefaultCamera():Camera3D
		{
			var lens:PerspectiveLens = new PerspectiveLens();
			lens.far = 100000;
			lens.near = 1;
			
			var cam:Camera3D = new Camera3D(lens);
			cam.name = "DefaultCamera";
			cam.position = new Vector3D(150, 125, 150);
			cam.lookAt(new Vector3D());
			
			return cam;
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
			if (argumentReality && argumentReality.completed)
			{
				argumentReality.container.lost();
				
				if (bridge)
				{
					bridge.container.transform = argumentReality.container.transform;
					bridge.container.visible = argumentReality.container.visible; 								
				}
				
				argumentReality.update();
			}
			
			if (controller)			
				controller.update();			
			
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
					view.filters3d = [new BloomFilter3D(18,18,.9,1,4)];
					break;
				
				case 2:		
					levels = new LevelsFilter3D();
					levels.rgb = new Point(0.1,1)
					view.filters3d = [levels];	
					break;	
				
				case 3:
					levels = new LevelsFilter3D();
					levels.rgb = new Point(.1,.9);
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
				case Keyboard.SPACE:
					if (argumentReality == null && bridge.camera.length > 0)
					{
						var cameraIndex:int = bridge.camera.indexOf(view.camera);
						
						if (cameraIndex+1 == bridge.camera.length) setCamera();	
						else if (cameraIndex == -1) setCamera(bridge.camera[0]);
						else setCamera(bridge.camera[(cameraIndex+1) % bridge.camera.length]);
					}							
					break;
			}				
		}
		
		private function updateBS():void
		{
			bs.width = stage.stageWidth;
			bs.height = stage.stageHeight;
		}
		
		private function updateAlign(e:Event=null):void
		{			
			if (bs.parent)
				updateBS();
			
			player.width = stage.stageWidth;
			player.height = stage.stageHeight;
			
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			
			view.render();
		}
	}
}