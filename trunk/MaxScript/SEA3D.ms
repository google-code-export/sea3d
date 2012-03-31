-- SEA3D Exporter 1.0
-- Copyright (C) 2012 Sunag Entertainment

global seafloater, 
seaconfig_compress = "zlib", 
seaconfig_export = "visible", 
seaconfig_animation = true,
seaconfig_geometry = true,
seaconfig_skeleton = true,
seaconfig_material = true,
seaconfig_texture = true,
seaconfig_camera = true,
seaconfig_light = true,
seaconfig_helper = true,
seaconfig_multiplechannel = true,
seaconfig_vertexcolor = true,
seaconfig_env = true,
seaTimeRange = #(animationRange.start.frame as integer,animationRange.end.frame as integer),
seaErrors = #(),
seaWarning = #(),
seaListenerText = "",
seaBitmapList = #(),
seaTextureList = #(),
seaMaterialList = #(),
seaMeshList = #(),
seaCameraList = #(),
seaHelperList = #(),
seaLightList = #(),
seaEnvList = #(),
seaFileList = #()

fn getSourceFolder = 
(
	local filename = getSourceFileName()
	local i = filename.count	
	
	while i > 1  do
	(
		if filename[i] == "\\" then
		(
			return substring filename 1 i			
		)
		i -= 1
	)
	
	return ""
)	

dotnet.loadAssembly (getSourceFolder() + "sea.dll")

struct SEAEnv
(
	obj, type
)

struct SEATexture
(
	obj, name=#(),textures=#(), masks=#(), masksID=#(), blendMode=#(), opacity=#()
)

struct SEAMaterial
(
	obj,
	diffuseMap, ambientMap, specularMap, selfIllumMap, opacityMap, refractionMap, reflectionMap, bumpMap, normalMap,
	fresnel = false, fresnelColor, fresnelPower, fresnelAmount
)

struct SEAMesh
(
	obj, temp, polymats, mats, containsSkin, instances=#()
)

struct SEACamera
(
	obj
)

struct SEAHelper
(
	obj
)

struct SEALight
(
	obj
)

function saveObjectTransform object =
(
	local t = object
	return #(t.position.x,t.position.y,t.position.z,t.rotation.x,t.rotation.y,t.rotation.z,t.rotation.w,t.scale.x,t.scale.y,t.scale.z)
)

function resetObjectTransform object =
(	
	object.rotation = quat 0 0 0 1
	object.position = [0,0,0]
	object.scale = [1,1,1]
)
	
function loadObjectTransform object data =
(	
	object.rotation = quat (data[4]) (data[5]) (data[6]) (data[7])
	object.position = [data[1],data[2],data[3]]	
	object.scale = [data[8],data[9],data[10]]
)

-- Export

function getName f =
(
	local file = filterString f "\\"	
	return file[file.count]
)

function newFile = 
(
	return (dotNetObject "Sunag.SEA.File")
)

function addToken list token value type =
(
	list[list.count+1] = #(token,value,type)
)

function appendFile file =
(
	seaFileList[seaFileList.count+1] = file
)

function appendAnimation data n t =
(
	data.WriteUTFTiny n
	data.WriteByte t
)

function seaNumKeys c =
(
	if c != undefined do return (numKeys c)
	return -1
)

function countTrue list =
(
	local count = 0
	for i=1 to list.count do
	(
		if list[i] == true do count += 1
	)
	return count
)

function exportTokens data tokens =
(
	data.WriteByte tokens.count
	for j=1 to tokens.count do
	(
		local token = tokens[j]
		local n = token[1]
		local v = token[2]
		local t = token[3]
		
		data.WriteUTFTiny n
		
		if (t == "byte") then
		(
			data.WriteByte 0
			data.WriteByte (int (ceil v))
		)
		else if (t == "boolean") then
		(
			data.WriteByte 1
			data.WriteBoolean v
		)
		else if (t == "float") then
		(
			data.WriteByte 3
			data.WriteFloat v
		)
		else if (t == "string") then
		(
			data.WriteByte 10
			data.WriteUTFTiny v
		)	
		else if (t == "rgb") then
		(
			data.WriteByte 20
			data.WriteByte (int (ceil v.r))
			data.WriteByte (int (ceil v.g))
			data.WriteByte (int (ceil v.b))
		)				
	)
)

function exportTextureTokens data tex =
(
	-- Get Tokens
	local tokens = #()
	if tex.coords.mapChannel > 1 do ( addToken tokens "channel" (tex.coords.mapChannel-1) "byte" )
	if tex.coords.U_Offset != 0 do ( addToken tokens "offsetU" tex.coords.U_Offset "float" )
	if tex.coords.V_Offset != 0 do ( addToken tokens "offsetV" tex.coords.V_Offset "float" )
	if tex.coords.U_Tiling != 1 do ( addToken tokens "scaleU" tex.coords.U_Tiling "float" )			
	if tex.coords.V_Tiling != 1 do ( addToken tokens "scaleV" tex.coords.V_Tiling "float" )	
	if tex.coords.W_Angle != 0 do ( addToken tokens "rotation" tex.coords.W_Angle "float" )	
	if tex.coords.mappingType > 0 do ( addToken tokens "mappingType" tex.coords.mappingType "byte" )
	if tex.coords.U_Tile == false do ( addToken tokens "repeatU" tex.coords.U_Tile "boolean" )
	if tex.coords.V_Tile == false do ( addToken tokens "repeatV" tex.coords.V_Tile "boolean" )
	exportTokens data tokens
)

function containsTextureAnimation tex =
(
	local offsetU = seaNumKeys tex.coords.U_Offset.controller > 0
	local offsetV = seaNumKeys tex.coords.V_Offset.controller > 0
	local tilingU = seaNumKeys tex.coords.U_Tiling.controller > 0
	local tilingV = seaNumKeys tex.coords.V_Tiling.controller > 0
	
	return (offsetU or offsetV or tilingU or tilingV)
)

function exportBitmap =
(
	for i=1 to seaBitmapList.count do
	(
		local file = newFile()
		local data = file.Data
		-- Write File
		data.ReadFile (seaBitmapList[i])	
		file.Filename = ((getName seaBitmapList[i]) + ".bitmap")
		appendFile file
	)
	
	return seaErrors.count
)

function exportTextureAnimation obj nm =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = nm + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_offsetU = seaNumKeys obj.coords.U_Offset.controller > 0
	local c_offsetV = seaNumKeys obj.coords.V_Offset.controller > 0
	local c_scaleU = seaNumKeys obj.coords.U_Tiling.controller > 0
	local c_scaleV = seaNumKeys obj.coords.V_Tiling.controller > 0
	local c_rotation = seaNumKeys obj.coords.W_Angle.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_offsetU,c_offsetV,c_scaleU,c_scaleV,c_rotation))) -- Count
	if c_offsetU do appendAnimation data "offsetU" 3 -- Float
	if c_offsetV do appendAnimation data "offsetV" 3 -- Float
	if c_scaleU do appendAnimation data "scaleU" 3 -- Float
	if c_scaleV do appendAnimation data "scaleV" 3 -- Float
	if c_rotation do appendAnimation data "rotation" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if (c_offsetU) do ( data.WriteFloat -obj.coords.U_Offset )
		if (c_offsetV) do ( data.WriteFloat obj.coords.V_Offset )
		if (c_scaleU) do ( data.WriteFloat obj.coords.U_Tiling )
		if (c_scaleV) do ( data.WriteFloat obj.coords.V_Tiling )
		if (c_rotation) do ( data.WriteFloat obj.coords.W_Angle )
	)
	
	appendFile file
)

function exportTexture =
(
	for i=1 to seaTextureList.count do
	(		
		local file = newFile()
		local data = file.Data
		local sea = seaTextureList[i]				
		local count = sea.textures.count					
		-- Write Data
		file.Filename = (sea.obj.name + ".texture")
		data.WriteByte count
		for i=1 to count do
		(
			local tex = sea.textures[i]
			local mak = sea.masks[i]
			local blendMode = sea.blendMode[i]
			local opacity = sea.opacity[i]
			local name = sea.name[i]			
			
			data.WriteUTFTiny name
			data.WriteByte blendMode
			data.WriteByte opacity
			
			-- Write Texture
			data.WriteUTFTiny (getName tex.filename)				
			exportTextureTokens data tex
			
			if (containsTextureAnimation tex) then
			(				
				local nm = sea.obj.name + ":texture" +  (i as string)				
				data.WriteUTFTiny nm
				exportTextureAnimation tex nm 
			)
			else
			(
				data.WriteByte 0
			)
			
			-- Write Mask
			if (mak != undefined) then
			(
				data.WriteUTFTiny (getName mak.filename)				
				exportTextureTokens data mak
				
				if (containsTextureAnimation mak) then
				(
					local nm = sea.obj.name + ":mask" + (i as string)
					data.WriteUTFTiny nm
					exportTextureAnimation mak nm 
				)
				else
				(
					data.WriteByte 0
				)
			)
			else
			(
				data.WriteByte 0
			)						
		)		
		
		appendFile file
	)
	
	return seaErrors.count
)

