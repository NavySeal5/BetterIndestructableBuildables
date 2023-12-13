--#################################################################
-- Carpentry
--#################################################################

--#################################################################
-- Wooden Door
--#################################################################
local original_onWoodenDoor = ISBuildMenu.onWoodenDoor
ISBuildMenu.onWoodenDoor = function(...)
    local original_ISWoodenDoorNew = ISWoodenDoor.new
    local actual_door_var = nil
    ISWoodenDoor.new = function(...)
        actual_door_var = original_ISWoodenDoorNew(...)
        if SandboxVars.BINDB.woodenDoor then
            actual_door_var.isThumpable = false
        end
        return actual_door_var
    end
    original_onWoodenDoor(...)
    actual_door_var.modData["need:Base.Plank"] = SandboxVars.BINDB.woodenDoorPlanks;
    actual_door_var.modData["need:Base.Nails"]= SandboxVars.BINDB.woodenDoorNails;
    ISWoodenDoor.new = original_ISWoodenDoorNew
end

--#################################################################
-- Wooden Double Door
--#################################################################
local original_onDoubleWoodenDoor = ISBuildMenu.onDoubleWoodenDoor
ISBuildMenu.onDoubleWoodenDoor = function(...)
    local original_ISDoubleDoorNew = ISDoubleDoor.new
    local actual_door_var = nil
    ISDoubleDoor.new = function(...)
        actual_door_var = original_ISDoubleDoorNew(...)
        if SandboxVars.BINDB.woodenDoubleDoor then
            actual_door_var.isThumpable = false
        end
        return actual_door_var
    end
    original_onDoubleWoodenDoor(...)
    actual_door_var.modData["need:Base.Plank"] = SandboxVars.BINDB.woodenDoubleDoorPlanks;
    actual_door_var.modData["need:Base.Nails"]= SandboxVars.BINDB.woodenDoubleDoorNails;
    ISDoubleDoor.new = original_ISDoubleDoorNew
end
--#################################################################
-- Log Wall
--#################################################################
-- Only use this if not running the Addon
if not getActivatedMods():contains("BINDB_LOGWALL") then
    local original_onLogWall = ISBuildMenu.onLogWall
    ISBuildMenu.onLogWall = function(...)
        local original_ISWoodenWallNew = ISWoodenWall.new
        local actual_wall_var = nil
        ISWoodenWall.new = function(...)
            actual_wall_var = original_ISWoodenWallNew(...)
            if SandboxVars.BINDB.logWall then
                actual_wall_var.isThumpable = false
            end
            return actual_wall_var
        end
        original_onLogWall(...)
        ISWoodenWall.new = original_ISWoodenWallNew
    end
end
--#################################################################
-- Wood Wall Lv2
--#################################################################

--#################################################################
-- Wood Wall Lv3
--#################################################################


-- Patching Carpentry Tooltips
-- Excluding Log Wall
local original_canBuild = ISBuildMenu.canBuild
ISBuildMenu.canBuild = function(plankNb, nailsNb, hingeNb, doorknobNb, baredWireNb, carpentrySkill, option, player)
    -- Sadly no way to actually know what is currently being built
    -- So we just assume objects based on their build cost
    -- Wooden Door 4 Planks 4 Nails 2 Hinge 1 Doorknob 0 Wire 3 Skill
    if doorknobNb == 1 and hingeNb == 2  and plankNb == 4 and nailsNb == 4 then
        plankNb = SandboxVars.BINDB.woodenDoorPlanks
        nailsNb = SandboxVars.BINDB.woodenDoorNails
    -- Wooden Double Door 12 Planks 12 Nails 4 Hinge 2 Doorknob 0 Wire 6 Skill
    elseif doorknobNb == 2 and hingeNb == 4 and plankNb == 12 and nailsNb == 12 then
        plankNb = SandboxVars.BINDB.woodenDoubleDoorPlanks
        nailsNb = SandboxVars.BINDB.woodenDoubleDoorNails
    end
    return original_canBuild(plankNb, nailsNb, hingeNb, doorknobNb, baredWireNb, carpentrySkill, option, player)
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