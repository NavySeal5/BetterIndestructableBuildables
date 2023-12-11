--Big Thanks to Indestructible Log Walls for finding out how disabling the zombie damage can be achieved

-- Big Wire Fence
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

-- Big Pole Fence

-- Metal Wall Lv1

-- Metal Wall Lv2

-- Log Wall

-- Wood Wall Lv1

-- Wood Wall Lv2

-- Wood Wall Lv3

-- This Part takes care of injecting the new configured values into the contextmenu, otherwise it would only use the default vanilla costs
local original_checkMetalWeldingFurnitures = ISBlacksmithMenu.checkMetalWeldingFurnitures
ISBlacksmithMenu.checkMetalWeldingFurnitures = function(metalPipes, smallMetalSheet, metalSheet, hinge, scrapMetal, torchUse, skill, player, toolTip, metalBar, wire)
    --print(toolTip.name)
    if string.find(toolTip.name, getText("ContextMenu_BigWiredFence")) then
        metalPipes = SandboxVars.BINDB.bigWireFenceMetalPipes;
        wire = SandboxVars.BINDB.bigWireFenceWire;
        scrapMetal = SandboxVars.BINDB.bigWireFenceScrapMetal;
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