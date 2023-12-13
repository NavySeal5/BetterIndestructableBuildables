require "BINDB_Carpentry"

-- Override Vanilla menu as there is no other way to manipulate the context menu of specific entries
ISBuildMenu.buildWallMenu = function(subMenu, option, player)
    local sprite = ISBuildMenu.getWoodenWallFrameSprites(player);
    local wallOption = subMenu:addOption(getText("ContextMenu_Wooden_Wall_Frame"), worldobjects, ISBuildMenu.onWoodenWallFrame, sprite, player);
    local tooltip = ISBuildMenu.canBuild(2, 2, 0, 0, 0, 2, wallOption, player);
    tooltip:setName(getText("ContextMenu_Wooden_Wall_Frame"));
    tooltip.description = getText("Tooltip_craft_woodenWallFrameDesc") .. tooltip.description;
    tooltip:setTexture(sprite.sprite);
    ISBuildMenu.requireHammer(wallOption)

--	local sprite = ISBuildMenu.getWoodenWallSprites(player);
--	local wallOption = subMenu:addOption(getText("ContextMenu_Wooden_Wall"), worldobjects, ISBuildMenu.onWoodenWall, sprite, player);
--	local tooltip = ISBuildMenu.canBuild(3, 3, 0, 0, 0, 2, wallOption, player);
--	tooltip:setName(getText("ContextMenu_Wooden_Wall"));
--	tooltip.description = getText("Tooltip_craft_woodenWallDesc") .. tooltip.description;
--	tooltip:setTexture(sprite.sprite);
--	ISBuildMenu.requireHammer(wallOption)

	local pillarOption = subMenu:addOption(getText("ContextMenu_Wooden_Pillar"), worldobjects, ISBuildMenu.onWoodenPillar, player);
	local tooltip = ISBuildMenu.canBuild(2, 3, 0, 0, 0, 2, pillarOption, player);
	tooltip:setName(getText("ContextMenu_Wooden_Pillar"));
	tooltip.description = getText("Tooltip_craft_woodenPillarDesc") .. tooltip.description;
	tooltip:setTexture("walls_exterior_wooden_01_27");
	ISBuildMenu.requireHammer(pillarOption)

    local logOption = subMenu:addOption(getText("ContextMenu_Log_Wall"), worldobjects, ISBuildMenu.onLogWall, player);
    local tooltip = ISBuildMenu.canBuild(0, 0, 0, 0, 0, 0, logOption, player);
    tooltip:setName(getText("ContextMenu_Log_Wall"));
    local numLog = ISBuildMenu.countMaterial(player, "Base.Log")
    -- Custom BINDB overriding log cost and changing description
    local actualLogCost = SandboxVars.BINDB.logWallLogs -- added this
    if numLog < actualLogCost then
		tooltip.description = tooltip.description .. ISBuildMenu.bhs .. getItemNameFromFullType("Base.Log") .. " " .. numLog .. "/" .. actualLogCost .. " <LINE> "; -- Change here
        if not ISBuildMenu.cheat then
            logOption.onSelect = nil;
            logOption.notAvailable = true;
        end
    else
		tooltip.description = tooltip.description .. ISBuildMenu.ghs .. getItemNameFromFullType("Base.Log") .. " " .. numLog .. "/" .. actualLogCost .. " <LINE> "; -- Change here
    end
    tooltip:setTexture("carpentry_02_80");
    
    -- log wall require either 4 ripped sheet, 4 twine or 2 ropes
    local numRippedSheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets") + ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty")
    local numTwine = ISBuildMenu.countMaterial(player, "Base.Twine")
    local numRope = ISBuildMenu.countMaterial(player, "Base.Rope")
    local actualSheetCost = SandboxVars.BINDB.logWallRopes -- added this
    -- Custom BINDB Change costs here aswell, rope requirement is half of sheet requirement
    if numRippedSheets >= actualSheetCost then -- Change here
		tooltip.description = tooltip.description .. ISBuildMenu.ghs .. getItemNameFromFullType("Base.RippedSheets") .. " " .. numRippedSheets .. "/" .. actualSheetCost; -- Change here
    elseif numTwine >= actualSheetCost then -- Change here
		tooltip.description = tooltip.description .. ISBuildMenu.ghs .. getItemNameFromFullType("Base.Twine") .. " " .. numTwine .. "/" .. actualSheetCost; -- Change here
    elseif numRope >= math.floor(actualSheetCost/2) then -- Change here
		tooltip.description = tooltip.description .. ISBuildMenu.ghs .. getItemNameFromFullType("Base.Rope") .. " " .. numRope .. "/" .. math.floor(actualSheetCost/2); -- Change here
    else
		tooltip.description = tooltip.description .. ISBuildMenu.bhs .. getItemNameFromFullType("Base.RippedSheets") .. " " .. numRippedSheets .. "/" .. actualSheetCost .." <LINE> " .. getText("ContextMenu_or") .. " " .. getItemNameFromFullType("Base.Twine") .. " " .. numTwine .. "/" .. actualSheetCost .. " <LINE> " .. getText("ContextMenu_or") .. " " .. getItemNameFromFullType("Base.Rope") .. " " .. numRope .. "/".. math.floor(actualSheetCost/2); -- Change here
        if not ISBuildMenu.cheat then
            logOption.onSelect = nil;
            logOption.notAvailable = true;
        end
    end
    tooltip.description = getText("Tooltip_craft_wallLogDesc") .. tooltip.description;

    if wallOption.notAvailable and logOption.notAvailable and pillarOption.notAvailable then
        option.notAvailable = true;
    end
