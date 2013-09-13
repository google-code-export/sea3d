package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.LayeredDiffuseMethod;
	import away3d.materials.methods.LayeredTexture;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import sunag.animation.AnimationPlayer;
	import sunag.events.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.config.DefaultConfig;
	
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class MultilayerStudioAnimated extends Sprite
	{
		private var view:View3D;
		private var scene:Scene3D;
		private var sea3d:SEA3D;
		private var player:AnimationPlayer;
		
		public function MultilayerStudioAnimated()
		{
			/**
			 * Basic config.
			 * */
			
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
			 * Play All Animation 
			 * */			
			
			player = new AnimationPlayer();
			
			// play root animation
			player.play();
			
			/**
			 * Config
			 * */			
			
			var config:DefaultConfig = new DefaultConfig();
			config.player = player;
			
			/**
			 * <sea3d.container> contains all elements loaded.
			 * add objects in scene container
			 * */
			
			scene.addChild(config.container = new ObjectContainer3D());
			
			/**
			 * Init loader
			 * */			
			
			sea3d = new SEA3D(config);
					
			sea3d.addEventListener(SEAEvent.COMPLETE, onComplete);			
			sea3d.load(new URLRequest("../assets/LayeredTexture.sea"));
		}
		
		private function onEnterFrame(e:Event):void
		{		
			/**
			 * Interaction
			 * */
			
			view.render();
		}
		
		private function onComplete(e:SEAEvent):void
		{
			/**
			 * <Camera001> Camera contained in MAX file.
			 * <sea3d.get...> Using for get element.			 
			 * */						
			
			view.camera = sea3d.getCamera("Camera001");
						
			/**
			 * Start render and update.
			 * */
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}