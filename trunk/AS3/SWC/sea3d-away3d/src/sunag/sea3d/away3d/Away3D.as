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

package sunag.sea3d.away3d
{
	import away3d.animators.SmoothSkeletonAnimator;
	import away3d.animators.data.SkeletonAnimation;
	import away3d.animators.data.SkeletonAnimationSequence;
	import away3d.animators.data.SkeletonAnimationState;
	import away3d.animators.skeleton.JointPose;
	import away3d.animators.skeleton.Skeleton;
	import away3d.animators.skeleton.SkeletonJoint;
	import away3d.animators.skeleton.SkeletonPose;
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.materials.ColorMaterial;
	import away3d.materials.DefaultMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.materials.methods.TerrainDiffuseMethod;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import sunag.sea.SEAObject;
	import sunag.sea3d.SEAAnimation;
	import sunag.sea3d.SEABitmap;
	import sunag.sea3d.SEACameraFree;
	import sunag.sea3d.SEACameraTarget;
	import sunag.sea3d.SEAEnvironment;
	import sunag.sea3d.SEAHelper;
	import sunag.sea3d.SEALight;
	import sunag.sea3d.SEALightFree;
	import sunag.sea3d.SEALightPoint;
	import sunag.sea3d.SEALightTarget;
	import sunag.sea3d.SEAMaterial;
	import sunag.sea3d.SEAMesh;
	import sunag.sea3d.SEASkeletonAnimation;
	import sunag.sea3d.SEASkeletonMesh;
	import sunag.sea3d.SEATexture;
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.away3d.animation.CameraFreeAnimation;
	import sunag.sea3d.away3d.animation.CameraTargetAnimation;
	import sunag.sea3d.away3d.animation.HelperAnimation;
	import sunag.sea3d.away3d.animation.LightPointAnimation;
	import sunag.sea3d.away3d.animation.LightTargetAnimation;
	import sunag.sea3d.away3d.animation.MeshAnimation;
	import sunag.sea3d.away3d.animation.SkeletonMeshAnimation;
	import sunag.sea3d.away3d.animation.TextureAnimation;
	import sunag.sea3d.away3d.entities.Helper;
	import sunag.sea3d.bridge.Bridge;
	import sunag.sea3d.mesh.SubMesh;
	import sunag.sea3d.mesh.UVData;
	import sunag.sea3d.mesh.UVIndex;
	import sunag.sea3d.skeleton.animation.BaseFrameData;
	import sunag.sea3d.skeleton.animation.FrameData;
	import sunag.sea3d.skeleton.animation.HierarchyData;
	import sunag.sea3d.skeleton.mesh.JointData;
	import sunag.sea3d.skeleton.mesh.VertexData;
	import sunag.sea3d.skeleton.mesh.WeightData;
	import sunag.sea3d.texture.Layer;
	import sunag.sea3d.texture.LayerBitmap;
	import sunag.utils.MathHelper;

	public class Away3D extends Bridge
	{
		private var _typeFunction:Array = [];
		private var _container:ObjectContainer3D = new ObjectContainer3D();
		private var _object:Object = {};				
		private var _lightPicker:StaticLightPicker = new StaticLightPicker([]);
		private var _shadow:ShadowMapMethodBase;
		private var _ambient:Number = .2;	
		private var _enabledShadow:Boolean = true;
		
		private var _rotationQuat:Quaternion = (function():Quaternion
		{
			var quat:Quaternion = new Quaternion();
			
			var t1 : Quaternion = new Quaternion();
			var t2 : Quaternion = new Quaternion();
			
			t1.fromAxisAngle(Vector3D.X_AXIS, 90 * MathHelper.RADIANS);
			t2.fromAxisAngle(Vector3D.Y_AXIS, 180 * MathHelper.RADIANS);
			
			quat.multiply(t2, t1);
			
			return quat;
		})();
		
		private var _whiteTexture:BitmapTexture = new BitmapTexture(new BitmapData(2, 2, false, 0xFFFFFF));

		private var _bitmap:Vector.<BitmapData> = new Vector.<BitmapData>();
		private var _camera:Vector.<Camera3D> = new Vector.<Camera3D>();
		private var _mesh:Vector.<Mesh> = new Vector.<Mesh>();
		private var _cubemap:Vector.<BitmapCubeTexture> = new Vector.<BitmapCubeTexture>();
		private var _material:Vector.<DefaultMaterialBase> = new Vector.<DefaultMaterialBase>();
		private var _texture:Vector.<BitmapTexture> = new Vector.<BitmapTexture>();
		private var _light:Vector.<LightBase> = new Vector.<LightBase>();
		private var _skeletonAnimation:Vector.<SkeletonAnimationSequence> = new Vector.<SkeletonAnimationSequence>();
		private var _animation:Vector.<Animation> = new Vector.<Animation>();
		private var _composite:Vector.<TerrainDiffuseMethod> = new Vector.<TerrainDiffuseMethod>();
		private var _helper:Vector.<Helper> = new Vector.<Helper>();
		
		public function get shadowMap():ShadowMapMethodBase
		{
			return _shadow;
		}
		
		public function get bitmap():Vector.<BitmapData>
		{
			return _bitmap;
		}
		
		public function get helper():Vector.<Helper>
		{
			return _helper;
		}
		
		public function get composite():Vector.<TerrainDiffuseMethod>
		{
			return _composite;
		}
		
		public function get animation():Vector.<Animation>
		{
			return _animation;
		}
		
		public function get skeletonAnimation():Vector.<SkeletonAnimationSequence>
		{
			return _skeletonAnimation;
		}
		
		public function get light():Vector.<LightBase>
		{
			return _light;
		}
		
		public function get texture():Vector.<BitmapTexture>
		{
			return _texture;
		}
		
		public function get material():Vector.<DefaultMaterialBase>
		{
			return _material;
		}
		
		public function get cubemap():Vector.<BitmapCubeTexture>
		{
			return _cubemap;
		}
		
		public function get mesh():Vector.<Mesh>
		{
			return _mesh;
		}
		
		public function get camera():Vector.<Camera3D>
		{
			return _camera;
		}						
		
		public function Away3D()
		{
			_typeFunction[SEABitmap.TYPE] = readBitmap;
			_typeFunction[SEATexture.TYPE] = readTexture;
			_typeFunction[SEAMaterial.TYPE] = readMaterial;
			_typeFunction[SEAAnimation.TYPE] = readAnimation;
			_typeFunction[SEASkeletonMesh.TYPE] = readSkeletonMesh;
			_typeFunction[SEASkeletonAnimation.TYPE] = readSkeletonAnimation
			_typeFunction[SEAMesh.TYPE] = readMesh;					
			_typeFunction[SEACameraFree.TYPE] = readCameraFree;
			_typeFunction[SEACameraTarget.TYPE] = readCameraTarget;			
			_typeFunction[SEALightFree.TYPE] = readLightFree;
			_typeFunction[SEALightTarget.TYPE] = readLightTarget;
			_typeFunction[SEALightPoint.TYPE] = readLightPoint;
			_typeFunction[SEAEnvironment.TYPE] = readEnvironment;
			_typeFunction[SEAHelper.TYPE] = readHelper;
		}
				
		public function containsObject(name:String):Boolean
		{
			return _object[name] != null;
		}
		
		public function getObject(name:String):*
		{
			return _object[name];
		}
		
		public function getCamera(name:String):Camera3D
		{
			return getObject("camera/"+name);
		}
		
		public function getEnvironment():SkyBox
		{
			return getObject("environment/background");
		}
		
		public function getLight(name:String):LightBase
		{
			return getObject("light/"+name);
		}
		
		public function getCubeMap(name:String):BitmapCubeTexture
		{
			if (!getObject("cubemap/"+name))
			{
				readCubeMap(getSEABitmap(name));
			}			
			
			return getObject("cubemap/"+name);
		}
		
		public function getBitmapTexture(name:String):BitmapTexture
		{
			return getObject("bitmap/"+name);
		}
		
		public function getTexture(name:String):*
		{
			return getObject("texture/"+name);
		}
		
		public function getMaterial(name:String):TextureMaterial
		{
			return getObject("material/"+name);
		}
		
		public function getMesh(name:String):Mesh
		{
			return getObject("mesh/"+name);
		}
		
		public function getAnimation(name:String):Animation
		{
			return getObject("animation/"+name);
		}
		
		public function getSkeletonAnimation(name:String):SkeletonAnimationSequence
		{
			return getObject("skeleton-animation/"+name);
		}
		
		public function get container():ObjectContainer3D
		{
			return _container;
		}		
		
		public override function read(sea:SEAObject):void
		{			
			super.read(sea);
			_typeFunction[sea.type](sea);						
		}
		
		public function getColorMaterial(color:uint):ColorMaterial
		{
			var mat:ColorMaterial = new ColorMaterial(color);			
			mat.lightPicker = _lightPicker;
			mat.ambientColor = 0xFFFFFF;
			mat.ambient = _ambient;
			mat.shadowMethod = _shadow;
			_material.push(mat);
			return mat;
		}
		
		private function readLightMap(layers:Vector.<Layer>, mat:TextureMaterial):void
		{
			for each(var layer:Layer in layers)
			{				
				mat.addMethod
				(						
					new LightMapMethod
					(
						getBitmapTexture(layer.texture.name), 
						layer.blendMode === 1 ?  LightMapMethod.ADD : LightMapMethod.MULTIPLY,
						layer.texture.channel == 1
					)
				);
			}
		}
		
		private function readCubeMap(sea:SEABitmap):void
		{	
			var cubemap:BitmapCubeTexture;
			
			if (sea.isCubemap)
			{
				cubemap = new BitmapCubeTexture
					(
						// Horizontal Strip (OPEN-GL)
						sea.getCubeMapBitmapData(0),
						sea.getCubeMapBitmapData(1),
						sea.getCubeMapBitmapData(2),
						sea.getCubeMapBitmapData(3),
						sea.getCubeMapBitmapData(4),
						sea.getCubeMapBitmapData(5)
						
						/* Horizontal Strip Standard
						sea.getCubeMapBitmapData(0),
						sea.getCubeMapBitmapData(2),
						sea.getCubeMapBitmapData(4),
						sea.getCubeMapBitmapData(5),
						sea.getCubeMapBitmapData(3),
						sea.getCubeMapBitmapData(1)
						*/
					);				
			}
			else
			{
				throw new Error("Invalid CubeMap.");
			}
					
			cubemap.name = sea.name;
			
			_cubemap.push(_object["cubemap/"+sea.name] = cubemap);
		}
		
		public function readMaterial(sea:SEAMaterial):void
		{
			var mat:TextureMaterial = new TextureMaterial();
						
			mat.repeat = true;
			mat.shadowMethod = _shadow;
			mat.name = sea.name;			
			mat.smooth = sea.smooth;
			mat.lightPicker = _lightPicker;			
			mat.alpha = sea.opacity;
			mat.bothSides = sea.bothSides;						
			mat.gloss = sea.gloss;
			mat.specularColor = sea.specularColor;
			mat.specular = sea.specular / 100;
			mat.ambient = _ambient;			
			mat.ambientColor = 0xFFFFFF;
			
			if (sea.diffuseMap)
			{					
				var diffuseMap:* = getTexture(sea.diffuseMap);
				
				if (diffuseMap is BasicDiffuseMethod)
				{
					mat.texture = getBitmapTexture(getSEATexture(sea.diffuseMap).texture.name);					
					mat.diffuseMethod = diffuseMap;
				}
				else if (diffuseMap is BitmapTexture)
				{
					mat.texture = diffuseMap;
				}
				
				readLightMap(getSEATexture(sea.diffuseMap).lightMap, mat);
				
				mat.repeat = getSEATexture(sea.diffuseMap).isRepeat;
				mat.alphaBlending = getSEATexture(sea.diffuseMap).isTransparent;
				
				if (mat.alphaBlending)
				{
					if (!sea.opacityMap && sea.opacityMapAmount > 0)
					{
						mat.alphaThreshold = sea.opacityMapAmount;
					}
					else mat.alphaThreshold = .5;
				}
			}
			else
			{
				mat.diffuseMethod.diffuseColor = sea.diffuse;
			}
			
			if (sea.specularMap)
			{
				mat.specularMap = getTexture(sea.specularMap);									
			}
			
			if (sea.reflectionMap)
			{
				if (sea.fresnel)
				{
					var fresnelMap:FresnelEnvMapMethod = new FresnelEnvMapMethod(getCubeMap(getSEATexture(sea.reflectionMap).texture.name), sea.reflectionMapAmount);
					fresnelMap.fresnelPower = sea.fresnelPower;			
					mat.addMethod(fresnelMap);
				}	
				else
				{
					mat.addMethod(new EnvMapMethod(getCubeMap(getSEATexture(sea.reflectionMap).texture.name), sea.reflectionMapAmount));
				}
			}
			else if (sea.fresnel)
			{
				var rimLight:RimLightMethod = new RimLightMethod(sea.fresnelColor, sea.fresnelAmount, sea.fresnelPower, RimLightMethod.MIX);
				mat.addMethod(rimLight);
			}
			
			var normalMap:String = sea.bumpMap;
			if (!normalMap) normalMap = sea.normalMap;
			
			if (normalMap)
			{				
				mat.normalMap = getTexture(normalMap);
			}																				
			
			if (sea.selfIllumColor > 0)
			{
				mat.blendMode = BlendMode.ADD;
				mat.ambientColor = 0xFFFFFF;
				mat.diffuseMethod.diffuseColor = sea.selfIllumColor;
				mat.ambient = 1;				
				mat.lightPicker = null;
			}
			else if (sea.selfIllumAmount > 0)
			{
				mat.ambient = sea.selfIllumAmount;				
				if (sea.diffuseMap) mat.ambientColor = 0xFFFFFF;
				else mat.ambientColor = sea.diffuse;
			}
			
			_material.push(_object[sea.ns] = mat);
		}				
		
		private function readTextureBlending(sea:SEATexture):TerrainDiffuseMethod
		{
			var textureData:Array = [];
			var tileData:Array = [];
			var opacityData:Array = [1];
			
			var i:int;
			var blending:BitmapTexture, layer:Layer;			
			
			
			// Blending Map			
			tileData.push((sea.texture.scaleU + sea.texture.scaleV)/2);
						
			for(i=0;i<sea.layer.length;i++)
			{
				layer = sea.layer[i];
				
				if (layer.mask && layer.blendMode === 0)
				{
					textureData.push(getBitmapTexture(layer.texture.name));
					tileData.push((layer.texture.scaleU + layer.texture.scaleV)/2);
					opacityData.push(layer.opacity);
					
					if (!blending)
					{
						blending = getBitmapTexture(layer.mask.name);
					}
				}
			}
			
			if (!blending)
			{
				blending = _whiteTexture;
			}
			
			var diffuse:TerrainDiffuseMethod = new TerrainDiffuseMethod(textureData, blending, tileData);
			
			// shift Main Texture Tile Data			
			tileData.shift();
			
			
			// Detail Map			
			if (sea.detailMap.length > 0)
			{
				layer = sea.detailMap[0];
				
				tileData.push((layer.texture.scaleU + layer.texture.scaleV)/2);		
				opacityData.push(layer.opacity);
				diffuse.setDetailTexture(getBitmapTexture(layer.texture.name), tileData, opacityData);
			}
			else
			{
				diffuse.setDetailTexture(null, tileData, opacityData);
			}		
			
			return diffuse;
		}		
		
		public function readTexture(sea:SEATexture):void
		{			
			if (sea.isMultimap || sea.detailMap.length > 0)
			{																	
				_composite.push(_object[sea.ns] = readTextureBlending(sea));
			}
			else
			{
				_texture.push(_object[sea.ns] = getBitmapTexture(sea.texture.name));
			}
		}
		
		public function readAnimation(sea:SEAAnimation):void
		{
			_animation.push(_object[sea.ns] = new Animation(sea.sequence));
		}
		
		public function readSkeletonAnimation(sea:SEASkeletonAnimation):void
		{
			var seq:SkeletonAnimationSequence = new SkeletonAnimationSequence(sea.name);
			
			for (var i : int = 0; i < sea.numFrames; ++i)
			{
				seq.arcane::addFrame(skeletonAnimationTranslatePose(sea, sea.frameData[i]), 1000 / sea.frameRate);
			}
			
			_skeletonAnimation.push(_object[sea.ns] = seq);
		}
		
		private function skeletonAnimationTranslatePose(sea:SEASkeletonAnimation, frameData:FrameData) : SkeletonPose
		{
			var hierarchy : HierarchyData;
			var pose : JointPose;
			var base : BaseFrameData;
			var flags : int;
			var j : int;
			var translate:Vector3D = new Vector3D();
			var orientation:Quaternion = new Quaternion();
			var components:Vector.<Number> = frameData.components;
			var skelPose:SkeletonPose = new SkeletonPose();
			var jointPoses:Vector.<JointPose> = skelPose.jointPoses;
			
			for (var i : int = 0; i < sea.numJoints; ++i) {
				j = 0;
				pose = new JointPose();
				hierarchy = sea.hierarchy[i];
				base = sea.baseFrameData[i];
				flags = hierarchy.flags;
				translate.x = base.position.x;
				translate.y = base.position.y;
				translate.z = base.position.z;
				orientation.x = base.orientation.x;
				orientation.y = base.orientation.y;
				orientation.z = base.orientation.z;
				
				if (flags & 1) translate.x = components[hierarchy.startIndex + (j++)];
				if (flags & 2) translate.y = components[hierarchy.startIndex + (j++)];
				if (flags & 4) translate.z = components[hierarchy.startIndex + (j++)];
				if (flags & 8) orientation.x = components[hierarchy.startIndex + (j++)];
				if (flags & 16) orientation.y = components[hierarchy.startIndex + (j++)];
				if (flags & 32) orientation.z = components[hierarchy.startIndex + (j++)];
				
				var w : Number = 1 - orientation.x * orientation.x - orientation.y * orientation.y - orientation.z * orientation.z;
				orientation.w = w < 0 ? 0 : -Math.sqrt(w);
								
				if (hierarchy.parentIndex < 0) {
					pose.orientation.multiply(_rotationQuat, orientation);
					pose.translation = _rotationQuat.rotatePoint(translate);
				}
				else {
					pose.orientation.copyFrom(orientation);
					pose.translation.x = translate.x;
					pose.translation.y = translate.y;
					pose.translation.z = translate.z;
				}
				
				jointPoses[i] = pose;
			}
			
			return skelPose;
		}
		
		public function readBitmap(sea:SEABitmap):void
		{
			var texture:BitmapTexture = new BitmapTexture(sea.getPowerOfTwoBitmapData());
			texture.name = sea.name;
			_object[sea.ns] = texture;
		}
		
		private function readMeshAnimationUV(subMesh:away3d.core.base.SubMesh, name:String):void
		{
			var mat:SEAMaterial = getSEAMaterial(name);
			
			if (mat)
			{
				var tex:SEATexture = getSEATexture(mat.diffuseMap);
				
				if (tex && tex.layer.length > 0)
				{
					var layer:LayerBitmap = tex.texture;
					
					if (layer.animation)
					{		
						var textureAnimation:TextureAnimation = new TextureAnimation(subMesh, getAnimation(layer.animation).cloneData(), layer.offsetU, layer.offsetV, layer.scaleU, layer.scaleV, layer.rotation);
					
						getMaterial(name).animateUVs = true;
						addAnimation(textureAnimation, layer.animation);
					}
				}
			}
		}
						
		public function readMesh(sea:SEAMesh):void
		{
			var i:int, geo:Geometry, mesh:Mesh, anmMaterial:String, mat:String;
			
			if (sea.instance)
			{					
				var instMesh:Mesh = getMesh(sea.instance);
				var instSEAMesh:SEAMesh = getSEAMesh(sea.instance);
				
				mesh = new Mesh(instMesh.geometry);
				
				if (sea.sameMaterial)
				{
					for(i=0;i<instMesh.subMeshes.length;i++)
					{
						mesh.subMeshes[i].material = instMesh.subMeshes[i].material;
						readMeshAnimationUV(mesh.subMeshes[i], instSEAMesh.subMesh[i].material);		
					}
				}
			}
			else 
			{
				geo = new Geometry();	
				
				for(i=0;i<sea.subMesh.length;i++)
				{
					geo.addSubGeometry(buildSubMesh(sea.subMesh[i], sea.vertex, sea.normal, sea.uv));
				}
				
				mesh = new Mesh(geo);			
			}
						
			mesh.castsShadows = sea.castShadows;			
			mesh.name = sea.name;				
						
			// Apply material
			if (!sea.sameMaterial)
			{
				for(i=0;i<mesh.subMeshes.length;i++)
				{
					mat = sea.subMesh[i].material;
					
					if (mat)
					{
						mesh.subMeshes[i].material = getMaterial(mat);						
						readMeshAnimationUV(mesh.subMeshes[i], mat);						
					}
					else
					{
						mesh.subMeshes[i].material = getColorMaterial(sea.color);
					}
				}
			}						
			
			mesh.position = sea.position;												
			mesh.rotation = sea.rotation;			
			mesh.scale = sea.scale;
						
			_container.addChild(mesh);
									
			_mesh.push(_object[sea.ns] = mesh);
			
			if (sea.animation) 
			{
				addAnimation(new MeshAnimation(mesh, getAnimation(sea.animation).cloneData(), sea.position, sea.rotation, sea.scale), sea.animation);
			}
		}				
		
		public function buildSubMesh(subMesh:sunag.sea3d.mesh.SubMesh, vertex:Vector.<Number>, normal:Vector.<Number>, uvData:Vector.<UVData>):SubGeometry
		{
			var subGeo:SubGeometry = new SubGeometry();
									
			var indexData:Vector.<uint> = new Vector.<uint>();
			var verts:Vector.<Number> = new Vector.<Number>();
			var norms:Vector.<Number> = normal ? new Vector.<Number>() : null;			
			var uvs:Array = [];			
			var cacheIndex:Array = [];
			var indexAt:uint = 0;
			
			var i:int, j:int;
			
			for(i=0;i<uvData.length;i++)			
			{
				uvs[i] = new Vector.<Number>();
			}
			
			var vertexIndex:Vector.<uint> = subMesh.vertexIndex;		
			var uvIndex:Vector.<UVIndex> = subMesh.uvIndex;	
			
			for(i=0;i<vertexIndex.length;i++)
			{							
				// BuildID
				var id:String = vertexIndex[i].toString();
								
				for(j=0;j<uvIndex.length;j++) {
					id += "/" + uvIndex[j].data[i];
				}
								
				if (!cacheIndex[id])
				{		
					// AddInCache <Smooth Object>
					cacheIndex[id] = indexAt;
					
					// Vertex
					var index:uint = vertexIndex[i] * 3;										
					verts.push(vertex[index], vertex[index+1], vertex[index+2]);
					
					// UVs
					for(j=0;j<uvIndex.length;j++) {
						var indexUV:uint = uvIndex[j].data[i] * 2;									
						uvs[j].push(uvData[j].data[indexUV], uvData[j].data[indexUV+1]);	
					}
					
					// Normals
					if (norms) 
						norms.push(normal[index], normal[index+1], normal[index+2]);
															
					// Index
					indexData.push(indexAt++);			
				}
				else
				{
					indexData.push(cacheIndex[id]);
				}
			}
				
			subGeo.autoDeriveVertexNormals = norms == null;
			subGeo.autoDeriveVertexTangents = true;
			
			subGeo.updateVertexData(verts);
			subGeo.updateIndexData(indexData);			
			subGeo.updateUVData(uvs[0]);
			if (uvs.length > 1) 
				subGeo.updateSecondaryUVData(uvs[1]);	
			if (norms) subGeo.updateVertexNormalData(norms);
			
			return subGeo;
		}
		
		private function readSkeletonMesh(sea:SEASkeletonMesh):void
		{
			var i:int;
			var skeleton:Skeleton = new Skeleton();
			var bindPoses:Vector.<Matrix3D> = meshSkeletonJoints(sea, skeleton);
															
			var geometry:Geometry = new Geometry();			
			for (i=0;i<sea.numMeshes;++i) 
			{
				geometry.addSubGeometry(skeletonMesh(sea.meshData[i].vertexData, sea.meshData[i].weight, sea.meshData[i].indices, bindPoses, sea.maxJointCount));				
			}
			
			geometry.animation = new SkeletonAnimation(skeleton, sea.maxJointCount);
					
			var mesh:Mesh = new Mesh(geometry, getColorMaterial(0x555555));		
			
			mesh.castsShadows = sea.castShadows;
			mesh.name = sea.name;				
			
			for (i=0;i<sea.numMeshes;++i) 
			{
				mesh.subMeshes[i].material = getMaterial(sea.meshData[i].material);
			}
									
			if (sea.animation)
			{
				var animator:SmoothSkeletonAnimator = new SmoothSkeletonAnimator(SkeletonAnimationState(mesh.animationState));				
				animator.addSequence(getSkeletonAnimation(sea.animation));
				animator.playSequence(getSkeletonAnimation(sea.animation).name);
				
				addAnimation
					(
					new SkeletonMeshAnimation
						(
							mesh, 
							animator, 
							getSkeletonAnimation(sea.animation)
						)
					,
					sea.animation, true
					);				
			}
						
			_container.addChild(mesh);
			
			_mesh.push(_object["mesh/"+sea.name] = mesh);
		}
				
		private function skeletonMesh(vertexData:Vector.<VertexData>, weights:Vector.<WeightData>, indices:Vector.<uint>, bindPoses:Vector.<Matrix3D>, maxJointCount:uint) : SkinnedSubGeometry
		{
			var len : int = vertexData.length;
			var v1 : int, v2 : int, v3 : int;
			var vertex : VertexData;
			var weight : WeightData;
			var bindPose : Matrix3D;
			var pos : Vector3D;
			var subGeom:SkinnedSubGeometry = new SkinnedSubGeometry(maxJointCount);
			var uvs : Vector.<Number> = new Vector.<Number>(len * 2, true);
			var vertices : Vector.<Number> = new Vector.<Number>(len * 3, true);
			var jointIndices : Vector.<Number> = new Vector.<Number>(len * maxJointCount, true);
			var jointWeights : Vector.<Number> = new Vector.<Number>(len * maxJointCount, true);
			var l : int;
			
			for (var i : int = 0; i < len; ++i) {
				vertex = vertexData[i];
				v1 = vertex.index * 3;
				v2 = v1 + 1;
				v3 = v1 + 2;
				vertices[v1] = vertices[v2] = vertices[v3] = 0;
				
				for (var j : int = 0; j < vertex.count; ++j) {
					weight = weights[vertex.start + j];
					bindPose = bindPoses[weight.joint];
					pos = bindPose.transformVector(weight.pos);
					vertices[v1] += pos.x * weight.bias;
					vertices[v2] += pos.y * weight.bias;
					vertices[v3] += pos.z * weight.bias;
					
					// indices need to be multiplied by 3 (amount of matrix registers)
					jointIndices[l] = weight.joint * 3;
					jointWeights[l++] = weight.bias;
				}
				
				for (j = vertex.count; j < maxJointCount; ++j) {
					jointIndices[l] = 0;
					jointWeights[l++] = 0;
				}
				
				v1 = vertex.index << 1;
				uvs[v1++] = vertex.u;
				uvs[v1] = vertex.v;
			}
			
			subGeom.updateVertexData(vertices);
			subGeom.updateUVData(uvs);
			subGeom.updateIndexData(indices);
			subGeom.arcane::updateJointIndexData(jointIndices);
			subGeom.arcane::updateJointWeightsData(jointWeights);
			
			return subGeom;
		}
		
		private function meshSkeletonJoints(sea:SEASkeletonMesh, skeleton:Skeleton):Vector.<Matrix3D>
		{
			var data:Vector.<Matrix3D> = new Vector.<Matrix3D>(sea.numJoints);			 
			
			for (var i:int=0;i<sea.jointData.length;i++)
			{
				var joint:JointData = sea.jointData[i];				
				
				var quat : Quaternion = new Quaternion();
				quat.multiply(_rotationQuat, vector3DToQuaternion(joint.orientation));
								 									
				var pos:Vector3D = _rotationQuat.rotatePoint(joint.position);
				
				data[i] = quat.toMatrix3D();
				data[i].appendTranslation(pos.x, pos.y, pos.z);								
				
				var inv : Matrix3D = data[i].clone();
				inv.invert();
				
				var skeletonJoint:SkeletonJoint = skeleton.joints[i] = new SkeletonJoint();
				skeletonJoint.name = joint.name;
				skeletonJoint.parentIndex = joint.parentIndex;
				skeletonJoint.inverseBindPose = inv.rawData;
			}
			
			return data;
		}
		
		public function readCameraFree(sea:SEACameraFree):void
		{
			var camera:Camera3D = 
				readCamera
				(
					sea.name,
					sea.fov,
					sea.position
				)
				
			sea.rotation = sea.rotation;
				
			if (sea.animation) 
			{
				var ann:CameraFreeAnimation = new CameraFreeAnimation
					(
						camera,
						getAnimation(sea.animation).cloneData(),
						sea.position,
						sea.rotation,
						sea.fov
					)
				
				addAnimation(ann, sea.animation);
			}
		}
		
		public function readCameraTarget(sea:SEACameraTarget):void
		{
			var camera:Camera3D = 
				readCamera
				(
					sea.name,
					sea.fov,
					sea.position
				)
			
			camera.lookAt(sea.target);
				
			if (sea.animation) 
			{
				var ann:CameraTargetAnimation = new CameraTargetAnimation
					(
						camera,
						getAnimation(sea.animation).cloneData(),
						sea.position,
						sea.target,
						sea.fov
					)
				
				addAnimation(ann, sea.animation);
			}
		}
		
		private function readCamera(name:String, fov:Number, position:Vector3D):Camera3D
		{
			var lens:PerspectiveLens = new PerspectiveLens(fov);
			lens.far = _shadow ? 1000 : 100000;
			lens.near = 1;
			
			var cam:Camera3D = new Camera3D(lens);
			cam.position = position;
			cam.name = name;
			
			_camera.push(_object["camera/"+name] = cam);	
			
			return cam;
		}
				
		public function readLightPoint(sea:SEALightPoint):void
		{
			var light:PointLight = new PointLight();
			
			readLight
			(
				light, 
				sea.name, 
				sea.color, 
				sea.multiplier, 
				sea.position
			);
			
			if (sea.attenuation)
			{
				light.radius = sea.attenStart;
				light.fallOff = sea.attenEnd;				
			}
			
			if (sea.animation) 
			{
				addAnimation
				(
					new LightPointAnimation
					(
						light, 
						getAnimation(sea.animation).cloneData(), 
						sea.position, 						
						sea.color, 
						sea.multiplier,
						sea.attenStart,
						sea.attenEnd
					), 
					sea.animation
				);
			}	
		}
		
		private function readLightFree(sea:SEALightFree):void
		{
			var light:DirectionalLight = new DirectionalLight();
			
			readLight
			(
				light, 
				sea.name, 
				sea.color, 
				sea.multiplier, 
				sea.position
			);
						
			light.rotation = sea.rotation;
			
			readShadow(light, sea);
							
			if (sea.animation) 
			{
				addAnimation
				(
					new LightTargetAnimation
					(
						light, 
						getAnimation(sea.animation).cloneData(), 
						sea.position, 
						sea.color, 
						sea.multiplier,
						sea.rotation
					), 
					sea.animation
				);
			}			
		}
		
		private function readLightTarget(sea:SEALightTarget):void
		{
			var light:DirectionalLight = new DirectionalLight();
			
			readLight
			(
				light, 
				sea.name, 
				sea.color, 
				sea.multiplier, 
				sea.position
			);
			
			light.lookAt(sea.target);
			
			readShadow(light, sea);
			
			if (sea.animation) 
			{
				addAnimation
				(
					new LightTargetAnimation
					(
						light, 
						getAnimation(sea.animation).cloneData(), 
						sea.position, 
						sea.color, 
						sea.multiplier,
						sea.target
					), 
					sea.animation
				);
			}			
		}
		
		private function readShadow(light:LightBase, sea:SEALight):void
		{
			if (!_enabledShadow) return;
			
			if (light is DirectionalLight)
			{
				if (sea.shadow && !_shadow)
				{
					light.shadowMapper = new DirectionalShadowMapper();
					light.shadowMapper.depthMapSize = 2048;				
					_shadow = new FilteredShadowMapMethod(light as DirectionalLight);
					//applyShadow( _shadow = new SoftShadowMapMethod(light) );
					_shadow.epsilon = 0.0006;
				}
			}
		}
		
		private function readLight(light:LightBase, name:String, color:int, multiplier:Number, position:Vector3D):void
		{
			light.color = color;
			light.diffuse = multiplier;
			light.position = position;	
			light.name = name;
			
			light.ambientColor = 0xFFFFFF;
			light.ambient = 1;
									
			_container.addChild(light);
			
			// Update
			_lightPicker.lights.push(light)
			_lightPicker.lights = _lightPicker.lights;			
			
			_light.push(_object["light/"+name] = light);
		}
		
		public function readEnvironment(sea:SEAEnvironment):void
		{
			_container.addChild(_object[sea.ns] = new SkyBox(getCubeMap(sea.texture)));
		}
		
		public function readHelper(sea:SEAHelper):void
		{
			var helper:Helper = new Helper(sea.position, sea.rotation, sea.scale, sea.color);
			helper.name = sea.name;
			
			if (sea.animation)
			{
				addAnimation(new HelperAnimation(helper, getAnimation(sea.animation).cloneData(), sea.position, sea.rotation, sea.scale), sea.animation);
			}
			
			_helper.push(_object["helper/"+sea.name] = helper);
		}
		
		public function get lightPicker():LightPickerBase
		{
			return _lightPicker;
		}
		
		public function get ambient():Number
		{
			return _ambient;
		}
		
		public function set ambient(value:Number):void
		{
			_ambient = value;
		}
		
		public function get enabledShadow():Boolean
		{
			return enabledShadow;
		}
		
		public function set enabledShadow(value:Boolean):void
		{
			_enabledShadow = value;
		}
		
		private function vector3DToQuaternion(value:Vector3D):Quaternion
		{
			return new Quaternion
				(
					value.x,
					value.y,
					value.z,
					value.w
				);
		}
		
		public override function dispose():void
		{						
			for each(var camera:Camera3D in _camera)
			{
				camera.dispose();
				camera.disposeAsset();
			}
			
			for each(var mesh:Mesh in _mesh)
			{
				mesh.dispose();
				mesh.disposeAsset();
			}
			
			for each(var cubemap:BitmapCubeTexture in _cubemap)
			{
				cubemap.dispose();
				cubemap.disposeAsset();
			}
			
			for each(var material:DefaultMaterialBase in _material)
			{
				material.dispose();
				material.disposeAsset();
			}
			
			for each(var texture:BitmapTexture in _texture)
			{
				texture.dispose();
				texture.disposeAsset();
			}
			
			for each(var light:LightBase in _light)
			{
				light.dispose();
				light.disposeAsset();
			}
			
			for each(var skeletonAnimation:SkeletonAnimationSequence in _skeletonAnimation)
			{
				skeletonAnimation.dispose();
				skeletonAnimation.disposeAsset();
			}
			
			for each(var composite:TerrainDiffuseMethod in _composite)
			{
				composite.dispose();
			}
			
			_whiteTexture.dispose();
			_whiteTexture.bitmapData.dispose();
			
			_container.dispose();
			
			super.dispose();
		}
	}
}