function colorNotEqual c v =
(
	return (ceil c.r != v or ceil c.g != v or ceil c.b != v)
)

function exportMaterial =
(
	for i=1 to seaMaterialList.count do
	(
		local file = newFile()
		local data = file.Data
		local sea = seaMaterialList[i]
		local mat = sea.obj
		-- Write Data
		local tokenList = #()
		file.Filename = mat.name + ".material"
		
		if (mat.wire) do (addToken tokenList "wire" mat.wire "boolean")
		if (mat.twoSided) do (addToken tokenList "bothSides" mat.twoSided "boolean")
		if (mat.adLock == false and (colorNotEqual mat.ambient 150)) do (addToken tokenList "ambient" mat.ambient "rgb")
		if (colorNotEqual mat.diffuse 150) do (addToken tokenList "diffuse" mat.diffuse "rgb")
		if (colorNotEqual mat.specular 230) do (addToken tokenList "specularColor" mat.specular "rgb")
		if (ceil mat.specularLevel != 0) do (addToken tokenList "specular" mat.specularLevel "byte")
		if (ceil mat.glossiness != 10) do (addToken tokenList "gloss" mat.glossiness "byte")
		if (ceil mat.opacity != 100) do (addToken tokenList "opacity" mat.opacity "byte")		
		if (mat.faceted == false) do (addToken tokenList "smooth" (mat.faceted == false) "boolean")
		
		if (mat.useSelfIllumColor) then
		(
			if (colorNotEqual mat.selfIllumColor 0) do (addToken tokenList "selfIllumColor" mat.selfIllumColor "rgb")
		)
		else
		(
			if (ceil mat.selfIllumAmount != 0) do (addToken tokenList "selfIllumAmount" (ceil ((mat.selfIllumAmount/100)*255)) "byte")
		)
		
		if mat.ambientMapEnable do (
			addToken tokenList "ambientMapAmount" mat.ambientMapAmount "byte"
			if sea.ambientMap != undefined do ( addToken tokenList "ambientMap" sea.ambientMap.obj.name "string" )
		)
		
		if mat.diffuseMapEnable do (
			addToken tokenList "diffuseMapAmount" mat.diffuseMapAmount "byte"
			if sea.diffuseMap != undefined do ( addToken tokenList "diffuseMap" sea.diffuseMap.obj.name "string" )
		)				
		
		if mat.specularMapEnable do (
			addToken tokenList "specularMapAmount" mat.specularMapAmount "byte"
			if sea.specularMap != undefined do ( addToken tokenList "specularMap" sea.specularMap.obj.name "string" )
		)
		
		if mat.selfIllumMapEnable do (
			addToken tokenList "selfIllumMapAmount" mat.selfIllumMapAmount "byte" 
			if sea.selfIllumMap != undefined do ( addToken tokenList "selfIllumMap" sea.selfIllumMap.obj.name "string" )
		)
		
		if mat.opacityMapEnable do (
			addToken tokenList "opacityMapAmount" mat.opacityMapAmount "byte"
			if sea.opacityMap != undefined do ( addToken tokenList "opacityMap" sea.opacityMap.obj.name "string" )
		)
		
		if mat.refractionMapEnable do (			
			addToken tokenList "refractionMapAmount" mat.refractionMapAmount "byte"
			if sea.refractionMap != undefined do ( addToken tokenList "refractionMap" sea.refractionMap.obj.name "string" )
		)				
		
		if mat.reflectionMapEnable do (
			addToken tokenList "reflectionMapAmount" mat.reflectionMapAmount "byte"		
			if sea.reflectionMap != undefined then ( 
				addToken tokenList "reflectionMap" sea.reflectionMap.obj.name "string" 
				if sea.fresnel == true do ( 
					addToken tokenList "fresnel" true "boolean"  
					addToken tokenList "fresnelPower" sea.fresnelPower "float" 
					addToken tokenList "fresnelAmount" sea.fresnelAmount "float" 
				)
			)
			else if sea.fresnel == true then ( 
				addToken tokenList "fresnel" true "boolean"
				addToken tokenList "fresnelColor" sea.fresnelColor "rgb" 				
			)						
		)
		
		if mat.bumpMapEnable do (			
			if sea.bumpMap != undefined then 
			( 
				addToken tokenList "bumpMapAmount" mat.bumpMapAmount "byte"
				addToken tokenList "bumpMap" sea.bumpMap.obj.name "string"
			)
			else if sea.normalMap != undefined then 
			( 
				addToken tokenList "normalMapAmount" mat.bumpMapAmount "byte"
				addToken tokenList "normalMap" sea.normalMap.obj.name "string"
			)
		)
		
		exportTokens data tokenList
		
		appendFile file
	)
	
	return seaErrors.count
)

function exportObjectAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_rot = seaNumKeys obj.rotation.controller > 0
	local c_sca = seaNumKeys obj.scale.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_rot,c_sca))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_rot do appendAnimation data "rotation" 30 -- Vector3D
	if c_sca do appendAnimation data "scale" 30 -- Vector3D
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if (c_pos) do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if (c_rot) do
		(
			-- Write Rotation						
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
		)
		if (c_sca) do
		(
			-- Write Scale
			data.WriteFloat obj.transform.scale.x
			data.WriteFloat obj.transform.scale.z
			data.WriteFloat obj.transform.scale.y
		)
	)
	
	appendFile file
)

function exportHelperAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_rot = seaNumKeys obj.rotation.controller > 0
	local c_sca = seaNumKeys obj.scale.controller > 0
	local c_wire = seaNumKeys obj.wirecolor.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_rot,c_sca,c_wire))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_rot do appendAnimation data "rotation" 30 -- Vector3D
	if c_sca do appendAnimation data "scale" 30 -- Vector3D
	if c_wire do appendAnimation data "color" 20 -- Color
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if (c_pos) do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if (c_rot) do
		(
			-- Write Rotation						
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
		)
		if (c_sca) do
		(
			-- Write Scale
			data.WriteFloat obj.transform.scale.x
			data.WriteFloat obj.transform.scale.z
			data.WriteFloat obj.transform.scale.y
		)
		if (c_wire) do
		(
			data.WriteByte obj.wirecolor.r
			data.WriteByte obj.wirecolor.g
			data.WriteByte obj.wirecolor.b
		)
	)
	
	appendFile file
)

