function inscribe_thing()
    if file_exists(mp.get_property("path", nil)) then
        thing = mp.get_property("media-title", "dood")
        length = mp.get_property_number("length", 0)
        file = io.open(os.getenv("HOME") .. "/Documents/EXlog.txt", "a+")
        io.output(file)
        io.write(thing .. "\t" .. os.date('%m-%d-%y %H:%M:%S') .. length .. "\n")
        io.close(file)
    end
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

mp.register_event("start-file", inscribe_thing)
