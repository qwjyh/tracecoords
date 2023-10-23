local modname = core.get_current_modname() or "??"
local modstorage = core.get_mod_storage()
local is_enabled_coord_log = false

core.register_on_shutdown(function()
    print("[TRACECOORDS] shutdown client")
end)

local localplayer
core.register_on_connect(function()
    localplayer = core.localplayer
    is_enabled_coord_log = false
end)

core.register_chatcommand("tlog", {
    func = function(param)
        if is_enabled_coord_log then
            print("[TRACECOORDS] Logging stopping... \"" .. os.date("!%FT%T") .. "\"")
        else
            print("[TRACECOORDS] Logging starting... \"" .. os.date("!%FT%T") .. "\"")
        end
        is_enabled_coord_log = not is_enabled_coord_log
    end
})

core.register_on_punchnode(function(pos, node)
    local pos = localplayer:get_pos()
    print("[TRACECOORDS] Coordinate: " .. core.pos_to_string(pos))
end)

-- log player coords every 0.3s
local count = 0
core.register_globalstep(function(dtime)
    if is_enabled_coord_log then
        count = count + 1
        if count >= 30 then
            local pos = localplayer:get_pos()
            print("[TRACECOORDS] Coordinate:" .. core.pos_to_string(pos))
            -- print("[TRACECOORDS] Coordinate:")
            count = 0
        end
    end
end)

-- modname debug
core.after(2, function()
    print("[TRACECOORDS] loaded " .. modname .. " mod")
    modstorage:set_string("current_mod", modname)
    print(modstorage:get_string("current_mod"))
    print("[TRACECOORDS] " .. core.get_us_time())
    print("[TRACECOORDS] Date: \"" .. os.date("!%FT%T") .. "\"")
end)
