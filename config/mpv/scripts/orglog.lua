directory = os.getenv("HOME") .. "/Dropbox"
tempfile = directory .. "/log.tmp"
logfile = directory .. "/log.org"
last = false
ended = false

function add_entry()
    if last then return end

    if file_exists(mp.get_property("path", nil)) then
        if not file_exists(tempfile) then
            temp = assert(io.open(tempfile, "w"))
            temp:close()
        end

        temp = assert(io.open(tempfile, "r"))
        local contents = temp:read'*a'
        temp:close()

        local filename = mp.get_property("filename", "dood")

        local file = io.open(logfile, "a+")
        io.output(file)

        if contents == filename then
            starttime = os.time()
            io.write(":Resumed: " .. starttime .. "\n")
            io.close(file)
            return
        elseif contents ~= "" then
            io.write(":END:\n")
        end

        local started = os.time()
        local timestamp = "[" .. os.date('%Y-%m-%d %a %H:%M') .. "]"
        local mediatitle = mp.get_property("media-title", "dood")
        local length = mp.get_property_number("duration", -1)
        if length == -1 then print("No length available!") end
        io.write("** " .. timestamp .. " " .. mediatitle .. "\n")
        io.write(":PROPERTIES:\n")
        if mediatitle ~= filename then io.write(":Filename: " .. filename .. "\n") end
        io.write(":Length: " .. length .. "\n")
        io.write(":END:\n:LOGBOOK:\n")
        io.write(":Started: " .. started .. "\n")
        io.close(file)

        write_last_file(filename)
    end
end

function next_file(event)
    local file = io.open(logfile, "a+")
    io.output(file)
    stoptime = os.time()

    if ended then return end

    if event.reason == "eof" then
        io.write(":Finished: " .. stoptime .. "\n")
        io.write(":END:\n")
        write_last_file("")
    elseif event.reason == "quit" then
        io.write(":Stopped: " .. stoptime .. "\n")
    else
        io.write(":Skipped: " .. stoptime .. "\n")
    end

    io.close(file)

    if last then
        print("last file ended.")
        ended = true
        mp.command("quit")
    end
end

function write_last_file(name)
    local temp = io.open(tempfile, "w+")
    io.output(temp)
    io.write(name)
    io.close(temp)
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

function set_last_file_handler()
    print("set last file.")
    last = true
end

mp.register_event("file-loaded", add_entry)
mp.register_event("end-file", next_file)
mp.add_key_binding("X", "set_last_file", set_last_file_handler)