function exportMeshObject sea inst instMats =
(
	local file = newFile()
	local data = file.Data
	local obj = sea.obj	
	local tokens = #()
		
	if (obj.castShadows==false) do (addToken tokens "castShadows" obj.castShadows "boolean")
	
	exportTokens data tokens
	
	data.WriteByte sea.obj.wirecolor.r
	data.WriteByte sea.obj.wirecolor.g
	data.WriteByte sea.obj.wirecolor.b
	
	-- Write Data
	file.Filename = obj.name + ".mesh"
	local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.rotation.controller > 0) or (seaNumKeys obj.scale.controller > 0))
	if (seaconfig_animation and containsAnim) then
	(
		exportObjectAnimation obj
		data.WriteUTFTiny obj.name
	)
	else
	(
		data.WriteByte 0				
	)
	
	set time (seaTimeRange[1])
	-- Write Position
	data.WriteFloat obj.transform.position.x
	data.WriteFloat obj.transform.position.z
	data.WriteFloat obj.transform.position.y
	-- Write Rotation
	local ctrl = obj.rotation.controller
	data.WriteFloat -ctrl[1].value
	data.WriteFloat -ctrl[3].value
	data.WriteFloat -ctrl[2].value
	-- Write Scale
	data.WriteFloat obj.transform.scale.x
	data.WriteFloat obj.transform.scale.z
	data.WriteFloat obj.transform.scale.y
	
	obj = sea.temp
	
	local vertexcount = getnumverts obj			
	local channelcount = (nummapsused obj) - 1	
	local objecttransform = saveObjectTransform obj
	resetObjectTransform obj
	
	local index = 1	
	
	-- Organize Material
	local mats = #()
	local polymats = #()
	for m = 1 to sea.polymats.count do
	(		
		if sea.polymats[m] != undefined do 
		(
			mats[index] = sea.mats[m]
			polymats[index] = sea.polymats[m]
			index += 1
		)
	)
	
	-- Instances
	if inst != undefined then
	(
		data.WriteUTFTiny inst.obj.name
		
		local sameMats = true
		for m = 1 to instMats.count do 		
		(
			if instMats[m] != mats[m] do
			(
				sameMats = false
			)
		)
		
		data.WriteBoolean sameMats
		if sameMats == false do
		(
			data.WriteByte polymats.count
			for m = 1 to polymats.count do 		
			(
				data.WriteUTFTiny mats[m]
			)	
		)
	)
	else
	(
		data.WriteByte 0
		
		-- Organize UVs
		index = 1
		local uvs = #()		
		local uvsLength = #()
		for c = 1 to channelcount do
		(		
			try
			(
				meshop.getMapVert obj c 1
				uvs[index] = c
				index += 1
			)
			catch ()
		)
				
		uvsLength[1] = getnumtverts obj
		
		for c = 2 to uvs.count do
		(
			local uvCount = 1
			local uvCh = uvs[c]
			
			try
			(
				while (true) do
				(
					meshop.getMapVert obj uvCh uvCount
					uvCount+=1
				)			
			)
			catch()
			
			uvsLength[uvsLength.count+1] = (uvCount - 1)
		)
		
		-- Write Struct		
		data.WriteShort vertexcount			
		data.WriteByte polymats.count
		for m = 1 to polymats.count do 
		(									
			if mats[m] != undefined then
			(			
				data.WriteUTFTiny mats[m]				
			)
			else
			(
				data.WriteByte 0		
			)		

			data.WriteShort polymats[m].count			
		)			
		
		data.WriteByte uvs.count
		for c=1 to uvs.count do
		(
			data.WriteShort uvsLength[c]
		)				
		
		if seaconfig_vertexcolor then
		(
			data.WriteBoolean obj.vertexColorsShaded		
			
			-- Export VertexColors
			if obj.vertexColorsShaded do
			(			
				for v=1 to vertexcount do
				(
					local vc = (getVertColor object v)
					data.WriteByte (vc.x)
					data.WriteByte (vc.y)
					data.WriteByte (vc.z)
				)		
			)
		)
		else
		(
			data.WriteBoolean false
		)
		
		-- Export Vertices			
		for v=1 to vertexcount do
		(
			local vert = (GetVert obj v)
			data.WriteFloat vert.x
			data.WriteFloat vert.z
			data.WriteFloat vert.y
		)
		
		-- Export Faces
		for m = 1 to polymats.count do
		(
			local faces = polymats[m]
			for f = 1 to faces.count do 
			(				
				local faceID = faces[f]
				local poly = GetFace obj faceID
				
				data.WriteShort (poly.x as integer -1)
				data.WriteShort (poly.z as integer -1)
				data.WriteShort (poly.y as integer -1)

				for c = 1 to uvs.count do
				(
					local channelID = uvs[c]					
					
					local vface = meshop.getMapFace obj channelID faceID
					
					data.WriteShort (vface.x as integer -1)
					data.WriteShort (vface.z as integer -1)
					data.WriteShort (vface.y as integer -1)
				)
			)
		)				
			
		-- Export UV Channels	
		for c=1 to uvs.count do
		(		
			local channelID = uvs[c]
			for v=1 to uvsLength[c] do
			(	
				local uv = (meshop.getMapVert obj channelID v)
				data.WriteFloat uv.x
				data.WriteFloat (1.0 - uv.y)
			)
		)
	)
	
	loadObjectTransform obj objecttransform		
	
	appendFile file
	
	for i=1 to sea.instances.count do
	(
		exportMeshObject (sea.instances[i]) sea mats
	)
)

function exportCameraFreeAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])		
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_rot = seaNumKeys obj.rotation.controller > 0
	local c_fov = seaNumKeys obj.fov.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_rot,c_fov))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_rot do appendAnimation data "rotation" 30 -- Vector3D
	if c_fov do appendAnimation data "fov" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if c_pos do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if c_rot do
		(
			-- Write Animation
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
		)
		if c_fov do
		(
			-- Write FOV
			data.WriteFloat obj.fov
		)
	)
	
	appendFile file
)

function exportCameraTargetAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_tar = seaNumKeys obj.target.position.controller > 0
	local c_fov = seaNumKeys obj.fov.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_tar,c_fov))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_tar do appendAnimation data "target" 30 -- Vector3D
	if c_fov do appendAnimation data "fov" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if c_pos do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if c_tar do
		(
			-- Write Target Position
			data.WriteFloat obj.target.transform.position.x
			data.WriteFloat obj.target.transform.position.z
			data.WriteFloat obj.target.transform.position.y
		)
		if c_fov do
		(
			-- Write FOV
			data.WriteFloat obj.fov
		)
	)
	
	appendFile file
)

function exportCamera = 
(
	for i=1 to seaCameraList.count do
	(
		local file = newFile()
		local data = file.Data
		local sea = seaCameraList[i]
		local obj = sea.obj
		-- Write Data				
		if (obj.type == #free) then
		(
			file.Filename = obj.name + ".camera-free"
			
			local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.rotation.controller > 0) or (seaNumKeys obj.fov.controller > 0))
			if seaconfig_animation and containsAnim then
			(
				exportCameraFreeAnimation obj
				data.WriteUTFTiny obj.name
			)
			else
			(
				data.WriteByte 0				
			)
			
			set time (seaTimeRange[1])
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
			-- Write Rotation
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
			-- Write FOV
			data.WriteFloat obj.fov
		)	
		else
		(
			file.Filename = obj.name + ".camera-target"
			
			local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.target.position.controller > 0) or (seaNumKeys obj.fov.controller > 0))
			if seaconfig_animation and containsAnim then
			(
				exportCameraTargetAnimation obj
				data.WriteUTFTiny obj.name
			)
			else
			(
				data.WriteByte 0				
			)
			
			set time (seaTimeRange[1])
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
			-- Write Target Position
			data.WriteFloat obj.target.transform.position.x
			data.WriteFloat obj.target.transform.position.z
			data.WriteFloat obj.target.transform.position.y
			-- Write FOV
			data.WriteFloat obj.fov
		)	

		appendFile file		
	)
	
	return seaErrors.count
)

function exportHelper = 
(
	for i=1 to seaHelperList.count do
	(
		local file = newFile()
		local data = file.Data
		local sea = seaHelperList[i]
		local obj = sea.obj	
		
		-- Write Data
		file.Filename = obj.name + ".helper"
		local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.rotation.controller > 0) or (seaNumKeys obj.scale.controller > 0) or (seaNumKeys obj.wirecolor.controller > 0))
		if seaconfig_animation and containsAnim then
		(
			exportHelperAnimation obj
			data.WriteUTFTiny obj.name
		)
		else
		(
			data.WriteByte 0				
		)
		
		set time (seaTimeRange[1])
		-- Write Position
		data.WriteFloat obj.transform.position.x
		data.WriteFloat obj.transform.position.z
		data.WriteFloat obj.transform.position.y
		-- Write Rotation
		local ctrl = obj.rotation.controller
		data.WriteFloat -ctrl[1].value
		data.WriteFloat -ctrl[3].value
		data.WriteFloat -ctrl[2].value
		-- Write Scale
		data.WriteFloat obj.transform.scale.x
		data.WriteFloat obj.transform.scale.z
		data.WriteFloat obj.transform.scale.y
		-- Write Color
		data.WriteByte sea.obj.wirecolor.r
		data.WriteByte sea.obj.wirecolor.g
		data.WriteByte sea.obj.wirecolor.b
		
		appendFile file
	)
	
	return seaErrors.count
)

function exportLightFreeAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_rot = seaNumKeys obj.rotation.controller > 0
	local c_rgb = seaNumKeys obj.rgb.controller > 0
	local c_mult = seaNumKeys obj.multiplier.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_rot,c_rgb,c_mult))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_rot do appendAnimation data "rotation" 30 -- Vector3D
	if c_rgb do appendAnimation data "color" 20 -- RGB
	if c_mult do appendAnimation data "multiplier" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if c_pos do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if c_rot do
		(
			-- Write Rotation
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
		)
		if c_rgb do
		(
			-- Write Data		
			data.WriteByte obj.rgb.r
			data.WriteByte obj.rgb.g
			data.WriteByte obj.rgb.b
		)
		if c_mult do
		(
			data.WriteFloat obj.multiplier
		)
	)
	
	appendFile file
)

function exportLightTargetAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_tar = seaNumKeys obj.target.position.controller > 0
	local c_rgb = seaNumKeys obj.rgb.controller > 0
	local c_mult = seaNumKeys obj.multiplier.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_tar,c_rgb,c_mult))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_tar do appendAnimation data "target" 30 -- Vector3D
	if c_rgb do appendAnimation data "color" 20 -- RGB
	if c_mult do appendAnimation data "multiplier" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if c_pos do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if c_tar do
		(
			-- Write Target Position
			data.WriteFloat obj.target.transform.position.x
			data.WriteFloat obj.target.transform.position.z
			data.WriteFloat obj.target.transform.position.y
		)
		if c_rgb do
		(
			-- Write Data		
			data.WriteByte obj.rgb.r
			data.WriteByte obj.rgb.g
			data.WriteByte obj.rgb.b
		)
		if c_mult do
		(
			data.WriteFloat obj.multiplier
		)
	)
	
	appendFile file
)

