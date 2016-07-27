function jump_to_file()
    filename = mp.get_property("filename", nil)
    file_format = mp.get_property("file-format", nil)
    print(file_format)
    print(filename)

    if (file_format == "jpg" or file_format == "png_pipe") and string.find(filename, "%%%%") == 1 then
        lis = split(filename, "%%")
        jump_file = lis[2]
        jump_time = lis[4]
		jump_time = string.sub(jump_time, 0, -5)
		times = split(jump_time, ":")
		for k,v in pairs(times) do print(k,v) end
		seconds = (times[1] * 60 * 60) + (times[2] * 60) + times[3]
        print(jump_file)
        print("start=" .. jump_time)
        if file_exists("./" .. jump_file) then
            mp.unregister_event("start-file")
            mp.unregister_event("file-loaded")
            mp.unregister_event("end-file")
            mp.commandv("loadfile", jump_file, "replace", "start=+" .. seconds)
        end
    end
end

-- Compatibility: Lua-5.1
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

mp.register_event("file-loaded", jump_to_file)
