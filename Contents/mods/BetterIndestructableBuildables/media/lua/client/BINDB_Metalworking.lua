-- Big Thanks to Indestructible Log Walls for finding out how disabling the zombie damage can be achieved
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1965117520 

--#################################################################
--                      Metal Wire Fencing
--#################################################################
--- Big Wire Fence
--- ContextMenu_BigWiredFence
local original_onBigWiredFence = ISBlacksmithMenu.onBigWiredFence
ISBlacksmithMenu.onBigWiredFence = function(...)
    local original_ISWoodenWallNew = ISWoodenWall.new
    local actual_fence_var = nil
    ISWoodenWall.new = function(...)
        actual_fence_var = original_ISWoodenWallNew(...)
        if SandboxVars.BINDB.bigWireFence then
            actual_fence_var.isThumpable = false
        end
        return actual_fence_var
    end
    original_onBigWiredFence(...)
    actual_fence_var.modData["need:Base.MetalPipe"] = SandboxVars.BINDB.bigWireFenceMetalPipes;
    actual_fence_var.modData["use:Base.Wire"] = SandboxVars.BINDB.bigWireFenceWire;
    actual_fence_var.modData["need:Base.ScrapMetal"]= SandboxVars.BINDB.bigWireFenceScrapMetal;
    ISWoodenWall.new = original_ISWoodenWallNew
end

--- Big Wire Fence Double Gate
--- ContextMenu_Double_Metal_Door
local original_onDoubleMetalDoor = ISBlacksmithMenu.onDoubleMetalDoor
ISBlacksmithMenu.onDoubleMetalDoor = function(...)
    local original_ISDoubleDoorNew = ISDoubleDoor.new
    local actual_door_var = nil
    ISDoubleDoor.new = function(...)
        actual_door_var = original_ISDoubleDoorNew(...)
        if SandboxVars.BINDB.bigWireFenceGate then
            actual_door_var.isThumpable = false
        end
        return actual_door_var
    end
    original_onDoubleMetalDoor(...)
    actual_door_var.modData["need:Base.MetalPipe"] = SandboxVars.BINDB.bigWireFenceGateMetalPipes;
    actual_door_var.modData["use:Base.Wire"] = SandboxVars.BINDB.bigWireFenceGateWire;
    actual_door_var.modData["need:Base.ScrapMetal"]= SandboxVars.BINDB.bigWireFenceGateScrapMetal;
    ISDoubleDoor.new = original_ISDoubleDoorNew
end

--#################################################################
-- Metal Pole Fencing
--#################################################################
--- Big Pole Fence
--- ContextMenu_BigMetalFence
local original_onBigMetalFence = ISBlacksmithMenu.onBigMetalFence
ISBlacksmithMenu.onBigMetalFence = function(...)
    local original_ISWoodenWallNew = ISWoodenWall.new
    local actual_fence_var = nil
    ISWoodenWall.new = function(...)
        actual_fence_var = original_ISWoodenWallNew(...)
        if SandboxVars.BINDB.bigMetalFence then
            actual_fence_var.isThumpable = false
        end
        return actual_fence_var
    end
    original_onBigMetalFence(...)
    actual_fence_var.modData["need:Base.MetalPipe"] = SandboxVars.BINDB.bigMetalFenceMetalPipes
    actual_fence_var.modData["need:Base.ScrapMetal"]= SandboxVars.BINDB.bigMetalFenceScrapMetal
    ISWoodenWall.new = original_ISWoodenWallNew
end

