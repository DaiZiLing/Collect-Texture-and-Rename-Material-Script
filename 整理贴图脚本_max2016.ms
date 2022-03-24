
/* 全部炸开：所有模型解组、解除链接
* --材质名为贴图名：所有使用到了的贴图名字变成对应的材质名字，没有用到的不管，并整进路径里
*   --必须先把贴图路径全部绝对化
*   --多维材质若ID最大的ID数不等于子材质数量，会报错
* --贴图整理到文件夹：所有用到的或者没用到的都整进路径里
* --释放位图缓存：不解释
* --清空Undo缓存：不解释
* --清理丢失贴图：不解释
* --模型位于原点：所有模型移动到原点并放地板上
* 材质给予编辑器：每个物体的材质整进材质编辑器里，包括重复的
*/


rollout sort_map "整理贴图脚本" width:270 height:228
(
	button 'btn1' "整理整个场景贴图" pos:[11,158] width:119 height:39 align:#left
	edittext 'edt1' "" pos:[107,6] width:153 height:24 align:#left
	label 'lbl1' "贴图到复制路径..." pos:[11,10] width:99 height:20 align:#left
	button 'btn3' "整理视口内贴图" pos:[141,113] width:119 height:39 align:#left
	button 'btn6' "前处理" pos:[11,113] width:119 height:39 align:#left
	button 'btn15' "视口材质列入编辑器" pos:[141,158] width:119 height:39 align:#left
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
	label 'lbl8' "进度：" pos:[11,204] width:40 height:20 align:#left
	
	--bitmap 'bmp1' "Statu_Wait" pos:[56,204] width:52 height:14 fileName:"wait.jpg" align:#left
	--label 'lbl9' "Wait..." pos:[56,204] width:40 height:20 align:#left
	progressBar 'jindutiao' "" pos:[46,206] width:100 height:10 color:[255,102,241] align:#left

	
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
	)
	)
	on edt1 changed var do
	(
	Texture_Path = var
	)
	on btn3 pressed do --材质名为贴图名
	(
	macros.run "Medit Tools" "clear_medit_slots"
	max select all
	caizhi_num = 1
		
		
	for i in $ do 
	(
		undo off
		bb = selection as array	
		bbs = bb.count
		
		jindutiao.value = 100. * bbc / bbs
		
		--print jindutiao.value
		
		if (meditMaterials[caizhi_num] == undefined) do --判别 undefined
		(
			)
	caizhi_shux = i.material as string -- 标准材质给予贴图名字
	if matchPattern caizhi_shux pattern:"*:Standard" == True do 
	(
		--标准材质的颜色贴图
		if i.material.diffuseMapEnable == false do 
		(
		)
		if i.material.diffuseMapEnable == true do
		(
			if  matchPattern(getFilenameFile(i.material.diffuseMap.fileName) as string) pattern:"undefined" == True do
					(
					)
			if  matchPattern(getFilenameFile(i.material.diffuseMap.fileName) as string) pattern:"undefined" == False do
					(
						i.material.showInViewport = True
						caizhi_namee = getFilenameFile (i.material.diffuseMap.fileName)
						i.material.name = caizhi_namee
						--顺带把贴图给拷了
						copyFile i.material.diffuseMap.fileName (Texture_Path + "//" + getFilenameFile i.material.diffuseMap.fileName + getFilenameType i.material.diffuseMap.fileName)
					)
		)
		
		--标准材质的alpha贴图
		if i.material.opacityMapEnable == false do 
		(
		)
		if i.material.opacityMapEnable == true do
		(
			if  matchPattern(getFilenameFile(i.material.opacityMap.fileName) as string) \
			pattern:"undefined" == True do
					(
					)
			if  matchPattern(getFilenameFile(i.material.opacityMap.fileName) as string) \
					pattern:"undefined" == False do
					(
						--i.material.showInViewport = True
						caizhi_namee = getFilenameFile (i.material.opacityMap.fileName)
						i.material.name = caizhi_namee
						--顺带把贴图给拷了
						copyFile i.material.opacityMap.fileName \
						(Texture_Path + "//" + getFilenameFile i.material.opacityMap.fileName + getFilenameType i.material.opacityMap.fileName)
					)
		)
	)
	if matchPattern caizhi_shux pattern:"*Multi/Sub-Object:*" == True do -- 如果是多维材质
	(
		macros.run "Medit Tools" "clear_medit_slots" 
		meditMaterials[1] = i.material
		caizhi_shuliang = meditMaterials[1].numsubs 
		for j = 1 to caizhi_shuliang do 
		(
			if meditMaterials[1].MaterialList[1].diffuseMapEnable == false do 
			(
				)
			meditMaterials[j+1] = meditMaterials[1].MaterialList[j]
				if meditMaterials[1].MaterialList[j].diffuseMapEnable == false do 
			(
				)
				if meditMaterials[1].MaterialList[j].diffuseMapEnable == true do 
				(
					if (matchPattern (meditMaterials[1].MaterialList[j].diffuseMap.fileName as string) pattern:"undefined") == True do
					(
						)
					if (matchPattern (meditMaterials[1].MaterialList[j].diffuseMap.fileName as string) pattern:"undefined") == False do
						(
							if matchPattern meditMaterials[1].MaterialList[j].diffuseMap.fileName pattern:"*.*" == True do 
					(
					caizhi_namee = getFilenameFile (meditMaterials[j+1].diffuseMap.fileName)
					meditMaterials[j+1].showInViewport = True
					meditMaterials[j+1].name = caizhi_namee
						--顺带把贴图给拷了
						copyFile meditMaterials[1].MaterialList[j].diffuseMap.fileName (Texture_Path + "//" + getFilenameFile meditMaterials[1].MaterialList[j].diffuseMap.fileName + getFilenameType meditMaterials[1].MaterialList[j].diffuseMap.fileName)
					)
				)
				)
		)
		macros.run "Medit Tools" "clear_medit_slots" 
	)
	
	clearUndoBuffer() 
	freeSceneBitmaps() 
	
	bbc = bbc + 1
	
	)
	clearSelection()
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
		bb_10 = selection as array	
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
	meditMaterials[caizhi_num] = i.material
			--meditMaterials[caizhi_num].showInViewport 
			caizhi_num = caizhi_num + 1
			if caizhi_num > 24 do 
				(
					macros.run "Medit Tools" "clear_medit_slots"
					caizhi_num = 1
					)
		)
	)
)
-- End of Rollout --
 createDialog sort_map
gc()
clearlistener()