function exportLightOmniAnimation obj =
(	
	local file = newFile()
	local data = file.Data	
	-- Write Data
	file.Filename = obj.name + ".animation"
	-- Frame Rate
	data.WriteByte frameRate
	-- Frame Count
	data.WriteShort (seaTimeRange[2] - seaTimeRange[1])	
	-- Contains
	local c_pos = seaNumKeys obj.position.controller > 0
	local c_rgb = seaNumKeys obj.rgb.controller > 0
	local c_mult = seaNumKeys obj.multiplier.controller > 0
	-- Data Struct
	data.WriteByte (countTrue (#(c_pos,c_rgb,c_mult))) -- Count
	if c_pos do appendAnimation data "position" 30 -- Vector3D
	if c_rgb do appendAnimation data "color" 20 -- RGB
	if c_mult do appendAnimation data "multiplier" 3 -- Float
	-- Data Raw
	for t = seaTimeRange[1] to seaTimeRange[2] do
	(
		set time t		
		if c_pos do
		(
			-- Write Position
			data.WriteFloat obj.transform.position.x
			data.WriteFloat obj.transform.position.z
			data.WriteFloat obj.transform.position.y
		)
		if c_rgb do
		(
			-- Write Data		
			data.WriteByte obj.rgb.r
			data.WriteByte obj.rgb.g
			data.WriteByte obj.rgb.b
		)
		if c_mult do
		(
			data.WriteFloat obj.multiplier
		)
	)
	
	appendFile file
)

function exportLight = 
(
	for i=1 to seaLightList.count do
	(
		local file = newFile()
		local data = file.Data
		local sea = seaLightList[i]
		local obj = sea.obj
		
		data.WriteByte obj.rgb.r
		data.WriteByte obj.rgb.g
		data.WriteByte obj.rgb.b
		data.WriteFloat obj.multiplier
		
		-- Write Position
		set time (seaTimeRange[1])	
		
		data.WriteFloat obj.transform.position.x
		data.WriteFloat obj.transform.position.z
		data.WriteFloat obj.transform.position.y
		
		data.WriteBoolean obj.baseObject.castShadows		
		if obj.baseObject.castShadows do
		(
			data.WriteByte obj.shadowColor.r
			data.WriteByte obj.shadowColor.g
			data.WriteByte obj.shadowColor.b
			data.WriteFloat obj.shadowMultiplier
		)
		
		if (obj.type == #omni) then
		(
			file.Filename = obj.name + ".light-point"
			
			local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.rgb.controller > 0) or (seaNumKeys obj.multiplier.controller > 0))
			if seaconfig_animation and containsAnim then
			(
				exportLightOmniAnimation obj
				data.WriteUTFTiny obj.name
			)
			else
			(
				data.WriteByte 0				
			)						
		)	
		else if (obj.type == #freespot or obj.type == #freedirect) then		
		(
			file.Filename = obj.name + ".light-free"
			
			local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.rotation.controller > 0) or (seaNumKeys obj.rgb.controller > 0) or (seaNumKeys obj.multiplier.controller > 0))
			if seaconfig_animation and containsAnim then
			(
				exportLightFreeAnimation obj
				data.WriteUTFTiny obj.name
			)
			else
			(
				data.WriteByte 0				
			)
			
			set time (seaTimeRange[1])
			
			-- Write Rotation
			local ctrl = obj.rotation.controller
			data.WriteFloat -ctrl[1].value
			data.WriteFloat -ctrl[3].value
			data.WriteFloat -ctrl[2].value
		)
		else if (obj.type == #targetspot or obj.type == #targetdirect) then
		(
			file.Filename = obj.name + ".light-target"
			
			local containsAnim = ((seaNumKeys obj.position.controller > 0) or (seaNumKeys obj.target.position.controller > 0) or (seaNumKeys obj.rgb.controller > 0) or (seaNumKeys obj.multiplier.controller > 0))
			if seaconfig_animation and containsAnim then
			(
				exportLightTargetAnimation obj
				data.WriteUTFTiny obj.name
			)
			else
			(
				data.WriteByte 0				
			)
			
			set time (seaTimeRange[1])
			
			-- Write Target Position
			data.WriteFloat obj.target.transform.position.x
			data.WriteFloat obj.target.transform.position.z
			data.WriteFloat obj.target.transform.position.y			
		)
		
		appendFile file
	)
	
	return seaErrors.count
)

function exportEnv = 
(
	for i=1 to seaEnvList.count do
	(
		local file = newFile()
		local data = file.Data
		local sea = seaEnvList[i]
		local obj = sea.obj
		local type = sea.type
		
		if (type == "environment") then
		(
			file.Filename = "background.environment"
			data.WriteUTFTiny (getName obj.filename)
		)		
		
		appendFile file
	)
	
	return seaErrors.count
)

function error1001 n = 
(
	seaErrors[seaErrors.count+1] = "#1001: Conflicted name. More than one object with the name \"" + n + "\" was found."
)

function error1002 n = 
(
	seaErrors[seaErrors.count+1] = "#1002: Conflicted name. More than one material with the name \"" + n + "\" was found."
)

function error1003 n = 
(
	seaErrors[seaErrors.count+1] = "#1003: Conflicted name. More than one texture with the name \"" + n + "\" was found."
)

function error1011 n = 
(
	seaErrors[seaErrors.count+1] = "#1011: Material \"" + n + "\" is not compatible."
)

function error1012 t n = 
(
	seaErrors[seaErrors.count+1] = "#1012: Shader " + t + " in the \"" + n + "\" is not compatible."
)

function error1013 t n = 
(
	seaErrors[seaErrors.count+1] = "#1013: Slot " + (toLower t) + " in the material \"" + n + "\" is not compatible."
)

function error1014 t n = 
(
	seaErrors[seaErrors.count+1] = "#1014: Texture \"" + t + "\" in the material \"" + n + "\" is not compatible. Only JPG, PNG and GIF."
)

function error1015 t n = 
(	
	seaErrors[seaErrors.count+1] = "#1015: Falloff parameters \"" + t + "\" in the material \"" + n + "\" is not compatible."
)

function warning2001 n = 
(
	seaWarning[seaWarning.count+1] = "#2001: Object \"" + n + "\" will not be exported."
)

function warning2002 n = 
(
	seaWarning[seaWarning.count+1] = "#2002: Invalid geometry. Object \"" + n + "\" will not be exported."
)

function warning2003 n = 
(
	seaWarning[seaWarning.count+1] = "#2003: Skin from the object \"" + n + "\" will not be exported."
)

function warning2004 n = 
(
	seaWarning[seaWarning.count+1] = "#2004: Morpher from the object \"" + n + "\" will not be exported."
)

function warning2005 n = 
(
	seaWarning[seaWarning.count+1] = "#2005: Additional Bump in the material \"" + n + "\" will not be exported."
)

function warning2006 n = 
(
	seaWarning[seaWarning.count+1] = "#2006: Invalid light, \"" + n + "\" will not be exported."
)

function warning2007 n = 
(
	seaWarning[seaWarning.count+1] = "#2007: Found a vertex in mesh \"" + n + "\" without skin attachment."
)

function containsString list str =
(
	for i=1 to list.count do
	(
		if str == list[i] do 
		(
			return i
		)
	)
	return 0
)

function appendBitmap filename n =
(
	f = toLower filename
	local found = false
	
	for i=1 to seaBitmapList.count do
	(
		if (seaBitmapList[i] == f) do
		(
			found = true
		)				
	)
	
	if (found == false) do
	(
		local ext = substring f (f.count-3) 4
		
		if ext != ".jpg" and ext != ".png" and ext != ".gif" do
		(					
			error1014 (getName filename) n
		)		

		seaBitmapList[seaBitmapList.count+1] = filename		
	)
)

function appendTexture map n type enabledComposite =
(
	for  i=1 to seaTextureList.count do
	(
		if seaTextureList[i].obj.name == map.name do
		(
			if seaTextureList[i].obj == map then
			(
				return seaTextureList[i]
			)
			else
			(
				error1003 map.name		
			)
		)
	)
	
	local sea = SEATexture map	
	local c = 1
	local tokens
	
	seaTextureList[seaTextureList.count+1] = sea
	
	if (classof map == BitmapTexture) then
	(		
		tokens = #()
		
		sea.textures[c] = map
		sea.blendMode[c] = 0
		sea.opacity[c] = 100
		sea.name[c] = "SingleMap"
		
		appendBitmap map.filename n
	)
	else if (enabledComposite and classof map == CompositeTexturemap) then
	(		
		for i=1 to map.mapList.count do
		(
			local en = map.mapEnabled[i]
			local dm = map.mapList[i]
			local mm = map.mask[i]
			local emm = map.maskEnabled[i]
			local blendMode = map.blendMode[i]
			local opacity = map.opacity[i]
			local name = map.layerName[i]
			
			if (en and dm != undefined) do
			(
				sea.opacity[c] = opacity
				sea.blendMode[c] = blendMode
				sea.name[c] = name				
				
				if (classof dm == BitmapTexture) then
				(			
					sea.textures[c] = dm
					appendBitmap dm.filename n
				)
				else
				(
					error1013 type n		
				)
				
				if (emm and mm != undefined) do
				(
					if (classof mm == BitmapTexture) then
					(
						sea.masks[c] = mm
						appendBitmap mm.filename n
					)
					else
					(
						error1013 type n
					)
				)
				
				c += 1
			)						
		)
	)	
	else
	(
		error1013 type n		
	)			
	
	return sea
)

function compileMaterial mat names mats =
(	
	local matat = (containsString names mat.name)	
	local newmat = SEAMaterial mat
	
	if (matat > 0) do 
	( 				
		if mats[matat] != mat do
		(
			error1002 mat.name
			return undefined
		)
		
		return undefined
	)
	
	if (mat.shaderType != 1) then
	(
		local t = "Anisotropic"		
		if (mat.shaderType == 2) then t = "Metal"
		else if (mat.shaderType == 3) then t = "Multi-Layer"
		else if (mat.shaderType == 4) then t = "Oren-Nayar-Blinn"
		else if (mat.shaderType == 5) then t = "Phong"
		else if (mat.shaderType == 6) then t = "Strauss"
		else if (mat.shaderType == 7) then t = "Translucent Shader"
		
		error1012 t mat.name
		return undefined
	)
	
	if (mat.diffuseMap != undefined and mat.diffuseMapEnable) do
	(
		newmat.diffuseMap = appendTexture mat.diffusemap mat.name "Diffuse Map" true
	)
	if (mat.ambientMap  != undefined and mat.ambientMapEnable) do
	(
		newmat.ambientMap = appendTexture mat.ambientMap mat.name "Ambient Map" false
	)
	if (mat.specularMap  != undefined and mat.specularMapEnable) do
	(
		newmat.specularMap = appendTexture mat.specularMap mat.name "Specular Map" false
	)
	if (mat.selfIllumMap  != undefined and mat.selfIllumMapEnable) do
	(
		newmat.selfIllumMap = appendTexture mat.selfIllumMap mat.name "Self-Ilumination Map" false
	)
	if (mat.opacityMap  != undefined and mat.opacityMapEnable) do
	(
		newmat.opacityMap = appendTexture mat.opacityMap mat.name "Opacity Map" false
	)
	if (mat.refractionMap  != undefined and mat.refractionMapEnable) do
	(
		newmat.refractionMap = appendTexture mat.refractionMap mat.name "Refraction Map" false
	)
	if (mat.reflectionMap  != undefined and mat.reflectionMapEnable) do
	(
		if classof mat.reflectionMap == Falloff then
		(
			if mat.reflectionMap.type == 2 then
			(
				newmat.fresnel = true
				newmat.fresnelPower = mat.reflectionMap.ior
				newmat.fresnelAmount = mat.reflectionMap.texture_output.Output_Amount 
				
				if mat.reflectionMap.map2On == true and mat.reflectionMap.map2 != undefined then
				(									
					newmat.reflectionMap = appendTexture mat.reflectionMap.map2 mat.name "Reflection Map" false
				)
				else
				(
					newmat.fresnelColor = mat.reflectionMap.color2										
				)
			)
			else
			(
				error1015 "Reflection Map" mat.name
			)
		)
		else
		(
			newmat.reflectionMap = appendTexture mat.reflectionMap mat.name "Reflection Map" false
		)
	)
	if (mat.bumpMap  != undefined and mat.bumpMapEnable) do
	(
		if (classof mat.bumpMap == Normal_Bump) then
		(
			if (mat.bumpMap.normal_map != undefined) do
			(
				newmat.normalMap = appendTexture mat.bumpMap.normal_map mat.name "Normal Map" false
			)			
			if (mat.bumpMap.bump_map != undefined) do
			(
				warning2005 mat.name
			)			
		)
		else
		(
			newmat.bumpMap = appendTexture mat.bumpMap mat.name "Bump Map" false
		)
	)
	
	seaMaterialList[seaMaterialList.count+1] = newmat
	names[names.count+1] = mat.name
	mats[mats.count+1] = mat
)

function seaDispose =
(
	for i=1 to seaMeshList.count do
	(
		if (seaMeshList[i].temp != seaMeshList[i].obj) do
		(
			delete (seaMeshList[i].temp)
		)
	)
)

-- md5 exporter based in der_ton, tom-(at)gmx.de

--user defined globals:
global g_mapchannel = 1 --the mapping channel that contains the texture vertices and faces, usually "1". change this only if you know what you're doing
global g_bindpos_frame = 0
--user defined globals end here

global md5skin --the skin modifier object
global md5bonemapping = #() --mapping of the skin modifier bone index to the md5 bone index
global md5skel --the skeleton structure that is going to be constructed

fn righthand_mat mat =
(
	-- convert the matrix to a righthanded one, by flipping its Z axis if it's lefthanded
	if dot (cross mat.row1 mat.row2) mat.row3 > 0 then
	(
		md5mat = copy mat
	)
	else
	(
		md5mat = copy mat
		md5mat.row3 = - md5mat.row3
	)
	return md5mat
)

struct md5vertex
(
	loc,
	uvmap,
	numweights,
	firstweightindx,
	weights,
	origvertindx,
	origtvertindx,
	
	fn tomd5mesh data meshName =
	(
		data.WriteFloat uvmap[1]
		data.WriteFloat uvmap[2]
		
		data.WriteShort (firstweightindx-1)
		data.WriteShort (numweights)
				
		if (numweights==0) then warning2007 meshName
	)
)

struct md5weight
(
	loc,
	tboneid,
	tweight,
	
	fn tomd5mesh data =
	(
		data.WriteShort (md5bonemapping[tboneid]-1)
		
		data.WriteFloat tweight
		
		data.WriteFloat -loc.x
		data.WriteFloat -loc.y
		data.WriteFloat -loc.z
	)
)

struct md5tri
(
	v1,
	v2,
	v3,
	fn tomd5mesh data =
	(
		data.WriteShort (v1-1)
		data.WriteShort (v3-1)
		data.WriteShort (v2-1)
	)
)


struct md5submesh
(
	verts = #(),
	weights = #(),
	tris = #(),
	shader,
	matrid,
	
	fn tomd5mesh data meshName =
	(
		data.WriteUTFTiny shader
		data.WriteShort verts.count
		data.WriteShort tris.count
		data.WriteShort weights.count
		
		for v=1 to verts.count do (
			verts[v].tomd5mesh data meshName
		)
				
		for t=1 to tris.count do (
			tris[t].tomd5mesh data
		)
		
		for t=1 to weights.count do (
			weights[t].tomd5mesh data
		)		
	),
	
	fn checkforvertex vertindx tvertindx=
	(
		for i=1 to verts.count do
		(
			if (vertindx == verts[i].origvertindx and tvertindx == verts[i].origtvertindx) do
			(
				return i
			)
		)
		return undefined
	),
	
	fn addmd5tri obj triindx self =
	(
		vertindices = getface obj triindx
		if (meshop.getMapSupport obj 1) then
			tvertindices = meshop.getmapface obj g_mapchannel triindx
		else
			tvertindices = [0,0,0]
		vertindices = #(vertindices.x as integer, vertindices.y as integer, vertindices.z as integer)
		tvertindices = #(tvertindices.x as integer, tvertindices.y as integer, tvertindices.z as integer)
		md5vertindices = #()
		for i=1 to 3 do
		(
			md5vertindices[i] = self.checkforvertex vertindices[i] tvertindices[i]
			if (md5vertindices[i] == undefined) do
			(
				pos = obj.verts[vertindices[i]].pos
				if (meshop.getMapSupport obj g_mapchannel) then
					uv = meshop.getmapvert obj g_mapchannel tvertindices[i]
				else uv = [0,0,0]
				numweights = skinops.getvertexweightcount md5skin vertindices[i]
				newvert = md5vertex pos #(uv.x, 1.0 - uv.y) numweights (self.weights.count+1) origvertindx:vertindices[i] origtvertindx:tvertindices[i] 
				for w = 1 to numweights do 
				(
					weightval = skinops.getvertexweight md5skin vertindices[i] w
					boneid = skinops.getvertexweightboneid md5skin vertindices[i] w
					bspos = pos * md5skel.md5bones[boneid].bindmatinv
					newweight = md5weight bspos boneid weightval
					append self.weights newweight					
				)
				append self.verts newvert
				md5vertindices[i] = self.verts.count
			)
		)
		append self.tris (md5tri md5vertindices[1] md5vertindices[2] md5vertindices[3])
	) --phew, that function was quite non-trivial... now I gotta take a break and play Turrican
)

struct md5mesh
(
	submeshes = #(),
	bones = #(),
	
	fn tomd5mesh data meshName =
	(
		--data.WriteByte submeshes.count
		
		for i=1 to submeshes.count do
		(
			submeshes[i].tomd5mesh data meshName
		)
	)
)

struct md5bone
(
	name,
	theboneobj, --the bone's node
	parentptr,	--parent bone's node
	parentmd5bone,
	md5boneindex,
	bindmat = matrix3 1, --initialized as identity matrix, bone's idle matrix
	bindmatinv = matrix3 1, --stores the inverted idle matrix, to speed up calculations
	
	fn tomd5mesh data =
	(
		data.WriteUTFTiny name
		
		if (parentptr != undefined) then 
			data.WriteShort parentmd5bone.md5boneindex --default (parentmd5bone.md5boneindex-1)
		else
			data.WriteShort 0
		
		data.WriteFloat -bindmat[4].x
		data.WriteFloat -bindmat[4].y
		data.WriteFloat -bindmat[4].z		
		
		bindquat = bindmat as quat
		if (bindquat.w<0) then 
		(
			bindquat.x=-bindquat.x
			bindquat.y=-bindquat.y
			bindquat.z=-bindquat.z
		)
		
		data.WriteFloat bindquat.x
		data.WriteFloat bindquat.y
		data.WriteFloat bindquat.z	
		
		--if (parentptr != undefined) then ( data.WriteUTFTiny parentmd5bone.name )		
		
		return s
	)
)

struct md5animation
(
	md5skeleton,
	numFrames,
	numJoints,
	md5framerate,
	numAnimatedComponents,
	bounds=#(),
	baseframe = #(),
	frames = #(),
	boneflags = #(),
	boneframedataindex = #(),
	
	fn tomd5anim data =
	(
		data.WriteByte frameRate
		data.WriteShort numFrames
		data.WriteShort numJoints		
		data.WriteShort numAnimatedComponents
		
		-- hierarchy
		for i=1 to md5skeleton.md5bones.count do
		(
			for j=1 to md5skeleton.md5bones.count do
			(
				if md5bonemapping[j]==i then 
				(
					if (md5skeleton.md5bones[j].parentptr != undefined) then 
					(
						parentmd5indx = md5skeleton.md5bones[j].parentmd5bone.md5boneindex
						parentmd5name = md5skeleton.md5bones[j].parentmd5bone.name
					)
					else
					(
						parentmd5indx = 0
						parentmd5name = ""
					)

					data.WriteUTFTiny md5skeleton.md5bones[j].name
					data.WriteShort parentmd5indx
					data.WriteShort boneflags[j]
					data.WriteShort boneframedataindex[j]										
					--data.WriteUTFTiny parentmd5name
				)
			)
		)
		
		-- bounds
		for i=1 to numFrames do
		(
			data.WriteFloat bounds[i*6-5]
			data.WriteFloat bounds[i*6-4]
			data.WriteFloat bounds[i*6-3]
			
			data.WriteFloat bounds[i*6-2]
			data.WriteFloat bounds[i*6-1]
			data.WriteFloat bounds[i*6]						
		)

		-- baseframe
		for i=1 to numJoints do
		(
			data.WriteFloat -baseframe[i*6-5]
			data.WriteFloat -baseframe[i*6-4]
			data.WriteFloat -baseframe[i*6-3]
			
			data.WriteFloat baseframe[i*6-2]
			data.WriteFloat baseframe[i*6-1]
			data.WriteFloat baseframe[i*6]						
		)

		for t=1 to numFrames do
		(
			-- frame
			for i=1 to numJoints do
			(
				data.WriteFloat -frames[t][i*6-5]
				data.WriteFloat -frames[t][i*6-4]
				data.WriteFloat -frames[t][i*6-3]
				
				data.WriteFloat frames[t][i*6-2]
				data.WriteFloat frames[t][i*6-1]
				data.WriteFloat frames[t][i*6]
			)
		)
	),
	
	fn build timerange obj =
	(
		numFrames = timerange[2] - timerange[1] + 1
		numJoints = md5skeleton.md5bones.count
		md5framerate = framerate
		--build bounds
		originbone = undefined
		for j=1 to md5skeleton.md5bones.count do
		(
			if md5bonemapping[j]==1 then 
			(
				originbone = md5skeleton.md5bones[j].theboneobj
				format "using originbone: %\n" originbone.name
			)
		)
		
		set time timerange[1]
		origposx = originbone.transform[4].x
		origposy = originbone.transform[4].y
		origposz = originbone.transform[4].z
		
		for t=timerange[1] to timerange[2] do
		(
			set time t

			append bounds (obj.min.x - origposx)
			append bounds (obj.min.y - origposy)
			append bounds (obj.min.z - origposz)
			append bounds (obj.max.x - origposx)
			append bounds (obj.max.y - origposy)
			append bounds (obj.max.z - origposz)
			append frames #() -- initialize each of the elements in frames with empty array
		)

		-- build baseframe
		set time timerange[1]
		
		for i=1 to md5skeleton.md5bones.count do
		(
			for j=1 to md5skeleton.md5bones.count do
			(
				if md5bonemapping[j]==i then
				(
					if md5skeleton.md5bones[j].parentptr!=undefined then
					(	
						tr = copy md5skeleton.md5bones[j].parentptr.transform
						tr = righthand_mat tr
						tr = inverse tr
					)
					else
						tr = matrix3 1
					tr = md5skeleton.md5bones[j].theboneobj.transform * tr
					tr = righthand_mat tr

					baseframe[i*6-5] = tr[4].x
					baseframe[i*6-4] = tr[4].y
					baseframe[i*6-3] = tr[4].z
					quat = copy tr.rotationpart
					if (quat.w<0) then 
					(
						quat.x=-quat.x
						quat.y=-quat.y
						quat.z=-quat.z
					)
					baseframe[i*6-2] = quat.x
					baseframe[i*6-1] = quat.y
					baseframe[i*6-0] = quat.z
				)
			)
		)
		
		for abst = timerange[1] to timerange[2] do
		(
			set time abst
			for i=1 to md5skeleton.md5bones.count do
			(
				for j=1 to md5skeleton.md5bones.count do
				(
					if md5bonemapping[j]==i then
					(
						boneflags[j] = 63
						boneframedataindex[j] = (i-1)*6
						t = abst - timerange[1]+1
						if md5skeleton.md5bones[j].parentptr!=undefined then
						(	
							tr = copy md5skeleton.md5bones[j].parentptr.transform
							tr = righthand_mat tr
							tr = inverse tr
						)
						else
							tr = matrix3 1
						tr = md5skeleton.md5bones[j].theboneobj.transform * tr
						tr = righthand_mat tr
	
						frames[t][i*6-5] = tr[4].x
						frames[t][i*6-4] = tr[4].y
						frames[t][i*6-3] = tr[4].z
						quat = copy tr.rotationpart
						if (quat.w<0) then 
						(
							quat.x=-quat.x
							quat.y=-quat.y
							quat.z=-quat.z
						)
						frames[t][i*6-2] = quat.x
						frames[t][i*6-1] = quat.y
						frames[t][i*6-0] = quat.z
					)
				)
			)
		)
		numAnimatedComponents = numJoints * 6 --boneframedataindexcounter
	)
)

struct md5skeleton
(
	md5bones = #(),
	
	fn buildparentlinks =
	(
		for i=1 to md5bones.count do
		(
			if md5bones[i].parentptr!=undefined do
			(
				for j=1 to md5bones.count do
				(
					if md5bones[i].parentptr==md5bones[j].theboneobj then md5bones[i].parentmd5bone=md5bones[j]
				)
				if md5bones[i].parentmd5bone==undefined then md5bones[i].parentptr=undefined
			)
		)
	),
	
	fn generatemapping =
	(
		currentb = 1
		while (currentb<=md5bones.count) do
		(
			--print currentb --a cheap progress indicator
			for i=1 to md5bones.count do
			(
				if md5bones[i].md5boneindex==undefined and (md5bones[i].parentmd5bone==undefined or (md5bones[i].parentmd5bone!=undefined and md5bones[i].parentmd5bone.md5boneindex!=undefined)) do
				(
					md5bones[i].md5boneindex=currentb
					md5bonemapping[i]=currentb
					currentb +=1
				)
			)
		)
	),
	
	fn tomd5mesh data numMeshes =
	(
		data.WriteShort md5bones.count
		data.WriteByte numMeshes
		
		for i=1 to md5bones.count do
		(
			for j=1 to md5bones.count do
			(
				if md5bonemapping[j]==i then 
				(
					md5bones[j].tomd5mesh data
				)
			)
		)
	)
)

-- SEA3D

rollout SEAListener "SEA3D Listener" width:500 height:300
(
    dotNetControl dncText "System.Windows.Forms.Textbox" width:490 height:290 align:#center

    on SEAListener open do
    (
        dncText.Font = dotNetObject "System.Drawing.Font" "MS Sans Serif" 8 ((dotNetClass "System.Drawing.FontStyle").Regular)
		dncText.BorderStyle = (dotNetClass "System.Windows.Forms.BorderStyle").FixedSingle
		dncText.BackColor = (dotNetClass "System.Drawing.Color").fromARGB (((colorMan.getColor #background) * 255)[1] as integer) (((colorMan.getColor #background) * 255)[2] as integer) (((colorMan.getColor #background) * 255)[3] as integer)
		dncText.ForeColor = (dotNetClass "System.Drawing.Color").fromARGB (((colorMan.getColor #text) * 255)[1] as integer) (((colorMan.getColor #text) * 255)[2] as integer) (((colorMan.getColor #text) * 255)[3] as integer)
		dncText.MultiLine = true
		dncText.WordWrap = true
		dncText.ReadOnly = true
		dncText.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Vertical
		dncText.Text = seaListenerText
    )
)

rollout SEA "SEA3D"
(		
	radiobuttons compressItem "Compress Method" pos:[7,4] default:2 labels:#("None", "ZLib", "Deflate")	
	radiobuttons exportItem "Export" pos:[7,40] default:2 labels:#("All", "Visible", "Selected")	
			
	progressBar progress pos:[7,82] width:200 height:14 align:#center
	
	--button previewButton "Preview" pos:[100,104] 		
	button exportButton "Export" pos:[159,104] 		
	
	hyperLink __url "code.google.com/p/sea3d/" address:"http://code.google.com/p/sea3d/" align:#center
	label __copyright "SEA3D 1.0 © Sunag Entertainment 2012" align:#center
		
	on protectItem changed s do
	(		
		btn4.enabled = edt1.enabled = s != 1
	)
	
	on compressItem changed s do
	(
		if s == 1 then seaconfig_compress = "none"
		else if s == 2 then seaconfig_compress = "zlib"
		else if s == 3 then seaconfig_compress = "deflate"
	)
	
	on exportItem changed s do
	(
		if s == 1 then seaconfig_export = "all"
		else if s == 2 then seaconfig_export = "visible"
		else if s == 3 then seaconfig_export = "selected"
	)
	
	fn setProgress v =
	(
		progress.value = v
		--sleep 0.1
	)
	
	fn md5exportobj obj = 
	(
		max modify mode
		set coordsys world
		mods = obj.modifiers
		for i=1 to mods.count do
		(
			if (classof mods[i] == Skin) do
			(
				md5skin = mods[i]
				modPanel.setCurrentObject obj.modifiers[i]
				exit
			)
		)
		
		set time g_bindpos_frame
		--md5 data construction begins here
		numbones = skinops.getnumberbones md5skin
		md5skel = md5skeleton()
		for i=1 to numbones do
		(
			bname = skinops.getbonename md5skin i 1
			bn = md5bone name:bname
			append md5skel.md5bones bn
			boneobjname = skinops.getbonename md5skin i 0
			thebone = getnodebyname boneobjname
			bn.theboneobj = thebone
			if (thebone.parent != undefined) then bn.parentptr = thebone.parent
			bn.bindmat = thebone.transform
			bn.bindmat = righthand_mat bn.bindmat
			bindmat2 = copy bn.bindmat
			bn.bindmatinv = inverse bn.bindmat
		)		
		md5skel.buildparentlinks()
		md5skel.generatemapping()
		
		faces = obj.faces
		usedmaterials = #()
		-- collect used materials
		for i=1 to faces.count do
		(
			m = getfacematid obj i
			j=1 
			found=false
			while (j<=usedmaterials.count and found==false) do
			(
				if usedmaterials[j]==m then found=true
				j+=1
			)
			if found==false then usedmaterials[usedmaterials.count+1]=m
		)
		-- for each used material, we need a submesh
		md5 = md5mesh()
		if (obj.material!=undefined) then
		(
			for i=1 to usedmaterials.count do
			(
				md5.submeshes[i]= md5submesh()
				md5.submeshes[i].matrid = usedmaterials[i]
			)
		)
		else
		(
			md5.submeshes[1]= md5submesh()
			md5.submeshes[1].matrid = 1
			usedmaterials = #()
		)
		
		if (usedmaterials.count>1 and ((classof obj.material) as string == "Multimaterial")) do
		(
			mt = obj.material
			for i=1 to usedmaterials.count do
			(
				md5.submeshes[i].shader = obj.material.materiallist[usedmaterials[i]].name
			)
		)
		if (usedmaterials.count>1 and ((classof obj.material) as string != "Multimaterial")) do
		(
			for i=1 to md5.submeshes.count do
			(
				md5.submeshes[i].shader = obj.material.name
			)
		)
		
		if (usedmaterials.count==1) do
		(
			if (classof obj.material) as string != "Multimaterial" then
			(
				md5.submeshes[1].shader = obj.material.name
			)
			else
			(
				md5.submeshes[1].shader = obj.material.materiallist[1].name
			)
		)
		
		if obj.material != undefined then
		(
			-- collect faces into the submeshes, according to the material the faces use
			for i=1 to faces.count do
			(
				m = getfacematid obj i
				j=1 
				while (j<usedmaterials.count) do
				(
					if usedmaterials[j]==m then exit
					else j+=1
				)
				
				md5.submeshes[j].addmd5tri obj i md5.submeshes[j]
			)
		)
		else
		(
			for i=1 to faces.count do
			(
				md5.submeshes[1].addmd5tri obj i md5.submeshes[1]
			)
		)
		
		local anm = ""
		
		-- Export Animation
		if seaconfig_animation do
		(
			local file = newFile()
			local data = file.Data
			
			anm = obj.name
			
			file.Filename = obj.name + ".skeleton-animation"
			
			md5anim = md5animation(md5skel)
			md5anim.build seaTimeRange obj
			md5anim.tomd5anim data
			
			appendFile file
		)
		
		-- Export Mesh		
		if seaconfig_geometry do
		(
			local file = newFile()
			local data = file.Data
			local tokens = #()
			
			if (obj.castShadows==false) do (addToken tokens "castShadows" obj.castShadows "boolean")
			
			exportTokens data tokens
			
			data.WriteByte obj.wirecolor.r
			data.WriteByte obj.wirecolor.g
			data.WriteByte obj.wirecolor.b
			
			file.Filename = obj.name + ".skeleton-mesh"
			
			data.WriteUTFTiny anm
			
			md5skel.tomd5mesh data md5.submeshes.count
			md5.tomd5mesh data obj.name
			
			appendFile file	
		)
	)
	
	fn exportMesh =
	(
		for i=1 to seaMeshList.count do
		(
			setProgress (((float i) / (float seaMeshList.count)) * 100.0)
			local sea = seaMeshList[i]
			
			if sea.containsSkin then md5exportobj sea.obj
			else exportMeshObject sea undefined undefined						
		)
		
		return seaErrors.count
	)
	
	fn compileObjects list =
	(
		setProgress 0
		progress.color = color 0 119 212
		
		-- Colleted Names
		local _names = #()
		for i=1 to list.count do
		(
			local n = list[i].name		
			if (containsString _names n) > 0 do error1001 n		
			_names[_names.count+1] = n
		)
		
		if (seaErrors.count>0) do 
			return seaErrors.count
		
		-- Valid Objects		
		local mats = #()
		local _mats = #()
		local _mats_names = #()		
		for i=1 to list.count do
		(
			setProgress (((float i) / (float list.count)) * 100.0)
			
			local n =  list[i]
			
			if SuperClassOf n == GeometryClass then
			(						
				if (ClassOf n != TargetObject and ClassOf n != HubObject and ClassOf n != CATBone and ClassOf n != Bone and Classof n != BoneGeometry) then --if ((ClassOf n == Editable_Mesh) or (ClassOf n == PolyMeshObject) or (ClassOf n == Editable_Poly)) then
				(
					local instanceObject = false
					local instanceObjectID = -1
					
					-- Check Instaces				
					InstanceMgr.GetInstances n &instances				
					if (instances.count > 0) do
					(					
						for m=1 to seaMeshList.count do				
						(
							for mi=1 to instances.count do		
							(
								if (instanceObject == false and (seaMeshList[m].obj == instances[mi])) do
								(
									instanceObject = true
									instanceObjectID = m
								)							
							)
						)
					)
					
					local containsSkin = false
					
					-- Modifiers
					if (instanceObject == false) do
					(
						for m=1 to n.modifiers.count do				
						(
							if (ClassOf n.modifiers[m] == Skin) then 
							(
								if seaconfig_skeleton then ( containsSkin = true )
								else (
									warning2003 n.name
								)
							)
							else if (ClassOf n.modifiers[m] == Morpher) then 
							(
								warning2004 n.name				
							)
						)
					)
					
					-- Convert to Mesh
					local obj = n								
					if ClassOf obj != Editable_mesh  do
					(
						obj = copy obj
						convertToMesh obj		
					)												
					
					-- Separate Material	
					polymats = #()	
					mats = #()
					local numfaces = getnumfaces obj	
					for f = 1 to numfaces do
					(
						local m = getfacematid obj f								
						if polymats[m] == undefined do polymats[m] = #()		
						polymats[m][polymats[m].count+1] = f
					)
					
					if obj.material != undefined do
					(
						if classof obj.material == StandardMaterial then
						(					
							for m=1 to polymats.count do
							(
								if (polymats[m] != undefined) do mats[m] = obj.material.name
							)
							
							compileMaterial obj.material _mats_names _mats		
						)
						else if classof obj.material == MultiMaterial then
						(
							for m=1 to obj.material.materiallist.count do
							(
								if (polymats[m] != undefined) do
								(
									local mat = obj.material.materiallist[m]
									if classof mat == StandardMaterial then
									(
										mats[m] = mat.name
										compileMaterial mat _mats_names _mats			
									)
									else
									(
										error1011 mat.name
									)
								)
							)
						)
						else
						(
							error1011 obj.material.name
						)							
					)							

					local sMesh = (SEAMesh n obj polymats mats containsSkin)
					
					if (instanceObject) then
					(
						if (n != obj) then ( delete obj )
						local hmesh = seaMeshList[instanceObjectID]
						hmesh.instances[hmesh.instances.count+1] = sMesh
					)
					else
					(
						seaMeshList[seaMeshList.count+1] = sMesh
					)
				)
				else
				(
					--warning2002 n.name
				)
			)
			else if SuperClassOf n == Camera then
			(
				seaCameraList[seaCameraList.count+1] = SEACamera n
			)
			else if SuperClassOf n == Helper then
			(
				seaHelperList[seaHelperList.count+1] = SEAHelper n
			)
			else if SuperClassOf n == Light then
			(
				if (n.type == #targetspot or n.type == #omni or n.type == #freespot or n.type == #targetdirect or n.type == #freedirect) then
				(
					if n.enabled do (seaLightList[seaLightList.count+1] = SEALight n)
				)
				else
				(
					warning2006 n.name
				)
			)
			else
			(			
				warning2001 n.name
			)
		)
		
		return seaErrors.count
	)
	
	fn exportList list =
	(
		if (list.count == 0) do
		(
			messagebox "No objects selected."
			return undefined
		)
		
		--DisableSceneRedraw();
		
		try (			
			if (compileObjects list) == 0 do
			(	
				setProgress 0
				progress.color = color 119 212 212
				
				local passCount = (1.0 / 7.0) * 100.0
				
				if (seaconfig_env) do
				(				
					if classof environmentMap == BitmapTexture then
					(
						appendBitmap environmentMap.filename "Environment Map"					
						seaEnvList[seaEnvList.count+1] = SEAEnv environmentMap "environment"
					)
				)
					
				if (exportBitmap() > 0) do return undefined
				setProgress (passCount * 1)
					
				if (exportTexture() > 0) do return undefined
				setProgress (passCount * 2)
				
				if (exportLight() > 0) do return undefined
				setProgress (passCount * 3)
				
				if (exportMaterial() > 0) do return undefined
				setProgress (passCount * 4)
				
				if (exportMesh() > 0) do return undefined
				setProgress (passCount * 5)				
				
				if (exportCamera() > 0) do return undefined
				setProgress (passCount * 6)
				
				if (exportHelper() > 0) do return undefined
				setProgress (passCount * 7)												
				
				if seaconfig_env do
				(
					if (exportEnv() > 0) do return undefined
				)
				
				local sea3d = (dotNetObject "Sunag.SEA.Assets" "3D:1.0")
				
				for i=1 to seaFileList.count do
				(
					local file = seaFileList[i]	
					
					if  (
							(seaconfig_animation and (file.Type == "animation" or (file.Type == "skeleton-animation" and seaconfig_skeleton))) or
							(seaconfig_geometry and (file.Type == "mesh" or (file.Type == "skeleton-mesh" and seaconfig_skeleton))) or
							(seaconfig_camera and (file.Type == "camera-free" or file.Type == "camera-target")) or
							(seaconfig_material and file.Type == "material") or
							(seaconfig_texture and (file.Type == "texture" or file.Type == "bitmap")) or
							(seaconfig_light and (file.Type == "light-target" or file.Type == "light-free" or file.Type == "light-point")) or
							(seaconfig_helper and file.Type == "helper") or
							(seaconfig_env and file.Type == "environment")
						) do
					(			
						sea3d.AddFile file
					)
				)
				
				sea3d.Save()
			)
			
			if (seaWarning.count > 0 or seaErrors.count > 0) do
			(
				seaListenerText = ""
				
				for i=1 to seaErrors.count do
				(
					seaListenerText = ("• Error " + (seaErrors[i]) + "\r\n") + seaListenerText
				)
				
				for i=1 to seaWarning.count do
				(
					seaListenerText = ("• Warning " + (seaWarning[i]) + "\r\n") + seaListenerText
				)
				
				try destroyDialog SEAListener catch()
				createDialog SEAListener
			)		
		) catch ( messagebox ("Error: " + (getCurrentException())) )
		
		setProgress 0
		
		set time off
		--EnableSceneRedraw();	
			
		seaDispose()
		
		gc()
	)
	
	on exportButton pressed do
	(
		seaErrors = #()
		seaWarning = #()

		seaBitmapList = #()
		seaTextureList = #()
		seaMaterialList = #()
		seaMeshList = #()
		seaCameraList = #()
		seaHelperList = #()
		seaLightList = #()
		seaEnvList = #()
		seaFileList = #()
		
		local seaconfig_compressID = 0
		if seaconfig_compress == "zlib" then seaconfig_compressID = 1
		else if seaconfig_compress == "deflate" then seaconfig_compressID = 2
		
		if (seaconfig_export == "all") then
		(
			exportList (for o in objects where true collect o)
		)
		else if (seaconfig_export == "visible") then
		(
			exportList (for o in objects where not o.isHiddenInVpt collect o)
		)
		else if (seaconfig_export == "selected") then
		(			
			exportList (GetCurrentSelection())
		)
	)
)

rollout SEAAnimation "Animation"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	spinner _start "Start:" pos:[17,27] range:[-100000,100000,animationRange.start.frame as integer] width:85 type:#integer
	spinner _end "End:" pos:[117,27] range:[-100000,100000,animationRange.end.frame as integer] width:85 type:#integer
	
	fn updateAnimationRange =
	(
		seaTimeRange = #(_start.value, _end.value)
	)
	
	on _start changed s do
	(
		if (_start.value > _end.value) do _end.value = _start.value
		updateAnimationRange()
	)
	
	on _end changed s do
	(
		if (_end.value < _start.value) do _start.value = _end.value
		updateAnimationRange()
	)
	
	on _enabled changed s do
	(
		_start.enabled = _end.enabled = s
		seaconfig_animation = s
	)
)

rollout SEAGeometry "Geometry"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	checkbox _multiple "Multiple Channels" pos:[80,7] checked:true
	checkbox _vertexColor "Vertex Color" pos:[80,27] checked:true toolTip:"Export Vertex Color if available."
	
	on _enabled changed s do
	(
		_multiple.enabled = _vertexColor.enabled = s
		seaconfig_geometry = s
	)
	
	on _multiple changed s do
	(
		seaconfig_multiplechannel = s
	)
	
	on _vertexColor changed s do
	(
		seaconfig_vertexcolor = s
	)
)

rollout SEASkeleton "Skeleton"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true	
	spinner _mapchannel "Mapchannel:" pos:[117,7] range:[1,99,1] type:#integer width:85
	spinner _bindpos "Bindpos:" pos:[9,29] range:[-1000000,1000000,0] type:#integer
	button _about "About" pos:[157,29] height:16
		
	on _enabled changed s do
	(
		_mapchannel.enabled = _bindpos.enabled = s
		seaconfig_skeleton = s
	)
	
	on _mapchannel changed s do
	(
		g_mapchannel = s
	)	

	on _bindpos changed s do
	(
		g_bindpos_frame = s
	)	
	
	on _about pressed do
	(
		messagebox "Skin exporter based in\nMD5 Exporter  V0.92 - 2004-08-24\n(C) 2004, der_ton (tom-@gmx.de)\nVisit www.doom3world.org forum for tech-support\nAny feedback is welcome! :)"
	)
)

rollout SEAMaterials "Materials"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	
	on _enabled changed s do
	(
		seaconfig_texture = s
	)
)

rollout SEATextures "Textures"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	
	on _enabled changed s do
	(
		seaconfig_texture = s
	)
)

rollout SEACameras "Cameras"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	
	on _enabled changed s do
	(
		seaconfig_camera = s
	)
)

rollout SEALights "Lights"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true
	
	on _enabled changed s do
	(
		seaconfig_light = s
	)
)

rollout SEAEnvironment "Environment"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true	
	
	on _enabled changed s do
	(
		seaconfig_env = s
	)
)

rollout SEAHelpers "Helpers"
(
	checkbox _enabled "Enabled" pos:[7,7] checked:true	
	
	on _enabled changed s do
	(
		seaconfig_helper = s
	)
)

if seafloater != undefined do
(
	closerolloutfloater seafloater 
)

seafloater = newRolloutFloater "SEA3D Exporter" 230 500

addRollout SEA seafloater rolledUp:false
addRollout SEAAnimation seafloater rolledUp:false
addRollout SEAGeometry seafloater rolledUp:false
addRollout SEASkeleton seafloater rolledUp:false
addRollout SEAMaterials seafloater rolledUp:false
addRollout SEATextures seafloater rolledUp:false
addRollout SEACameras seafloater rolledUp:false
addRollout SEALights seafloater rolledUp:false
addRollout SEAEnvironment seafloater rolledUp:false
addRollout SEAHelpers seafloater rolledUp:false