--- Big Pole Fence Single Door
--- ContextMenu_BigMetalFenceGate
local original_onBigMetalFenceGate = ISBlacksmithMenu.onBigMetalFenceGate
ISBlacksmithMenu.onBigMetalFenceGate = function(...)
    local original_ISWoodenDoorNew = ISWoodenDoor.new
    local actual_fence_var = nil
    ISWoodenDoor.new = function(...)
        actual_fence_var = original_ISWoodenDoorNew(...)
        if SandboxVars.BINDB.bigMetalFenceSingleGate then
            actual_fence_var.isThumpable = false
        end
        return actual_fence_var
    end
    original_onBigMetalFenceGate(...)
    actual_fence_var.modData["need:Base.MetalPipe"] = SandboxVars.BINDB.bigMetalFenceSingleGateMetalPipes;
    actual_fence_var.modData["need:Base.ScrapMetal"]= SandboxVars.BINDB.bigMetalFenceSingleGateScrapMetal;
    ISWoodenDoor.new = original_ISWoodenDoorNew
end

--- Big Pole Fence Double Door/Gate
--- ContextMenu_BigMetalDoubleDoor
local original_onDoublePoleDoor = ISBlacksmithMenu.onDoublePoleDoor
ISBlacksmithMenu.onDoublePoleDoor = function(...)
    local original_ISDoubleDoorNew = ISDoubleDoor.new
    local actual_door_var = nil
    ISDoubleDoor.new = function(...)
        actual_door_var = original_ISDoubleDoorNew(...)
        if SandboxVars.BINDB.bigMetalFenceDoubleGate then
            actual_door_var.isThumpable = false
        end
        return actual_door_var
    end
    original_onDoublePoleDoor(...)
    actual_door_var.modData["need:Base.MetalPipe"] = SandboxVars.BINDB.bigMetalFenceDoubleGateMetalPipes;
    actual_door_var.modData["need:Base.ScrapMetal"]= SandboxVars.BINDB.bigMetalFenceDoubleGateScrapMetal;
    ISDoubleDoor.new = original_ISDoubleDoorNew
end

--#################################################################
-- Metal Wall Lv1
--#################################################################

--#################################################################
-- Metal Wall Lv2
--#################################################################


-- Patching Metalworking tooltips
local original_checkMetalWeldingFurnitures = ISBlacksmithMenu.checkMetalWeldingFurnitures
ISBlacksmithMenu.checkMetalWeldingFurnitures = function(metalPipes, smallMetalSheet, metalSheet, hinge, scrapMetal, torchUse, skill, player, toolTip, metalBar, wire)
    --print(toolTip.name)
    if string.find(toolTip.name, getText("ContextMenu_BigWiredFence")) then
        metalPipes = SandboxVars.BINDB.bigWireFenceMetalPipes
        wire = SandboxVars.BINDB.bigWireFenceWire
        scrapMetal = SandboxVars.BINDB.bigWireFenceScrapMetal
    elseif string.find(toolTip.name, getText("ContextMenu_Double_Metal_Door"))then
        metalPipes = SandboxVars.BINDB.bigWireFenceGateMetalPipes
        scrapMetal = SandboxVars.BINDB.bigWireFenceGateScrapMetal
        wire = SandboxVars.BINDB.bigWireFenceGateWire
    elseif string.find(toolTip.name, getText("ContextMenu_BigMetalFence")) then 
        metalPipes = SandboxVars.BINDB.bigMetalFenceMetalPipes
        scrapMetal = SandboxVars.BINDB.bigMetalFenceScrapMetal
    elseif string.find(toolTip.name, getText("ContextMenu_BigMetalFenceGate")) then
        metalPipes = SandboxVars.BINDB.bigMetalFenceSingleGateMetalPipes
        scrapMetal = SandboxVars.BINDB.bigMetalFenceSingleGateScrapMetal
    elseif string.find(toolTip.name, getText("ContextMenu_BigMetalDoubleDoor")) then
        metalPipes = SandboxVars.BINDB.bigMetalFenceDoubleGateMetalPipes
        scrapMetal = SandboxVars.BINDB.bigMetalFenceDoubleGateScrapMetal
    end

    return original_checkMetalWeldingFurnitures(metalPipes, smallMetalSheet, metalSheet, hinge, scrapMetal, torchUse, skill, player, toolTip, metalBar, wire)
    --print_table(toolTip)
end

-- Debug stuffs from stackoverflow
function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end