function lookup_jisho()
    local text = mp.get_property("sub-text")
    if text == "" then
        return
    end
    mp.set_property("pause", "yes")
    os.execute("open \"http://jisho.org/search/" .. text .. "\"")
end

mp.add_key_binding("Ctrl+j", "lookup_jisho", lookup_jisho)
