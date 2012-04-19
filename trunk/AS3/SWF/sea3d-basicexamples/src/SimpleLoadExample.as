/** 
 * Copyright (C) 2012 Sunag Entertainment
 * */

package
{
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.System;
	
	import sunag.sea.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.away3d.Away3D;
	
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class SimpleLoadExample extends Sprite
	{
		private var view:View3D;
		private var scene:Scene3D;
		private var loader:SEA3D;
		private var bridge:Away3D;
		
		[Embed (source="../assets/SimpleScene.sea",mimeType="application/octet-stream")]
		private var SimpleScene:Class;
		
		public function SimpleLoadExample()
		{
			/**
			 * Basic config.
			 * */
			
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
			addChild(new AwayStats(view));
			
			/**
			 * Init loader for Away3D.
			 * */			
			
			bridge = new Away3D();
						
			/**
			 * Alternative config
			 * */
			
			//bridge.ambient = 0x00;
			//bridge.enabledShadow = false;
			
			loader = new SEA3D(bridge);
			
			/**
			 * <SEAEvent.COMPLETE> Called when the file was loaded completely.
			 * <SEAEvent.PROGRESS> Called when the file is progressing.
			 * */
			
			loader.addEventListener(SEAEvent.COMPLETE, onComplete);
			loader.addEventListener(SEAEvent.PROGRESS, onProgress);
			
			/**
			 * Start load.
			 * */
			
			loader.load(new SimpleScene());						
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (loader.loaded) {
				// Custom Code
				
				/**
				 * <player.updateTime> Update in real-time animation using linear interpolation.
				 * <timeScale=1> 1 is the real time. -1 is a reverse time.
				 * 
				 * <OR> get/set actual frame, time or animation position.
				 * */
				
				var timeScale:Number = stage.mouseX - (stage.stageWidth/2);				
				timeScale /= stage.stageWidth/8;
												
				bridge.player.updateTime(timeScale);
									
				/**
				 * Type 1: Using time delta
				 * */
				//bridge.player.updateTime(1);				
				//trace(bridge.player.time);				
				
				/**
				 * Type 2: Using frame rate
				 * */
				//bridge.player.frame++;
				//trace(bridge.player.frame);
				
				/**
				 * Type 3: Using position animation
				 * */
				//bridge.player.position++;
				//trace(bridge.player.position);
				
				/**
				 * <player.update> Update animation
				 * */
				
				bridge.player.update();
			}
			
			view.render();
		}
		
		private function onProgress(e:SEAEvent):void
		{
			/**
			 * Trace progress 0 at 1.		 
			 * */
			trace("LoadProgress:", loader.position / loader.length);
		}
		
		private function onComplete(e:SEAEvent):void
		{
			/**
			 * Examples: Acessing data		 
			 * */
			
			trace("MeshCount:", bridge.mesh.length);
			trace("GetMesh:", bridge.getMesh("Box001"));
			trace("GetLight:", bridge.getLight("Direct001"));
						
			/**
			 * <Camera001> Camera contained in MAX file.
			 * <bridge.get...> Using for get element.			 
			 * */
			
			view.camera = bridge.getCamera("Camera001");
			
			/**
			 * <bridge.container> contains all elements loaded.
			 * add objects in scene container
			 * */
			
			scene.addChild(bridge.container);
			
			/**
			 * Start render and update.
			 * */
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}