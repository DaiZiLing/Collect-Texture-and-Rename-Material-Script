
/*
全部炸开：所有模型解组、解除链接
--材质名为贴图名：所有使用到了的贴图名字变成对应的材质名字，没有用到的不管，并整进路径里
  --必须先把贴图路径全部绝对化
  --多维材质若ID最大的ID数不等于子材质数量，会报错
--贴图整理到文件夹：所有用到的或者没用到的都整进路径里
材质给予编辑器：每个物体的材质整进材质编辑器里，包括重复的
*/

rollout sort_map "整理贴图脚本 for 2021（Vray）" width:270 height:269
(
	button 'btn1' "整理整个场景贴图" pos:[11,194] width:119 height:39 align:#left
	edittext 'edt1' "" pos:[107,6] width:153 height:24 align:#left
	label 'lbl1' "贴图到复制路径..." pos:[11,10] width:99 height:20 align:#left
	button 'btn3' "整理视口内贴图" pos:[141,149] width:119 height:39 align:#left
	button 'btn6' "前处理" pos:[10,149] width:119 height:39 align:#left
	button 'btn15' "视口材质列入编辑器" pos:[141,194] width:119 height:39 align:#left
	checkbox 'chk30' "环境光颜色" pos:[13,34] width:85 height:18 align:#left
	checkbox 'chk31' "漫反射颜色" pos:[13,53] width:85 height:18 checked:true align:#left
	checkbox 'chk32' "高光颜色" pos:[13,72] width:66 height:18 align:#left
	checkbox 'chk33' "高光级别" pos:[13,91] width:66 height:18 align:#left
	checkbox 'chk34' "光泽度" pos:[106,34] width:55 height:18 align:#left
	checkbox 'chk35' "自发光" pos:[106,53] width:66 height:18 align:#left
	checkbox 'chk36' "不透明度" pos:[106,72] width:85 height:18 align:#left
	checkbox 'chk37' "过滤色" pos:[106,91] width:66 height:18 align:#left
	checkbox 'chk38' "凹凸" pos:[196,34] width:55 height:18 align:#left
	checkbox 'chk39' "反射" pos:[196,53] width:55 height:18 align:#left
	checkbox 'chk40' "折射" pos:[196,72] width:55 height:18 align:#left
	checkbox 'chk41' "置换" pos:[196,91] width:55 height:18 align:#left
	checkbox 'chk42' "HDRI" pos:[13,115] width:66 height:18 align:#left
	checkbox 'chk43' "VRMesh" pos:[106,115] width:66 height:18 align:#left
	checkbox 'chk44' "Dummy" pos:[196,115] width:55 height:18 align:#left
	label 'lbl8' "进度：" pos:[11,245] width:40 height:20 align:#left
	label 'lbl9' "-- 未运行 --" pos:[158,244] width:103 height:20 align:#left
	
	progressBar 'jindutiao' "" pos:[46,245] width:100 height:10 color:[255,102,241] align:#left

	local flieminzi
	local Texture_Path
	global caizhi_num = 1
	global mapfileN
	global index
	global mapfiles = #() 
	global huoquwenjian
	global caizhi_shux
	global caizhi_namee
	global caizhi_shuliang
	global bbc
	global zicaizhimin
	global caizhide
	global caizhideliang
	

	on btn1 pressed do --贴图整理到路径
	(
		mapfiles = #() 
		fn addmap mapfile = 
		(
			mapfileN = mapfile as name 
			index = finditem mapfiles mapfileN 
			if index == 0 do append mapfiles mapfileN 
		) 
		enumeratefiles addmap 
		sort mapfiles
		for mapfile in mapfiles do 
		(
			print (mapfile as String)
			--print (getFilenameFileT mapfile)
			if Texture_Path == Null do
			(
				messagebox"Input Path！"
				exit
			)
			copyFile mapfile (Texture_Path + "//" + getFilenameFile mapfile + getFilenameType mapfile)
			lbl9.text = getFilenameFile mapfile + getFilenameType mapfile
		)
		
		lbl9.text = "-- 完成 --"
	)
	on edt1 changed var do
	(
		Texture_Path = var
	)
	on btn3 pressed do --材质名为贴图名
	(
		--macros.run "Medit Tools" "clear_medit_slots"
		max select all
		caizhi_num = 1
		
		for i in $ do 
		(
			
			if Texture_Path == Null do
			(
				messagebox"Input Path！"
				exit
				--go to line 82
			)
			
			undo off
			bb = selection as array	
			bbs = bb.count
			
			jindutiao.value = 100.*bbc/bbs
			
			--print jindutiao.value
			
			if (meditMaterials[caizhi_num] == undefined) do --判别 undefined
			(
			)
			caizhi_shux = i.material as string -- 标准材质给予贴图名字
			
			
			if matchPattern caizhi_shux pattern:"*:Standard__Legacy" == True do 
			(
				
				--标准材质的颜色贴图
				if i.material.diffuseMapEnable == off do 
				(
				)
				if i.material.diffuseMapEnable == on do
				(
					if  matchPattern(i.material.diffuseMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.diffuseMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.diffuseMap as string) pattern:"*:Bitmap*" == True do 
						(
							i.material.showInViewport = True
							caizhi_namee = getFilenameFile (i.material.diffuseMap.fileName)
							i.material.name = caizhi_namee
							--顺带把贴图给拷了
							copyFile i.material.diffuseMap.fileName (Texture_Path + "//" + getFilenameFile i.material.diffuseMap.fileName + getFilenameType i.material.diffuseMap.fileName)
							lbl9.text = getFilenameFile i.material.diffuseMap.fileName + getFilenameType i.material.diffuseMap.fileName
						)
					)
				)
				
				
				--标准材质的alpha贴图
				if i.material.opacityMapEnable == off do 
				(
				)
				if i.material.opacityMapEnable == on do
				(
					if  matchPattern(i.material.opacityMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.opacityMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.opacityMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.opacityMap.fileName (Texture_Path + "//" + getFilenameFile i.material.opacityMap.fileName + getFilenameType i.material.opacityMap.fileName)
							lbl9.text = getFilenameFile i.material.opacityMap.fileName + getFilenameType i.material.opacityMap.fileName
						)
					)
				)
				
				--标准材质的环境光颜色贴图
				if i.material.ambientMapEnable == off do 
				(
				)
				if i.material.ambientMapEnable == on do
				(
					if  matchPattern(i.material.ambientMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.ambientMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.ambientMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.ambientMap.fileName (Texture_Path + "//" + getFilenameFile i.material.ambientMap.fileName + getFilenameType i.material.ambientMap.fileName)
							lbl9.text = i.material.ambientMap.fileName + getFilenameType i.material.ambientMap.fileName
						)
					)
				)
				
				--标准材质的高光颜色贴图
				if i.material.specularMapEnable == off do 
				(
				)
				if i.material.specularMapEnable == on do
				(
					if  matchPattern(i.material.specularMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.specularMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.specularMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.specularMap.fileName (Texture_Path + "//" + getFilenameFile i.material.specularMap.fileName + getFilenameType i.material.specularMap.fileName)
							lbl9.text = i.material.specularMap.fileName + getFilenameType i.material.specularMap.fileName
						)
					)
				)
				
				--标准材质的高光级别贴图
				if i.material.specularLevelMapEnable == off do 
				(
				)
				if i.material.specularLevelMapEnable == on do
				(
					if  matchPattern(i.material.specularLevelMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.specularLevelMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.specularLevelMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.specularLevelMap.fileName (Texture_Path + "//" + getFilenameFile i.material.specularLevelMap.fileName + getFilenameType i.material.specularLevelMap.fileName)
							lbl9.text = getFilenameFile i.material.specularLevelMap.fileName + getFilenameType i.material.specularLevelMap.fileName
						)
					)
				)
				
				--标准材质的光泽度贴图
				if i.material.glossinessMapEnable == off do 
				(
				)
				if i.material.glossinessMapEnable == on do
				(
					if  matchPattern(i.material.glossinessMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.glossinessMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.glossinessMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.glossinessMap.fileName (Texture_Path + "//" + getFilenameFile i.material.glossinessMap.fileName + getFilenameType i.material.glossinessMap.fileName)
							lbl9.text = getFilenameFile i.material.glossinessMap.fileName + getFilenameType i.material.glossinessMap.fileName
						)
					)
				)
				
				--标准材质的自发光贴图
				if i.material.selfillumMapEnable == off do 
				(
				)
				if i.material.selfillumMapEnable == on do
				(
					if  matchPattern(i.material.selfillumMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.selfillumMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.selfillumMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.selfillumMap.fileName (Texture_Path + "//" + getFilenameFile i.material.selfillumMap.fileName + getFilenameType i.material.selfillumMap.fileName)
							lbl9.text = getFilenameFile i.material.selfillumMap.fileName + getFilenameType i.material.selfillumMap.fileName
						)
					)
				)
				
				--标准材质的过滤色贴图
				if i.material.filterMapEnable == off do 
				(
				)
				if i.material.filterMapEnable == on do
				(
					if  matchPattern(i.material.filterMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.filterMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.filterMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.filterMap.fileName (Texture_Path + "//" + getFilenameFile i.material.filterMap.fileName + getFilenameType i.material.filterMap.fileName)
							lbl9.text = getFilenameFile i.material.filterMap.fileName + getFilenameType i.material.filterMap.fileName
						)
					)
				)
				
				--标准材质的凹凸贴图
				if i.material.bumpMapEnable == off do 
				(
				)
				if i.material.bumpMapEnable == on do
				(
					
					
					if  matchPattern((i.material.bumpMap) as string) pattern:"*:法线凹凸*" == True do
					(
						
						if  matchPattern ((i.material.bumpMap.normal_map.fileName) as string) pattern:"undefined" == True then
						(
						)
						
						else
						(
							--顺带把贴图给拷了
							copyFile i.material.bumpMap.normal_map.fileName (Texture_Path + "//" + getFilenameFile i.material.bumpMap.normal_map.fileName + getFilenameType i.material.bumpMap.normal_map.fileName)
							lbl9.text = getFilenameFile i.material.bumpMap.normal_map.fileName + getFilenameType i.material.bumpMap.normal_map.fileName
						)
						
					)
					
					if  matchPattern((i.material.bumpMap) as string) pattern:"*:Bitmap*" == True do
					(
						
						if  matchPattern ((i.material.bumpMap.fileName) as string) pattern:"undefined" == True then
						(
						)
						
						else
						(
							--顺带把贴图给拷了
							copyFile i.material.bumpMap.fileName (Texture_Path + "//" + getFilenameFile i.material.bumpMap.fileName + getFilenameType i.material.bumpMap.fileName)
							lbl9.text = getFilenameFile i.material.bumpMap.fileName + getFilenameType i.material.bumpMap.fileName
						)
						
					)
				)
				
				--标准材质的反射贴图
				if i.material.reflectionMapEnable == off do 
				(
				)
				if i.material.reflectionMapEnable == on do
				(
					if  matchPattern(i.material.reflectionMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.reflectionMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.reflectionMap as string) pattern:"*:Bitmap*" == True do 
						(
							copyFile i.material.reflectionMap.fileName (Texture_Path + "//" + getFilenameFile i.material.reflectionMap.fileName + getFilenameType i.material.reflectionMap.fileName)
							lbl9.text = getFilenameFile i.material.reflectionMap.fileName + getFilenameType i.material.reflectionMap.fileName
						)
					)
				)
				
				--标准材质的折射贴图
				if i.material.refractionMapEnable == off do 
				(
				)
				if i.material.refractionMapEnable == on do
				(
					if  matchPattern(i.material.refractionMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.refractionMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.refractionMap as string) pattern:"*:Bitmap*" == True do 
						(
						--顺带把贴图给拷了
						copyFile i.material.refractionMap.fileName (Texture_Path + "//" + getFilenameFile i.material.refractionMap.fileName + getFilenameType i.material.refractionMap.fileName)
						lbl9.text = getFilenameFile i.material.refractionMap.fileName + getFilenameType i.material.refractionMap.fileName
						)
					)
				)
				
				--标准材质的置换贴图
				if i.material.displacementMapEnable == off do 
				(
				)
				if i.material.displacementMapEnable == on do
				(
					if  matchPattern(i.material.displacementMap as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.displacementMap as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.displacementMap as string) pattern:"*:Bitmap*" == True do 
						(
						--顺带把贴图给拷了
						copyFile i.material.displacementMap.fileName (Texture_Path + "//" + getFilenameFile i.material.displacementMap.fileName + getFilenameType i.material.displacementMap.fileName)
						lbl9.text = getFilenameFile i.material.displacementMap.fileName + getFilenameType i.material.displacementMap.fileName
						)
					)
				)
				
			)
			
			--如果材质是Normal_Bump
			
			if matchPattern caizhi_shux pattern:"*多维/子对象:*" == True do -- 如果是多维材质
			(
				--macros.run "Medit Tools" "clear_medit_slots" 
				meditMaterials[1] = i.material
				--caizhi_shuliang = meditMaterials[1].numsubs
				
				caizhide = meditMaterials[1].MaterialIDList
			caizhi_shuliang = caizhide.count
				
				--for j = 1 to caizhi_shuliang do --分配子材质到各个材质框
				--(
					
					--if meditMaterials[1].MaterialList[1].diffuseMapEnable == false do 
					--(
					--)
					--meditMaterials[j+1] = meditMaterials[1].MaterialList[j]
				--)
				
				for j = 1 to caizhi_shuliang do 
				(
					zicaizhimin = meditMaterials[1].MaterialList[j] as string
					
					if matchPattern zicaizhimin pattern:"*:Standard__Legacy" == True do --子材质如果是旧版标准材质
					(
						if meditMaterials[1].MaterialList[j].diffuseMapEnable == false do 
						(
						)
						if meditMaterials[1].MaterialList[j].diffuseMapEnable == true do 
						(
							if (matchPattern (meditMaterials[1].MaterialList[j].diffuseMap as string) pattern:"undefined") == True do
							(
							)
							if (matchPattern (meditMaterials[1].MaterialList[j].diffuseMap as string) pattern:"undefined") == False do
							(
								if matchPattern (meditMaterials[1].MaterialList[j].diffuseMap as string) pattern:"*:Bitmap*" == True do 
								(
									caizhi_namee = getFilenameFile (meditMaterials[1].MaterialList[j].diffuseMap.fileName)
									meditMaterials[1].MaterialList[j].showInViewport = True 
									meditMaterials[1].MaterialList[j].name = caizhi_namee 
									--顺带把贴图给拷了
									copyFile meditMaterials[1].MaterialList[j].diffuseMap.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].diffuseMap.fileName + getFilenameType meditMaterials[1].MaterialList[j].diffuseMap.fileName)
									lbl9.text = getFilenameFile meditMaterials[1].MaterialList[j].diffuseMap.fileName + getFilenameType meditMaterials[1].MaterialList[j].diffuseMap.fileName
								)
							)
						)
						
						if meditMaterials[1].MaterialList[j].bumpMapEnable == false do --子材质的标准材质之凹凸贴图
						(
						)
						if meditMaterials[1].MaterialList[j].bumpMapEnable == true do
						(

							if  matchPattern((meditMaterials[1].MaterialList[j].bumpMap) as string) pattern:"*:法线凹凸*" == True do
							(
								
								if  matchPattern ((meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName) as string) pattern:"undefined" == True then
								(
								)
								
								else
								(
									--顺带把贴图给拷了
									copyFile meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName + getFilenameType meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName)
									lbl9.text = getFilenameFile meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName + getFilenameType meditMaterials[1].MaterialList[j].bumpMap.normal_map.fileName
								)
								
							)
							
							if  matchPattern((meditMaterials[1].MaterialList[j].bumpMap) as string) pattern:"*:Bitmap*" == True do
							(
								
								if  matchPattern ((meditMaterials[1].MaterialList[j].bumpMap.fileName) as string) pattern:"undefined" == True then
								(
								)
								
								else
								(
									--顺带把贴图给拷了
									copyFile meditMaterials[1].MaterialList[j].bumpMap.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].bumpMap.fileName + getFilenameType meditMaterials[1].MaterialList[j].bumpMap.fileName)
									lbl9.text = getFilenameFile meditMaterials[1].MaterialList[j].bumpMap.fileName + getFilenameType meditMaterials[1].MaterialList[j].bumpMap.fileName
								)
								
							)
						)
						
					)
					
					
					if matchPattern zicaizhimin pattern:"*:Physical_Material" == True do --子材质如果是物理材质
					(
						if meditMaterials[1].MaterialList[j].base_color_map_on == false do 
						(
						)
						if meditMaterials[1].MaterialList[j].base_color_map_on == true do 
						(
							if (matchPattern (meditMaterials[1].MaterialList[j].base_color_map as string) pattern:"undefined") == True do
							(
								
							)
							if (matchPattern (meditMaterials[1].MaterialList[j].base_color_map as string) pattern:"undefined") == False do
							(
								if matchPattern (meditMaterials[1].MaterialList[j].base_color_map as string) pattern:"*:Bitmap*" == True do 
								(
									caizhi_namee = getFilenameFile (meditMaterials[j+1].base_color_map.fileName)
									meditMaterials[1].MaterialList[j].showInViewport = True 
									meditMaterials[1].MaterialList[j].name = caizhi_namee 
									--顺带把贴图给拷了
									copyFile meditMaterials[1].MaterialList[j].base_color_map.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].base_color_map.fileName + getFilenameType meditMaterials[1].MaterialList[j].base_color_map.fileName)
									lbl9.text = getFilenameFile meditMaterials[1].MaterialList[j].base_color_map.fileName + getFilenameType meditMaterials[1].MaterialList[j].base_color_map.fileName
								)
							)
						)
					)
					
					if matchPattern zicaizhimin pattern:"*:VRayMtl" == True do --子材质如果是Vray 材质
					(
						if meditMaterials[1].MaterialList[j].texmap_diffuse_on == false do 
						(
						)
						if meditMaterials[1].MaterialList[j].texmap_diffuse_on == true do 
						(
							if (matchPattern(meditMaterials[1].MaterialList[j].texmap_diffuse as string) pattern:"undefined") == True do
							(
							)
							if (matchPattern(meditMaterials[1].MaterialList[j].texmap_diffuse as string) pattern:"undefined") == False do
							(
								if matchPattern (meditMaterials[1].MaterialList[j].texmap_diffuse as string) pattern:"*:Bitmap*" == True do 
								(
									caizhi_namee = getFilenameFile(meditMaterials[1].MaterialList[j].texmap_diffuse.fileName)
									meditMaterials[1].MaterialList[j].showInViewport = True 
									meditMaterials[1].MaterialList[j].name = caizhi_namee 
									--顺带把贴图给拷了
									copyFile meditMaterials[1].MaterialList[j].texmap_diffuse.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].texmap_diffuse.fileName + getFilenameType meditMaterials[1].MaterialList[j].texmap_diffuse.fileName)
									lbl9.text = getFilenameFile meditMaterials[1].MaterialList[j].texmap_diffuse.fileName + getFilenameType meditMaterials[1].MaterialList[j].texmap_diffuse.fileName
								)
							)
						)
					)
					
				)
				--macros.run "Medit Tools" "clear_medit_slots" 
			)
			
			
			if matchPattern caizhi_shux pattern:"*:VRayMtl" == True do --如果是vray材质
			(
				
				--vray材质的颜色贴图
				if i.material.texmap_diffuse_on == false do 
				(
				)
				if i.material.texmap_diffuse_on == true do
				(
					if  matchPattern(i.material.texmap_diffuse as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(i.material.texmap_diffuse as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.texmap_diffuse as string) pattern:"*:Bitmap*" == True do 
						(
							i.material.showInViewport = True
							caizhi_namee = getFilenameFile (i.material.texmap_diffuse.fileName)
							i.material.name = caizhi_namee
							--顺带把贴图给拷了
							copyFile i.material.texmap_diffuse.fileName (Texture_Path + "//" + getFilenameFile i.material.texmap_diffuse.fileName + getFilenameType i.material.texmap_diffuse.fileName)
							lbl9.text = getFilenameFile i.material.texmap_diffuse.fileName + getFilenameType i.material.texmap_diffuse.fileName
						)
					)
				)
				
				--vray材质的凹凸和法线贴图
				if i.material.texmap_bump_on == false do 
				(
				)
				if i.material.texmap_bump_on == true do
				(
					
					
					if  matchPattern((i.material.texmap_bump) as string) pattern:"*:VRayNormalMap*" == True do
					(
						
						if  matchPattern ((i.material.bumpMap.normal_map.fileName) as string) pattern:"undefined" == True then
						(
						)
						
						else
						(
							--顺带把贴图给拷了
							copyFile i.material.bumpMap.normal_map.fileName (Texture_Path + "//" + getFilenameFile i.material.bumpMap.normal_map.fileName + getFilenameType i.material.bumpMap.normal_map.fileName)
							lbl9.text = getFilenameFile i.material.bumpMap.normal_map.fileName + getFilenameType i.material.bumpMap.normal_map.fileName
						)
						
					)
					
					if  matchPattern((i.material.texmap_bump) as string) pattern:"*:Bitmap*" == True do
					(
						
						if  matchPattern ((i.material.texmap_bump.fileName) as string) pattern:"undefined" == True then
						(
						)
						
						else
						(
							--顺带把贴图给拷了
							copyFile i.material.texmap_bump.fileName (Texture_Path + "//" + getFilenameFile i.material.texmap_bump.fileName + getFilenameType i.material.texmap_bump.fileName)
							lbl9.text = getFilenameFile i.material.texmap_bump.fileName + getFilenameType i.material.texmap_bump.fileName
						)
						
					)
				)
				
			)
			
			if matchPattern caizhi_shux pattern:"*:Physical_Material*" == True do --如果是物理材质
			(
				
				--物理材质的颜色贴图
				if i.material.base_color_map_on == false do 
				(
				)
				if i.material.base_color_map_on == true do
				(
					if  matchPattern (i.material.base_color_map as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern (i.material.base_color_map as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.base_color_map as string) pattern:"*:Bitmap*" == True do 
						(
							i.material.showInViewport = True
							caizhi_namee = getFilenameFile (i.material.base_color_map.fileName)
							i.material.name = caizhi_namee
							--顺带把贴图给拷了
							copyFile i.material.base_color_map.fileName (Texture_Path + "//" + getFilenameFile i.material.base_color_map.fileName + getFilenameType i.material.base_color_map.fileName)
							lbl9.text = getFilenameFile i.material.base_color_map.fileName + getFilenameType i.material.base_color_map.fileName
						)
						
					)
				)
				
				--物理材质的法线贴图
				if i.material.bump_map_on == false do 
				(
				)
				if i.material.bump_map_on == true do
				(
					if  matchPattern (i.material.bump_map as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern (i.material.bump_map as string) pattern:"undefined" == False do
					(
						if matchPattern (i.material.bump_map as string) pattern:"*:Bitmap*" == True do 
						(
							i.material.showInViewport = True
							--caizhi_namee = getFilenameFile (i.material.base_color_map.fileName)
							--i.material.name = caizhi_namee
							--顺带把贴图给拷了
							copyFile i.material.bump_map.fileName (Texture_Path + "//" + getFilenameFile i.material.bump_map.fileName + getFilenameType i.material.bump_map.fileName)
							lbl9.text = getFilenameFile i.material.bump_map.fileName + getFilenameType i.material.bump_map.fileName
						)
						
					)
				)
				
			)
			
			if matchPattern caizhi_shux pattern:"*:VRayLightMtl*" == True do --如果是vray灯光材质
			(
	
				--vray材质的颜色贴图
				if i.material.texmap_on == false do 
				(
				)
				if i.material.texmap_on == true do
				(
					if  matchPattern(getFilenameFile(i.material.texmap.fileName) as string) pattern:"undefined" == True do
					(
					)
					if  matchPattern(getFilenameFile(i.material.texmap.fileName) as string) pattern:"undefined" == False do
					(
						i.material.showInViewport = True
						caizhi_namee = getFilenameFile (i.material.texmap.fileName)
						i.material.name = caizhi_namee
						--顺带把贴图给拷了
						copyFile i.material.texmap.fileName (Texture_Path + "//" + getFilenameFile i.material.texmap.fileName + getFilenameType i.material.texmap.fileName)
					)
				)
			)
			
			/*if matchPattern i.name pattern:"*VRayProxy*" == True do --如果vray代理对象
			(
				copyFile i.filename (Texture_Path + "//" + getFilenameFile i.filename + getFilenameType i.filename)
			)*/
			
			clearUndoBuffer() 
			freeSceneBitmaps() 
			
			bbc = bbc + 1
			
			
		)
		clearSelection()
		
		
		
		/*--Vray环境HDRI
		if matchPattern(EnvironmentMap as string) pattern:"undefined" == true do
		(
			
		)
		
		if matchPattern(EnvironmentMap as string) pattern:"undefined" == false do
		(
			macros.run "Medit Tools" "clear_medit_slots"
			meditMaterials[1] = EnvironmentMap
			if matchPattern(meditMaterials[1] as string) pattern:"*:Bitmap" == true do
			(
				copyFile meditMaterials[1].Filename (Texture_Path + "//" + getFilenameFile meditMaterials[1].Filename + getFilenameType meditMaterials[1].Filename)
			)
			if matchPattern(meditMaterials[1] as string) pattern:"*:VRayHDRI" == true do
			(
				copyFile meditMaterials[1].HDRIMapName (Texture_Path + "//" + getFilenameFile meditMaterials[1].HDRIMapName + getFilenameType meditMaterials[1].HDRIMapName)
			)
			macros.run "Medit Tools" "clear_medit_slots"
			
		)*/
		macros.run "Medit Tools" "clear_medit_slots"
		lbl9.text = "-- 完成 --"
		---组装后
	)
	on btn6 pressed do --前处理
	(
		
		clearSelection()
		max select all
		max group explode
		max unlink
		clearSelection()
		
		clearSelection()
		max select all
		for i in $ do
		(
			if  matchPattern(i.material as string) pattern:"undefined" == True do
			(
				hide i
			)
		)
		clearSelection()
		
		max select all
		bb_10 = selection as array	--判定进度条
		bb_10_1 = bb_10.count
		
		if bb_10_1 < 10 then
		(
			bbc = 1
		)
		
		else
		(
			bbc = 0
		)
		
		jindutiao.value = 0
		clearSelection()
		lbl9.text = "-- 前处理完成 --"
	)
	on btn15 pressed do --材质给予编辑器
	(
		clearSelection()
		max select all
		max group explode
		max unlink
		clearSelection()
		caizhi_num = 1
		macros.run "Medit Tools" "clear_medit_slots"
		max select all
		for i in $ do 
		(
			if (meditMaterials[caizhi_num] == undefined) do
			(
				
			)
			
			if (matchPattern (i.Material as string) pattern:"undefined") == False do
			(
				meditMaterials[caizhi_num] = i.material
				caizhi_num = caizhi_num + 1
			)
			
			--meditMaterials[caizhi_num].showInViewport 
			if caizhi_num > 24 do 
			(
				--macros.run "Medit Tools" "clear_medit_slots"
				caizhi_num = 1
			)
		)
		clearSelection()
		lbl9.text = "-- 已赋予 --"
	)
)
-- End of Rollout --
createDialog sort_map
gc()
clearlistener()