end

--#################################################################
-- Log Wall
--#################################################################
-- We hard override it in this case, as too many changes in the middle of the function are needed
ISBuildMenu.onLogWall = function(worldobjects, player)
    local wall = ISWoodenWall:new("carpentry_02_80", "carpentry_02_81", nil);
    wall.modData["need:Base.Log"] = SandboxVars.BINDB.logWallLogs;
	local sheets = ISBuildMenu.countMaterial(player, "Base.RippedSheets");
	local sheetsDirty = ISBuildMenu.countMaterial(player, "Base.RippedSheetsDirty");
    local maxSheets = SandboxVars.BINDB.logWallRopes -- Added this
	if sheets >= maxSheets then sheets = maxSheets; sheetsDirty = 0 end -- Change here
	if sheetsDirty >= maxSheets then sheetsDirty = maxSheets; sheets = 0 end -- Change here
	if sheets < maxSheets and sheetsDirty > 0 then sheetsDirty = maxSheets - sheets; end -- Change here
    if sheets + sheetsDirty >= maxSheets then -- Change here
		if sheets > 0 then wall.modData["need:Base.RippedSheets"] = tostring(sheets); end
		if sheetsDirty > 0 then wall.modData["need:Base.RippedSheetsDirty"] = tostring(sheetsDirty); end
    elseif ISBuildMenu.countMaterial(player, "Base.Twine") >= maxSheets then -- Change here
        wall.modData["need:Base.Twine"] = maxSheets; -- Change here
    elseif ISBuildMenu.countMaterial(player, "Base.Rope") >= math.floor(maxSheets/2) then -- Change here
        wall.modData["need:Base.Rope"] = math.floor(maxSheets/2); -- Change here
    end
    if SandboxVars.BINDB.logWall then
        wall.isThumpable = false
    end
    wall.modData["xp:Woodwork"] = 5;
    wall.player = player;
	wall.noNeedHammer = true
	wall.canBarricade = false
	wall.name = "Log Wall"
	wall.craftingBank = "BuildingGeneric"
	wall.completionSound = "BuildWoodenStructureLarge"
    getCell():setDrag(wall, player);
end